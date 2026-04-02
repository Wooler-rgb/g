'use client';

import React, { createContext, useContext, useState, useEffect, useCallback, useRef } from 'react';
import { GameState, PortfolioItem, BondPosition } from './types';
import { getKeyRate } from './game-data';
import { api } from './api-client';
import { getSession, setSession, clearSession } from './session';

// Key: "TICKER-YEAR-MONTH", value: price in ₽
type PriceMap = Record<string, number>;

// Bump key when storage format changes to avoid parsing old incompatible data
const STORAGE_KEY = 'sibinvest_v3';

const defaultState: GameState = {
  mode: null,
  crisis: null,
  currentYearIndex: 0,
  username: '',
  budget: 1_000_000,
  portfolio: {},
  bonds: [],
  netWorthHistory: [],
  bots: [],
  roomCode: '',
  gameStarted: false,
  lastRefreshAt: null,
};

interface GameContextType {
  state: GameState;
  setState: React.Dispatch<React.SetStateAction<GameState>>;
  /** true после того как localStorage прочитан — используй для задержки редиректов */
  hydrated: boolean;
  buyStock: (ticker: string, shares: number, price: number) => boolean;
  sellStock: (ticker: string, shares: number, price: number) => boolean;
  buyBonds: (amount: number, year: number, month: number) => boolean;
  sellBonds: (amount: number) => boolean;
  getBondValue: () => number;
  getPortfolioValue: (year: number, month?: number) => number;
  getTotalNetWorth: (year: number, month?: number) => number;
  getSharpeRatio: () => number | null;
  reset: () => void;
  /** Prices from DB for current step (ticker → price) — used for realtime mode */
  priceSnapshot: Record<string, number>;
  setPriceSnapshot: React.Dispatch<React.SetStateAction<Record<string, number>>>;
  /** Full price map for entire crisis: "TICKER-YEAR-MONTH" → price */
  fullPriceMap: Record<string, number>;
  /** Dividend map for full crisis period: "TICKER-YEAR-MONTH" → perShare */
  dividendMap: Record<string, number>;
  /** Get price from DB (full map first, then snapshot, then static fallback) */
  getDbPrice: (ticker: string, year: number, month?: number) => number;
}

const GameContext = createContext<GameContextType | null>(null);

export function GameProvider({ children }: { children: React.ReactNode }) {
  const [state, setState] = useState<GameState>(defaultState);
  const [hydrated, setHydrated] = useState(false);
  const [priceSnapshot, setPriceSnapshot] = useState<Record<string, number>>({});
  const [fullPriceMap, setFullPriceMap] = useState<Record<string, number>>({});
  const [dividendMap, setDividendMap] = useState<Record<string, number>>({});
  const saveTimerRef = useRef<ReturnType<typeof setTimeout> | null>(null);

  // Hydrate from localStorage (synchronous — crisis serialized in full, no API call needed)
  useEffect(() => {
    try {
      const saved = localStorage.getItem(STORAGE_KEY);
      if (saved) {
        const parsed = JSON.parse(saved);
        setState({ ...defaultState, ...parsed });
      }
    } catch {
      // ignore corrupt storage
    }
    setHydrated(true);
  }, []);

  // Persist to localStorage + session cookie on every state change (after hydration)
  useEffect(() => {
    if (!hydrated) return;
    try {
      // Сохраняем полное состояние включая crisis (для синхронной гидрации)
      localStorage.setItem(STORAGE_KEY, JSON.stringify(state));
    } catch {
      // ignore
    }

    // Обновляем session cookie — идентификатор активной сессии
    if (state.username && state.mode) {
      setSession({
        username: state.username,
        mode: state.mode,
        crisisId: state.crisis?.id ?? '',
        roomCode: state.roomCode ?? '',
      });
    }

    // Debounced API sync — save 3s after last state change
    if (state.username && state.gameStarted) {
      if (saveTimerRef.current) clearTimeout(saveTimerRef.current);
      saveTimerRef.current = setTimeout(() => {
        const bondsValue = (state.bonds ?? []).reduce((s, b) => s + b.faceValue, 0);
        api.game.save({
          username: state.username,
          roomCode: state.roomCode || undefined,
          budget: state.budget,
          portfolioJson: JSON.stringify({ ...state.portfolio, __bondsValue__: bondsValue }),
        }).catch(() => {});
      }, 3000);
    }
  }, [state, hydrated]);

  // Load full price map + dividend map from DB when crisis starts (once per crisis)
  useEffect(() => {
    if (!hydrated || !state.crisis) return;
    const years = state.crisis.years;
    if (years.length === 0) return;
    const first = years[0];
    const last  = years[years.length - 1];
    const from  = `${first.year}-${first.month}`;
    const to    = `${last.year}-${last.month}`;

    api.prices.range(from, to)
      .then(({ map }) => setFullPriceMap(map))
      .catch(() => {});

    api.dividends.range(from, to)
      .then(({ map }) => setDividendMap(map))
      .catch(() => {});
  }, [hydrated, state.crisis?.id]);

  const getDbPrice = useCallback(
    (ticker: string, year: number, month = 1): number => {
      const key = `${ticker}-${year}-${month}`;
      if (fullPriceMap[key]) return fullPriceMap[key];
      if (priceSnapshot[ticker]) return priceSnapshot[ticker];
      return 0;
    },
    [fullPriceMap, priceSnapshot],
  );

  const COMMISSION = 0.01; // 1%

  const buyStock = useCallback(
    (ticker: string, shares: number, price: number): boolean => {
      const cost = shares * price;
      const commission = Math.ceil(cost * COMMISSION);
      const total = cost + commission;
      if (state.budget < total || shares <= 0) return false;
      setState((prev) => {
        const existing = prev.portfolio[ticker];
        const newShares = (existing?.shares ?? 0) + shares;
        const newAvg = existing
          ? (existing.avgBuyPrice * existing.shares + cost) / newShares
          : price;
        return {
          ...prev,
          budget: prev.budget - total,
          portfolio: {
            ...prev.portfolio,
            [ticker]: { ticker, shares: newShares, avgBuyPrice: newAvg },
          },
        };
      });
      return true;
    },
    [state.budget],
  );

  const sellStock = useCallback(
    (ticker: string, shares: number, price: number): boolean => {
      const holding = state.portfolio[ticker];
      if (!holding || holding.shares < shares || shares <= 0) return false;
      setState((prev) => {
        const proceeds = shares * price;
        const commission = Math.ceil(proceeds * COMMISSION);
        const newShares = prev.portfolio[ticker].shares - shares;
        const newPortfolio = { ...prev.portfolio };
        if (newShares <= 0) {
          delete newPortfolio[ticker];
        } else {
          newPortfolio[ticker] = { ...newPortfolio[ticker], shares: newShares };
        }
        return { ...prev, budget: prev.budget + proceeds - commission, portfolio: newPortfolio };
      });
      return true;
    },
    [state.portfolio],
  );

  const buyBonds = useCallback(
    (amount: number, year: number, month: number): boolean => {
      if (state.budget < amount || amount <= 0) return false;
      const annualYield = getKeyRate(year, month);
      setState((prev) => ({
        ...prev,
        budget: prev.budget - amount,
        bonds: [...(prev.bonds ?? []), { faceValue: amount, annualYield, purchasedYear: year, purchasedMonth: month }],
      }));
      return true;
    },
    [state.budget],
  );

  const sellBonds = useCallback(
    (amount: number): boolean => {
      const totalBondValue = (state.bonds ?? []).reduce((s, b) => s + b.faceValue, 0);
      if (totalBondValue <= 0) return false;
      const accrued = (state.bonds ?? []).reduce((s, b) => s + b.faceValue * (b.annualYield / 12), 0);
      const redeemed = Math.min(amount, totalBondValue);
      setState((prev) => {
        const ratio = redeemed / totalBondValue;
        const newBonds: BondPosition[] = [];
        let remaining = redeemed;
        for (const b of (prev.bonds ?? [])) {
          const take = b.faceValue * ratio;
          remaining -= take;
          if (b.faceValue - take > 1) {
            newBonds.push({ ...b, faceValue: b.faceValue - take });
          }
        }
        return {
          ...prev,
          budget: prev.budget + redeemed + accrued * ratio,
          bonds: newBonds,
        };
      });
      return true;
    },
    [state.bonds],
  );

  const getBondValue = useCallback(
    (): number => (state.bonds ?? []).reduce((s, b) => s + b.faceValue, 0),
    [state.bonds],
  );

  const getPortfolioValue = useCallback(
    (year: number, month = 1): number =>
      Object.values(state.portfolio).reduce((sum: number, item: PortfolioItem) => {
        const key = `${item.ticker}-${year}-${month}`;
        const price = fullPriceMap[key] || priceSnapshot[item.ticker] || 0;
        return sum + item.shares * price;
      }, 0),
    [state.portfolio, fullPriceMap, priceSnapshot],
  );

  const getTotalNetWorth = useCallback(
    (year: number, month = 1): number => state.budget + getPortfolioValue(year, month) + getBondValue(),
    [state.budget, getPortfolioValue, getBondValue],
  );

  const getSharpeRatio = useCallback((): number | null => {
    const raw = state.netWorthHistory ?? [];
    if (raw.length < 2) return null;
    const history = [1_000_000, ...raw];
    const returns: number[] = [];
    for (let i = 1; i < history.length; i++) {
      if (history[i - 1] > 0) returns.push((history[i] - history[i - 1]) / history[i - 1]);
    }
    if (returns.length < 2) return null;
    const mean = returns.reduce((a, b) => a + b, 0) / returns.length;
    const steps = state.crisis?.years ?? [];
    let rfSum = 0, rfCount = 0;
    for (let i = 1; i < steps.length && i < history.length; i++) {
      rfSum += getKeyRate(steps[i].year, steps[i].month) / 12;
      rfCount++;
    }
    const rfMonthly = rfCount > 0 ? rfSum / rfCount : 0.16 / 12;
    const variance = returns.reduce((s, r) => s + Math.pow(r - mean, 2), 0) / (returns.length - 1);
    const stdDev = Math.sqrt(variance);
    if (stdDev === 0) return null;
    return ((mean - rfMonthly) / stdDev) * Math.sqrt(12);
  }, [state.netWorthHistory, state.crisis]);

  const reset = useCallback(() => {
    try {
      localStorage.removeItem(STORAGE_KEY);
    } catch {
      // ignore
    }
    clearSession();
    setState(defaultState);
  }, []);

  return (
    <GameContext.Provider
      value={{
        state, setState, hydrated,
        buyStock, sellStock, buyBonds, sellBonds, getBondValue,
        getPortfolioValue, getTotalNetWorth, getSharpeRatio,
        reset, priceSnapshot, setPriceSnapshot, fullPriceMap, dividendMap, getDbPrice,
      }}
    >
      {children}
    </GameContext.Provider>
  );
}

export function useGame() {
  const ctx = useContext(GameContext);
  if (!ctx) throw new Error('useGame must be used within GameProvider');
  return ctx;
}
