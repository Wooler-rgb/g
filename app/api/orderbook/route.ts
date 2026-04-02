import { prisma } from '@/lib/prisma';
import type { NextRequest } from 'next/server';

function seeded(seed: number) {
  let s = seed | 1;
  return () => {
    s = Math.imul(48271, s) | 0;
    return ((s >>> 0) & 0x7fffffff) / 0x7fffffff;
  };
}

// GET /api/orderbook?ticker=SBER&year=2014&month=9
// Возвращает стакан (bid/ask) на основе реальной цены из БД
export async function GET(request: NextRequest) {
  const ticker = request.nextUrl.searchParams.get('ticker')?.toUpperCase();
  const yearP  = request.nextUrl.searchParams.get('year');
  const monthP = request.nextUrl.searchParams.get('month');

  if (!ticker) {
    return Response.json({ error: 'ticker обязателен' }, { status: 400 });
  }

  try {
    const stock = await prisma.stonk.findUnique({ where: { ticker } });
    if (!stock) {
      return Response.json({ error: 'Акция не найдена' }, { status: 404 });
    }

    let price: number | null = null;

    if (yearP && monthP) {
      const y = parseInt(yearP);
      const m = parseInt(monthP);
      const exact = await prisma.price.findUnique({
        where: { stonkId_year_month: { stonkId: stock.id, year: y, month: m } },
      });
      if (exact) {
        price = exact.price;
      } else {
        // Интерполируем — берём ближайшие до и после
        const before = await prisma.price.findFirst({
          where: {
            stonkId: stock.id,
            OR: [{ year: { lt: y } }, { year: y, month: { lte: m } }],
          },
          orderBy: [{ year: 'desc' }, { month: 'desc' }],
        });
        const after = await prisma.price.findFirst({
          where: {
            stonkId: stock.id,
            OR: [{ year: { gt: y } }, { year: y, month: { gt: m } }],
          },
          orderBy: [{ year: 'asc' }, { month: 'asc' }],
        });
        if (before && after) {
          const tgt  = y * 12 + m;
          const bOrd = before.year * 12 + before.month;
          const aOrd = after.year  * 12 + after.month;
          const t = (tgt - bOrd) / (aOrd - bOrd);
          price = before.price + (after.price - before.price) * t;
        } else {
          price = before?.price ?? after?.price ?? null;
        }
      }
    } else {
      // Последняя известная цена
      const latest = await prisma.price.findFirst({
        where: { stonkId: stock.id },
        orderBy: [{ year: 'desc' }, { month: 'desc' }],
      });
      price = latest?.price ?? null;
    }

    if (price === null) {
      return Response.json({ error: 'Нет данных о цене' }, { status: 404 });
    }

    // Генерируем стакан детерминировано от цены
    const seed = Math.round(price * 1000 + (parseInt(yearP ?? '0') * 12 + parseInt(monthP ?? '1')));
    const rng  = seeded(seed);
    const spread = price * 0.002;

    const bids = Array.from({ length: 12 }, (_, i) => ({
      price: +(price! - spread * (i + 1) * (0.5 + rng() * 0.5)).toFixed(price! >= 100 ? 2 : 4),
      size:  Math.floor(rng() * 9500 + 500),
    }));

    const asks = Array.from({ length: 12 }, (_, i) => ({
      price: +(price! + spread * (i + 1) * (0.5 + rng() * 0.5)).toFixed(price! >= 100 ? 2 : 4),
      size:  Math.floor(rng() * 9500 + 500),
    }));

    return Response.json({
      ticker,
      price,
      bids,
      asks,
      spread: +(asks[0].price - bids[0].price).toFixed(price >= 100 ? 2 : 4),
    });
  } catch (e) {
    console.error('[GET /api/orderbook]', e);
    return Response.json({ error: 'Ошибка сервера' }, { status: 500 });
  }
}
