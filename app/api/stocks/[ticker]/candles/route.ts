// GET /api/stocks/[ticker]/candles?tf=day|week|month|3m|year
// Proxies MOEX ISS candle data (OHLCV)

import type { NextRequest } from 'next/server';

type Timeframe = 'day' | 'week' | 'month' | '3m' | 'year';

const MOEX_BASE =
  'https://iss.moex.com/iss/engines/stock/markets/shares/boards/TQBR/securities';

function pad(n: number) {
  return String(n).padStart(2, '0');
}
function fmt(d: Date) {
  return `${d.getFullYear()}-${pad(d.getMonth() + 1)}-${pad(d.getDate())}`;
}

function getRange(tf: Timeframe): { from: string; interval: number; revalidate: number } {
  const now = new Date();
  switch (tf) {
    case 'day': {
      const from = new Date(now);
      from.setDate(from.getDate() - 1);
      return { from: fmt(from), interval: 60, revalidate: 60 };
    }
    case 'week': {
      const from = new Date(now);
      from.setDate(from.getDate() - 7);
      return { from: fmt(from), interval: 60, revalidate: 300 };
    }
    case 'month': {
      const from = new Date(now);
      from.setMonth(from.getMonth() - 1);
      return { from: fmt(from), interval: 24, revalidate: 3600 };
    }
    case '3m': {
      const from = new Date(now);
      from.setMonth(from.getMonth() - 3);
      return { from: fmt(from), interval: 24, revalidate: 3600 };
    }
    case 'year': {
      const from = new Date(now);
      from.setFullYear(from.getFullYear() - 1);
      return { from: fmt(from), interval: 7, revalidate: 86400 };
    }
  }
}

export async function GET(
  request: NextRequest,
  { params }: { params: Promise<{ ticker: string }> },
) {
  const { ticker } = await params;
  const tf = (request.nextUrl.searchParams.get('tf') ?? 'month') as Timeframe;
  const { from, interval, revalidate } = getRange(tf);
  const till = fmt(new Date());

  try {
    const url =
      `${MOEX_BASE}/${ticker.toUpperCase()}/candles.json` +
      `?from=${from}&till=${till}&interval=${interval}&iss.meta=off`;

    const r = await fetch(url, {
      next: { revalidate },
      headers: { 'User-Agent': 'SibInvest/2.0' },
    });

    if (!r.ok) {
      return Response.json({ candles: [] }, { status: 502 });
    }

    const data = await r.json();
    const raw = data?.candles;
    if (!raw?.columns || !raw?.data) {
      return Response.json({ candles: [] });
    }

    const cols: string[] = raw.columns;
    const oIdx = cols.indexOf('open');
    const cIdx = cols.indexOf('close');
    const hIdx = cols.indexOf('high');
    const lIdx = cols.indexOf('low');
    const vIdx = cols.indexOf('volume');
    const bIdx = cols.indexOf('begin');

    const candles = (raw.data as (string | number | null)[][])
      .map((row) => ({
        time: String(row[bIdx] ?? ''),
        open: Number(row[oIdx] ?? 0),
        high: Number(row[hIdx] ?? 0),
        low: Number(row[lIdx] ?? 0),
        close: Number(row[cIdx] ?? 0),
        volume: Number(row[vIdx] ?? 0),
      }))
      .filter((c) => c.open > 0 && c.close > 0);

    return Response.json({ candles });
  } catch (e) {
    console.error(`[GET /api/stocks/${ticker}/candles]`, e);
    return Response.json({ candles: [] });
  }
}
