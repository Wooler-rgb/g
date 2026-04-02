import { prisma } from '@/lib/prisma';
import type { NextRequest } from 'next/server';

// GET /api/prices/snapshot?year=2020&month=3
// Returns { SBER: 185.2, GAZP: 165.0, ... } — one price per ticker for the given month
// Interpolates if the exact month is missing
export async function GET(request: NextRequest) {
  const { searchParams } = request.nextUrl;
  const year  = Number(searchParams.get('year'));
  const month = Number(searchParams.get('month'));

  if (!year || !month) {
    return Response.json({ error: 'year, month required' }, { status: 400 });
  }

  try {
    const stocks = await prisma.stonk.findMany({
      include: {
        prices: {
          orderBy: [{ year: 'asc' }, { month: 'asc' }],
        },
      },
    });

    const snapshot: Record<string, number> = {};
    const ord = (y: number, m: number) => y * 12 + m;
    const target = ord(year, month);

    for (const stock of stocks) {
      const pts = stock.prices;
      if (pts.length === 0) continue;

      const exact = pts.find((p) => p.year === year && p.month === month);
      if (exact) {
        snapshot[stock.ticker] = exact.price;
        continue;
      }

      // Linear interpolation between nearest neighbours
      let before: typeof pts[0] | undefined;
      let after:  typeof pts[0] | undefined;
      for (const p of pts) {
        const o = ord(p.year, p.month);
        if (o <= target) before = p;
        else { after = p; break; }
      }

      if (before && after) {
        const t = (target - ord(before.year, before.month)) /
                  (ord(after.year, after.month) - ord(before.year, before.month));
        snapshot[stock.ticker] = before.price + (after.price - before.price) * t;
      } else if (before) {
        snapshot[stock.ticker] = before.price;
      } else if (after) {
        snapshot[stock.ticker] = after.price;
      }
    }

    return Response.json(snapshot);
  } catch (e) {
    console.error('[GET /api/prices/snapshot]', e);
    return Response.json({ error: 'Ошибка сервера' }, { status: 500 });
  }
}
