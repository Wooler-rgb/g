// GET /api/stocks/[ticker]/trades
// Proxies recent trades from MOEX ISS

import type { NextRequest } from 'next/server';

const MOEX_BASE =
  'https://iss.moex.com/iss/engines/stock/markets/shares/boards/TQBR/securities';

export async function GET(
  _request: NextRequest,
  { params }: { params: Promise<{ ticker: string }> },
) {
  const { ticker } = await params;

  try {
    const url =
      `${MOEX_BASE}/${ticker.toUpperCase()}/trades.json` +
      `?iss.meta=off&iss.only=trades&trades.columns=TRADENO,TRADETIME,PRICE,QUANTITY,BUYSELL,VALUE`;

    const r = await fetch(url, {
      next: { revalidate: 10 },
      headers: { 'User-Agent': 'SibInvest/2.0' },
    });

    if (!r.ok) {
      return Response.json({ trades: [] }, { status: 502 });
    }

    const data = await r.json();
    const raw = data?.trades;
    if (!raw?.columns || !raw?.data) {
      return Response.json({ trades: [] });
    }

    const cols: string[] = raw.columns;
    const noIdx   = cols.indexOf('TRADENO');
    const tIdx    = cols.indexOf('TRADETIME');
    const pIdx    = cols.indexOf('PRICE');
    const qIdx    = cols.indexOf('QUANTITY');
    const sIdx    = cols.indexOf('BUYSELL');
    const vIdx    = cols.indexOf('VALUE');

    const trades = (raw.data as (string | number | null)[][])
      .map((row) => ({
        no: String(row[noIdx] ?? ''),
        time: String(row[tIdx] ?? '').slice(11, 19),
        price: Number(row[pIdx] ?? 0),
        quantity: Number(row[qIdx] ?? 0),
        buysell: (row[sIdx] as 'B' | 'S' | null) ?? null,
        value: Number(row[vIdx] ?? 0),
      }))
      .filter((t) => t.price > 0)
      .reverse()
      .slice(0, 50);

    return Response.json({ trades });
  } catch (e) {
    console.error(`[GET /api/stocks/${ticker}/trades]`, e);
    return Response.json({ trades: [] });
  }
}
