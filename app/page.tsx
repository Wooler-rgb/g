'use client';

import { useState, useEffect } from 'react';
import { useRouter } from 'next/navigation';
import { useGame } from '@/lib/game-context';
import { BOT_NAMES } from '@/lib/game-data';
import { Crisis, BotPlayer } from '@/lib/types';
import { api, ApiCrisis } from '@/lib/api-client';

type Step = 'home' | 'crisis' | 'username';

function randomCode() {
  return Math.random().toString(36).slice(2, 8).toUpperCase();
}

function generateBots(count: number, crisisYearsLength: number): BotPlayer[] {
  const styles: BotPlayer['style'][] = ['conservative', 'aggressive', 'speculative', 'dividend', 'tech'];
  return Array.from({ length: count }, (_, i) => ({
    id: `bot_${i}`,
    username: BOT_NAMES[i % BOT_NAMES.length],
    style: styles[i % styles.length],
    yearReturns: Array.from({ length: crisisYearsLength }, () => 0),
  }));
}

export default function HomePage() {
  const router = useRouter();
  const { setState, reset } = useGame();
  const [step, setStep] = useState<Step>('home');
  const [mode, setMode] = useState<'solo' | 'multi' | 'realtime' | null>(null);
  const [selectedCrisis, setSelectedCrisis] = useState<Crisis | null>(null);
  const [username, setUsername] = useState('');
  const [particles, setParticles] = useState<{ id: number; x: number; y: number; size: number; dur: number; delay: number }[]>([]);
  const [usernameError, setUsernameError] = useState('');
  const [starting, setStarting] = useState(false);
  // Crises: try API first, fall back to local static data instantly
  const [apiCrises, setApiCrises] = useState<ApiCrisis[]>([]);
  const [crisesLoading, setCrisesLoading] = useState(true);

  useEffect(() => {
    reset();
    setParticles(Array.from({ length: 24 }, (_, i) => ({
      id: i,
      x: Math.random() * 100,
      y: Math.random() * 100,
      size: Math.random() * 3 + 1,
      dur: Math.random() * 8 + 4,
      delay: Math.random() * 5,
    })));
    // Fetch crises from backend
    api.crises.list()
      .then((data) => {
        setApiCrises(data);
        setCrisesLoading(false);
      })
      .catch(() => {
        setCrisesLoading(false);
      });
  }, []);

  function handleModeSelect(m: 'solo' | 'multi' | 'realtime') {
    setMode(m);
    if (m === 'realtime') {
      setStep('username'); // skip crisis selection for realtime
    } else {
      setStep('crisis');
    }
  }

  function handleCrisisSelect(c: Crisis) {
    setSelectedCrisis(c);
    setStep('username');
  }

  async function handleStart() {
    if (!mode || starting) return;
    const name = username.trim() || 'Трейдер';
    setUsernameError('');
    setStarting(true);

    if (mode === 'realtime') {
      // Register user in background — non-blocking
      api.users.create(name).catch(() => {});
      setState((prev) => ({
        ...prev,
        mode: 'realtime',
        crisis: null,
        currentYearIndex: 0,
        username: name,
        budget: 1_000_000,
        portfolio: {},
        bots: [],
        roomCode: '',
        gameStarted: false,
        lastRefreshAt: null,
      }));
      router.push('/trading');
      return;
    }

    if (!selectedCrisis) { setStarting(false); return; }
    const fullCrisis = selectedCrisis as unknown as Crisis;
    const bots = generateBots(4, fullCrisis.years.length);

    // Register user; if multi mode, create room on backend
    let roomCode = '';
    try {
      await api.users.create(name);
      if (mode === 'multi') {
        const room = await api.rooms.create(selectedCrisis.id, name);
        roomCode = room.code;
      }
    } catch {
      // Backend unavailable — fall back to local random code
      if (mode === 'multi') roomCode = randomCode();
    }

    setState((prev) => ({
      ...prev,
      mode,
      crisis: fullCrisis,
      currentYearIndex: 0,
      username: name,
      budget: 1_000_000,
      portfolio: {},
      bots,
      roomCode,
      gameStarted: false,
      lastRefreshAt: null,
    }));

    if (mode === 'multi') {
      router.push('/lobby');
    } else {
      router.push('/trading');
    }
  }

  return (
    <div className="min-h-screen app-grid relative overflow-hidden flex flex-col">
      {/* Floating particles */}
      <div className="pointer-events-none fixed inset-0 overflow-hidden">
        {particles.map((p) => (
          <div
            key={p.id}
            className="absolute rounded-full opacity-30"
            style={{
              left: `${p.x}%`,
              top: `${p.y}%`,
              width: p.size,
              height: p.size,
              background: 'var(--accent)',
              animation: `float-glow ${p.dur}s ${p.delay}s ease-in-out infinite`,
            }}
          />
        ))}
      </div>

      {/* ===== HOME STEP ===== */}
      {step === 'home' && (
        <div className="flex flex-col items-center justify-center min-h-screen px-4 gap-12">
          <div className="text-center rise-in">
            <div className="flex items-center justify-center gap-3 mb-4">
              <div
                className="w-12 h-12 rounded-xl flex items-center justify-center text-2xl pulse-ring"
                style={{ background: 'linear-gradient(135deg, rgba(49,255,140,0.2), rgba(53,217,255,0.1))' }}
              >
                📈
              </div>
              <span className="text-sm font-bold tracking-[0.3em] text-[var(--muted)] uppercase">
                Симулятор трейдинга
              </span>
            </div>
            <h1 className="text-6xl sm:text-8xl font-black tracking-tight aurora-text leading-none mb-4">
              СибИнвестиции
            </h1>
            <p className="text-[var(--muted)] text-lg max-w-md mx-auto leading-relaxed">
              Торгуй акциями MOEX сквозь финансовые кризисы России.
              <br />
              Начни с 1 000 000 ₽ — стань легендой рынка.
            </p>
          </div>

          <div className="flex flex-col gap-4 w-full max-w-2xl rise-in-2">
            <div className="grid grid-cols-1 sm:grid-cols-2 gap-4">
              <button
                onClick={() => handleModeSelect('solo')}
                className="glass-panel shimmer-border hover-float rounded-2xl p-7 text-left group border border-[var(--line)] transition-all"
              >
                <div className="text-3xl mb-3">🧑‍💻</div>
                <h2 className="text-xl font-bold text-[var(--foreground)] mb-1">Соло игра</h2>
                <p className="text-[var(--muted)] text-sm leading-relaxed">
                  Торгуй самостоятельно. Проверь интуицию против реальных исторических данных.
                </p>
                <div className="mt-4 flex items-center gap-2 text-[var(--accent)] text-sm font-bold">
                  Начать <span className="group-hover:translate-x-1 transition-transform inline-block">→</span>
                </div>
              </button>

              <button
                onClick={() => handleModeSelect('multi')}
                className="glass-panel shimmer-border hover-float rounded-2xl p-7 text-left group border border-[var(--line)] transition-all"
              >
                <div className="text-3xl mb-3">👥</div>
                <h2 className="text-xl font-bold text-[var(--foreground)] mb-1">Мультиплеер</h2>
                <p className="text-[var(--muted)] text-sm leading-relaxed">
                  Создай комнату и пригласи друзей. Кто лучший инвестор кризиса?
                </p>
                <div className="mt-4 flex items-center gap-2 text-[var(--accent-blue)] text-sm font-bold">
                  Создать комнату <span className="group-hover:translate-x-1 transition-transform inline-block">→</span>
                </div>
              </button>
            </div>

            {/* Real-time mode — full width banner */}
            <button
              onClick={() => handleModeSelect('realtime')}
              className="glass-panel shimmer-border hover-float rounded-2xl p-6 text-left group border border-[var(--line)] transition-all relative overflow-hidden"
              style={{ borderColor: 'rgba(53,217,255,0.25)' }}
            >
              <div
                className="absolute inset-0 opacity-5"
                style={{ background: 'linear-gradient(135deg, rgba(53,217,255,0.4), transparent 60%)' }}
              />
              <div className="relative flex items-center gap-5">
                <div className="text-4xl flex-shrink-0">🔴</div>
                <div className="flex-1 min-w-0">
                  <div className="flex items-center gap-2 mb-1">
                    <h2 className="text-xl font-bold text-[var(--foreground)]">Реальное время</h2>
                    <span
                      className="text-xs px-2 py-0.5 rounded-full font-bold animate-pulse"
                      style={{ background: 'rgba(53,217,255,0.15)', color: 'var(--accent-blue)', border: '1px solid rgba(53,217,255,0.3)' }}
                    >
                      LIVE
                    </span>
                  </div>
                  <p className="text-[var(--muted)] text-sm leading-relaxed">
                    Торгуй на живых данных MOEX прямо сейчас. Цены обновляются каждые 5 минут.
                  </p>
                </div>
                <div className="text-[var(--accent-blue)] text-sm font-bold flex-shrink-0 flex items-center gap-1">
                  Начать <span className="group-hover:translate-x-1 transition-transform inline-block">→</span>
                </div>
              </div>
            </button>
          </div>

          <div className="w-full overflow-hidden border-y border-[var(--line)] py-2 text-xs rise-in-4">
            <div className="ticker-tape">
              <div className="ticker-inner">
                {[...Array(2)].map((_, ri) =>
                  [
                    ['SBER', '+2.1%'], ['GAZP', '-1.3%'], ['LKOH', '+4.7%'], ['YNDX', '+8.2%'],
                    ['MGNT', '-0.5%'], ['VTBR', '+1.1%'], ['ROSN', '+3.4%'], ['NVTK', '-2.1%'],
                    ['GMKN', '+0.8%'], ['ALRS', '-3.2%'], ['TATN', '+1.9%'], ['MTSS', '+0.4%'],
                  ].map(([ticker, chg], i) => (
                    <span
                      key={`${ri}-${i}`}
                      className="flex items-center gap-1"
                    >
                      <span className="text-[var(--foreground)] font-bold">{ticker}</span>
                      <span style={{ color: chg.startsWith('+') ? 'var(--accent)' : 'var(--danger)' }}>
                        {chg}
                      </span>
                    </span>
                  )),
                )}
              </div>
            </div>
          </div>
        </div>
      )}

      {/* ===== CRISIS STEP ===== */}
      {step === 'crisis' && (
        <div className="flex flex-col items-center justify-center min-h-screen px-4 py-12 gap-8">
          <div className="text-center rise-in">
            <button
              onClick={() => setStep('home')}
              className="text-[var(--muted)] text-sm mb-6 hover:text-[var(--foreground)] transition-colors flex items-center gap-2 mx-auto"
            >
              ← Назад
            </button>
            <h2 className="text-4xl sm:text-5xl font-black aurora-text mb-2">Выбери кризис</h2>
            <p className="text-[var(--muted)]">С какого момента истории начнём инвестировать?</p>
          </div>

          <div className="grid grid-cols-1 sm:grid-cols-2 gap-5 w-full max-w-3xl">
            {crisesLoading ? (
              <div className="col-span-2 text-center text-[var(--muted)] py-12">
                <div className="text-3xl mb-3 animate-pulse">📊</div>
                Загрузка данных с сервера...
              </div>
            ) : (apiCrises.length > 0 ? apiCrises : []).map((crisis, i) => (
              <button
                key={crisis.id}
                onClick={() => handleCrisisSelect(crisis as unknown as Crisis)}
                className="glass-panel shimmer-border hover-float rounded-2xl p-7 text-left group border border-[var(--line)] transition-all rise-in"
                style={{ animationDelay: `${i * 0.1}s` }}
              >
                <div className="flex items-start gap-4">
                  <div
                    className="w-12 h-12 rounded-xl flex items-center justify-center text-2xl flex-shrink-0"
                    style={{ background: crisis.color + '22', border: `1px solid ${crisis.color}44` }}
                  >
                    {crisis.emoji}
                  </div>
                  <div className="flex-1 min-w-0">
                    <div className="text-xs font-bold tracking-wider mb-1" style={{ color: crisis.color }}>
                      {crisis.periodLabel} · {crisis.years.length} ходов
                    </div>
                    <h3 className="text-lg font-bold text-[var(--foreground)] mb-1 group-hover:text-[var(--accent)] transition-colors">
                      {crisis.name}
                    </h3>
                    <p className="text-[var(--muted)] text-sm leading-relaxed">{crisis.description}</p>
                    <div className="mt-3 flex gap-1 flex-wrap">
                      {crisis.years.slice(0, 8).map((y) => (
                        <span
                          key={y.label}
                          className="text-xs px-2 py-0.5 rounded-full"
                          style={{ background: crisis.color + '18', color: crisis.color }}
                        >
                          {y.label}
                        </span>
                      ))}
                      {crisis.years.length > 8 && (
                        <span className="text-xs px-2 py-0.5 rounded-full" style={{ background: 'rgba(255,255,255,0.05)', color: 'var(--muted)' }}>
                          +{crisis.years.length - 8} мес.
                        </span>
                      )}
                    </div>
                  </div>
                </div>
              </button>
            ))}
          </div>
        </div>
      )}

      {/* ===== USERNAME STEP ===== */}
      {step === 'username' && (mode === 'realtime' || selectedCrisis) && (
        <div className="flex flex-col items-center justify-center min-h-screen px-4 gap-8">
          <div className="text-center rise-in">
            <button
              onClick={() => mode === 'realtime' ? setStep('home') : setStep('crisis')}
              className="text-[var(--muted)] text-sm mb-6 hover:text-[var(--foreground)] transition-colors flex items-center gap-2 mx-auto"
            >
              ← Назад
            </button>
            {mode === 'realtime' ? (
              <>
                <div className="text-5xl mb-4">🔴</div>
                <h2 className="text-4xl font-black aurora-text mb-2">Реальное время</h2>
                <p className="text-[var(--muted)] max-w-sm mx-auto">
                  Текущие цены MOEX · Обновление каждые 5 минут
                </p>
              </>
            ) : (
              <>
                <div className="text-5xl mb-4">{selectedCrisis!.emoji}</div>
                <h2 className="text-4xl font-black aurora-text mb-2">{selectedCrisis!.name}</h2>
                <p className="text-[var(--muted)] max-w-sm mx-auto">{selectedCrisis!.description}</p>
              </>
            )}
          </div>

          <div className="glass-panel rounded-2xl p-8 w-full max-w-md rise-in-2">
            <h3 className="text-xl font-bold mb-6 text-center">
              {mode === 'multi' ? '👥 Создание комнаты' : mode === 'realtime' ? '🔴 Профиль трейдера' : '🧑‍💻 Твой профиль трейдера'}
            </h3>

            <div className="space-y-4">
              <div>
                <label className="block text-[var(--muted)] text-sm mb-2">Твой никнейм</label>
                <input
                  type="text"
                  value={username}
                  onChange={(e) => { setUsername(e.target.value); setUsernameError(''); }}
                  onKeyDown={(e) => e.key === 'Enter' && handleStart()}
                  placeholder="Введи никнейм..."
                  maxLength={20}
                  className="w-full px-4 py-3 rounded-xl text-[var(--foreground)] placeholder-[var(--muted)] outline-none transition-all focus:ring-1"
                  style={{
                    background: 'rgba(11,49,36,0.5)',
                    border: usernameError ? '1px solid var(--danger)' : '1px solid var(--line-strong)',
                    outlineColor: usernameError ? 'var(--danger)' : 'var(--accent)',
                  }}
                  autoFocus
                />
                {usernameError && (
                  <div className="mt-1.5 text-xs font-bold px-1" style={{ color: 'var(--danger)' }}>
                    {usernameError}
                  </div>
                )}
              </div>

              <div
                className="rounded-xl p-4 text-sm"
                style={{
                  background: mode === 'realtime' ? 'rgba(53,217,255,0.06)' : 'rgba(49,255,140,0.06)',
                  border: mode === 'realtime' ? '1px solid rgba(53,217,255,0.2)' : '1px solid rgba(49,255,140,0.15)',
                }}
              >
                <div className="flex justify-between mb-2">
                  <span className="text-[var(--muted)]">Стартовый капитал</span>
                  <span className="text-[var(--accent)] font-bold">1 000 000 ₽</span>
                </div>
                {mode === 'realtime' ? (
                  <>
                    <div className="flex justify-between mb-2">
                      <span className="text-[var(--muted)]">Дата начала</span>
                      <span className="text-[var(--foreground)]">{new Date().toLocaleDateString('ru-RU')}</span>
                    </div>
                    <div className="flex justify-between">
                      <span className="text-[var(--muted)]">Режим</span>
                      <span className="font-bold" style={{ color: 'var(--accent-blue)' }}>🔴 LIVE</span>
                    </div>
                  </>
                ) : (
                  <>
                    <div className="flex justify-between mb-2">
                      <span className="text-[var(--muted)]">Период</span>
                      <span className="text-[var(--foreground)]">{selectedCrisis!.periodLabel}</span>
                    </div>
                    <div className="flex justify-between">
                      <span className="text-[var(--muted)]">Количество ходов</span>
                      <span className="text-[var(--foreground)]">{selectedCrisis!.years.length} месяцев</span>
                    </div>
                  </>
                )}
              </div>

              <button
                onClick={handleStart}
                disabled={starting}
                className="w-full py-4 rounded-xl font-bold text-lg transition-all hover:scale-[1.02] active:scale-95 pulse-ring disabled:opacity-60 disabled:cursor-not-allowed disabled:scale-100"
                style={{
                  background: mode === 'realtime'
                    ? 'linear-gradient(135deg, var(--accent-blue), rgba(53,217,255,0.6))'
                    : 'linear-gradient(135deg, var(--accent), var(--accent-soft))',
                  color: '#061712',
                }}
              >
                {starting ? '⏳ Загрузка...' : mode === 'multi' ? '🚀 Создать комнату' : mode === 'realtime' ? '🔴 Начать торги' : '🚀 Начать торговлю'}
              </button>
            </div>
          </div>
        </div>
      )}
    </div>
  );
}
