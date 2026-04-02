export interface Stock {
  ticker: string;
  name: string;
  sector: string;
  color: string;
}

export interface NewsItem {
  title: string;
  body: string;
  impact: 'positive' | 'negative' | 'neutral';
  sector?: string;
}

export interface GameStep {
  year: number;
  month: number;      // 1–12
  label: string;      // «Сен 2014»
  news: NewsItem[];
  eventName?: string;
  eventDescription?: string;
  eventColor?: string;
}

export interface Crisis {
  id: string;          // matches SCENARIOS key in moex_parser.py
  name: string;
  description: string;
  emoji: string;
  color: string;
  parserKey: string;   // '2014_ruble' | '2020_covid' | '2022_feb' | '2023_rate'
  periodLabel: string; // «Сен 2014 — Фев 2015»
  years: GameStep[];   // steps — по одному месяцу каждый
}

export interface PortfolioItem {
  ticker: string;
  shares: number;
  avgBuyPrice: number;
}

export interface BotPlayer {
  id: string;
  username: string;
  style: 'conservative' | 'aggressive' | 'speculative' | 'dividend' | 'tech';
  yearReturns: number[];
}

export interface BondPosition {
  faceValue: number;    // amount invested in rubles
  annualYield: number;  // e.g. 0.16 for 16%
  purchasedYear: number;
  purchasedMonth: number;
}

export interface GameState {
  mode: 'solo' | 'multi' | 'realtime' | null;
  crisis: Crisis | null;
  currentYearIndex: number;
  username: string;
  budget: number;
  portfolio: Record<string, PortfolioItem>;
  bonds: BondPosition[];
  netWorthHistory: number[]; // net worth at each step end
  bots: BotPlayer[];
  roomCode: string;
  gameStarted: boolean;
  lastRefreshAt: number | null; // timestamp ms, for realtime mode
}

export interface OHLCCandle {
  open: number;
  high: number;
  low: number;
  close: number;
}

export interface OrderLevel {
  price: number;
  size: number;
}
