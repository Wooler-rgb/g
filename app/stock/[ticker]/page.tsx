'use client';

import { useState, useEffect, useRef, use } from 'react';
import { useRouter } from 'next/navigation';
import { useGame } from '@/lib/game-context';
import {
  STOCKS, formatPrice, formatMoney, MONTHS_RU,
} from '@/lib/game-data';
import { api, ApiDividend, ApiCandle, ApiTrade } from '@/lib/api-client';

// ============ PRICE LINE CHART ============
function PriceLineChart({
  history,
  crisisStartIndex,
  width,
  height,
}: {
  history: { label: string; price: number }[];
  crisisStartIndex: number;
  width: number;
  height: number;
}) {
  const [hovered, setHovered] = useState<number | null>(null);
  const svgRef = useRef<SVGSVGElement>(null);

  if (history.length === 0) return (
    <div className="flex items-center justify-center h-40 text-sm text-[var(--muted)]">
      Нет данных о ценах
    </div>
  );

  const prices = history.map((h) => h.price).filter((p) => p > 0);
  if (prices.length === 0) return null;

  const minP = Math.min(...prices);
  const maxP = Math.max(...prices);
  const range = maxP - minP || 1;
  const pad = { top: 16, bottom: 28, left: 8, right: 72 };
  const chartW = width - pad.left - pad.right;
  const chartH = height - pad.top - pad.bottom;

  const toX = (i: number) =>
    pad.left + (history.length > 1 ? (i / (history.length - 1)) * chartW : chartW / 2);
  const toY = (p: number) => pad.top + ((maxP - p) / range) * chartH;

  const gridPrices = Array.from({ length: 5 }, (_, i) => minP + (range / 4) * i);

  const linePath = history
    .map((h, i) => `${i === 0 ? 'M' : 'L'} ${toX(i).toFixed(1)},${toY(h.price).toFixed(1)}`)
    .join(' ');
  const areaPath = `${linePath} L ${toX(history.length - 1).toFixed(1)},${pad.top + chartH} L ${toX(0).toFixed(1)},${pad.top + chartH} Z`;

  function handleMouseMove(e: React.MouseEvent<SVGSVGElement>) {
    if (!svgRef.current || history.length < 2) return;
    const rect = svgRef.current.getBoundingClientRect();
    const svgX = ((e.clientX - rect.left) / rect.width) * width;
    const raw = ((svgX - pad.left) / chartW) * (history.length - 1);
    setHovered(Math.max(0, Math.min(history.length - 1, Math.round(raw))));
  }

  const axisTicks = Array.from({ length: Math.min(6, history.length) }, (_, i) =>
    Math.round((i / (Math.min(6, history.length) - 1)) * (history.length - 1)),
  );

  // Crisis start vertical line
  const crisisX = crisisStartIndex > 0 && crisisStartIndex < history.length
    ? toX(crisisStartIndex)
    : null;

  return (
    <div className="relative">
      <svg
        ref={svgRef}
        width="100%"
        height={height}
        viewBox={`0 0 ${width} ${height}`}
        className="chart-crosshair"
        onMouseMove={handleMouseMove}
        onMouseLeave={() => setHovered(null)}
      >
        <defs>
          <linearGradient id="areaGradPre" x1="0" y1="0" x2="0" y2="1">
            <stop offset="0%" stopColor="rgba(53,217,255,0.12)" />
            <stop offset="100%" stopColor="rgba(53,217,255,0)" />
          </linearGradient>
          <linearGradient id="areaGradCrisis" x1="0" y1="0" x2="0" y2="1">
            <stop offset="0%" stopColor="rgba(49,255,140,0.18)" />
            <stop offset="100%" stopColor="rgba(49,255,140,0)" />
          </linearGradient>
          <clipPath id="chartClip">
            <rect x={pad.left} y={pad.top} width={chartW} height={chartH} />
          </clipPath>
          {crisisX && (
            <clipPath id="preClip">
              <rect x={pad.left} y={pad.top} width={crisisX - pad.left} height={chartH} />
            </clipPath>
          )}
          {crisisX && (
            <clipPath id="crisisClip">
              <rect x={crisisX} y={pad.top} width={chartW - (crisisX - pad.left)} height={chartH} />
            </clipPath>
          )}
        </defs>

        {gridPrices.map((p, i) => {
          const y = toY(p);
          return (
            <g key={i}>
              <line x1={pad.left} x2={width - pad.right} y1={y} y2={y}
                stroke="rgba(171,255,217,0.08)" strokeWidth={1} strokeDasharray="4,4" />
              <text x={width - pad.right + 6} y={y + 4} fill="rgba(156,199,180,0.6)" fontSize={9}>
                {formatPrice(p).replace(' ₽', '')}
              </text>
            </g>
          );
        })}

        {/* Area fills */}
        {crisisX ? (
          <>
            <path d={areaPath} fill="url(#areaGradPre)" clipPath="url(#preClip)" />
            <path d={areaPath} fill="url(#areaGradCrisis)" clipPath="url(#crisisClip)" />
          </>
        ) : (
          <path d={areaPath} fill="url(#areaGradCrisis)" clipPath="url(#chartClip)" />
        )}

        {/* Line paths */}
        {crisisX ? (
          <>
            <path d={linePath} fill="none" stroke="rgba(53,217,255,0.6)" strokeWidth={1.5}
              clipPath="url(#preClip)" />
            <path d={linePath} fill="none" stroke="rgba(49,255,140,0.85)" strokeWidth={1.5}
              clipPath="url(#crisisClip)" />
          </>
        ) : (
          <path d={linePath} fill="none" stroke="rgba(49,255,140,0.85)" strokeWidth={1.5}
            clipPath="url(#chartClip)" />
        )}

        {/* Crisis start marker */}
        {crisisX && (
          <>
            <line x1={crisisX} x2={crisisX} y1={pad.top} y2={pad.top + chartH}
              stroke="rgba(255,200,100,0.5)" strokeWidth={1.5} strokeDasharray="5,3" />
            <text x={crisisX + 4} y={pad.top + 10} fill="rgba(255,200,100,0.8)" fontSize={8}>
              Кризис
            </text>
          </>
        )}

        {/* Data points */}
        {history.map((h, i) => (
          <circle key={i} cx={toX(i)} cy={toY(h.price)} r={hovered === i ? 4 : 2}
            fill={hovered === i ? '#31ff8c' : (crisisX && i < crisisStartIndex ? 'rgba(53,217,255,0.5)' : 'rgba(49,255,140,0.5)')}
            style={{ transition: 'r 0.1s' }} />
        ))}

        {hovered !== null && (
          <>
            <line x1={toX(hovered)} x2={toX(hovered)} y1={pad.top} y2={pad.top + chartH}
              stroke="rgba(49,255,140,0.5)" strokeWidth={1} strokeDasharray="3,3" />
            <line x1={pad.left} x2={width - pad.right} y1={toY(history[hovered].price)} y2={toY(history[hovered].price)}
              stroke="rgba(49,255,140,0.25)" strokeWidth={1} strokeDasharray="3,3" />
          </>
        )}

        {axisTicks.map((idx) => (
          <text key={idx} x={toX(idx)} y={height - 6} fill="rgba(156,199,180,0.5)"
            fontSize={9} textAnchor="middle">
            {history[idx]?.label ?? ''}
          </text>
        ))}
      </svg>

      {hovered !== null && (
        <div className="absolute top-2 left-2 rounded-lg px-3 py-2 text-xs pointer-events-none z-10"
          style={{ background: 'var(--surface-strong)', border: '1px solid var(--line-strong)' }}>
          <span className="text-[var(--muted)]">{history[hovered].label}: </span>
          <span className="font-bold text-[var(--accent)]">{formatPrice(history[hovered].price)}</span>
        </div>
      )}

      {/* Legend */}
      {crisisX && (
        <div className="flex gap-4 mt-2 text-xs text-[var(--muted)]">
          <span className="flex items-center gap-1">
            <span className="w-3 h-0.5 inline-block rounded" style={{ background: 'rgba(53,217,255,0.7)' }} />
            До кризиса
          </span>
          <span className="flex items-center gap-1">
            <span className="w-3 h-0.5 inline-block rounded" style={{ background: 'rgba(49,255,140,0.8)' }} />
            Кризис
          </span>
        </div>
      )}
    </div>
  );
}

// ============ CANDLESTICK CHART ============
type Timeframe = 'day' | 'week' | 'month' | '3m' | 'year';
const TF_LABELS: { key: Timeframe; label: string }[] = [
  { key: 'day', label: '1Д' },
  { key: 'week', label: '1Н' },
  { key: 'month', label: '1М' },
  { key: '3m', label: '3М' },
  { key: 'year', label: '1Г' },
];

function CandlestickChart({
  candles,
  width,
  height,
}: {
  candles: ApiCandle[];
  width: number;
  height: number;
}) {
  const [hovered, setHovered] = useState<number | null>(null);
  const svgRef = useRef<SVGSVGElement>(null);

  if (candles.length === 0) return (
    <div className="flex items-center justify-center h-40 text-sm text-[var(--muted)]">
      Нет данных о свечах
    </div>
  );

  const highs = candles.map((c) => c.high);
  const lows = candles.map((c) => c.low);
  const minP = Math.min(...lows);
  const maxP = Math.max(...highs);
  const range = maxP - minP || 1;

  const pad = { top: 16, bottom: 28, left: 8, right: 72 };
  const chartW = width - pad.left - pad.right;
  const chartH = height - pad.top - pad.bottom;
  const n = candles.length;
  const slotW = chartW / n;
  const bodyW = Math.max(1, slotW * 0.6);

  const toX = (i: number) => pad.left + (i + 0.5) * slotW;
  const toY = (p: number) => pad.top + ((maxP - p) / range) * chartH;

  const gridPrices = Array.from({ length: 5 }, (_, i) => minP + (range / 4) * i);

  function handleMouseMove(e: React.MouseEvent<SVGSVGElement>) {
    if (!svgRef.current) return;
    const rect = svgRef.current.getBoundingClientRect();
    const svgX = ((e.clientX - rect.left) / rect.width) * width;
    const idx = Math.floor((svgX - pad.left) / slotW);
    setHovered(idx >= 0 && idx < n ? idx : null);
  }

  const axisTicks = Array.from({ length: Math.min(6, n) }, (_, i) =>
    Math.round((i / Math.max(1, Math.min(6, n) - 1)) * (n - 1)),
  );

  const fmtLabel = (t: string) => {
    // "2024-12-01 09:00:00" → "01.12" or "09:00"
    const [date, time] = t.split(' ');
    if (date && time) {
      const parts = date.split('-');
      if (parts.length === 3) return `${parts[2]}.${parts[1]}`;
    }
    return (time ?? t).slice(0, 5);
  };

  return (
    <div className="relative">
      <svg
        ref={svgRef}
        width="100%"
        height={height}
        viewBox={`0 0 ${width} ${height}`}
        className="chart-crosshair"
        onMouseMove={handleMouseMove}
        onMouseLeave={() => setHovered(null)}
      >
        {gridPrices.map((p, i) => {
          const y = toY(p);
          return (
            <g key={i}>
              <line x1={pad.left} x2={width - pad.right} y1={y} y2={y}
                stroke="rgba(171,255,217,0.08)" strokeWidth={1} strokeDasharray="4,4" />
              <text x={width - pad.right + 6} y={y + 4} fill="rgba(156,199,180,0.6)" fontSize={9}>
                {formatPrice(p).replace(' ₽', '')}
              </text>
            </g>
          );
        })}

        {candles.map((c, i) => {
          const isGreen = c.close >= c.open;
          const color = isGreen ? 'rgba(49,255,140,0.9)' : 'rgba(255,120,135,0.9)';
          const x = toX(i);
          const bodyTop = toY(Math.max(c.open, c.close));
          const bodyBot = toY(Math.min(c.open, c.close));
          const bodyH = Math.max(1, bodyBot - bodyTop);

          return (
            <g key={i} opacity={hovered !== null && hovered !== i ? 0.5 : 1}>
              <line x1={x} x2={x} y1={toY(c.high)} y2={toY(c.low)}
                stroke={color} strokeWidth={1} />
              <rect
                x={x - bodyW / 2} y={bodyTop}
                width={bodyW} height={bodyH}
                fill={isGreen ? color : 'none'}
                stroke={color} strokeWidth={1} rx={0.5}
              />
            </g>
          );
        })}

        {hovered !== null && (
          <line x1={toX(hovered)} x2={toX(hovered)} y1={pad.top} y2={pad.top + chartH}
            stroke="rgba(49,255,140,0.3)" strokeWidth={1} strokeDasharray="3,3" />
        )}

        {axisTicks.map((idx) => (
          <text key={idx} x={toX(idx)} y={height - 6}
            fill="rgba(156,199,180,0.5)" fontSize={9} textAnchor="middle">
            {fmtLabel(candles[idx]?.time ?? '')}
          </text>
        ))}
      </svg>

      {hovered !== null && (
        <div className="absolute top-2 left-2 rounded-lg px-3 py-2 text-xs pointer-events-none z-10"
          style={{ background: 'var(--surface-strong)', border: '1px solid var(--line-strong)' }}>
          <div className="text-[var(--muted)] mb-1 font-mono">{candles[hovered].time.slice(0, 16)}</div>
          <div className="grid grid-cols-2 gap-x-3 gap-y-0.5">
            <span className="text-[var(--muted)]">O:</span>
            <span className="font-mono">{formatPrice(candles[hovered].open)}</span>
            <span className="text-[var(--muted)]">H:</span>
            <span className="font-mono" style={{ color: 'var(--accent)' }}>{formatPrice(candles[hovered].high)}</span>
            <span className="text-[var(--muted)]">L:</span>
            <span className="font-mono" style={{ color: 'var(--danger)' }}>{formatPrice(candles[hovered].low)}</span>
            <span className="text-[var(--muted)]">C:</span>
            <span className="font-mono font-bold">{formatPrice(candles[hovered].close)}</span>
          </div>
        </div>
      )}
    </div>
  );
}

// ============ RECENT TRADES ============
function RecentTradesSection({ ticker }: { ticker: string }) {
  const [trades, setTrades] = useState<ApiTrade[]>([]);
  const [loading, setLoading] = useState(true);

  useEffect(() => {
    const load = () => {
      api.stocks.trades(ticker)
        .then(({ trades: t }) => setTrades(t))
        .catch(() => {})
        .finally(() => setLoading(false));
    };
    load();
    const id = setInterval(load, 30_000);
    return () => clearInterval(id);
  }, [ticker]);

  return (
    <div className="glass-panel rounded-2xl p-4 rise-in-2">
      <div className="flex items-center justify-between mb-3">
        <div className="text-sm font-bold">Последние сделки</div>
        <span className="flex items-center gap-1 text-xs text-[var(--muted)]">
          <span className="w-1.5 h-1.5 rounded-full bg-red-500 animate-pulse" /> Live
        </span>
      </div>
      {loading ? (
        <div className="text-xs text-[var(--muted)]">Загрузка...</div>
      ) : trades.length === 0 ? (
        <div className="text-xs text-[var(--muted)]">Нет данных — торги не идут или биржа закрыта</div>
      ) : (
        <div className="overflow-x-auto">
          <table className="w-full text-xs font-mono">
            <thead>
              <tr className="text-[var(--muted)] border-b border-[var(--line)]">
                <th className="text-left pb-2">Время</th>
                <th className="text-right pb-2">Цена</th>
                <th className="text-right pb-2">Кол-во</th>
                <th className="text-right pb-2">Объём</th>
              </tr>
            </thead>
            <tbody>
              {trades.slice(0, 30).map((t, i) => {
                const isBuy = t.buysell === 'B';
                const isSell = t.buysell === 'S';
                const color = isBuy
                  ? 'var(--accent)'
                  : isSell
                  ? 'var(--danger)'
                  : 'var(--foreground)';
                return (
                  <tr key={t.no || i} className="border-b border-[var(--line)] hover:bg-white/3 transition-colors">
                    <td className="py-1.5 text-[var(--muted)]">{t.time}</td>
                    <td className="py-1.5 text-right font-bold" style={{ color }}>
                      {formatPrice(t.price)}
                    </td>
                    <td className="py-1.5 text-right">{t.quantity.toLocaleString('ru-RU')}</td>
                    <td className="py-1.5 text-right text-[var(--muted)]">
                      {t.value >= 1_000_000
                        ? `${(t.value / 1_000_000).toFixed(1)}М`
                        : t.value >= 1_000
                        ? `${(t.value / 1_000).toFixed(0)}К`
                        : t.value.toFixed(0)}
                    </td>
                  </tr>
                );
              })}
            </tbody>
          </table>
        </div>
      )}
    </div>
  );
}

// ============ DIVIDEND HISTORY ============
function DividendHistorySection({
  ticker,
  untilYear,
  untilMonth,
}: {
  ticker: string;
  untilYear: number;
  untilMonth: number;
}) {
  const [dividends, setDividends] = useState<ApiDividend[]>([]);
  const [loading, setLoading] = useState(true);

  useEffect(() => {
    api.dividends.forTicker(ticker)
      .then(({ dividends: d }) => {
        // Показываем только дивиденды, выплаченные до текущего шага игры
        const paid = d.filter(
          (div) => div.year < untilYear || (div.year === untilYear && div.month <= untilMonth),
        );
        setDividends(paid);
      })
      .catch(() => {})
      .finally(() => setLoading(false));
  }, [ticker, untilYear, untilMonth]);

  if (loading) return (
    <div className="glass-panel rounded-2xl p-4">
      <div className="text-sm font-bold mb-3">История дивидендов</div>
      <div className="text-xs text-[var(--muted)]">Загрузка...</div>
    </div>
  );

  if (dividends.length === 0) return null;

  function formatPaymentDate(raw: string): string {
    try {
      const d = new Date(raw);
      return d.toLocaleDateString('ru-RU', { day: '2-digit', month: '2-digit', year: 'numeric' });
    } catch {
      return raw;
    }
  }

  return (
    <div className="glass-panel rounded-2xl p-4 rise-in-2">
      <div className="text-sm font-bold mb-3">История дивидендов</div>
      <div className="overflow-x-auto">
        <table className="w-full text-sm">
          <thead>
            <tr className="text-[var(--muted)] text-xs border-b border-[var(--line)]">
              <th className="text-left pb-2">Дата выплаты</th>
              <th className="text-right pb-2">На акцию</th>
              <th className="text-right pb-2">Валюта</th>
            </tr>
          </thead>
          <tbody>
            {dividends.map((d, i) => (
              <tr key={i} className="border-b border-[var(--line)] hover:bg-white/3 transition-colors">
                <td className="py-2 text-xs font-mono">{formatPaymentDate(d.paymentDate)}</td>
                <td className="py-2 text-right font-mono font-bold text-[var(--accent)]">
                  {d.perShare.toLocaleString('ru-RU', { maximumFractionDigits: 2 })}
                </td>
                <td className="py-2 text-right text-xs text-[var(--muted)]">{d.currency}</td>
              </tr>
            ))}
          </tbody>
        </table>
      </div>
    </div>
  );
}

// ============ MAIN PAGE ============
export default function StockPage({ params }: { params: Promise<{ ticker: string }> }) {
  const { ticker } = use(params);
  const router = useRouter();
  const { state, hydrated, buyStock, sellStock, getDbPrice, priceSnapshot } = useGame();
  const chartRef = useRef<HTMLDivElement>(null);
  const [chartWidth, setChartWidth] = useState(600);
  const [orderType, setOrderType] = useState<'buy' | 'sell'>('buy');
  const [amount, setAmount] = useState('');
  const [notification, setNotification] = useState<{ msg: string; ok: boolean } | null>(null);
  const [rtPrices, setRtPrices] = useState<Record<string, number>>({});
  // Pre-crisis price history (4 years before crisis start)
  const [allPrices, setAllPrices] = useState<{ year: number; month: number; price: number }[]>([]);
  // Realtime candlestick chart
  const [tf, setTf] = useState<Timeframe>('month');
  const [candles, setCandles] = useState<ApiCandle[]>([]);
  const [candlesLoading, setCandlesLoading] = useState(false);
  const [mobileTab, setMobileTab] = useState<'chart' | 'trade'>('chart');

  const crisis = state.crisis;
  const isRealtime = state.mode === 'realtime';
  const isMulti = state.mode === 'multi';

  useEffect(() => {
    if (!hydrated) return;
    if (!state.username || (!isRealtime && !crisis)) { router.push('/'); return; }
  }, [hydrated, state.username, isRealtime, crisis]);

  // Multi mode: poll room state — redirect back to /trading when host advances or ends game
  useEffect(() => {
    if (!isMulti || !state.roomCode) return;
    const knownStep = state.currentYearIndex;
    const poll = () => {
      api.rooms.get(state.roomCode)
        .then((room) => {
          if (room.status === 'finished') { router.push('/results'); return; }
          if ((room.currentStepIndex ?? 0) > knownStep) { router.push('/trading'); }
        })
        .catch(() => {});
    };
    const id = setInterval(poll, 3000);
    return () => clearInterval(id);
  }, [isMulti, state.roomCode, state.currentYearIndex]); // eslint-disable-line react-hooks/exhaustive-deps

  // Load full price history for extended chart
  useEffect(() => {
    api.stocks.get(ticker)
      .then((d) => setAllPrices(d.prices ?? []))
      .catch(() => {});
  }, [ticker]);

  useEffect(() => {
    if (!isRealtime) return;
    if (Object.keys(priceSnapshot).length > 0) setRtPrices(priceSnapshot);
  }, [isRealtime, priceSnapshot]);

  // Fetch candles when in realtime mode or timeframe changes
  useEffect(() => {
    if (!isRealtime) return;
    setCandlesLoading(true);
    api.stocks.candles(ticker, tf)
      .then(({ candles: c }) => setCandles(c))
      .catch(() => setCandles([]))
      .finally(() => setCandlesLoading(false));
  }, [isRealtime, ticker, tf]); // eslint-disable-line react-hooks/exhaustive-deps

  useEffect(() => {
    const obs = new ResizeObserver((entries) => {
      setChartWidth(entries[0].contentRect.width);
    });
    if (chartRef.current) obs.observe(chartRef.current);
    return () => obs.disconnect();
  }, []);

  if (!state.username || (!isRealtime && !crisis)) return null;

  const stock = STOCKS.find((s) => s.ticker === ticker);
  if (!stock) return (
    <div className="min-h-screen flex items-center justify-center">
      <div className="text-[var(--muted)]">Акция не найдена</div>
    </div>
  );

  const yearIndex = state.currentYearIndex;
  const stepData = crisis?.years[yearIndex];
  const prevStepData = crisis?.years[Math.max(0, yearIndex - 1)];
  const currentYear = stepData?.year ?? new Date().getFullYear();
  const currentMonth = stepData?.month ?? new Date().getMonth() + 1;
  const prevYear = prevStepData?.year ?? currentYear;
  const prevMonth = prevStepData?.month ?? currentMonth;

  const price = isRealtime
    ? (rtPrices[ticker] ?? 0)
    : getDbPrice(ticker, currentYear, currentMonth);
  const prevPrice = isRealtime
    ? (rtPrices[ticker] ?? 0)
    : getDbPrice(ticker, prevYear, prevMonth);
  const change = isRealtime || prevPrice === 0 ? 0 : ((price - prevPrice) / prevPrice) * 100;
  const isUp = change >= 0;
  const holding = state.portfolio[ticker];

  const COMMISSION_RATE = 0.005;
  const sharesInput = parseInt(amount) || 0;
  const totalCost = sharesInput * price;
  const commission = Math.ceil(totalCost * COMMISSION_RATE);
  const totalWithCommission = totalCost + commission;
  const netProceeds = totalCost - commission;
  const canBuy = sharesInput > 0 && totalWithCommission <= state.budget;
  const canSell = sharesInput > 0 && (holding?.shares ?? 0) >= sharesInput;

  // ROI calculation
  const roi = holding && price > 0 && holding.avgBuyPrice > 0
    ? ((price - holding.avgBuyPrice) / holding.avgBuyPrice) * 100
    : null;

  function notify(msg: string, ok: boolean) {
    setNotification({ msg, ok });
    setTimeout(() => setNotification(null), 2500);
  }

  function handleTrade() {
    if (orderType === 'buy') {
      if (buyStock(ticker, sharesInput, price)) {
        notify(`✓ Куплено ${sharesInput.toLocaleString('ru-RU')} шт ${ticker}`, true);
        setAmount('');
      } else {
        notify('Недостаточно средств', false);
      }
    } else {
      if (sellStock(ticker, sharesInput, price)) {
        notify(`✓ Продано ${sharesInput.toLocaleString('ru-RU')} шт ${ticker}`, true);
        setAmount('');
      } else {
        notify('Недостаточно акций', false);
      }
    }
  }

  const maxBuyShares = price > 0 ? Math.floor(state.budget / (price * 1.005)) : 0;
  const maxSellShares = holding?.shares ?? 0;

  // ---- Build extended price history for chart ----
  const crisisStartYear = crisis?.years[0]?.year ?? 0;
  const crisisStartMonth = crisis?.years[0]?.month ?? 1;
  const crisisStartOrd = crisisStartYear * 12 + crisisStartMonth;
  const chartStartOrd = (crisisStartYear - 4) * 12 + crisisStartMonth;

  const stepHistory = isRealtime
    ? [{ label: new Date().toLocaleDateString('ru-RU', { day: 'numeric', month: 'short' }), price }]
    : (() => {
        // Pre-crisis history from DB (4 years before crisis start)
        const preHistory = allPrices
          .filter((p) => {
            const ord = p.year * 12 + p.month;
            return ord >= chartStartOrd && ord < crisisStartOrd && p.price > 0;
          })
          .sort((a, b) => (a.year * 12 + a.month) - (b.year * 12 + b.month))
          .map((p) => ({ label: `${MONTHS_RU[p.month]} ${p.year}`, price: p.price }));

        // Crisis history up to current step
        const crisisHistory = (crisis?.years ?? [])
          .slice(0, yearIndex + 1)
          .map((s) => ({ label: s.label, price: getDbPrice(ticker, s.year, s.month) }))
          .filter((d) => d.price > 0);

        return [...preHistory, ...crisisHistory];
      })();

  // Index where crisis starts in the combined history
  const crisisStartIndex = isRealtime ? 0 : stepHistory.length - (crisis?.years.slice(0, yearIndex + 1).filter(s => getDbPrice(ticker, s.year, s.month) > 0).length ?? 0);

  return (
    <div className="min-h-screen app-grid">
      {notification && (
        <div
          className="fixed top-4 right-4 z-50 px-5 py-3 rounded-xl font-bold text-sm scale-in"
          style={{
            background: notification.ok ? 'rgba(49,255,140,0.15)' : 'rgba(255,120,135,0.15)',
            border: `1px solid ${notification.ok ? 'rgba(49,255,140,0.4)' : 'rgba(255,120,135,0.4)'}`,
            color: notification.ok ? 'var(--accent)' : 'var(--danger)',
          }}
        >
          {notification.msg}
        </div>
      )}

      {/* TOP */}
      <div
        className="flex items-center gap-4 px-4 py-3 border-b border-[var(--line)]"
        style={{ background: 'var(--surface-strong)', backdropFilter: 'blur(20px)' }}
      >
        <button onClick={() => router.push('/trading')}
          className="text-[var(--muted)] hover:text-[var(--foreground)] transition-colors text-sm flex items-center gap-1">
          ← Торги
        </button>
        <div
          className="w-8 h-8 rounded-lg flex items-center justify-center text-xs font-black"
          style={{ background: stock.color + '22', color: stock.color, border: `1px solid ${stock.color}44` }}
        >
          {ticker.slice(0, 2)}
        </div>
        <div>
          <div className="font-black text-lg">{ticker}</div>
          <div className="text-xs text-[var(--muted)]">{stock.name} · {stock.sector}</div>
        </div>
        <div className="ml-4">
          <div className="text-2xl font-black">{formatPrice(price)}</div>
          <div className="text-sm font-bold" style={{ color: isUp ? 'var(--accent)' : 'var(--danger)' }}>
            {isUp ? '▲' : '▼'} {Math.abs(change).toFixed(2)}% за месяц
          </div>
        </div>
        <div className="ml-auto text-sm text-[var(--muted)] flex items-center gap-1">
          {isRealtime
            ? <><span className="w-1.5 h-1.5 rounded-full bg-red-500 animate-pulse" /> LIVE</>
            : stepData?.label}
        </div>
      </div>

      {/* Mobile tab bar */}
      <div className="flex sm:hidden border-b border-[var(--line)]" style={{ background: 'rgba(4,17,13,0.95)' }}>
        {(['chart', 'trade'] as const).map((tab) => (
          <button
            key={tab}
            onClick={() => setMobileTab(tab)}
            className="flex-1 py-2.5 text-sm font-bold transition-colors"
            style={{
              color: mobileTab === tab ? 'var(--accent)' : 'var(--muted)',
              borderBottom: mobileTab === tab ? '2px solid var(--accent)' : '2px solid transparent',
            }}
          >
            {tab === 'chart' ? '📊 График' : '💰 Торги'}
          </button>
        ))}
      </div>

      <div className="grid grid-cols-1 sm:grid-cols-[1fr_320px] gap-0 h-[calc(100vh-98px)] sm:h-[calc(100vh-57px)]">
        {/* LEFT */}
        <div className={`overflow-y-auto p-4 space-y-4 ${mobileTab === 'trade' ? 'hidden sm:block' : ''}`}>
          {/* Chart */}
          <div className="glass-panel rounded-2xl p-4 rise-in">
            <div className="flex items-center justify-between mb-3">
              <div className="text-sm font-bold">
                График {ticker}
                {!isRealtime && crisisStartYear > 0 && (
                  <span className="text-xs text-[var(--muted)] ml-2">
                    {crisisStartYear - 4} — {stepData?.label ?? ''}
                  </span>
                )}
              </div>
              {isRealtime && (
                <div className="flex gap-1">
                  {TF_LABELS.map(({ key, label }) => (
                    <button
                      key={key}
                      onClick={() => setTf(key)}
                      className="px-2 py-1 rounded text-xs font-bold transition-colors"
                      style={{
                        background: tf === key ? 'rgba(49,255,140,0.15)' : 'rgba(255,255,255,0.05)',
                        color: tf === key ? 'var(--accent)' : 'var(--muted)',
                        border: `1px solid ${tf === key ? 'rgba(49,255,140,0.3)' : 'transparent'}`,
                      }}
                    >
                      {label}
                    </button>
                  ))}
                </div>
              )}
            </div>
            <div ref={chartRef}>
              {isRealtime ? (
                candlesLoading ? (
                  <div className="flex items-center justify-center h-[280px] text-sm text-[var(--muted)]">
                    Загрузка свечей...
                  </div>
                ) : (
                  <CandlestickChart
                    candles={candles}
                    width={chartWidth - 32}
                    height={280}
                  />
                )
              ) : (
                <PriceLineChart
                  history={stepHistory}
                  crisisStartIndex={crisisStartIndex}
                  width={chartWidth - 32}
                  height={280}
                />
              )}
            </div>
          </div>

          {/* Historical prices table */}
          <div className="glass-panel rounded-2xl p-4 rise-in-1">
            <div className="text-sm font-bold mb-3">Доходность по месяцам (кризисный период)</div>
            <div className="overflow-x-auto">
              <table className="w-full text-sm">
                <thead>
                  <tr className="text-[var(--muted)] text-xs border-b border-[var(--line)]">
                    <th className="text-left pb-2">Месяц</th>
                    <th className="text-right pb-2">Цена</th>
                    <th className="text-right pb-2">Изменение</th>
                  </tr>
                </thead>
                <tbody>
                  {(crisis?.years ?? []).slice(0, yearIndex + 1).map((s, i, arr) => {
                    const rowPrice = getDbPrice(ticker, s.year, s.month);
                    const prevS = arr[i - 1];
                    const prevRowPrice = prevS ? getDbPrice(ticker, prevS.year, prevS.month) : 0;
                    const rowChg = prevRowPrice > 0 ? ((rowPrice - prevRowPrice) / prevRowPrice) * 100 : 0;
                    const isCurrent = i === arr.length - 1;
                    return (
                      <tr key={s.label} className="border-b border-[var(--line)] hover:bg-white/3 transition-colors"
                        style={{ opacity: isCurrent ? 1 : 0.7 }}>
                        <td className="py-2">
                          <span className={isCurrent ? 'font-bold text-[var(--accent)]' : ''}>{s.label}</span>
                        </td>
                        <td className="py-2 text-right font-mono">{formatPrice(rowPrice)}</td>
                        <td className="py-2 text-right">
                          {i > 0 && rowPrice > 0 && (
                            <span style={{ color: rowChg >= 0 ? 'var(--accent)' : 'var(--danger)' }}>
                              {rowChg >= 0 ? '▲' : '▼'} {Math.abs(rowChg).toFixed(1)}%
                            </span>
                          )}
                        </td>
                      </tr>
                    );
                  })}
                </tbody>
              </table>
            </div>
          </div>

          {/* Key metrics */}
          <div className="glass-panel rounded-2xl p-4 rise-in-2">
            <div className="text-sm font-bold mb-3">Ключевые показатели</div>
            <div className="grid grid-cols-2 sm:grid-cols-3 gap-3">
              {[
                { label: 'Текущая цена', value: formatPrice(price) },
                { label: 'Прошлый месяц', value: formatPrice(prevPrice) },
                { label: 'Изм. за месяц', value: `${isUp ? '+' : ''}${change.toFixed(2)}%`, color: isUp ? 'var(--accent)' : 'var(--danger)' },
                { label: 'В портфеле', value: holding ? `${holding.shares.toLocaleString('ru-RU')} шт` : '—' },
                { label: 'Ср. цена покупки', value: holding ? formatPrice(holding.avgBuyPrice) : '—' },
                { label: 'Стоимость пакета', value: holding ? formatMoney(holding.shares * price) : '—' },
                {
                  label: 'ROI',
                  value: roi !== null ? `${roi >= 0 ? '+' : ''}${roi.toFixed(2)}%` : '—',
                  color: roi !== null ? (roi >= 0 ? 'var(--accent)' : 'var(--danger)') : undefined,
                },
              ].map((m) => (
                <div key={m.label} className="rounded-xl p-3" style={{ background: 'rgba(255,255,255,0.03)', border: '1px solid var(--line)' }}>
                  <div className="text-xs text-[var(--muted)] mb-1">{m.label}</div>
                  <div className="font-bold text-sm" style={{ color: m.color ?? 'var(--foreground)' }}>{m.value}</div>
                </div>
              ))}
            </div>
          </div>

          {/* Recent trades (realtime only) */}
          {isRealtime && <RecentTradesSection ticker={ticker} />}

          {/* Dividend history from DB */}
          <DividendHistorySection ticker={ticker} untilYear={currentYear} untilMonth={currentMonth} />
        </div>

        {/* RIGHT: BUY/SELL */}
        <div
          className={`border-l border-[var(--line)] overflow-y-auto flex flex-col ${mobileTab === 'chart' ? 'hidden sm:flex' : ''}`}
          style={{ background: 'rgba(4,17,13,0.95)' }}
        >
          <div className="p-4 flex-1">
            <div className="flex rounded-xl overflow-hidden mb-4" style={{ border: '1px solid var(--line)' }}>
              {(['buy', 'sell'] as const).map((t) => (
                <button
                  key={t}
                  onClick={() => setOrderType(t)}
                  className="flex-1 py-2.5 text-sm font-bold transition-all"
                  style={{
                    background: orderType === t
                      ? (t === 'buy' ? 'rgba(49,255,140,0.2)' : 'rgba(255,120,135,0.2)')
                      : 'transparent',
                    color: orderType === t
                      ? (t === 'buy' ? 'var(--accent)' : 'var(--danger)')
                      : 'var(--muted)',
                  }}
                >
                  {t === 'buy' ? '↑ Купить' : '↓ Продать'}
                </button>
              ))}
            </div>

            <div className="space-y-3">
              <div>
                <label className="text-xs text-[var(--muted)] block mb-1.5">Количество акций</label>
                <input
                  type="number"
                  value={amount}
                  onChange={(e) => setAmount(e.target.value)}
                  placeholder="0"
                  min={1}
                  className="w-full px-3 py-2.5 rounded-xl text-[var(--foreground)] placeholder-[var(--muted)] outline-none text-sm"
                  style={{ background: 'rgba(255,255,255,0.05)', border: '1px solid var(--line-strong)' }}
                />
                <div className="flex gap-2 mt-1.5">
                  {[25, 50, 75, 100].map((pct) => (
                    <button
                      key={pct}
                      onClick={() => {
                        const max = orderType === 'buy' ? maxBuyShares : maxSellShares;
                        setAmount(String(Math.floor(max * pct / 100)));
                      }}
                      className="flex-1 py-1 rounded text-xs font-bold transition-colors hover:bg-white/10"
                      style={{ background: 'rgba(255,255,255,0.05)', color: 'var(--muted)' }}
                    >
                      {pct}%
                    </button>
                  ))}
                </div>
              </div>

              <div className="rounded-xl p-3 space-y-2" style={{ background: 'rgba(255,255,255,0.03)', border: '1px solid var(--line)' }}>
                <div className="flex justify-between text-xs">
                  <span className="text-[var(--muted)]">Цена акции</span>
                  <span>{formatPrice(price)}</span>
                </div>
                <div className="flex justify-between text-xs">
                  <span className="text-[var(--muted)]">Количество</span>
                  <span>{sharesInput.toLocaleString('ru-RU')} шт</span>
                </div>
                <div className="flex justify-between text-xs">
                  <span className="text-[var(--muted)]">Комиссия (0.5%)</span>
                  <span className="text-[var(--warning)]">−{formatMoney(commission)}</span>
                </div>
                <div className="flex justify-between text-sm font-bold border-t border-[var(--line)] pt-2">
                  <span className="text-[var(--muted)]">Итого</span>
                  <span style={{ color: orderType === 'buy' ? 'var(--danger)' : 'var(--accent)' }}>
                    {formatMoney(orderType === 'buy' ? totalWithCommission : netProceeds)}
                  </span>
                </div>
              </div>

              {orderType === 'buy' ? (
                <div className="text-xs text-[var(--muted)]">
                  Доступно: <span className="text-[var(--accent)]">{formatMoney(state.budget)}</span>
                  · Макс: <span className="font-bold">{maxBuyShares.toLocaleString('ru-RU')} шт</span>
                </div>
              ) : (
                <div className="text-xs text-[var(--muted)]">
                  В портфеле: <span className="text-[var(--accent)] font-bold">
                    {(holding?.shares ?? 0).toLocaleString('ru-RU')} шт
                  </span>
                </div>
              )}

              <button
                onClick={handleTrade}
                disabled={orderType === 'buy' ? !canBuy : !canSell}
                className="w-full py-3.5 rounded-xl font-bold text-sm transition-all hover:scale-[1.02] active:scale-95 disabled:opacity-40 disabled:cursor-not-allowed"
                style={{
                  background: orderType === 'buy'
                    ? 'linear-gradient(135deg, var(--accent), var(--accent-soft))'
                    : 'linear-gradient(135deg, var(--danger), rgba(255,120,135,0.7))',
                  color: '#061712',
                }}
              >
                {orderType === 'buy' ? '↑ Купить' : '↓ Продать'} {ticker}
              </button>
            </div>
          </div>
        </div>
      </div>
    </div>
  );
}
