'use client';

import { useState, useEffect, use } from 'react';
import { useRouter } from 'next/navigation';
import { useGame } from '@/lib/game-context';
import { Crisis } from '@/lib/types';
import { api } from '@/lib/api-client';

interface RoomInfo {
  code: string;
  status: string;
  scenarioId: string;
  scenario: { id: string; name: string; emoji: string; periodLabel: string };
  players: { id: number; username: string }[];
}

export default function JoinPage({ params }: { params: Promise<{ code: string }> }) {
  const { code } = use(params);
  const router = useRouter();
  const { setState } = useGame();

  const [room, setRoom] = useState<RoomInfo | null>(null);
  const [error, setError] = useState('');
  const [username, setUsername] = useState('');
  const [joining, setJoining] = useState(false);
  const [loading, setLoading] = useState(true);

  useEffect(() => {
    api.rooms.get(code)
      .then((r) => {
        setRoom(r as unknown as RoomInfo);
        setLoading(false);
      })
      .catch(() => {
        setError('Комната не найдена или уже завершена');
        setLoading(false);
      });
  }, [code]);

  async function handleJoin() {
    const name = username.trim();
    if (!name) return;
    if (!room) return;
    setJoining(true);
    setError('');

    try {
      await api.rooms.join(code, name);
      const fullCrisis = await api.crises.get(room.scenarioId);

      setState((prev) => ({
        ...prev,
        mode: 'multi',
        crisis: fullCrisis as unknown as Crisis,
        currentYearIndex: 0,
        username: name,
        budget: 1_000_000,
        portfolio: {},
        bots: [],
        roomCode: code,
        gameStarted: false,
        lastRefreshAt: null,
      }));

      router.push('/lobby');
    } catch (e: unknown) {
      setError(e instanceof Error ? e.message : 'Не удалось присоединиться к комнате');
      setJoining(false);
    }
  }

  if (loading) {
    return (
      <div className="min-h-screen app-grid flex items-center justify-center">
        <div className="text-[var(--muted)] text-center">
          <div className="text-3xl mb-3 animate-pulse">🔍</div>
          Поиск комнаты...
        </div>
      </div>
    );
  }

  if (error && !room) {
    return (
      <div className="min-h-screen app-grid flex items-center justify-center px-4">
        <div className="glass-panel rounded-2xl p-8 w-full max-w-md text-center">
          <div className="text-4xl mb-4">❌</div>
          <h2 className="text-xl font-bold mb-2">Комната не найдена</h2>
          <p className="text-[var(--muted)] text-sm mb-6">{error}</p>
          <button
            onClick={() => router.push('/')}
            className="px-6 py-3 rounded-xl font-bold text-sm"
            style={{ background: 'rgba(49,255,140,0.15)', border: '1px solid rgba(49,255,140,0.3)', color: 'var(--accent)' }}
          >
            ← На главную
          </button>
        </div>
      </div>
    );
  }

  if (room?.status === 'finished') {
    return (
      <div className="min-h-screen app-grid flex items-center justify-center px-4">
        <div className="glass-panel rounded-2xl p-8 w-full max-w-md text-center">
          <div className="text-4xl mb-4">🏁</div>
          <h2 className="text-xl font-bold mb-2">Игра завершена</h2>
          <p className="text-[var(--muted)] text-sm mb-6">Эта комната уже сыграла. Создай новую игру!</p>
          <button onClick={() => router.push('/')} className="px-6 py-3 rounded-xl font-bold text-sm"
            style={{ background: 'rgba(49,255,140,0.15)', border: '1px solid rgba(49,255,140,0.3)', color: 'var(--accent)' }}>
            ← На главную
          </button>
        </div>
      </div>
    );
  }

  return (
    <div className="min-h-screen app-grid flex items-center justify-center px-4">
      <div className="glass-panel rounded-2xl p-8 w-full max-w-md space-y-6 rise-in">
        <div className="text-center">
          <div className="text-4xl mb-2">👥</div>
          <h1 className="text-2xl font-black aurora-text mb-1">Присоединиться к игре</h1>
          <p className="text-[var(--muted)] text-sm">Комната <span className="font-mono text-[var(--accent)]">{code}</span></p>
        </div>

        {room && (
          <div className="rounded-xl p-4 text-sm" style={{ background: 'rgba(49,255,140,0.06)', border: '1px solid rgba(49,255,140,0.15)' }}>
            <div className="flex items-center gap-3 mb-3">
              <span className="text-xl">{room.scenario.emoji}</span>
              <div>
                <div className="font-bold">{room.scenario.name}</div>
                <div className="text-xs text-[var(--muted)]">{room.scenario.periodLabel}</div>
              </div>
            </div>
            <div className="flex items-center justify-between text-xs text-[var(--muted)]">
              <span>Игроков в комнате:</span>
              <span className="font-bold text-[var(--foreground)]">{room.players?.length ?? 0} / 8</span>
            </div>
          </div>
        )}

        <div className="space-y-4">
          <div>
            <label className="block text-[var(--muted)] text-sm mb-2">Твой никнейм</label>
            <input
              type="text"
              value={username}
              onChange={(e) => setUsername(e.target.value)}
              onKeyDown={(e) => e.key === 'Enter' && !joining && handleJoin()}
              placeholder="Введи никнейм..."
              maxLength={20}
              autoFocus
              className="w-full px-4 py-3 rounded-xl text-[var(--foreground)] placeholder-[var(--muted)] outline-none focus:ring-1 focus:ring-[var(--accent)]"
              style={{ background: 'rgba(11,49,36,0.5)', border: '1px solid var(--line-strong)' }}
            />
          </div>

          {error && (
            <div className="text-sm text-[var(--danger)] rounded-xl px-3 py-2"
              style={{ background: 'rgba(255,120,135,0.1)', border: '1px solid rgba(255,120,135,0.2)' }}>
              {error}
            </div>
          )}

          <div className="flex gap-3">
            <div className="rounded-xl p-3 flex-1 text-sm" style={{ background: 'rgba(255,255,255,0.03)', border: '1px solid var(--line)' }}>
              <div className="text-xs text-[var(--muted)] mb-0.5">Стартовый капитал</div>
              <div className="font-bold text-[var(--accent)]">1 000 000 ₽</div>
            </div>
          </div>

          <button
            onClick={handleJoin}
            disabled={!username.trim() || joining}
            className="w-full py-4 rounded-xl font-bold text-lg transition-all hover:scale-[1.02] active:scale-95 disabled:opacity-40 disabled:cursor-not-allowed pulse-ring"
            style={{
              background: 'linear-gradient(135deg, var(--accent), var(--accent-soft))',
              color: '#061712',
            }}
          >
            {joining ? '⏳ Вход...' : '🚀 Войти в игру'}
          </button>
        </div>
      </div>
    </div>
  );
}
