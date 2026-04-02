'use client';

import { useState, useEffect } from 'react';
import { useRouter } from 'next/navigation';
import { useGame } from '@/lib/game-context';
import { STOCKS, formatMoney, getBotNetWorth, inflationAdjusted } from '@/lib/game-data';
import { api, ApiLeaderboardRow } from '@/lib/api-client';

function AnimatedCounter({ target, duration = 2000 }: { target: number; duration?: number }) {
  const [value, setValue] = useState(0);
  useEffect(() => {
    const start = Date.now();
    const step = () => {
      const elapsed = Date.now() - start;
      const progress = Math.min(elapsed / duration, 1);
      const eased = 1 - Math.pow(1 - progress, 3);
      setValue(Math.floor(eased * target));
      if (progress < 1) requestAnimationFrame(step);
      else setValue(target);
    };
    requestAnimationFrame(step);
  }, [target]);
  return <>{value.toLocaleString('ru-RU')}</>;
}

export default function ResultsPage() {
  const router = useRouter();
  const { state, hydrated, getTotalNetWorth, reset, getDbPrice } = useGame();
  const [revealed, setRevealed] = useState(false);
  const [showConfetti, setShowConfetti] = useState(false);
  const [roomLeaderboard, setRoomLeaderboard] = useState<ApiLeaderboardRow[] | null>(null);
  const savedRef = useState(false);

  const crisis = state.crisis;

  useEffect(() => {
    if (!hydrated) return;
    if (!state.username || !crisis) { router.push('/'); return; }
    setTimeout(() => setRevealed(true), 500);
    setTimeout(() => setShowConfetti(true), 1500);

    if (savedRef[0]) return;
    savedRef[1](true);

    // Use the step the player actually reached, not the last step of the crisis
    const currentStep = crisis.years[state.currentYearIndex] ?? crisis.years[crisis.years.length - 1];
    const worth = getTotalNetWorth(currentStep.year, currentStep.month);

    api.leaderboard.save({
      username: state.username,
      netWorth: worth,
      startBudget: 1_000_000,
      roomCode: state.roomCode || undefined,
    }).then(() => {
      // After saving, fetch room leaderboard for multi mode
      if (state.mode === 'multi' && state.roomCode) {
        // Poll until all players have saved (up to 10 attempts)
        let attempts = 0;
        const fetchLeaderboard = () => {
          api.leaderboard.get(state.roomCode)
            .then((rows) => {
              const deduped = rows.filter((r, idx, arr) => arr.findIndex((x) => x.username === r.username) === idx);
              setRoomLeaderboard(deduped);
              // If we only see ourselves and there were other players, retry
              if (deduped.length < 2 && attempts < 10) {
                attempts++;
                setTimeout(fetchLeaderboard, 2000);
              }
            })
            .catch(() => {});
        };
        fetchLeaderboard();
      }
    }).catch(() => {});
  }, [hydrated]);

  if (!hydrated || !crisis || !state.username) return null;

  // Use the step the player actually reached
  const finalStep = crisis.years[state.currentYearIndex] ?? crisis.years[crisis.years.length - 1];
  const firstStep = crisis.years[0];
  const finalYear = finalStep.year;
  const finalMonth = finalStep.month;
  const myWorth = getTotalNetWorth(finalYear, finalMonth);
  const startAmount = 1_000_000;
  const pnl = myWorth - startAmount;
  const pnlPct = ((myWorth - startAmount) / startAmount) * 100;
  const isProfit = pnl >= 0;

  // Inflation-adjusted real return
  const inflTarget = inflationAdjusted(startAmount, firstStep.year, finalYear, finalMonth);
  const realReturn = myWorth - inflTarget;
  const realReturnPct = ((myWorth - inflTarget) / inflTarget) * 100;
  const beatInflation = realReturn >= 0;
  const isSolo = state.mode === 'solo';

  // CAGR — среднегодовая доходность
  const totalMonths = (finalYear - firstStep.year) * 12 + (finalMonth - firstStep.month);
  const totalYears = totalMonths / 12;
  const cagr = totalYears > 0 ? (Math.pow(myWorth / startAmount, 1 / totalYears) - 1) * 100 : pnlPct;

  const holdings = Object.values(state.portfolio).map((h) => {
    const price = getDbPrice(h.ticker, finalYear, finalMonth);
    const value = h.shares * price;
    const cost = h.shares * h.avgBuyPrice;
    const stockPnl = value - cost;
    const stock = STOCKS.find((s) => s.ticker === h.ticker);
    return { ...h, curPrice: price, value, cost, pnl: stockPnl, stock };
  }).sort((a, b) => b.value - a.value);

  // For multi mode: use real room leaderboard if available, else bots fallback for solo
  const allPlayers = isSolo
    ? []
    : roomLeaderboard
      ? roomLeaderboard.map((row) => ({
          name: row.username,
          worth: row.netWorth,
          isYou: row.username === state.username,
        }))
      : [
          { name: state.username, worth: myWorth, isYou: true },
          ...state.bots.map((b, i) => ({
            name: b.username,
            worth: getBotNetWorth(i, crisis.years, crisis.years.length - 1),
            isYou: false,
          })),
        ].sort((a, b) => b.worth - a.worth);

  const myRank = isSolo ? 1 : Math.max(1, allPlayers.findIndex((p) => p.isYou) + 1);
  const medals = ['🥇', '🥈', '🥉'];
  const rankLabels = ['🏆 ПОБЕДИТЕЛЬ', '🥈 ВТОРОЕ МЕСТО', '🥉 ТРЕТЬЕ МЕСТО', `#${myRank} МЕСТО`];
  const rankLabel = isSolo
    ? (isProfit ? '📈 ПРИБЫЛЬНАЯ ТОРГОВЛЯ' : '📉 УБЫТОЧНАЯ ТОРГОВЛЯ')
    : rankLabels[Math.min(myRank - 1, 3)];

  const confettiItems = Array.from({ length: 40 }, (_, i) => ({
    id: i,
    x: Math.random() * 100,
    color: ['var(--accent)', 'var(--accent-blue)', 'var(--accent-pink)', 'var(--warning)'][i % 4],
    dur: Math.random() * 3 + 2,
    delay: Math.random() * 2,
    size: Math.random() * 8 + 4,
  }));

  return (
    <div className="min-h-screen app-grid overflow-x-hidden">
      {/* Confetti */}
      {showConfetti && isProfit && (
        <div className="fixed inset-0 pointer-events-none z-10 overflow-hidden">
          {confettiItems.map((c) => (
            <div
              key={c.id}
              className="absolute rounded-sm"
              style={{
                left: `${c.x}%`,
                top: '-10px',
                width: c.size,
                height: c.size * 0.5,
                background: c.color,
                opacity: 0.8,
                animation: `float-glow ${c.dur}s ${c.delay}s ease-in forwards`,
                transform: `rotate(${Math.random() * 360}deg)`,
              }}
            />
          ))}
        </div>
      )}

      <div className="max-w-4xl mx-auto px-4 py-10 space-y-6">

        {/* HERO RESULT */}
        <div className={`text-center transition-all duration-1000 ${revealed ? 'opacity-100 translate-y-0' : 'opacity-0 translate-y-8'}`}>
          <div className="text-6xl mb-4">{isSolo ? (isProfit ? '📈' : '📉') : myRank === 1 ? '🏆' : myRank === 2 ? '🥈' : myRank === 3 ? '🥉' : '📊'}</div>
          <div
            className="text-sm font-black tracking-[0.4em] uppercase mb-3"
            style={{ color: (isSolo ? isProfit : myRank === 1) ? 'var(--warning)' : 'var(--muted)' }}
          >
            {rankLabel}
          </div>
          <h1 className="text-5xl sm:text-7xl font-black aurora-text leading-none mb-3">
            Итоги {finalYear}
          </h1>
          <p className="text-[var(--muted)] text-lg">{state.username} · {crisis.name}</p>
        </div>

        {/* MAIN STATS */}
        <div className={`grid grid-cols-2 sm:grid-cols-5 gap-4 transition-all duration-1000 delay-300 ${revealed ? 'opacity-100 translate-y-0' : 'opacity-0 translate-y-8'}`}>
          <div className="glass-panel rounded-2xl p-5 text-center col-span-2 sm:col-span-1">
            <div className="text-xs text-[var(--muted)] uppercase tracking-wider mb-2">Итоговый капитал</div>
            <div className="text-2xl font-black text-[var(--accent)]">
              <AnimatedCounter target={Math.floor(myWorth)} /> ₽
            </div>
          </div>
          <div className="glass-panel rounded-2xl p-5 text-center">
            <div className="text-xs text-[var(--muted)] uppercase tracking-wider mb-2">Прибыль / Убыток</div>
            <div className="text-2xl font-black" style={{ color: isProfit ? 'var(--accent)' : 'var(--danger)' }}>
              {isProfit ? '+' : ''}<AnimatedCounter target={Math.floor(pnl)} /> ₽
            </div>
          </div>
          <div className="glass-panel rounded-2xl p-5 text-center">
            <div className="text-xs text-[var(--muted)] uppercase tracking-wider mb-2">Номинальная доходность</div>
            <div className="text-2xl font-black" style={{ color: isProfit ? 'var(--accent)' : 'var(--danger)' }}>
              {isProfit ? '+' : ''}{pnlPct.toFixed(1)}%
            </div>
          </div>
          <div
            className="rounded-2xl p-5 text-center"
            style={{
              background: beatInflation ? 'rgba(49,255,140,0.07)' : 'rgba(255,120,135,0.07)',
              border: `1px solid ${beatInflation ? 'rgba(49,255,140,0.25)' : 'rgba(255,120,135,0.25)'}`,
            }}
          >
            <div className="text-xs uppercase tracking-wider mb-2" style={{ color: beatInflation ? 'var(--accent)' : 'var(--danger)' }}>
              Реальная доходность
            </div>
            <div className="text-2xl font-black" style={{ color: beatInflation ? 'var(--accent)' : 'var(--danger)' }}>
              {beatInflation ? '+' : ''}{realReturnPct.toFixed(1)}%
            </div>
            <div className="text-[10px] mt-1" style={{ color: beatInflation ? 'var(--accent)' : 'var(--danger)' }}>
              {beatInflation ? '▲ Обогнал инфляцию' : '▼ Отстал от инфляции'}
            </div>
          </div>
          <div className="glass-panel rounded-2xl p-5 text-center">
            <div className="text-xs text-[var(--muted)] uppercase tracking-wider mb-2">Годовая доходность</div>
            <div className="text-2xl font-black" style={{ color: cagr >= 0 ? 'var(--accent)' : 'var(--danger)' }}>
              {cagr >= 0 ? '+' : ''}{cagr.toFixed(1)}%
            </div>
            <div className="text-[10px] mt-1 text-[var(--muted)]">
              CAGR · {totalYears.toFixed(1)} лет
            </div>
          </div>
        </div>

        {/* INFLATION BREAKDOWN */}
        <div className={`glass-panel rounded-2xl p-5 transition-all duration-1000 delay-400 ${revealed ? 'opacity-100 translate-y-0' : 'opacity-0 translate-y-8'}`}>
          <div className="flex items-center justify-between flex-wrap gap-3">
            <div>
              <div className="text-xs text-[var(--muted)] uppercase tracking-wider mb-1">Инфляция с {firstStep.year} г.</div>
              <div className="text-sm font-bold">
                1 млн ₽ в {firstStep.year} г. = <span style={{ color: 'var(--warning)' }}>{(inflTarget / 1_000_000).toFixed(2)} млн ₽</span> в {finalYear} г.
              </div>
            </div>
            <div className="text-right">
              <div className="text-xs text-[var(--muted)] uppercase tracking-wider mb-1">Твой капитал vs инфляция</div>
              <div className="text-lg font-black" style={{ color: beatInflation ? 'var(--accent)' : 'var(--danger)' }}>
                {beatInflation ? '+' : ''}{formatMoney(realReturn)} реальной прибыли
              </div>
            </div>
          </div>
          <div className="mt-3 h-2 rounded-full overflow-hidden" style={{ background: 'rgba(255,255,255,0.06)' }}>
            <div
              className="h-full rounded-full transition-all duration-1000"
              style={{
                width: `${Math.min(100, (myWorth / inflTarget) * 100)}%`,
                background: beatInflation
                  ? 'linear-gradient(90deg, var(--accent), var(--accent-soft))'
                  : 'linear-gradient(90deg, var(--danger), rgba(255,120,135,0.6))',
              }}
            />
          </div>
        </div>

        {/* LEADERBOARD — only in multiplayer */}
        {!isSolo && <div className={`glass-panel rounded-2xl overflow-hidden transition-all duration-1000 delay-500 ${revealed ? 'opacity-100 translate-y-0' : 'opacity-0 translate-y-8'}`}>
          <div
            className="p-5 border-b border-[var(--line)]"
            style={{ background: 'linear-gradient(135deg, rgba(255,198,38,0.1), rgba(255,150,0,0.07))' }}
          >
            <div className="flex items-center gap-3">
              <span className="text-2xl">🏆</span>
              <div>
                <h2 className="font-black text-xl">Forbes · Итоговый рейтинг</h2>
                <p className="text-[var(--muted)] text-sm">Все участники · {crisis.name}</p>
              </div>
            </div>
          </div>
          <div className="p-4 space-y-2">
            {allPlayers.map((p, i) => {
              const pPnlPct = ((p.worth - startAmount) / startAmount) * 100;
              return (
                <div
                  key={p.name}
                  className="flex items-center gap-4 p-4 rounded-xl leaderboard-row"
                  style={{
                    animationDelay: `${0.6 + i * 0.1}s`,
                    background: p.isYou ? 'rgba(49,255,140,0.1)' : i === 0 ? 'rgba(255,198,38,0.07)' : 'rgba(255,255,255,0.02)',
                    border: p.isYou ? '1px solid rgba(49,255,140,0.3)' : i === 0 ? '1px solid rgba(255,198,38,0.25)' : '1px solid var(--line)',
                  }}
                >
                  <div className="text-2xl w-10 text-center flex-shrink-0">
                    {medals[i] ?? `#${i + 1}`}
                  </div>
                  <div className="flex-1 min-w-0">
                    <div className="flex items-center gap-2 flex-wrap">
                      <span className="font-bold">{p.name}</span>
                      {p.isYou && (
                        <span className="text-xs px-2 py-0.5 rounded-full text-[var(--accent)]"
                          style={{ background: 'rgba(49,255,140,0.15)' }}>Вы</span>
                      )}
                      {i === 0 && !p.isYou && (
                        <span className="text-xs px-2 py-0.5 rounded-full text-[var(--warning)]"
                          style={{ background: 'rgba(255,198,38,0.15)' }}>Победитель</span>
                      )}
                    </div>
                  </div>
                  <div className="text-right flex-shrink-0">
                    <div className="font-bold text-lg">{formatMoney(p.worth)}</div>
                    <div className="text-sm" style={{ color: pPnlPct >= 0 ? 'var(--accent)' : 'var(--danger)' }}>
                      {pPnlPct >= 0 ? '+' : ''}{pPnlPct.toFixed(1)}%
                    </div>
                  </div>
                </div>
              );
            })}
          </div>
        </div>}

        {/* PORTFOLIO BREAKDOWN */}
        {holdings.length > 0 && (
          <div className={`glass-panel rounded-2xl overflow-hidden transition-all duration-1000 delay-700 ${revealed ? 'opacity-100 translate-y-0' : 'opacity-0 translate-y-8'}`}>
            <div className="p-5 border-b border-[var(--line)]">
              <h2 className="font-black text-xl">Итоговый портфель</h2>
            </div>
            <div className="p-4">
              <table className="w-full text-sm">
                <thead>
                  <tr className="text-[var(--muted)] text-xs border-b border-[var(--line)]">
                    <th className="text-left pb-3">Акция</th>
                    <th className="text-right pb-3">Кол-во</th>
                    <th className="text-right pb-3">Цена</th>
                    <th className="text-right pb-3">Стоимость</th>
                    <th className="text-right pb-3">P&L</th>
                  </tr>
                </thead>
                <tbody>
                  {holdings.map((h) => (
                    <tr key={h.ticker} className="border-b border-[var(--line)] hover:bg-white/3 transition-colors">
                      <td className="py-3">
                        <div className="flex items-center gap-2">
                          <div
                            className="w-7 h-7 rounded-lg flex items-center justify-center text-xs font-black flex-shrink-0"
                            style={{ background: (h.stock?.color ?? '#31ff8c') + '22', color: h.stock?.color ?? 'var(--accent)' }}
                          >
                            {h.ticker.slice(0, 2)}
                          </div>
                          <div>
                            <div className="font-bold">{h.ticker}</div>
                            <div className="text-xs text-[var(--muted)]">{h.stock?.name}</div>
                          </div>
                        </div>
                      </td>
                      <td className="py-3 text-right font-mono">{h.shares.toLocaleString('ru-RU')}</td>
                      <td className="py-3 text-right font-mono">{formatMoney(h.curPrice)}</td>
                      <td className="py-3 text-right font-bold">{formatMoney(h.value)}</td>
                      <td className="py-3 text-right font-bold" style={{ color: h.pnl >= 0 ? 'var(--accent)' : 'var(--danger)' }}>
                        {h.pnl >= 0 ? '+' : ''}{formatMoney(h.pnl)}
                      </td>
                    </tr>
                  ))}
                  <tr className="font-black">
                    <td className="pt-3 text-[var(--muted)]" colSpan={3}>Свободные средства</td>
                    <td className="pt-3 text-right">{formatMoney(state.budget)}</td>
                    <td />
                  </tr>
                  <tr className="font-black text-lg border-t border-[var(--line-strong)]">
                    <td className="pt-3 text-[var(--accent)]" colSpan={3}>ИТОГО</td>
                    <td className="pt-3 text-right text-[var(--accent)]">{formatMoney(myWorth)}</td>
                    <td className="pt-3 text-right" style={{ color: isProfit ? 'var(--accent)' : 'var(--danger)' }}>
                      {isProfit ? '+' : ''}{pnlPct.toFixed(1)}%
                    </td>
                  </tr>
                </tbody>
              </table>
            </div>
          </div>
        )}

        {/* ACTIONS */}
        <div className={`flex gap-4 pb-10 transition-all duration-1000 delay-1000 ${revealed ? 'opacity-100 translate-y-0' : 'opacity-0 translate-y-8'}`}>
          <button
            onClick={() => { reset(); router.push('/'); }}
            className="flex-1 py-4 rounded-xl font-bold text-lg transition-all hover:scale-[1.02] active:scale-95 pulse-ring"
            style={{ background: 'linear-gradient(135deg, var(--accent), var(--accent-soft))', color: '#061712' }}
          >
            🔄 Начать заново
          </button>
          <button
            onClick={() => { reset(); router.push('/'); }}
            className="flex-1 py-4 rounded-xl font-bold text-lg transition-all hover:scale-[1.02] active:scale-95"
            style={{ background: 'rgba(255,255,255,0.07)', border: '1px solid var(--line-strong)' }}
          >
            🏠 На главную
          </button>
        </div>
      </div>
    </div>
  );
}
