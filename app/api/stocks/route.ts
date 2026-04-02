import { prisma } from '@/lib/prisma';

export async function GET() {
  try {
    const stocks = await prisma.stonk.findMany({
      orderBy: { ticker: 'asc' },
      include: {
        prices: {
          orderBy: [{ year: 'desc' }, { month: 'desc' }],
          take: 1, // последняя известная цена для каждой акции
        },
      },
    });

    return Response.json(
      stocks.map((s) => ({
        id: s.id,
        ticker: s.ticker,
        name: s.name,
        sector: s.sector,
        color: s.color,
        currentPrice: s.prices[0]?.price ?? null,
      })),
    );
  } catch (e) {
    console.error('[GET /api/stocks]', e);
    return Response.json({ error: 'Ошибка сервера' }, { status: 500 });
  }
}
