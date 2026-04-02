// GET /api/stocks/realtime[?dbOnly=1]
// Without dbOnly: fetches from MOEX ISS, saves to DB, falls back to DB if MOEX unavailable.
// With ?dbOnly=1: returns cached prices from DB only (no MOEX call) — used on navigation/refresh.
// Returns { prices: { SBER: 312.50, ... }, moexAvailable: boolean }

import { prisma } from '@/lib/prisma';
import type { NextRequest } from 'next/server';

const TICKERS = [
  'SBER', 'GAZP', 'LKOH', 'NVTK', 'ROSN', 'SNGS',
  'TATN', 'GMKN', 'CHMF', 'NLMK', 'ALRS', 'PLZL',
  'MGNT', 'MOEX', 'VTBR', 'AFLT', 'MTSS', 'IRAO',
];

const ISS_URL =
  'https://iss.moex.com/iss/engines/stock/markets/shares/boards/TQBR/securities.json';

export async function GET(request: NextRequest) {
  const dbOnly = request.nextUrl.searchParams.get('dbOnly') === '1';

  // 1. Read last known prices from DB as baseline
  let dbPrices: Record<string, number> = {};
  try {
    const rows = await prisma.$queryRaw<{ ticker: string; price: number }[]>`
      SELECT ticker, price FROM realtime_price
    `;
    for (const row of rows) {
      dbPrices[row.ticker] = row.price;
    }
  } catch {
    // Table may not exist on first boot — ignore
  }

  // dbOnly mode: return cached prices without calling MOEX (used after navigation within cooldown)
  if (dbOnly) {
    return Response.json({ prices: dbPrices, moexAvailable: false });
  }

  // 2. Try MOEX ISS
  let moexAvailable = false;
  try {
    const r = await fetch(
      `${ISS_URL}?securities=${TICKERS.join(',')}&iss.meta=off&iss.only=marketdata&marketdata.columns=SECID,LAST,WAPRICE,PREVPRICE`,
      {
        cache: 'no-store',
        headers: { 'User-Agent': 'SibInvest/2.0' },
        signal: AbortSignal.timeout(8000),
      },
    );

    if (r.ok) {
      const data = await r.json();
      const md = data?.marketdata;
      if (md?.columns && md?.data) {
        const cols: string[] = md.columns;
        const secIdx  = cols.indexOf('SECID');
        const lastIdx = cols.indexOf('LAST');
        const wapIdx  = cols.indexOf('WAPRICE');
        const prevIdx = cols.indexOf('PREVPRICE');

        const freshPrices: Record<string, number> = {};
        for (const row of md.data as (string | number | null)[][]) {
          const ticker = row[secIdx] as string;
          const price = (row[lastIdx] as number | null)
            ?? (row[wapIdx]  as number | null)
            ?? (row[prevIdx] as number | null);
          if (ticker && price != null && price > 0) {
            freshPrices[ticker] = price;
          }
        }

        if (Object.keys(freshPrices).length > 0) {
          moexAvailable = true;

          // Save fresh prices to DB (upsert each ticker)
          for (const [ticker, price] of Object.entries(freshPrices)) {
            try {
              await prisma.$executeRaw`
                INSERT INTO realtime_price (ticker, price, updated_at)
                VALUES (${ticker}, ${price}, NOW())
                ON CONFLICT (ticker) DO UPDATE
                  SET price = EXCLUDED.price, updated_at = NOW()
              `;
            } catch {
              // Ignore individual failures
            }
          }

          // Merge: DB baseline overwritten by fresh MOEX prices
          dbPrices = { ...dbPrices, ...freshPrices };
        }
      }
    }
  } catch {
    // MOEX unavailable — will use DB prices only
  }

  return Response.json({ prices: dbPrices, moexAvailable });
}
