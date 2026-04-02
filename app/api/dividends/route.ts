import { prisma } from '@/lib/prisma';
import type { NextRequest } from 'next/server';

// GET /api/dividends?from=2014-9&to=2026-4
// Returns all dividend payments in the date range as a flat map + array
export async function GET(request: NextRequest) {
  const { searchParams } = request.nextUrl;
  const from = searchParams.get('from'); // e.g. "2014-9"
  const to   = searchParams.get('to');   // e.g. "2026-4"

  try {
    let whereClause = {};

    if (from && to) {
      const [fy, fm] = from.split('-').map(Number);
      const [ty, tm] = to.split('-').map(Number);
      whereClause = {
        OR: [
          // simple range: year in (fy..ty)
          { year: { gte: fy, lte: ty } },
        ],
      };

      const rows = await prisma.dividend.findMany({
        where: {
          year: { gte: fy, lte: ty },
        },
        orderBy: [{ ticker: 'asc' }, { year: 'asc' }, { month: 'asc' }],
      });

      // Build a flat map: "TICKER-YEAR-MONTH" → perShare
      const map: Record<string, number> = {};
      for (const r of rows) {
        // Only include if within exact month range
        const ord = (y: number, m: number) => y * 12 + m;
        if (ord(r.year, r.month) < ord(fy, fm)) continue;
        if (ord(r.year, r.month) > ord(ty, tm)) continue;
        map[`${r.ticker}-${r.year}-${r.month}`] = r.perShare;
      }

      return Response.json({ map, count: Object.keys(map).length });
    }

    // No range — return all
    const rows = await prisma.dividend.findMany({
      orderBy: [{ ticker: 'asc' }, { year: 'asc' }, { month: 'asc' }],
    });
    const map: Record<string, number> = {};
    for (const r of rows) {
      map[`${r.ticker}-${r.year}-${r.month}`] = r.perShare;
    }
    return Response.json({ map, count: rows.length });
  } catch (e) {
    console.error('[GET /api/dividends]', e);
    return Response.json({ map: {}, count: 0 });
  }
}
