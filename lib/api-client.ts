/**
 * Клиент для API СибИнвестиции
 * Все данные берутся с бэкенда — никаких моков
 */

const BASE = typeof window !== 'undefined' ? '' : 'http://localhost:3000';

async function fetchJSON<T>(path: string, options?: RequestInit): Promise<T> {
  const res = await fetch(`${BASE}${path}`, {
    headers: { 'Content-Type': 'application/json' },
    ...options,
  });
  const data = await res.json();
  if (!res.ok) throw new Error(data.error ?? `HTTP ${res.status}`);
  return data as T;
}

// ─── Типы ответов ────────────────────────────────────────────────
export interface ApiStock {
  id: number;
  ticker: string;
  name: string;
  sector: string;
  color: string;
  currentPrice: number | null;
}

export interface ApiStockDetail extends ApiStock {
  prices: { year: number; month: number; price: number }[];
}

export interface ApiNewsItem {
  title: string;
  body: string;
  impact: 'positive' | 'negative' | 'neutral';
  sector?: string;
}

export interface ApiStep {
  year: number;
  month: number;
  label: string;
  news: ApiNewsItem[];
  eventName?: string;
  eventDescription?: string;
  eventColor?: string;
}

export interface ApiCrisis {
  id: string;
  name: string;
  description: string;
  emoji: string;
  color: string;
  parserKey: string;
  periodLabel: string;
  years: ApiStep[];
}

export interface ApiUser {
  id: number;
  username: string;
  createdAt: string;
}

export interface ApiRoom {
  id: number;
  code: string;
  status: string;
  scenarioId: string;
  hostUsername: string;
  currentStepIndex: number;
  readyJson: string;
  createdAt: string;
  players?: { id: number; username: string; budget: number; portfolioJson: string; finalNetWorth: number | null }[];
}

export interface ApiLeaderboardRow {
  rank: number;
  username: string;
  netWorth: number;
  startBudget: number;
  pnlPct: number;
  createdAt: string;
  roomCode?: string | null;
}

export interface ApiOrderBook {
  ticker: string;
  price: number;
  bids: { price: number; size: number }[];
  asks: { price: number; size: number }[];
  spread: number;
}

// ─── Свечи и сделки (MOEX ISS) ──────────────────────────────────
export interface ApiCandle {
  time: string;
  open: number;
  high: number;
  low: number;
  close: number;
  volume: number;
}

export interface ApiTrade {
  no: string;
  time: string;
  price: number;
  quantity: number;
  buysell: 'B' | 'S' | null;
  value: number;
}

// ─── Типы дивидендов ────────────────────────────────────────────
export interface ApiDividend {
  ticker: string;
  perShare: number;
  paymentDate: string;
  year: number;
  month: number;
  currency: string;
}

// ─── Акции ──────────────────────────────────────────────────────
export const api = {
  stocks: {
    list: () => fetchJSON<ApiStock[]>('/api/stocks'),
    get: (ticker: string) => fetchJSON<ApiStockDetail>(`/api/stocks/${ticker}`),
    price: (ticker: string, year: number, month: number) =>
      fetchJSON<{ ticker: string; year: number; month: number; price: number | null }>(
        `/api/stocks/${ticker}?year=${year}&month=${month}`,
      ),
    /** Real-time prices. dbOnly=true reads only from DB cache (no MOEX call) — fast, for page restores. */
    realtime: (opts?: { dbOnly?: boolean }) =>
      fetchJSON<{ prices: Record<string, number>; moexAvailable: boolean }>(
        `/api/stocks/realtime${opts?.dbOnly ? '?dbOnly=1' : ''}`,
      ),
    /** OHLCV candles from MOEX ISS */
    candles: (ticker: string, tf: string) =>
      fetchJSON<{ candles: ApiCandle[] }>(`/api/stocks/${ticker}/candles?tf=${tf}`),
    /** Recent trades from MOEX ISS */
    trades: (ticker: string) =>
      fetchJSON<{ trades: ApiTrade[] }>(`/api/stocks/${ticker}/trades`),
  },

  // ─── Цены ─────────────────────────────────────────────────────
  prices: {
    /** All tickers price snapshot for a given year/month */
    snapshot: (year: number, month: number) =>
      fetchJSON<Record<string, number>>(`/api/prices/snapshot?year=${year}&month=${month}`),
    /** Full price map for a date range: "TICKER-YEAR-MONTH" → price */
    range: (from: string, to: string) =>
      fetchJSON<{ map: Record<string, number> }>(`/api/prices/range?from=${from}&to=${to}`),
  },

  // ─── Дивиденды ────────────────────────────────────────────────
  dividends: {
    /** Dividend history for a specific ticker */
    forTicker: (ticker: string) =>
      fetchJSON<{ dividends: ApiDividend[] }>(`/api/dividends/${ticker}`),
    /** Flat dividend map { "TICKER-YEAR-MONTH": perShare } for a date range */
    range: (from: string, to: string) =>
      fetchJSON<{ map: Record<string, number>; count: number }>(
        `/api/dividends?from=${from}&to=${to}`,
      ),
  },

  // ─── Кризисы ──────────────────────────────────────────────────
  crises: {
    list: () => fetchJSON<ApiCrisis[]>('/api/crises'),
    get: (id: string) => fetchJSON<ApiCrisis>(`/api/crises/${id}`),
  },

  // ─── Пользователи ─────────────────────────────────────────────
  users: {
    create: (username: string) =>
      fetchJSON<ApiUser>('/api/users', {
        method: 'POST',
        body: JSON.stringify({ username }),
      }),
    find: (username: string) =>
      fetchJSON<ApiUser>(`/api/users?username=${encodeURIComponent(username)}`),
  },

  // ─── Комнаты ──────────────────────────────────────────────────
  rooms: {
    create: (scenarioId: string, username: string) =>
      fetchJSON<ApiRoom>('/api/rooms', {
        method: 'POST',
        body: JSON.stringify({ scenarioId, username }),
      }),
    get: (code: string) => fetchJSON<ApiRoom>(`/api/rooms/${code}`),
    join: (code: string, username: string) =>
      fetchJSON<{ code: string; scenarioId: string; userId: number; username: string }>(
        `/api/rooms/${code}/join`,
        { method: 'POST', body: JSON.stringify({ username }) },
      ),
    setStatus: (code: string, status: 'active' | 'finished') =>
      fetchJSON<ApiRoom>(`/api/rooms/${code}`, {
        method: 'PATCH',
        body: JSON.stringify({ status }),
      }),
    setStep: (code: string, currentStepIndex: number) =>
      fetchJSON<{ id: number; code: string; currentStepIndex: number }>(`/api/rooms/${code}`, {
        method: 'PATCH',
        body: JSON.stringify({ currentStepIndex }),
      }),
    setReady: (code: string, username: string, isReady: boolean) =>
      fetchJSON<{ readyJson: string }>(`/api/rooms/${code}/ready`, {
        method: 'POST',
        body: JSON.stringify({ username, isReady }),
      }),
  },

  // ─── Лидерборд ───────────────────────────────────────────────
  leaderboard: {
    get: (roomCode?: string) =>
      fetchJSON<ApiLeaderboardRow[]>(
        roomCode ? `/api/leaderboard?roomCode=${roomCode}` : '/api/leaderboard',
      ),
    save: (data: { username: string; netWorth: number; startBudget?: number; roomCode?: string }) =>
      fetchJSON<{ id: number; username: string; netWorth: number; rank: number; createdAt: string }>(
        '/api/leaderboard',
        { method: 'POST', body: JSON.stringify(data) },
      ),
  },

  // ─── Стакан ───────────────────────────────────────────────────
  orderbook: {
    get: (ticker: string, year?: number, month?: number) => {
      const params = year && month ? `?ticker=${ticker}&year=${year}&month=${month}` : `?ticker=${ticker}`;
      return fetchJSON<ApiOrderBook>(`/api/orderbook${params}`);
    },
  },

  // ─── Состояние игры ───────────────────────────────────────────
  game: {
    save: (data: {
      username: string;
      roomCode?: string;
      budget: number;
      portfolioJson: string;
      finalNetWorth?: number;
    }) => fetchJSON<{ id: number; budget: number }>('/api/game', {
      method: 'POST',
      body: JSON.stringify(data),
    }),
  },
};
