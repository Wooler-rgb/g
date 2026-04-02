import { prisma } from '@/lib/prisma';
import type { NextRequest } from 'next/server';

// GET /api/prices/range?from=2020-1&to=2022-3
// Returns { map: { "SBER-2020-1": 250, ... } } for every ticker × every month in range.
// Uses linear interpolation for months without an exact DB entry.
export async function GET(request: NextRequest) {
  const { searchParams } = request.nextUrl;
  const from = searchParams.get('from'); // "YYYY-M"
  const to   = searchParams.get('to');

  if (!from || !to) {
    return Response.json({ error: 'from, to required' }, { status: 400 });
  }

  const [fy, fm] = from.split('-').map(Number);
  const [ty, tm] = to.split('-').map(Number);
  const ord = (y: number, m: number) => y * 12 + m;

  if (!fy || !fm || !ty || !tm || ord(fy, fm) > ord(ty, tm)) {
    return Response.json({ error: 'invalid range' }, { status: 400 });
  }

  try {
    const stocks = await prisma.stonk.findMany({
      include: {
        prices: { orderBy: [{ year: 'asc' }, { month: 'asc' }] },
      },
    });

    const map: Record<string, number> = {};

    // Build list of target months
    const targets: { year: number; month: number }[] = [];
    let cy = fy, cm = fm;
    while (ord(cy, cm) <= ord(ty, tm)) {
      targets.push({ year: cy, month: cm });
      cm++;
      if (cm > 12) { cm = 1; cy++; }
    }

    for (const stock of stocks) {
      const pts = stock.prices;
      if (pts.length === 0) continue;

      for (const { year, month } of targets) {
        const target = ord(year, month);
        const exact = pts.find((p) => p.year === year && p.month === month);
        if (exact) {
          map[`${stock.ticker}-${year}-${month}`] = exact.price;
          continue;
        }

        // Linear interpolation
        let before: typeof pts[0] | undefined;
        let after:  typeof pts[0] | undefined;
        for (const p of pts) {
          const o = ord(p.year, p.month);
          if (o <= target) before = p;
          else { after = p; break; }
        }

        let price: number | undefined;
        if (before && after) {
          const t = (target - ord(before.year, before.month)) /
                    (ord(after.year, after.month) - ord(before.year, before.month));
          price = before.price + (after.price - before.price) * t;
        } else if (before) {
          price = before.price;
        } else if (after) {
          price = after.price;
        }

        if (price != null && price > 0) {
          map[`${stock.ticker}-${year}-${month}`] = price;
        }
      }
    }

    return Response.json({ map });
  } catch (e) {
    console.error('[GET /api/prices/range]', e);
    return Response.json({ error: 'Server error' }, { status: 500 });
  }
}
