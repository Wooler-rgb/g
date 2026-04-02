'use client';

import { useState, useEffect, useRef } from 'react';
import { useRouter } from 'next/navigation';
import Link from 'next/link';
import { useGame } from '@/lib/game-context';
import { STOCKS, MONTHS_RU, formatPrice, formatMoney, getBotNetWorth, inflationAdjusted, getKeyRate } from '@/lib/game-data';
import { api, ApiCrisis } from '@/lib/api-client';
import { BondPosition } from '@/lib/types';

// ============ BUDGET CHART ============
function BudgetChart({ budget, invested, bonds, total, sharpe }: {
  budget: number; invested: number; bonds: number; total: number; sharpe: number | null;
}) {
  const pctFree = total > 0 ? (budget / total) * 100 : 100;
  const pctInvested = total > 0 ? (invested / total) * 100 : 0;
  const pctBonds = total > 0 ? (bonds / total) * 100 : 0;
  const pnl = total - 1_000_000;

  return (
    <div className="glass-panel rounded-2xl p-4 mb-4">
      <div className="flex items-center justify-between mb-3">
        <span className="text-xs font-bold tracking-wider text-[var(--muted)] uppercase">Капитал</span>
        <span
          className="text-sm font-bold"
          style={{ color: pnl >= 0 ? 'var(--accent)' : 'var(--danger)' }}
        >
          {pnl >= 0 ? '+' : ''}{formatMoney(pnl)}
        </span>
      </div>
      <div className="text-2xl font-black aurora-text mb-3">{formatMoney(total)}</div>
      {/* Bar */}
      <div className="h-3 rounded-full overflow-hidden flex gap-0.5 mb-3" style={{ background: 'rgba(255,255,255,0.06)' }}>
        <div
          className="h-full transition-all duration-700"
          style={{ width: `${pctFree}%`, background: 'linear-gradient(90deg, var(--accent), var(--accent-soft))', borderRadius: pctInvested + pctBonds > 0 ? '999px 0 0 999px' : '999px' }}
        />
        {pctInvested > 0 && (
          <div
            className="h-full transition-all duration-700"
            style={{ width: `${pctInvested}%`, background: 'linear-gradient(90deg, var(--accent-blue), rgba(53,217,255,0.5))', borderRadius: pctBonds > 0 ? '0' : '0 999px 999px 0' }}
          />
        )}
        {pctBonds > 0 && (
          <div
            className="h-full rounded-r-full transition-all duration-700"
            style={{ width: `${pctBonds}%`, background: 'linear-gradient(90deg, #ffc626, rgba(255,198,38,0.5))' }}
          />
        )}
      </div>
      <div className="flex flex-wrap gap-x-4 gap-y-1 text-xs text-[var(--muted)]">
        <span>
          <span className="inline-block w-2 h-2 rounded-full mr-1" style={{ background: 'var(--accent)' }} />
          Свободно: {formatMoney(budget)}
        </span>
        <span>
          <span className="inline-block w-2 h-2 rounded-full mr-1" style={{ background: 'var(--accent-blue)' }} />
          Акции: {formatMoney(invested)}
        </span>
        {bonds > 0 && (
          <span>
            <span className="inline-block w-2 h-2 rounded-full mr-1" style={{ background: '#ffc626' }} />
            ОФЗ: {formatMoney(bonds)}
          </span>
        )}
      </div>
      {sharpe !== null && (
        <div className="mt-3 pt-3 border-t border-[var(--line)] flex items-center justify-between">
          <span className="text-xs text-[var(--muted)]">Коэф. Шарпа портфеля</span>
          <span className="text-xs font-bold" style={{ color: sharpe >= 1 ? 'var(--accent)' : sharpe >= 0 ? 'var(--warning)' : 'var(--danger)' }}>
            {sharpe.toFixed(2)}
          </span>
        </div>
      )}
    </div>
  );
}

// ============ STOCK ROW ============
function StockRow({ ticker, name, price, prevPrice, color, ownedShares, onClick }: {
  ticker: string; name: string; price: number; prevPrice: number; color: string;
  ownedShares: number; onClick: () => void;
}) {
  const chg = prevPrice > 0 ? ((price - prevPrice) / prevPrice) * 100 : 0;
  const isUp = chg >= 0;

  if (price === 0) return null;

  return (
    <button
      onClick={onClick}
      className="w-full flex items-center gap-3 px-3 py-2.5 rounded-xl hover:bg-white/5 transition-all group text-left"
    >
      <div
        className="w-9 h-9 rounded-lg flex items-center justify-center text-xs font-black flex-shrink-0"
        style={{ background: color + '22', color, border: `1px solid ${color}44` }}
      >
        {ticker.slice(0, 2)}
      </div>
      <div className="flex-1 min-w-0">
        <div className="font-bold text-sm leading-tight">{ticker}</div>
        <div className="text-xs text-[var(--muted)] truncate">{name}</div>
      </div>
      <div className="text-right flex-shrink-0">
        <div className="font-bold text-sm">{formatPrice(price)}</div>
        <div className="text-xs font-bold" style={{ color: isUp ? 'var(--accent)' : 'var(--danger)' }}>
          {isUp ? '▲' : '▼'} {Math.abs(chg).toFixed(1)}%
        </div>
      </div>
      {ownedShares > 0 && (
        <div
          className="w-1.5 h-full rounded-full flex-shrink-0"
          style={{ background: 'var(--accent)', minHeight: '32px' }}
        />
      )}
    </button>
  );
}

// ============ PORTFOLIO MODAL ============
function PortfolioModal({ onClose, year, month, prevYear, prevMonth }: {
  onClose: () => void;
  year: number; month: number;
  prevYear: number; prevMonth: number;
}) {
  const { state, getPortfolioValue, getDbPrice } = useGame();
  const holdings = Object.values(state.portfolio);
  const totalInvested = holdings.reduce((s, h) => s + h.shares * h.avgBuyPrice, 0);
  const totalCurrent = getPortfolioValue(year, month);
  const totalPnl = totalCurrent - totalInvested;

  return (
    <div className="fixed inset-0 z-50 flex items-center justify-center p-0 sm:p-4" onClick={onClose}>
      <div className="absolute inset-0 bg-black/60 backdrop-blur-sm" />
      <div
        className="glass-panel rounded-2xl w-full sm:max-w-lg max-h-[90vh] overflow-hidden scale-in relative z-10 mx-3 sm:mx-0"
        onClick={(e) => e.stopPropagation()}
      >
        <div className="p-5 border-b border-[var(--line)] flex items-center justify-between">
          <h2 className="font-black text-xl">Мой портфель</h2>
          <button onClick={onClose} className="text-[var(--muted)] hover:text-[var(--foreground)] text-xl">✕</button>
        </div>

        <div className="p-5 border-b border-[var(--line)] grid grid-cols-3 gap-4 text-center">
          <div>
            <div className="text-xs text-[var(--muted)] mb-1">Инвестировано</div>
            <div className="font-bold">{formatMoney(totalInvested)}</div>
          </div>
          <div>
            <div className="text-xs text-[var(--muted)] mb-1">Текущая стоимость</div>
            <div className="font-bold text-[var(--accent)]">{formatMoney(totalCurrent)}</div>
          </div>
          <div>
            <div className="text-xs text-[var(--muted)] mb-1">P&L</div>
            <div className="font-bold" style={{ color: totalPnl >= 0 ? 'var(--accent)' : 'var(--danger)' }}>
              {totalPnl >= 0 ? '+' : ''}{formatMoney(totalPnl)}
            </div>
          </div>
        </div>

        <div className="overflow-y-auto max-h-80 p-4 space-y-2">
          {holdings.length === 0 ? (
            <div className="text-center text-[var(--muted)] py-8">Портфель пуст. Купи акции!</div>
          ) : (
            holdings.map((h) => {
              const curPrice = getDbPrice(h.ticker, year, month);
              const prevPrice = getDbPrice(h.ticker, prevYear, prevMonth);
              const curVal = h.shares * curPrice;
              const boughtVal = h.shares * h.avgBuyPrice;
              const pnl = curVal - boughtVal;
              const chg = prevPrice > 0 ? ((curPrice - prevPrice) / prevPrice) * 100 : 0;
              const stock = STOCKS.find((s) => s.ticker === h.ticker);
              return (
                <div
                  key={h.ticker}
                  className="flex items-center gap-3 p-3 rounded-xl"
                  style={{ background: 'rgba(255,255,255,0.03)', border: '1px solid var(--line)' }}
                >
                  <div
                    className="w-10 h-10 rounded-lg flex items-center justify-center text-sm font-black flex-shrink-0"
                    style={{ background: (stock?.color ?? '#31ff8c') + '22', color: stock?.color ?? 'var(--accent)' }}
                  >
                    {h.ticker.slice(0, 2)}
                  </div>
                  <div className="flex-1 min-w-0">
                    <div className="flex items-center gap-2">
                      <span className="font-bold text-sm">{h.ticker}</span>
                      <span className="text-xs" style={{ color: chg >= 0 ? 'var(--accent)' : 'var(--danger)' }}>
                        {chg >= 0 ? '▲' : '▼'}{Math.abs(chg).toFixed(1)}%
                      </span>
                    </div>
                    <div className="text-xs text-[var(--muted)]">{h.shares.toLocaleString('ru-RU')} шт · ср. {formatPrice(h.avgBuyPrice)}</div>
                  </div>
                  <div className="text-right">
                    <div className="font-bold text-sm">{formatMoney(curVal)}</div>
                    <div className="text-xs" style={{ color: pnl >= 0 ? 'var(--accent)' : 'var(--danger)' }}>
                      {pnl >= 0 ? '+' : ''}{formatMoney(pnl)}
                    </div>
                  </div>
                </div>
              );
            })
          )}
        </div>
      </div>
    </div>
  );
}

// ============ FORBES MODAL ============
// ============ OFZ BONDS PANEL ============
function OFZPanel({
  budget, bondValue, bonds, year, month, onBuy, onSell,
}: {
  budget: number;
  bondValue: number;
  bonds: BondPosition[];
  year: number;
  month: number;
  onBuy: (amount: number) => boolean;
  onSell: (amount: number) => boolean;
}) {
  const [amount, setAmount] = useState('');
  const [notification, setNotification] = useState<{ msg: string; ok: boolean } | null>(null);
  const annualYield = getKeyRate(year, month);
  const monthlyYield = annualYield / 12;
  const monthlyIncome = bondValue * monthlyYield;

  function notify(msg: string, ok: boolean) {
    setNotification({ msg, ok });
    setTimeout(() => setNotification(null), 2500);
  }

  function handleBuy() {
    const amt = Number(amount.replace(/\s/g, '')) || 0;
    if (amt <= 0) return;
    if (onBuy(amt)) {
      notify(`✓ Куплено ОФЗ на ${amt.toLocaleString('ru-RU')} ₽`, true);
      setAmount('');
    } else {
      notify('Недостаточно средств', false);
    }
  }

  function handleSell() {
    if (bondValue <= 0) { notify('Нет облигаций для продажи', false); return; }
    if (onSell(bondValue)) {
      notify('✓ Облигации проданы', true);
      setAmount('');
    } else {
      notify('Ошибка продажи', false);
    }
  }

  const pctButtons = [25, 50, 75, 100];

  return (
    <div className="glass-panel rounded-2xl p-3 flex-shrink-0">
      {notification && (
        <div className="mb-2 text-xs px-2 py-1 rounded-lg font-bold"
          style={{
            background: notification.ok ? 'rgba(49,255,140,0.12)' : 'rgba(255,120,135,0.12)',
            color: notification.ok ? 'var(--accent)' : 'var(--danger)',
          }}>
          {notification.msg}
        </div>
      )}
      <div className="flex items-center justify-between mb-2">
        <div className="text-xs font-bold tracking-wider text-[var(--muted)] uppercase">🏛 ОФЗ Облигации</div>
        <div className="text-xs font-bold text-[var(--warning)]">
          {(annualYield * 100).toFixed(1)}% год.
        </div>
      </div>
      <div className="grid grid-cols-2 gap-2 mb-2">
        <div className="rounded-lg p-2" style={{ background: 'rgba(255,198,38,0.07)', border: '1px solid rgba(255,198,38,0.2)' }}>
          <div className="text-[10px] text-[var(--muted)]">В облигациях</div>
          <div className="font-bold text-sm text-[var(--warning)]">{formatMoney(bondValue)}</div>
        </div>
        <div className="rounded-lg p-2" style={{ background: 'rgba(49,255,140,0.05)', border: '1px solid rgba(49,255,140,0.15)' }}>
          <div className="text-[10px] text-[var(--muted)]">Доход/мес.</div>
          <div className="font-bold text-sm text-[var(--accent)]">+{formatMoney(monthlyIncome)}</div>
        </div>
      </div>
      {/* Quick percentage buttons */}
      <div className="flex gap-1 mb-2">
        {pctButtons.map((pct) => (
          <button
            key={pct}
            onClick={() => setAmount(String(Math.floor(budget * pct / 100)))}
            className="flex-1 py-1 rounded text-[10px] font-bold transition-all hover:scale-105"
            style={{ background: 'rgba(255,198,38,0.08)', border: '1px solid rgba(255,198,38,0.2)', color: 'var(--warning)' }}
          >
            {pct}%
          </button>
        ))}
      </div>
      <input
        type="number"
        value={amount}
        onChange={(e) => setAmount(e.target.value)}
        placeholder="Сумма ₽"
        className="w-full px-2 py-1.5 rounded-lg text-xs text-[var(--foreground)] placeholder-[var(--muted)] outline-none mb-2"
        style={{ background: 'rgba(255,255,255,0.06)', border: '1px solid var(--line-strong)' }}
      />
      <div className="flex gap-2">
        <button onClick={handleBuy}
          className="flex-1 py-1.5 rounded-lg text-xs font-bold transition-all hover:scale-105"
          style={{ background: 'rgba(255,198,38,0.15)', border: '1px solid rgba(255,198,38,0.3)', color: 'var(--warning)' }}>
          Купить ОФЗ
        </button>
        <button onClick={handleSell} disabled={bondValue <= 0}
          className="flex-1 py-1.5 rounded-lg text-xs font-bold transition-all hover:scale-105 disabled:opacity-40"
          style={{ background: 'rgba(255,120,135,0.1)', border: '1px solid rgba(255,120,135,0.25)', color: 'var(--danger)' }}>
          Продать ОФЗ
        </button>
      </div>
    </div>
  );
}

function ForbesModal({ onClose, year, month, yearIndex, readySet, roomPlayers, priceMap }: {
  onClose: () => void;
  year: number; month: number;
  yearIndex: number;
  readySet?: string[];
  roomPlayers?: { username: string; budget: number; portfolioJson: string }[];
  priceMap?: Record<string, number>;
}) {
  const { state, getTotalNetWorth } = useGame();
  const crisis = state.crisis!;
  const myWorth = getTotalNetWorth(year, month);
  const isMulti = state.mode === 'multi';

  function computeWorth(p: { username: string; budget: number; portfolioJson: string }) {
    if (!priceMap) return p.budget;
    let pv = 0;
    let bondsValue = 0;
    try {
      const portfolio = JSON.parse(p.portfolioJson || '{}') as Record<string, unknown>;
      bondsValue = typeof portfolio['__bondsValue__'] === 'number' ? (portfolio['__bondsValue__'] as number) : 0;
      for (const [ticker, item] of Object.entries(portfolio)) {
        if (ticker === '__bondsValue__') continue;
        const typedItem = item as { shares: number };
        pv += typedItem.shares * (priceMap[`${ticker}-${year}-${month}`] ?? 0);
      }
    } catch { /* ignore */ }
    return p.budget + pv + bondsValue;
  }

  const players = isMulti && roomPlayers && roomPlayers.length > 0
    ? roomPlayers.map((p) => ({
        name: p.username,
        worth: p.username === state.username ? myWorth : computeWorth(p),
        isYou: p.username === state.username,
      })).sort((a, b) => b.worth - a.worth)
    : [
        { name: state.username, worth: myWorth, isYou: true },
        ...state.bots.map((b, i) => ({
          name: b.username,
          worth: getBotNetWorth(i, crisis.years, yearIndex),
          isYou: false,
        })),
      ].sort((a, b) => b.worth - a.worth);

  const medals = ['🥇', '🥈', '🥉'];

  return (
    <div className="fixed inset-0 z-50 flex items-center justify-center p-4" onClick={onClose}>
      <div className="absolute inset-0 bg-black/60 backdrop-blur-sm" />
      <div
        className="glass-panel rounded-2xl w-full max-w-md scale-in relative z-10"
        onClick={(e) => e.stopPropagation()}
      >
        <div
          className="p-5 rounded-t-2xl text-center"
          style={{ background: 'linear-gradient(135deg, rgba(255,198,38,0.15), rgba(255,150,0,0.1))' }}
        >
          <div className="text-4xl mb-1">🏆</div>
          <h2 className="font-black text-2xl aurora-text">Forbes</h2>
          <p className="text-[var(--muted)] text-sm">{crisis.years[yearIndex]?.label} · Рейтинг богатейших</p>
        </div>

        <div className="p-4 space-y-2">
          {players.map((p, i) => (
            <div
              key={p.name}
              className="flex items-center gap-3 p-3 rounded-xl transition-all leaderboard-row"
              style={{
                animationDelay: `${i * 0.07}s`,
                background: p.isYou ? 'rgba(49,255,140,0.1)' : 'rgba(255,255,255,0.03)',
                border: p.isYou ? '1px solid rgba(49,255,140,0.3)' : '1px solid var(--line)',
              }}
            >
              <div className="text-xl w-8 text-center">{medals[i] ?? `#${i + 1}`}</div>
              <div className="flex-1 flex items-center gap-2 min-w-0">
                <span className="font-bold text-sm truncate">{p.name}</span>
                {p.isYou && (
                  <span className="text-xs px-1.5 py-0.5 rounded text-[var(--accent)] flex-shrink-0"
                    style={{ background: 'rgba(49,255,140,0.15)' }}>Вы</span>
                )}
                {readySet && (
                  <span
                    className="w-2 h-2 rounded-full flex-shrink-0"
                    style={{ background: readySet.includes(p.name) ? 'var(--accent)' : 'var(--danger)' }}
                    title={readySet.includes(p.name) ? 'Готов' : 'Не готов'}
                  />
                )}
              </div>
              <div className="font-bold text-right">
                <div className="text-sm">{formatMoney(p.worth)}</div>
                <div className="text-xs" style={{ color: p.worth >= 1_000_000 ? 'var(--accent)' : 'var(--danger)' }}>
                  {p.worth >= 1_000_000 ? '+' : ''}{(((p.worth - 1_000_000) / 1_000_000) * 100).toFixed(1)}%
                </div>
              </div>
            </div>
          ))}
        </div>

        <div className="p-4 pt-0">
          <button
            onClick={onClose}
            className="w-full py-3 rounded-xl font-bold transition-all hover:scale-[1.02]"
            style={{ background: 'rgba(255,255,255,0.07)', border: '1px solid var(--line)' }}
          >
            Закрыть
          </button>
        </div>
      </div>
    </div>
  );
}

// ============ MONTH TRANSITION — чистый fade без jitter ============
function MonthTransition({ label }: { label: string }) {
  return (
    <div className="year-transition-overlay">
      <div className="year-transition-content">
        <div className="text-[var(--muted)] text-sm tracking-widest uppercase mb-3">Переход к</div>
        <div className="text-6xl font-black aurora-text">{label}</div>
      </div>
    </div>
  );
}

// ============ CRISIS EVENT OVERLAY ============
function CrisisEvent({ eventName, eventDescription, eventColor, onContinue }: {
  eventName: string; eventDescription: string; eventColor: string; onContinue: () => void;
}) {
  return (
    <div className="nba-overlay" onClick={onContinue}>
      <div className="nba-scanlines" />
      <div
        className="nba-stripe-top"
        style={{ background: `linear-gradient(180deg, ${eventColor}55 0%, ${eventColor}22 100%)` }}
      />
      <div
        className="nba-stripe-bottom"
        style={{ background: `linear-gradient(0deg, ${eventColor}55 0%, ${eventColor}22 100%)` }}
      />

      {/* Animated grid */}
      <div
        className="absolute inset-0 opacity-10"
        style={{
          backgroundImage: `linear-gradient(${eventColor}44 1px, transparent 1px), linear-gradient(90deg, ${eventColor}44 1px, transparent 1px)`,
          backgroundSize: '80px 80px',
        }}
      />

      <div className="nba-title" style={{ color: eventColor, textShadow: `0 0 60px ${eventColor}88, 0 0 120px ${eventColor}44` }}>
        {eventName}
      </div>
      <div className="nba-sub text-[var(--foreground)]">{eventDescription}</div>
      <button className="nba-continue px-8 py-3 rounded-full font-bold text-sm tracking-widest uppercase transition-all hover:scale-105"
        style={{ background: eventColor + '33', border: `2px solid ${eventColor}`, color: eventColor }}>
        Нажми для продолжения
      </button>

      <div className="absolute bottom-8 left-0 right-0 text-center text-xs text-[var(--muted)] opacity-50">
        Нажмите в любое место чтобы продолжить
      </div>
    </div>
  );
}

// ============ CRISIS ANNOUNCEMENT CARD ============
// Показывается когда хронология игры входит в начало нового кризисного периода
function CrisisAnnouncementCard({ announcement, onContinue }: {
  announcement: { id: string; name: string; description: string; emoji: string; color: string; periodLabel: string };
  onContinue: () => void;
}) {
  const { name, description, emoji, color, periodLabel } = announcement;
  return (
    <div
      className="fixed inset-0 z-50 flex items-center justify-center p-6"
      style={{ background: 'rgba(0,0,0,0.85)', backdropFilter: 'blur(16px)' }}
    >
      {/* Glow backdrop */}
      <div
        className="absolute inset-0 pointer-events-none"
        style={{
          background: `radial-gradient(ellipse 60% 50% at 50% 50%, ${color}18 0%, transparent 70%)`,
        }}
      />

      <div
        className="relative w-full max-w-md rounded-3xl p-8 text-center"
        style={{
          background: `linear-gradient(135deg, ${color}0a 0%, rgba(4,17,13,0.95) 60%)`,
          border: `2px solid ${color}55`,
          boxShadow: `0 0 60px ${color}33, 0 0 120px ${color}11`,
          animation: 'scale-in 0.4s cubic-bezier(0.34,1.56,0.64,1)',
        }}
      >
        {/* Badge */}
        <div
          className="inline-block text-xs font-black tracking-widest uppercase px-3 py-1 rounded-full mb-5"
          style={{ background: color + '22', color, border: `1px solid ${color}55` }}
        >
          ⚡ Новый кризисный период
        </div>

        {/* Emoji */}
        <div
          className="w-20 h-20 rounded-2xl flex items-center justify-center text-4xl mx-auto mb-5"
          style={{ background: color + '18', border: `2px solid ${color}44` }}
        >
          {emoji}
        </div>

        {/* Period */}
        <div className="text-xs font-bold tracking-wider mb-2" style={{ color }}>
          {periodLabel}
        </div>

        {/* Name */}
        <h2 className="text-3xl font-black mb-3" style={{ color: 'var(--foreground)' }}>
          {name}
        </h2>

        {/* Description */}
        <p className="text-[var(--muted)] text-sm leading-relaxed mb-6">
          {description}
        </p>

        {/* Divider */}
        <div className="h-px mb-6" style={{ background: color + '33' }} />

        {/* Continue button */}
        <button
          onClick={onContinue}
          className="w-full py-4 rounded-2xl font-black text-base tracking-wide transition-all hover:scale-105 active:scale-95"
          style={{
            background: `linear-gradient(135deg, ${color}33, ${color}18)`,
            border: `2px solid ${color}88`,
            color,
            boxShadow: `0 0 24px ${color}33`,
          }}
        >
          Войти в период →
        </button>
      </div>
    </div>
  );
}

// ============ TUTORIAL OVERLAY ============
function TutorialOverlay({ mode, onClose }: { mode: string | null; onClose: () => void }) {
  const isRealtime = mode === 'realtime';
  return (
    <div
      className="fixed inset-0 z-[100] flex items-center justify-center p-4"
      style={{ background: 'rgba(0,0,0,0.88)', backdropFilter: 'blur(20px)' }}
    >
      <div className="glass-panel rounded-3xl w-full max-w-md p-8 scale-in">
        <div className="text-4xl text-center mb-4">📈</div>
        <h2 className="text-2xl font-black text-center mb-1">Как играть</h2>
        <p className="text-xs text-[var(--muted)] text-center mb-6 tracking-wider uppercase">Краткое руководство</p>
        <div className="space-y-4 text-sm mb-7">
          <div className="flex gap-3 items-start">
            <span className="text-xl flex-shrink-0">💰</span>
            <div>
              <div className="font-bold mb-0.5">Стартовый капитал — 1 000 000 ₽</div>
              <div className="text-[var(--muted)] text-xs leading-relaxed">
                Покупай акции MOEX и ОФЗ. Следи за балансом в верхней панели — не уйди в минус.
              </div>
            </div>
          </div>
          <div className="flex gap-3 items-start">
            <span className="text-xl flex-shrink-0">📊</span>
            <div>
              <div className="font-bold mb-0.5">Акции</div>
              <div className="text-[var(--muted)] text-xs leading-relaxed">
                Нажми на тикер в списке слева, чтобы открыть карточку с графиком и формой покупки/продажи.
              </div>
            </div>
          </div>
          <div className="flex gap-3 items-start">
            <span className="text-xl flex-shrink-0">🏛</span>
            <div>
              <div className="font-bold mb-0.5">ОФЗ — надёжный инструмент</div>
              <div className="text-[var(--muted)] text-xs leading-relaxed">
                {isRealtime
                  ? 'Облигации приносят ключевую ставку ЦБ в месяц. Кнопка «ОФЗ» в правой панели.'
                  : 'Доходность — ключевая ставка ЦБ на месяц покупки. Купи в правой панели и продай в любой момент.'}
              </div>
            </div>
          </div>
          <div className="flex gap-3 items-start">
            <span className="text-xl flex-shrink-0">{isRealtime ? '🔄' : '⏭'}</span>
            <div>
              <div className="font-bold mb-0.5">{isRealtime ? 'Обновление цен' : 'Следующий месяц'}</div>
              <div className="text-[var(--muted)] text-xs leading-relaxed">
                {isRealtime
                  ? 'Кнопка «Обновить цены» запрашивает актуальные данные с MOEX. Доступна раз в 5 минут.'
                  : 'Кнопка «Следующий месяц» сдвигает время. Читай новости — они подсказывают куда движется рынок.'}
              </div>
            </div>
          </div>
          {!isRealtime && (
            <div className="flex gap-3 items-start">
              <span className="text-xl flex-shrink-0">🏆</span>
              <div>
                <div className="font-bold mb-0.5">Цель</div>
                <div className="text-[var(--muted)] text-xs leading-relaxed">
                  Пройди кризисный период и постарайся обогнать ботов. Итоги — в таблице лидеров.
                </div>
              </div>
            </div>
          )}
        </div>
        <button
          onClick={onClose}
          className="w-full py-3 rounded-xl font-black text-sm transition-all hover:scale-[1.02] active:scale-95"
          style={{ background: 'linear-gradient(135deg, var(--accent), var(--accent-soft))', color: '#061712' }}
        >
          Понял, начинаем!
        </button>
      </div>
    </div>
  );
}

// ============ REAL-TIME TRADING PAGE ============
const RT_COOLDOWN_MS = 5 * 60 * 1000; // 5 minutes

function RealtimeTradingPage() {
  const router = useRouter();
  const { state, setState, setPriceSnapshot } = useGame();
  const [rtPrices, setRtPrices] = useState<Record<string, number>>({});
  const [moexError, setMoexError] = useState(false);
  const [filter, setFilter] = useState('');
  const [showPortfolio, setShowPortfolio] = useState(false);
  const [refreshing, setRefreshing] = useState(false);
  // Tick every second to re-render countdown timer
  const [, setTick] = useState(0);
  const timerRef = useRef<ReturnType<typeof setInterval> | null>(null);

  useEffect(() => {
    timerRef.current = setInterval(() => setTick((t) => t + 1), 1000);
    return () => { if (timerRef.current) clearInterval(timerRef.current); };
  }, []);

  // Auto-fetch on mount:
  // - Always calls API to restore prices (DB cache) — fixes blank list after navigation/refresh
  // - If cooldown expired: full MOEX fetch + updates lastRefreshAt
  // - If within cooldown: dbOnly=true (no MOEX call, just returns cached DB prices instantly)
  useEffect(() => {
    const lastRefresh = state.lastRefreshAt;
    const elapsed = lastRefresh ? Date.now() - lastRefresh : RT_COOLDOWN_MS + 1;
    const cooldownExpired = elapsed >= RT_COOLDOWN_MS;

    if (cooldownExpired) setRefreshing(true);

    api.stocks.realtime(cooldownExpired ? undefined : { dbOnly: true })
      .then(({ prices, moexAvailable }) => {
        if (cooldownExpired) setMoexError(!moexAvailable);
        if (Object.keys(prices).length > 0) {
          setRtPrices((prev) => ({ ...prev, ...prices }));
          setPriceSnapshot(prices);
        }
        if (cooldownExpired) setState((prev) => ({ ...prev, lastRefreshAt: Date.now() }));
      })
      .catch(() => {
        if (cooldownExpired) {
          setMoexError(true);
          setState((prev) => ({ ...prev, lastRefreshAt: Date.now() }));
        }
      })
      .finally(() => { if (cooldownExpired) setRefreshing(false); });
  }, []); // eslint-disable-line react-hooks/exhaustive-deps

  const lastRefresh = state.lastRefreshAt;
  const now = Date.now();
  const elapsed = lastRefresh ? now - lastRefresh : RT_COOLDOWN_MS + 1;
  const canRefresh = elapsed >= RT_COOLDOWN_MS;
  const secondsLeft = canRefresh ? 0 : Math.ceil((RT_COOLDOWN_MS - elapsed) / 1000);
  const minsLeft = Math.floor(secondsLeft / 60);
  const secsLeft = secondsLeft % 60;

  function handleRefresh() {
    if (!canRefresh || refreshing) return;
    setRefreshing(true);
    api.stocks.realtime()
      .then(({ prices, moexAvailable }) => {
        setMoexError(!moexAvailable);
        if (Object.keys(prices).length > 0) {
          setRtPrices((prev) => ({ ...prev, ...prices }));
          setPriceSnapshot(prices);
        }
        setState((prev) => ({ ...prev, lastRefreshAt: Date.now() }));
      })
      .catch(() => {
        setMoexError(true);
        setState((prev) => ({ ...prev, lastRefreshAt: Date.now() }));
      })
      .finally(() => setRefreshing(false));
  }

  const portfolioValue = Object.values(state.portfolio).reduce(
    (sum, h) => sum + h.shares * (rtPrices[h.ticker] ?? 0), 0
  );
  const totalNetWorth = state.budget + portfolioValue;
  const pnl = totalNetWorth - 1_000_000;

  const availableStocks = STOCKS.filter((s) => {
    if (!rtPrices[s.ticker]) return false;
    if (filter) return s.ticker.toLowerCase().includes(filter.toLowerCase()) || s.name.toLowerCase().includes(filter.toLowerCase());
    return true;
  });

  const pctFree = totalNetWorth > 0 ? (state.budget / totalNetWorth) * 100 : 100;
  const pctInvested = totalNetWorth > 0 ? (portfolioValue / totalNetWorth) * 100 : 0;

  return (
    <div className="min-h-screen app-grid flex flex-col" style={{ maxHeight: '100vh', overflow: 'hidden' }}>
      {/* Portfolio modal */}
      {showPortfolio && (
        <div className="fixed inset-0 z-50 flex items-center justify-center p-0 sm:p-4" onClick={() => setShowPortfolio(false)}>
          <div className="absolute inset-0 bg-black/60 backdrop-blur-sm" />
          <div className="glass-panel rounded-2xl w-full sm:max-w-lg max-h-[90vh] overflow-hidden scale-in relative z-10 mx-3 sm:mx-0" onClick={(e) => e.stopPropagation()}>
            <div className="p-5 border-b border-[var(--line)] flex items-center justify-between">
              <h2 className="font-black text-xl">Мой портфель</h2>
              <button onClick={() => setShowPortfolio(false)} className="text-[var(--muted)] hover:text-[var(--foreground)] text-xl">✕</button>
            </div>
            <div className="p-5 border-b border-[var(--line)] grid grid-cols-3 gap-4 text-center">
              <div>
                <div className="text-xs text-[var(--muted)] mb-1">Инвестировано</div>
                <div className="font-bold">{formatMoney(portfolioValue)}</div>
              </div>
              <div>
                <div className="text-xs text-[var(--muted)] mb-1">Всего</div>
                <div className="font-bold text-[var(--accent)]">{formatMoney(totalNetWorth)}</div>
              </div>
              <div>
                <div className="text-xs text-[var(--muted)] mb-1">P&L</div>
                <div className="font-bold" style={{ color: pnl >= 0 ? 'var(--accent)' : 'var(--danger)' }}>
                  {pnl >= 0 ? '+' : ''}{formatMoney(pnl)}
                </div>
              </div>
            </div>
            <div className="overflow-y-auto max-h-80 p-4 space-y-2">
              {Object.values(state.portfolio).length === 0 ? (
                <div className="text-center text-[var(--muted)] py-8">Портфель пуст.</div>
              ) : Object.values(state.portfolio).map((h) => {
                const curPrice = rtPrices[h.ticker] ?? 0;
                const curVal = h.shares * curPrice;
                const pnlH = curVal - h.shares * h.avgBuyPrice;
                const stock = STOCKS.find((s) => s.ticker === h.ticker);
                return (
                  <div key={h.ticker} className="flex items-center gap-3 p-3 rounded-xl"
                    style={{ background: 'rgba(255,255,255,0.03)', border: '1px solid var(--line)' }}>
                    <div className="w-10 h-10 rounded-lg flex items-center justify-center text-sm font-black flex-shrink-0"
                      style={{ background: (stock?.color ?? '#31ff8c') + '22', color: stock?.color ?? 'var(--accent)' }}>
                      {h.ticker.slice(0, 2)}
                    </div>
                    <div className="flex-1 min-w-0">
                      <div className="font-bold text-sm">{h.ticker}</div>
                      <div className="text-xs text-[var(--muted)]">{h.shares.toLocaleString('ru-RU')} шт · ср. {formatPrice(h.avgBuyPrice)}</div>
                    </div>
                    <div className="text-right">
                      <div className="font-bold text-sm">{formatMoney(curVal)}</div>
                      <div className="text-xs" style={{ color: pnlH >= 0 ? 'var(--accent)' : 'var(--danger)' }}>
                        {pnlH >= 0 ? '+' : ''}{formatMoney(pnlH)}
                      </div>
                    </div>
                  </div>
                );
              })}
            </div>
          </div>
        </div>
      )}

      {/* MOEX error banner */}
      {moexError && (
        <div className="flex-shrink-0 flex items-center justify-between gap-3 px-4 py-2 text-xs font-bold"
          style={{ background: 'rgba(255,79,79,0.12)', borderBottom: '1px solid rgba(255,79,79,0.3)', color: 'var(--danger)' }}>
          <span>⚠ MOEX ISS временно недоступен — показаны последние известные цены из базы данных</span>
          <button onClick={() => setMoexError(false)} className="opacity-60 hover:opacity-100">✕</button>
        </div>
      )}

      {/* TOP BAR */}
      <div className="flex-shrink-0 flex items-center gap-4 px-4 py-3 border-b border-[var(--line)]"
        style={{ background: 'var(--surface-strong)', backdropFilter: 'blur(20px)' }}>
        <Link href="/" className="text-[var(--accent)] font-black text-lg tracking-tight flex-shrink-0">
          СИБ<span className="text-[var(--foreground)]">ИНВЕСТ</span>
        </Link>
        <div className="flex-1" />
        <div className="flex items-center gap-2">
          <span className="w-2 h-2 rounded-full bg-red-500 animate-pulse" />
          <span className="text-sm font-bold" style={{ color: 'var(--accent-blue)' }}>LIVE</span>
        </div>
        <div className="flex-shrink-0 text-center">
          <div className="text-base font-black text-[var(--accent)]">
            {new Date().toLocaleDateString('ru-RU', { day: 'numeric', month: 'short', year: 'numeric' })}
          </div>
          <div className="text-xs text-[var(--muted)]">Реальное время</div>
        </div>
        <div className="flex-1" />
        <div className="text-right flex-shrink-0">
          <div className="text-sm font-bold">{state.username}</div>
          <div className="text-xs text-[var(--accent)]">{formatMoney(totalNetWorth)}</div>
        </div>
      </div>

      {/* MAIN LAYOUT */}
      <div className="flex-1 grid grid-cols-[280px_1fr_300px] gap-0 overflow-hidden" style={{ minHeight: 0 }}>

        {/* LEFT: STOCK LIST */}
        <div className="flex flex-col overflow-hidden border-r border-[var(--line)]" style={{ background: 'rgba(4,17,13,0.9)' }}>
          <div className="flex-shrink-0 p-3 border-b border-[var(--line)]">
            <div className="flex items-center gap-2 mb-2">
              <div className="text-xs font-bold tracking-wider text-[var(--muted)] uppercase flex-1">Акции MOEX</div>
              <span className="text-xs text-[var(--muted)]">
                {lastRefresh ? `обн. ${new Date(lastRefresh).toLocaleTimeString('ru-RU', { hour: '2-digit', minute: '2-digit' })}` : 'не обновлялось'}
              </span>
            </div>
            <input type="text" value={filter} onChange={(e) => setFilter(e.target.value)}
              placeholder="Поиск..." className="w-full px-3 py-1.5 rounded-lg text-sm text-[var(--foreground)] placeholder-[var(--muted)] outline-none"
              style={{ background: 'rgba(255,255,255,0.05)', border: '1px solid var(--line)' }} />
          </div>
          <div className="flex-1 overflow-y-auto p-2 space-y-0.5">
            {availableStocks.map((stock) => {
              const price = rtPrices[stock.ticker] ?? 0;
              const prevPrice = price;
              const chg = prevPrice > 0 ? ((price - prevPrice) / prevPrice) * 100 : 0;
              const isUp = chg >= 0;
              const owned = state.portfolio[stock.ticker]?.shares ?? 0;
              return (
                <button key={stock.ticker} onClick={() => router.push(`/stock/${stock.ticker}`)}
                  className="w-full flex items-center gap-3 px-3 py-2.5 rounded-xl hover:bg-white/5 transition-all text-left">
                  <div className="w-9 h-9 rounded-lg flex items-center justify-center text-xs font-black flex-shrink-0"
                    style={{ background: stock.color + '22', color: stock.color, border: `1px solid ${stock.color}44` }}>
                    {stock.ticker.slice(0, 2)}
                  </div>
                  <div className="flex-1 min-w-0">
                    <div className="font-bold text-sm leading-tight">{stock.ticker}</div>
                    <div className="text-xs text-[var(--muted)] truncate">{stock.name}</div>
                  </div>
                  <div className="text-right flex-shrink-0">
                    <div className="font-bold text-sm">{formatPrice(price)}</div>
                    <div className="text-xs font-bold" style={{ color: isUp ? 'var(--accent)' : 'var(--danger)' }}>
                      {isUp ? '▲' : '▼'} {Math.abs(chg).toFixed(2)}%
                    </div>
                  </div>
                  {owned > 0 && <div className="w-1.5 rounded-full flex-shrink-0" style={{ background: 'var(--accent)', minHeight: '32px' }} />}
                </button>
              );
            })}
          </div>
        </div>

        {/* CENTER */}
        <div className="flex flex-col overflow-hidden p-4 gap-4" style={{ background: 'rgba(4,17,13,0.6)' }}>
          {/* Capital */}
          <div className="glass-panel rounded-2xl p-4">
            <div className="flex items-center justify-between mb-3">
              <span className="text-xs font-bold tracking-wider text-[var(--muted)] uppercase">Капитал</span>
              <span className="text-sm font-bold" style={{ color: pnl >= 0 ? 'var(--accent)' : 'var(--danger)' }}>
                {pnl >= 0 ? '+' : ''}{formatMoney(pnl)}
              </span>
            </div>
            <div className="text-2xl font-black aurora-text mb-3">{formatMoney(totalNetWorth)}</div>
            <div className="h-3 rounded-full overflow-hidden flex gap-0.5 mb-3" style={{ background: 'rgba(255,255,255,0.06)' }}>
              <div className="h-full rounded-l-full transition-all duration-700"
                style={{ width: `${pctFree}%`, background: 'linear-gradient(90deg, var(--accent), var(--accent-soft))' }} />
              <div className="h-full rounded-r-full transition-all duration-700"
                style={{ width: `${pctInvested}%`, background: 'linear-gradient(90deg, var(--accent-blue), rgba(53,217,255,0.5))' }} />
            </div>
            <div className="flex justify-between text-xs text-[var(--muted)]">
              <span><span className="inline-block w-2 h-2 rounded-full mr-1" style={{ background: 'var(--accent)' }} />Свободно: {formatMoney(state.budget)}</span>
              <span><span className="inline-block w-2 h-2 rounded-full mr-1" style={{ background: 'var(--accent-blue)' }} />Инвестировано: {formatMoney(portfolioValue)}</span>
            </div>
          </div>

          {/* Holdings */}
          <div className="glass-panel rounded-2xl p-4 flex-1 overflow-hidden flex flex-col">
            <div className="flex items-center justify-between mb-3">
              <div className="text-xs font-bold tracking-wider text-[var(--muted)] uppercase">Мои позиции</div>
              <button onClick={() => setShowPortfolio(true)} className="text-xs text-[var(--accent)] hover:underline">Открыть →</button>
            </div>
            <div className="flex-1 overflow-y-auto space-y-2">
              {Object.values(state.portfolio).length === 0 ? (
                <div className="text-center text-[var(--muted)] text-sm py-8">Нет позиций. Купи акции, нажав на тикер слева.</div>
              ) : Object.values(state.portfolio).map((h) => {
                const curPrice = rtPrices[h.ticker] ?? 0;
                const curVal = h.shares * curPrice;
                const pnlH = curVal - h.shares * h.avgBuyPrice;
                const stock = STOCKS.find((s) => s.ticker === h.ticker);
                return (
                  <button key={h.ticker} onClick={() => router.push(`/stock/${h.ticker}`)}
                    className="w-full flex items-center gap-3 p-2.5 rounded-xl hover:bg-white/5 transition-all text-left"
                    style={{ border: '1px solid var(--line)' }}>
                    <div className="w-8 h-8 rounded-lg flex items-center justify-center text-xs font-black flex-shrink-0"
                      style={{ background: (stock?.color ?? '#31ff8c') + '22', color: stock?.color ?? 'var(--accent)' }}>
                      {h.ticker.slice(0, 2)}
                    </div>
                    <div className="flex-1 min-w-0">
                      <div className="text-sm font-bold">{h.ticker}</div>
                      <div className="text-xs text-[var(--muted)]">{h.shares.toLocaleString('ru-RU')} шт</div>
                    </div>
                    <div className="text-right">
                      <div className="text-sm font-bold">{formatMoney(curVal)}</div>
                      <div className="text-xs" style={{ color: pnlH >= 0 ? 'var(--accent)' : 'var(--danger)' }}>
                        {pnlH >= 0 ? '+' : ''}{formatMoney(pnlH)}
                      </div>
                    </div>
                  </button>
                );
              })}
            </div>
          </div>

          {/* Bottom actions */}
          <div className="flex gap-3">
            <button onClick={handleRefresh} disabled={!canRefresh || refreshing}
              className="w-full py-3 rounded-xl font-bold text-sm flex items-center justify-center gap-2 transition-all hover:scale-[1.02] active:scale-95 disabled:opacity-50 disabled:cursor-not-allowed"
              style={{
                background: canRefresh && !refreshing
                  ? 'linear-gradient(135deg, var(--accent-blue), rgba(53,217,255,0.6))'
                  : 'rgba(255,255,255,0.06)',
                color: canRefresh && !refreshing ? '#061712' : 'var(--muted)',
                border: canRefresh ? 'none' : '1px solid var(--line)',
              }}>
              {refreshing ? '⏳ Загрузка...' : canRefresh ? '🔄 Обновить цены' : `⏱ Обновление через ${minsLeft}:${String(secsLeft).padStart(2, '0')}`}
            </button>
          </div>
        </div>

        {/* RIGHT: RECENT ACTIVITY / NEWS */}
        <div className="flex flex-col overflow-hidden border-l border-[var(--line)]" style={{ background: 'rgba(4,17,13,0.9)' }}>
          <div className="flex-shrink-0 p-3 border-b border-[var(--line)]">
            <div className="text-xs font-bold tracking-wider text-[var(--muted)] uppercase">Рынок сегодня</div>
          </div>
          <div className="flex-1 overflow-y-auto p-3 space-y-3">
            <div className="rounded-xl p-4 text-sm" style={{ background: 'rgba(53,217,255,0.05)', border: '1px solid rgba(53,217,255,0.15)' }}>
              <div className="font-bold text-[var(--accent-blue)] mb-2">📡 MOEX ISS API</div>
              <p className="text-xs text-[var(--muted)] leading-relaxed">
                Цены обновляются каждые 15 минут. Нажми «Обновить цены» чтобы получить актуальные данные.
              </p>
            </div>
            <div className="rounded-xl p-4 text-sm" style={{ background: 'rgba(49,255,140,0.04)', border: '1px solid rgba(49,255,140,0.12)' }}>
              <div className="font-bold text-[var(--accent)] mb-2">📊 Последние сделки</div>
              <p className="text-xs text-[var(--muted)] leading-relaxed">
                В карточке каждой акции отображаются последние сделки по инструменту — удобно для оценки активности торгов.
              </p>
            </div>
            <div className="rounded-xl p-4 text-sm" style={{ background: 'rgba(255,255,255,0.03)', border: '1px solid var(--line)' }}>
              <div className="font-bold text-[var(--foreground)] mb-2">💡 Совет</div>
              <p className="text-xs text-[var(--muted)] leading-relaxed">
                Нажми на акцию слева, чтобы открыть интрадей-график, последние сделки и форму покупки/продажи.
              </p>
            </div>
          </div>
        </div>
      </div>
    </div>
  );
}

// ============ NEWS CARD ============
type NewsArticle = {
  id: number;
  url: string;
  title: string;
  rating: number;
  commentsCount: number;
  newsDate: string;
  yearMonth: string;
};

function NewsCard({ item, index }: { item: NewsArticle; index: number }) {
  return (
    <a
      href={item.url}
      target="_blank"
      rel="noopener noreferrer"
      className="block rounded-xl p-3 rise-in transition-colors hover:bg-white/5"
      style={{
        animationDelay: `${index * 0.05}s`,
        background: 'rgba(255,255,255,0.03)',
        border: '1px solid var(--line)',
        textDecoration: 'none',
      }}
    >
      <div className="flex items-start gap-2">
        <span className="text-sm flex-shrink-0 mt-0.5">📰</span>
        <div className="flex-1 min-w-0">
          <div className="text-sm font-semibold leading-tight text-[var(--foreground)] line-clamp-3">
            {item.title}
          </div>
          <div className="mt-1.5 flex flex-wrap items-center gap-2">
            <span className="text-[10px] text-[var(--muted)]">
              {new Date(item.newsDate).toLocaleDateString('ru-RU', { day: 'numeric', month: 'short', year: 'numeric' })}
            </span>
            {item.rating !== 0 && (
              <span className="text-[10px] px-1.5 py-0.5 rounded" style={{ background: 'rgba(49,255,140,0.1)', color: 'var(--accent)' }}>
                ▲ {item.rating}
              </span>
            )}
            {item.commentsCount > 0 && (
              <span className="text-[10px] text-[var(--muted)]">
                💬 {item.commentsCount}
              </span>
            )}
          </div>
        </div>
      </div>
    </a>
  );
}

// ============ MAIN TRADING PAGE (historical) ============
function HistoricalTradingPage() {
  const router = useRouter();
  const { state, getPortfolioValue, getTotalNetWorth, setState, dividendMap, getDbPrice, priceSnapshot, fullPriceMap, buyBonds, sellBonds, getBondValue, getSharpeRatio } = useGame();
  const [showPortfolio, setShowPortfolio] = useState(false);
  const [showForbes, setShowForbes] = useState(false);
  const [showEndConfirm, setShowEndConfirm] = useState(false);
  const [transitioning, setTransitioning] = useState(false);
  const [crisisEvent, setCrisisEvent] = useState<{ name: string; desc: string; color: string } | null>(null);
  const [crisisAnnouncement, setCrisisAnnouncement] = useState<{ id: string; name: string; description: string; emoji: string; color: string; periodLabel: string } | null>(null);
  const [allCrises, setAllCrises] = useState<ApiCrisis[]>([]);
  useEffect(() => {
    api.crises.list().then(setAllCrises).catch(() => {});
  }, []);
  const [nextStepLabel, setNextStepLabel] = useState<string | null>(null);
  const [dividendToasts, setDividendToasts] = useState<{ ticker: string; amount: number; perShare: number; shares: number }[]>([]);
  const [backendNews, setBackendNews] = useState<NewsArticle[] | null>(null);
  const [newsTotal, setNewsTotal] = useState(0);
  const [newsPage, setNewsPage] = useState(1);
  const [newsLoading, setNewsLoading] = useState(false);
  const [newsSearch, setNewsSearch] = useState('');
  const [searchResults, setSearchResults] = useState<NewsArticle[] | null>(null);
  const [searchTotal, setSearchTotal] = useState(0);
  const [searchPage, setSearchPage] = useState(1);
  const [searchLoading, setSearchLoading] = useState(false);
  const [filter, setFilter] = useState('');
  const [mobileTab, setMobileTab] = useState<'stocks' | 'capital' | 'news'>('capital');
  // Multi mode: room polling state
  const [roomHostUsername, setRoomHostUsername] = useState<string>('');
  const [readySet, setReadySet] = useState<string[]>([]);
  const [isReady, setIsReady] = useState(false);
  const [roomPlayers, setRoomPlayers] = useState<{ username: string; budget: number; portfolioJson: string }[]>([]);
  const pollRef = useRef<ReturnType<typeof setInterval> | null>(null);
  // Track last step we applied animations for (prevents double-fire from polling)
  const lastAnimatedStepRef = useRef(-1);

  const crisis = state.crisis!;
  const isSolo = state.mode === 'solo';
  const isMulti = state.mode === 'multi';
  const isHost = isMulti && (roomHostUsername ? state.username === roomHostUsername : true);

  const step = crisis.years[state.currentYearIndex];
  // Fetch news when step or page changes
  useEffect(() => {
    if (!step) return;
    if (newsPage === 1) setBackendNews(null);
    setNewsLoading(true);
    fetch(`/api/news?year=${step.year}&month=${step.month}&page=${newsPage}`)
      .then((r) => r.ok ? r.json() : null)
      .then((data) => {
        if (!data) return;
        setNewsTotal(data.total ?? 0);
        setBackendNews((prev) => newsPage === 1 ? (data.news ?? []) : [...(prev ?? []), ...(data.news ?? [])]);
      })
      .catch(() => { if (newsPage === 1) setBackendNews([]); })
      .finally(() => setNewsLoading(false));
  }, [step?.year, step?.month, newsPage]); // eslint-disable-line react-hooks/exhaustive-deps

  // Reset page when step changes
  useEffect(() => {
    setNewsPage(1);
    setNewsSearch('');
    setSearchResults(null);
  }, [step?.year, step?.month]); // eslint-disable-line react-hooks/exhaustive-deps

  // Debounced keyword search — scoped to current step's month
  useEffect(() => {
    if (!newsSearch.trim()) { setSearchResults(null); setSearchPage(1); return; }
    const t = setTimeout(() => {
      setSearchLoading(true);
      setSearchPage(1);
      fetch(`/api/news?search=${encodeURIComponent(newsSearch.trim())}&year=${step.year}&month=${step.month}&page=1`)
        .then((r) => r.ok ? r.json() : null)
        .then((data) => { setSearchResults(data?.news ?? []); setSearchTotal(data?.total ?? 0); })
        .catch(() => setSearchResults([]))
        .finally(() => setSearchLoading(false));
    }, 400);
    return () => clearTimeout(t);
  }, [newsSearch, step?.year, step?.month]); // eslint-disable-line react-hooks/exhaustive-deps

  function loadMoreSearch() {
    const nextPage = searchPage + 1;
    setSearchLoading(true);
    fetch(`/api/news?search=${encodeURIComponent(newsSearch.trim())}&year=${step.year}&month=${step.month}&page=${nextPage}`)
      .then((r) => r.ok ? r.json() : null)
      .then((data) => { setSearchResults((prev) => [...(prev ?? []), ...(data?.news ?? [])]); setSearchPage(nextPage); })
      .catch(() => {})
      .finally(() => setSearchLoading(false));
  }

  // Shared: apply a step advance with animations + state update (used by host AND participants)
  function applyStepAdvance(nextIndex: number) {
    const nextStep = crisis.years[nextIndex];
    if (!nextStep) return;

    setNextStepLabel(nextStep.label);
    setTransitioning(true);

    setTimeout(() => {
      const paidDivs: { ticker: string; amount: number; perShare: number; shares: number }[] = [];
      let divIncome = 0;
      for (const [ticker, holding] of Object.entries(state.portfolio)) {
        const key = `${ticker}-${nextStep.year}-${nextStep.month}`;
        const perShare = dividendMap[key] ?? 0;
        if (perShare > 0 && holding.shares > 0) {
          const amount = perShare * holding.shares;
          divIncome += amount;
          paidDivs.push({ ticker, amount, perShare, shares: holding.shares });
        }
      }

      setState((prev) => {
        const bondInterest = (prev.bonds ?? []).reduce((s, b) => s + b.faceValue * (b.annualYield / 12), 0);
        const newBudget = prev.budget + divIncome + bondInterest;
        const stockVal = Object.values(prev.portfolio).reduce((s, item) => {
          const p = fullPriceMap[`${item.ticker}-${nextStep.year}-${nextStep.month}`] || 0;
          return s + item.shares * p;
        }, 0);
        const bondVal = (prev.bonds ?? []).reduce((s, b) => s + b.faceValue, 0);
        const newNetWorth = newBudget + stockVal + bondVal;
        return {
          ...prev,
          currentYearIndex: nextIndex,
          budget: newBudget,
          netWorthHistory: [...(prev.netWorthHistory ?? []), newNetWorth],
        };
      });

      if (paidDivs.length > 0) {
        setDividendToasts(paidDivs);
        setTimeout(() => setDividendToasts([]), 6000);
      }
      if (nextStep.eventName) {
        setCrisisEvent({ name: nextStep.eventName, desc: nextStep.eventDescription ?? '', color: nextStep.eventColor ?? 'var(--accent)' });
      }
      const startedCrisis = allCrises.find((c) =>
        c.years[0]?.year === nextStep.year &&
        c.years[0]?.month === nextStep.month &&
        c.id !== crisis.id,
      );
      if (startedCrisis) {
        setCrisisAnnouncement({
          id: startedCrisis.id,
          name: startedCrisis.name,
          description: startedCrisis.description,
          emoji: startedCrisis.emoji,
          color: startedCrisis.color,
          periodLabel: startedCrisis.periodLabel,
        });
      }
      // Auto-end: reached the absolute last step → go to results after a short pause
      if (nextIndex === crisis.years.length - 1) {
        setTimeout(() => {
          if (isMulti && state.roomCode) api.rooms.setStatus(state.roomCode, 'finished').catch(() => {});
          router.push('/results');
        }, 2000);
      }
    }, 350);

    setTimeout(() => { setTransitioning(false); setNextStepLabel(null); }, 1000);
  }

  // Multi mode: poll room state every 3s for step sync, ready status, player list, and room status
  useEffect(() => {
    if (!isMulti || !state.roomCode) return;
    const poll = () => {
      api.rooms.get(state.roomCode)
        .then((room) => {
          // Room finished — redirect all participants to results
          if (room.status === 'finished') {
            if (pollRef.current) clearInterval(pollRef.current);
            router.push('/results');
            return;
          }
          if (room.hostUsername) setRoomHostUsername(room.hostUsername);
          let ready: string[] = [];
          try { ready = JSON.parse(room.readyJson ?? '[]'); } catch { ready = []; }
          setReadySet(ready);
          if (room.players) {
            setRoomPlayers(room.players.map((p) => ({
              username: p.username,
              budget: p.budget,
              portfolioJson: p.portfolioJson ?? '{}',
            })));
          }
          // Participant: sync step + run animations when host advances
          const serverStep = room.currentStepIndex ?? 0;
          if (serverStep > lastAnimatedStepRef.current && serverStep > 0) {
            lastAnimatedStepRef.current = serverStep;
            setIsReady(false); // clear ready on step advance
            applyStepAdvance(serverStep);
          }
        })
        .catch(() => {});
    };
    poll();
    pollRef.current = setInterval(poll, 3000);
    return () => { if (pollRef.current) clearInterval(pollRef.current); };
  }, [isMulti, state.roomCode]); // eslint-disable-line react-hooks/exhaustive-deps

  const prevStep = crisis.years[Math.max(0, state.currentYearIndex - 1)];
  const currentYear = step?.year ?? 2024;
  const currentMonth = step?.month ?? 1;
  const prevYear = prevStep?.year ?? currentYear;
  const prevMonth = prevStep?.month ?? currentMonth;
  const isLastStep = state.currentYearIndex >= crisis.years.length - 1;

  const portfolioValue = getPortfolioValue(currentYear, currentMonth);
  const totalNetWorth = getTotalNetWorth(currentYear, currentMonth);

  const availableStocks = STOCKS.filter((s) => {
    const price = getDbPrice(s.ticker, currentYear, currentMonth);
    if (price === 0) return false;
    if (filter) return s.ticker.toLowerCase().includes(filter.toLowerCase()) || s.name.toLowerCase().includes(filter.toLowerCase());
    return true;
  });

  function handleToggleReady() {
    const next = !isReady;
    setIsReady(next);
    api.rooms.setReady(state.roomCode, state.username, next).catch(() => {});
  }

  function handleAdvanceStep() {
    if (transitioning) return;
    if (isLastStep) {
      if (isMulti && state.roomCode) api.rooms.setStatus(state.roomCode, 'finished').catch(() => {});
      router.push('/results');
      return;
    }

    const nextIndex = state.currentYearIndex + 1;
    lastAnimatedStepRef.current = nextIndex; // prevent polling from re-firing this step
    applyStepAdvance(nextIndex);

    // Host: push step to server + clear ready
    if (isMulti && state.roomCode) {
      setTimeout(() => {
        api.rooms.setStep(state.roomCode, nextIndex).catch(() => {});
        api.rooms.setReady(state.roomCode, '__clear__', false).catch(() => {});
        setReadySet([]);
        setIsReady(false);
      }, 350);
    }
  }

  function handleEndEarly() {
    if (isMulti && state.roomCode) {
      api.rooms.setStatus(state.roomCode, 'finished').catch(() => {});
    }
    router.push('/results');
  }

  return (
    <div className="min-h-screen app-grid flex flex-col" style={{ maxHeight: '100vh', overflow: 'hidden' }}>
      {/* Overlays */}
      {transitioning && nextStepLabel && (
        <MonthTransition label={nextStepLabel} />
      )}
      {crisisEvent && (
        <CrisisEvent
          eventName={crisisEvent.name}
          eventDescription={crisisEvent.desc}
          eventColor={crisisEvent.color}
          onContinue={() => setCrisisEvent(null)}
        />
      )}
      {crisisAnnouncement && (
        <CrisisAnnouncementCard
          announcement={crisisAnnouncement}
          onContinue={() => setCrisisAnnouncement(null)}
        />
      )}
      {/* Dividend toasts */}
      {dividendToasts.length > 0 && (
        <div className="fixed bottom-20 md:bottom-6 right-4 sm:right-6 z-40 flex flex-col gap-2 pointer-events-none">
          {dividendToasts.map((d) => (
            <div
              key={d.ticker}
              className="flex items-center gap-3 px-4 py-3 rounded-2xl rise-in"
              style={{
                background: 'rgba(49,255,140,0.12)',
                border: '1px solid rgba(49,255,140,0.35)',
                backdropFilter: 'blur(16px)',
                boxShadow: '0 0 24px rgba(49,255,140,0.15)',
                minWidth: 240,
              }}
            >
              <span className="text-2xl">💰</span>
              <div>
                <div className="text-xs font-black uppercase tracking-wider text-[var(--accent)]">
                  Дивиденды получены
                </div>
                <div className="text-sm font-bold text-[var(--foreground)]">
                  {d.ticker} · {d.perShare.toLocaleString('ru-RU', { maximumFractionDigits: 2 })} ₽/акц.
                </div>
                <div className="text-sm font-black text-[var(--accent)]">
                  +{(d.amount / 1000).toFixed(1)} тыс ₽ ({d.shares.toLocaleString('ru-RU')} шт.)
                </div>
              </div>
            </div>
          ))}
        </div>
      )}
      {showPortfolio && (
        <PortfolioModal
          onClose={() => setShowPortfolio(false)}
          year={currentYear} month={currentMonth}
          prevYear={prevYear} prevMonth={prevMonth}
        />
      )}
      {showForbes && (
        <ForbesModal
          onClose={() => setShowForbes(false)}
          year={currentYear} month={currentMonth}
          yearIndex={state.currentYearIndex}
          readySet={isMulti ? readySet : undefined}
          roomPlayers={isMulti && roomPlayers.length > 0 ? roomPlayers : undefined}
          priceMap={fullPriceMap}
        />
      )}
      {showEndConfirm && (
        <div className="fixed inset-0 z-50 flex items-center justify-center p-4" onClick={() => setShowEndConfirm(false)}>
          <div className="absolute inset-0 bg-black/60 backdrop-blur-sm" />
          <div className="glass-panel rounded-2xl w-full max-w-sm p-6 relative z-10 text-center scale-in" onClick={(e) => e.stopPropagation()}>
            <div className="text-4xl mb-3">🏁</div>
            <h2 className="font-black text-xl mb-2">Завершить игру?</h2>
            <p className="text-sm text-[var(--muted)] mb-6 leading-relaxed">
              Итоги будут подведены по текущим ценам. Прогресс за оставшиеся месяцы не будет учтён.
            </p>
            <div className="flex gap-3">
              <button onClick={() => setShowEndConfirm(false)}
                className="flex-1 py-3 rounded-xl font-bold text-sm transition-all hover:scale-[1.02]"
                style={{ background: 'rgba(255,255,255,0.07)', border: '1px solid var(--line)' }}>
                Отмена
              </button>
              <button onClick={handleEndEarly}
                className="flex-1 py-3 rounded-xl font-bold text-sm transition-all hover:scale-[1.02]"
                style={{ background: 'linear-gradient(135deg, var(--accent-pink), rgba(255,79,216,0.6))', color: '#061712' }}>
                Завершить
              </button>
            </div>
          </div>
        </div>
      )}

      {/* TOP BAR */}
      <div
        className="flex-shrink-0 flex items-center gap-2 sm:gap-4 px-3 sm:px-4 py-2 sm:py-3 border-b border-[var(--line)]"
        style={{ background: 'var(--surface-strong)', backdropFilter: 'blur(20px)' }}
      >
        <Link href="/" className="text-[var(--accent)] font-black text-base sm:text-lg tracking-tight flex-shrink-0">
          СИБ<span className="text-[var(--foreground)]">ИНВЕСТ</span>
        </Link>
        <div className="flex-1" />
        {/* Step progress bar — hidden on mobile */}
        <div className="hidden sm:flex items-center gap-2">
          <span className="text-xs text-[var(--muted)]">
            {Math.round((state.currentYearIndex / Math.max(1, crisis.years.length - 1)) * 100)}%
          </span>
          <div className="w-36 h-1.5 rounded-full overflow-hidden" style={{ background: 'rgba(255,255,255,0.08)' }}>
            <div
              className="h-full rounded-full transition-all duration-700"
              style={{
                width: `${(state.currentYearIndex / Math.max(1, crisis.years.length - 1)) * 100}%`,
                background: 'linear-gradient(90deg, var(--accent), var(--accent-soft))',
              }}
            />
          </div>
          <span className="text-xs text-[var(--muted)]">Апр 2026</span>
        </div>
        {/* Mobile: compact progress bar */}
        <div className="sm:hidden flex-1 max-w-[80px]">
          <div className="h-1 rounded-full overflow-hidden" style={{ background: 'rgba(255,255,255,0.08)' }}>
            <div
              className="h-full rounded-full transition-all duration-700"
              style={{
                width: `${(state.currentYearIndex / Math.max(1, crisis.years.length - 1)) * 100}%`,
                background: 'linear-gradient(90deg, var(--accent), var(--accent-soft))',
              }}
            />
          </div>
        </div>
        <div className="flex-shrink-0 text-center">
          <div className="text-base sm:text-xl font-black text-[var(--accent)]">{step.label}</div>
          <div className="text-[10px] sm:text-xs text-[var(--muted)]">месяц {state.currentYearIndex + 1}/{crisis.years.length}</div>
        </div>
        <div className="flex-1 hidden sm:block" />
        <div className="text-right flex-shrink-0">
          <div className="text-xs sm:text-sm font-bold max-w-[80px] sm:max-w-none truncate">{state.username}</div>
          <div className="text-[10px] sm:text-xs text-[var(--accent)]">{formatMoney(totalNetWorth)}</div>
        </div>
      </div>

      {/* MAIN LAYOUT */}
      <div className="flex-1 grid grid-cols-1 md:grid-cols-[280px_1fr_300px] gap-0 overflow-hidden" style={{ minHeight: 0 }}>

        {/* LEFT: STOCK LIST */}
        <div
          className={`flex-col overflow-hidden border-r border-[var(--line)] ${mobileTab === 'stocks' ? 'flex' : 'hidden'} md:flex`}
          style={{ background: 'rgba(4,17,13,0.9)' }}
        >
          <div className="flex-shrink-0 p-3 border-b border-[var(--line)]">
            <div className="text-xs font-bold tracking-wider text-[var(--muted)] uppercase mb-2">Акции MOEX</div>
            <input
              type="text"
              value={filter}
              onChange={(e) => setFilter(e.target.value)}
              placeholder="Поиск..."
              className="w-full px-3 py-1.5 rounded-lg text-sm text-[var(--foreground)] placeholder-[var(--muted)] outline-none"
              style={{ background: 'rgba(255,255,255,0.05)', border: '1px solid var(--line)' }}
            />
          </div>
          <div className="flex-1 overflow-y-auto p-2 pb-20 md:pb-2 space-y-0.5">
            {availableStocks.map((stock) => (
              <StockRow
                key={stock.ticker}
                ticker={stock.ticker}
                name={stock.name}
                price={getDbPrice(stock.ticker, currentYear, currentMonth)}
                prevPrice={getDbPrice(stock.ticker, prevYear, prevMonth)}
                color={stock.color}
                ownedShares={state.portfolio[stock.ticker]?.shares ?? 0}
                onClick={() => router.push(`/stock/${stock.ticker}`)}
              />
            ))}
          </div>
        </div>

        {/* CENTER: BUDGET + PORTFOLIO SUMMARY */}
        <div className={`flex-col overflow-y-auto p-4 gap-4 pb-20 md:pb-4 ${mobileTab === 'capital' ? 'flex' : 'hidden'} md:flex`} style={{ background: 'rgba(4,17,13,0.6)' }}>
          <BudgetChart budget={state.budget} invested={portfolioValue} bonds={getBondValue()} total={totalNetWorth} sharpe={getSharpeRatio()} />

          {/* INFLATION WIDGET */}
          {(() => {
            const startStep = crisis.years[0];
            const startYear = startStep.year;
            // Normalize: inflation target = 1M at step 0, grows from there
            const inflBase = inflationAdjusted(1, startYear, startStep.year, startStep.month);
            const inflCurrent = inflationAdjusted(1, startYear, currentYear, currentMonth);
            const inflTarget = 1_000_000 * (inflCurrent / inflBase);
            const beating = totalNetWorth >= inflTarget;
            const diffPct = ((totalNetWorth - inflTarget) / inflTarget) * 100;
            return (
              <div
                className="rounded-2xl p-4"
                style={{
                  background: beating ? 'rgba(49,255,140,0.06)' : 'rgba(255,120,135,0.06)',
                  border: `1px solid ${beating ? 'rgba(49,255,140,0.2)' : 'rgba(255,120,135,0.2)'}`,
                }}
              >
                <div className="flex items-center justify-between mb-2">
                  <span className="text-xs font-bold tracking-wider uppercase" style={{ color: 'var(--muted)' }}>
                    Инфляция с {startYear} г.
                  </span>
                  <span
                    className="text-xs font-bold px-2 py-0.5 rounded-full"
                    style={{
                      background: beating ? 'rgba(49,255,140,0.15)' : 'rgba(255,120,135,0.15)',
                      color: beating ? 'var(--accent)' : 'var(--danger)',
                    }}
                  >
                    {beating ? '▲ Обгоняешь' : '▼ Отстаёшь'}
                  </span>
                </div>
                <div className="flex items-end justify-between gap-2">
                  <div>
                    <div className="text-[10px] text-[var(--muted)] mb-0.5">
                      1 млн ₽ в {startYear} = сейчас
                    </div>
                    <div className="text-base font-black" style={{ color: 'var(--foreground)' }}>
                      {(inflTarget / 1_000_000).toFixed(2)} млн ₽
                    </div>
                  </div>
                  <div className="text-right">
                    <div className="text-[10px] text-[var(--muted)] mb-0.5">Твой капитал</div>
                    <div
                      className="text-base font-black"
                      style={{ color: beating ? 'var(--accent)' : 'var(--danger)' }}
                    >
                      {diffPct >= 0 ? '+' : ''}{diffPct.toFixed(1)}%
                    </div>
                  </div>
                </div>
                <div className="mt-2 h-1.5 rounded-full overflow-hidden" style={{ background: 'rgba(255,255,255,0.06)' }}>
                  <div
                    className="h-full rounded-full transition-all duration-700"
                    style={{
                      width: `${Math.min(100, (totalNetWorth / inflTarget) * 100)}%`,
                      background: beating
                        ? 'linear-gradient(90deg, var(--accent), var(--accent-soft))'
                        : 'linear-gradient(90deg, var(--danger), rgba(255,120,135,0.6))',
                    }}
                  />
                </div>
              </div>
            );
          })()}

          {/* Holdings summary */}
          <div className="glass-panel rounded-2xl p-4 overflow-hidden flex flex-col" style={{ minHeight: '220px' }}>
            <div className="flex items-center justify-between mb-3">
              <div className="text-xs font-bold tracking-wider text-[var(--muted)] uppercase">Мои позиции</div>
              <button
                onClick={() => setShowPortfolio(true)}
                className="text-xs text-[var(--accent)] hover:underline"
              >
                Открыть →
              </button>
            </div>
            <div className="flex-1 overflow-y-auto space-y-2">
              {Object.values(state.portfolio).length === 0 ? (
                <div className="text-center text-[var(--muted)] text-sm py-8">
                  Нет позиций. Купи акции, нажав на тикер слева.
                </div>
              ) : (
                Object.values(state.portfolio).map((h) => {
                  const curPrice = getDbPrice(h.ticker, currentYear, currentMonth);
                  const curVal = h.shares * curPrice;
                  const pnl = curVal - h.shares * h.avgBuyPrice;
                  const stock = STOCKS.find((s) => s.ticker === h.ticker);
                  return (
                    <button
                      key={h.ticker}
                      onClick={() => router.push(`/stock/${h.ticker}`)}
                      className="w-full flex items-center gap-3 p-2.5 rounded-xl hover:bg-white/5 transition-all text-left"
                      style={{ border: '1px solid var(--line)' }}
                    >
                      <div
                        className="w-8 h-8 rounded-lg flex items-center justify-center text-xs font-black flex-shrink-0"
                        style={{ background: (stock?.color ?? '#31ff8c') + '22', color: stock?.color ?? 'var(--accent)' }}
                      >
                        {h.ticker.slice(0, 2)}
                      </div>
                      <div className="flex-1 min-w-0">
                        <div className="text-sm font-bold">{h.ticker}</div>
                        <div className="text-xs text-[var(--muted)]">{h.shares.toLocaleString('ru-RU')} шт</div>
                      </div>
                      <div className="text-right">
                        <div className="text-sm font-bold">{formatMoney(curVal)}</div>
                        <div className="text-xs" style={{ color: pnl >= 0 ? 'var(--accent)' : 'var(--danger)' }}>
                          {pnl >= 0 ? '+' : ''}{formatMoney(pnl)}
                        </div>
                      </div>
                    </button>
                  );
                })
              )}
            </div>
          </div>

          {/* OFZ Bonds */}
          <OFZPanel
            budget={state.budget}
            bondValue={getBondValue()}
            bonds={state.bonds ?? []}
            year={currentYear}
            month={currentMonth}
            onBuy={(amt) => buyBonds(amt, currentYear, currentMonth)}
            onSell={(amt) => sellBonds(amt)}
          />

          {/* Bottom actions */}
          <div className="flex gap-2">
            {!isSolo && (
              <button
                onClick={() => setShowForbes(true)}
                className="flex-1 py-3 rounded-xl font-bold text-sm flex items-center justify-center gap-2 transition-all hover:scale-[1.02]"
                style={{
                  background: 'linear-gradient(135deg, rgba(255,198,38,0.15), rgba(255,150,0,0.1))',
                  border: '1px solid rgba(255,198,38,0.3)',
                  color: '#ffc266',
                }}
              >
                🏆 Forbes
              </button>
            )}
            {/* Multi: participant sees Ready button; host sees Next Month */}
            {isMulti && !isHost ? (
              <button
                onClick={handleToggleReady}
                className="flex-[2] py-3 rounded-xl font-bold text-sm flex items-center justify-center gap-2 transition-all hover:scale-[1.02] active:scale-95"
                style={{
                  background: isReady
                    ? 'linear-gradient(135deg, var(--accent), var(--accent-soft))'
                    : 'rgba(255,255,255,0.08)',
                  border: isReady ? 'none' : '1px solid var(--line)',
                  color: isReady ? '#061712' : 'var(--foreground)',
                }}
              >
                {isReady ? '✓ Готов · ожидаю хоста' : '⏳ Нажми когда готов'}
              </button>
            ) : (
              <>
                {!isLastStep && (
                  <button
                    onClick={() => setShowEndConfirm(true)}
                    className="px-3 py-3 rounded-xl font-bold text-sm transition-all hover:scale-[1.02] active:scale-95"
                    style={{ background: 'rgba(255,120,135,0.1)', border: '1px solid rgba(255,120,135,0.25)', color: 'var(--danger)' }}
                    title="Завершить игру досрочно"
                  >
                    🏁
                  </button>
                )}
                <button
                  onClick={handleAdvanceStep}
                  className="flex-[2] py-3 rounded-xl font-bold text-sm flex items-center justify-center gap-2 transition-all hover:scale-[1.02] active:scale-95 pulse-ring"
                  style={{
                    background: isLastStep
                      ? 'linear-gradient(135deg, var(--accent-pink), rgba(255,79,216,0.6))'
                      : 'linear-gradient(135deg, var(--accent), var(--accent-soft))',
                    color: '#061712',
                  }}
                >
                  {isLastStep ? '🏁 Подвести итоги' : `📅 Следующий месяц →`}
                </button>
              </>
            )}
          </div>
        </div>

        {/* RIGHT: NEWS */}
        <div
          className={`flex-col overflow-hidden border-l border-[var(--line)] ${mobileTab === 'news' ? 'flex' : 'hidden'} md:flex`}
          style={{ background: 'rgba(4,17,13,0.9)' }}
        >
          {/* Header */}
          <div className="flex-shrink-0 p-3 border-b border-[var(--line)]">
            <div className="flex items-center justify-between mb-2">
              <div className="text-xs font-bold tracking-wider text-[var(--muted)] uppercase">
                {newsSearch ? `Поиск: «${newsSearch}»` : `Новости · ${step.label}`}
              </div>
              {!newsSearch && backendNews !== null && backendNews.length > 0 && (
                <div className="text-[10px] px-1.5 py-0.5 rounded" style={{ background: 'rgba(49,255,140,0.12)', color: 'var(--accent)' }}>
                  БД
                </div>
              )}
            </div>
            {/* Search input */}
            <div className="relative">
              <span className="absolute left-2.5 top-1/2 -translate-y-1/2 text-xs text-[var(--muted)]">🔍</span>
              <input
                type="text"
                value={newsSearch}
                onChange={(e) => setNewsSearch(e.target.value)}
                placeholder="Поиск по новостям..."
                className="w-full pl-7 pr-7 py-1.5 text-xs rounded-lg outline-none"
                style={{
                  background: 'rgba(255,255,255,0.05)',
                  border: '1px solid var(--line)',
                  color: 'var(--foreground)',
                }}
              />
              {newsSearch && (
                <button
                  onClick={() => setNewsSearch('')}
                  className="absolute right-2 top-1/2 -translate-y-1/2 text-xs text-[var(--muted)] hover:text-[var(--foreground)]"
                >
                  ✕
                </button>
              )}
            </div>
          </div>

          {/* News list */}
          <div className="flex-1 overflow-y-auto p-3 pb-20 md:pb-3 space-y-2">
            {newsSearch ? (
              <>
                {!searchResults && searchLoading && (
                  <div className="text-center text-xs text-[var(--muted)] py-8">Поиск...</div>
                )}
                {searchResults && searchResults.length === 0 && (
                  <div className="text-center text-xs text-[var(--muted)] py-8">
                    Ничего не найдено по запросу «{newsSearch}»
                  </div>
                )}
                {searchResults && searchResults.map((item, i) => (
                  <NewsCard key={item.id} item={item} index={i} />
                ))}
                {searchResults && searchResults.length < searchTotal && (
                  <button
                    onClick={loadMoreSearch}
                    disabled={searchLoading}
                    className="w-full py-2 text-xs rounded-lg transition-colors"
                    style={{ background: 'rgba(255,255,255,0.05)', color: 'var(--muted)', border: '1px solid var(--line)' }}
                  >
                    {searchLoading ? 'Загрузка...' : `Ещё (${searchTotal - searchResults.length})`}
                  </button>
                )}
              </>
            ) : (
              <>
                {backendNews === null && (
                  <div className="text-center text-xs text-[var(--muted)] py-8">Загрузка новостей...</div>
                )}
                {backendNews !== null && backendNews.length === 0 && (
                  <div className="text-center text-xs text-[var(--muted)] py-8">Нет новостей за этот период</div>
                )}
                {backendNews && backendNews.map((item, i) => (
                  <NewsCard key={item.id} item={item} index={i} />
                ))}
                {backendNews && backendNews.length < newsTotal && (
                  <button
                    onClick={() => setNewsPage((p) => p + 1)}
                    disabled={newsLoading}
                    className="w-full py-2 text-xs rounded-lg transition-colors"
                    style={{ background: 'rgba(255,255,255,0.05)', color: 'var(--muted)', border: '1px solid var(--line)' }}
                  >
                    {newsLoading ? 'Загрузка...' : `Ещё (${newsTotal - backendNews.length})`}
                  </button>
                )}
              </>
            )}
          </div>
        </div>
      </div>

      {/* ── MOBILE BOTTOM NAV ─────────────────────────────────────── */}
      <div
        className="md:hidden fixed bottom-0 inset-x-0 z-40 border-t border-[var(--line)] safe-area-bottom"
        style={{ background: 'var(--surface-strong)', backdropFilter: 'blur(20px)' }}
      >
        <div className="flex items-center h-16 px-2 gap-1">
          {/* Tabs */}
          <button
            onClick={() => setMobileTab('stocks')}
            className="flex-1 h-full flex flex-col items-center justify-center gap-0.5 rounded-xl transition-colors"
            style={{ color: mobileTab === 'stocks' ? 'var(--accent)' : 'var(--muted)', background: mobileTab === 'stocks' ? 'rgba(49,255,140,0.08)' : 'transparent' }}
          >
            <span className="text-base">📊</span>
            <span className="text-[10px] font-bold">Акции</span>
          </button>
          <button
            onClick={() => setMobileTab('capital')}
            className="flex-1 h-full flex flex-col items-center justify-center gap-0.5 rounded-xl transition-colors"
            style={{ color: mobileTab === 'capital' ? 'var(--accent)' : 'var(--muted)', background: mobileTab === 'capital' ? 'rgba(49,255,140,0.08)' : 'transparent' }}
          >
            <span className="text-base">💼</span>
            <span className="text-[10px] font-bold">Капитал</span>
          </button>
          <button
            onClick={() => setMobileTab('news')}
            className="flex-1 h-full flex flex-col items-center justify-center gap-0.5 rounded-xl transition-colors"
            style={{ color: mobileTab === 'news' ? 'var(--accent)' : 'var(--muted)', background: mobileTab === 'news' ? 'rgba(49,255,140,0.08)' : 'transparent' }}
          >
            <span className="text-base">📰</span>
            <span className="text-[10px] font-bold">Новости</span>
          </button>
          {/* Action button */}
          <div className="w-px h-8 mx-1 flex-shrink-0" style={{ background: 'var(--line)' }} />
          {isMulti && !isHost ? (
            <button
              onClick={handleToggleReady}
              className="flex-[1.4] h-10 rounded-xl font-bold text-xs flex items-center justify-center gap-1 transition-all flex-shrink-0"
              style={{
                background: isReady ? 'linear-gradient(135deg, var(--accent), var(--accent-soft))' : 'rgba(255,255,255,0.08)',
                border: isReady ? 'none' : '1px solid var(--line)',
                color: isReady ? '#061712' : 'var(--foreground)',
              }}
            >
              {isReady ? '✓ Готов' : '⏳ Готов?'}
            </button>
          ) : (
            <button
              onClick={handleAdvanceStep}
              disabled={transitioning}
              className="flex-[1.4] h-10 rounded-xl font-bold text-xs flex items-center justify-center gap-1 transition-all active:scale-95 disabled:opacity-60 flex-shrink-0"
              style={{
                background: isLastStep
                  ? 'linear-gradient(135deg, var(--accent-pink), rgba(255,79,216,0.6))'
                  : 'linear-gradient(135deg, var(--accent), var(--accent-soft))',
                color: '#061712',
              }}
            >
              {isLastStep ? '🏁 Итоги' : '📅 Далее'}
            </button>
          )}
        </div>
      </div>
    </div>
  );
}

// ============ ROUTER ============
export default function TradingPage() {
  const router = useRouter();
  const { state, hydrated } = useGame();
  const [showTutorial, setShowTutorial] = useState(false);

  useEffect(() => {
    if (!hydrated) return;
    if (!state.username) router.push('/');
    else if (state.mode !== 'realtime' && !state.crisis) router.push('/');
  }, [hydrated, state.username, state.mode, state.crisis]);

  useEffect(() => {
    if (!hydrated || !state.username) return;
    if (!localStorage.getItem('tutorial_v1_seen')) setShowTutorial(true);
  }, [hydrated, state.username]);

  function closeTutorial() {
    localStorage.setItem('tutorial_v1_seen', '1');
    setShowTutorial(false);
  }

  if (!hydrated || !state.username) return null;

  const inner = state.mode === 'realtime'
    ? <RealtimeTradingPage />
    : (state.crisis ? <HistoricalTradingPage /> : null);

  return (
    <>
      {showTutorial && <TutorialOverlay mode={state.mode} onClose={closeTutorial} />}
      {inner}
    </>
  );
}
