import { prisma } from '@/lib/prisma';
import type { NextRequest } from 'next/server';

// GET /api/dividends/:ticker
// Returns full dividend history for a ticker
export async function GET(
  _request: NextRequest,
  { params }: { params: Promise<{ ticker: string }> },
) {
  const { ticker } = await params;

  try {
    const rows = await prisma.dividend.findMany({
      where: { ticker: ticker.toUpperCase() },
      orderBy: [{ year: 'desc' }, { month: 'desc' }],
    });

    if (rows.length === 0) {
      return Response.json({ dividends: [] });
    }

    return Response.json({
      dividends: rows.map((r) => ({
        ticker: r.ticker,
        perShare: r.perShare,
        paymentDate: r.paymentDate,
        year: r.year,
        month: r.month,
        currency: r.currency,
      })),
    });
  } catch (e) {
    console.error(`[GET /api/dividends/${ticker}]`, e);
    return Response.json({ dividends: [] });
  }
}
