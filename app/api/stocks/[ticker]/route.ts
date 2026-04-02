import { prisma } from '@/lib/prisma';
import type { NextRequest } from 'next/server';

// Линейная интерполяция между ближайшими известными точками
function interpolatePrice(
  prices: { year: number; month: number; price: number }[],
  year: number,
  month: number,
): number | null {
  if (prices.length === 0) return null;

  const ord = (y: number, m: number) => y * 12 + m;
  const target = ord(year, month);
  const sorted = [...prices].sort((a, b) => ord(a.year, a.month) - ord(b.year, b.month));

  let before: (typeof sorted)[0] | undefined;
  let after: (typeof sorted)[0] | undefined;

  for (const p of sorted) {
    const o = ord(p.year, p.month);
    if (o <= target) before = p;
    else { after = p; break; }
  }

  if (!before && !after) return null;
  if (!before) return after!.price;
  if (!after) return before.price;

  const t = (target - ord(before.year, before.month)) /
            (ord(after.year, after.month) - ord(before.year, before.month));
  return before.price + (after.price - before.price) * t;
}

export async function GET(
  request: NextRequest,
  { params }: { params: Promise<{ ticker: string }> },
) {
  const { ticker } = await params;
  const url = request.nextUrl;
  const yearParam = url.searchParams.get('year');
  const monthParam = url.searchParams.get('month');

  try {
    const stock = await prisma.stonk.findUnique({
      where: { ticker: ticker.toUpperCase() },
      include: {
        prices: { orderBy: [{ year: 'asc' }, { month: 'asc' }] },
      },
    });

    if (!stock) {
      return Response.json({ error: 'Акция не найдена' }, { status: 404 });
    }

    const allPrices = stock.prices.map((p) => ({
      year: p.year,
      month: p.month,
      price: p.price,
    }));

    // Если запрошена конкретная точка — вернуть цену (с интерполяцией)
    if (yearParam && monthParam) {
      const y = parseInt(yearParam);
      const m = parseInt(monthParam);
      const exact = allPrices.find((p) => p.year === y && p.month === m);
      const price = exact?.price ?? interpolatePrice(allPrices, y, m);
      return Response.json({ ticker: stock.ticker, year: y, month: m, price });
    }

    return Response.json({
      id: stock.id,
      ticker: stock.ticker,
      name: stock.name,
      sector: stock.sector,
      color: stock.color,
      prices: allPrices,
    });
  } catch (e) {
    console.error(`[GET /api/stocks/${ticker}]`, e);
    return Response.json({ error: 'Ошибка сервера' }, { status: 500 });
  }
}
