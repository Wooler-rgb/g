'use client';

import { useState, useEffect, useRef } from 'react';
import { useRouter } from 'next/navigation';
import { useGame } from '@/lib/game-context';
import { api } from '@/lib/api-client';

const AVATARS = ['🐻', '🦊', '🐺', '🦁', '🐯', '🦝', '🐸', '🦄'];

interface RealPlayer {
  id: number;
  username: string;
}

export default function LobbyPage() {
  const router = useRouter();
  const { state, hydrated, setState } = useGame();
  const [players, setPlayers] = useState<RealPlayer[]>([]);
  const [countdown, setCountdown] = useState<number | null>(null);
  const [copied, setCopied] = useState(false);
  const [roomStatus, setRoomStatus] = useState<string>('waiting');
  const pollRef = useRef<ReturnType<typeof setInterval> | null>(null);

  const crisis = state.crisis;
  const roomCode = state.roomCode;

  // Poll room state from backend every 3 seconds
  useEffect(() => {
    if (!hydrated) return;
    if (!state.username) { router.push('/'); return; }
    if (!roomCode) return;

    async function fetchRoom() {
      try {
        const room = await api.rooms.get(roomCode);
        setPlayers(room.players?.map((p) => ({ id: p.id, username: p.username })) ?? []);
        setRoomStatus(room.status ?? 'waiting');
        // If host started game while we were waiting, redirect
        if (room.status === 'active' && !state.gameStarted) {
          setState((prev) => ({ ...prev, gameStarted: true }));
          router.push('/trading');
        }
      } catch {
        // Backend unavailable — show only self
        if (players.length === 0) {
          setPlayers([{ id: 0, username: state.username }]);
        }
      }
    }

    fetchRoom();
    pollRef.current = setInterval(fetchRoom, 3000);
    return () => { if (pollRef.current) clearInterval(pollRef.current); };
  }, [hydrated, roomCode, state.username]);

  function handleStart() {
    // Stop polling
    if (pollRef.current) clearInterval(pollRef.current);

    // Mark room as active on backend
    if (roomCode) {
      api.rooms.setStatus(roomCode, 'active').catch(() => {});
    }

    setState((prev) => ({ ...prev, gameStarted: true }));
    let c = 3;
    setCountdown(c);
    const iv = setInterval(() => {
      c--;
      if (c <= 0) {
        clearInterval(iv);
        router.push('/trading');
      } else {
        setCountdown(c);
      }
    }, 1000);
  }

  function copyLink() {
    const link = typeof window !== 'undefined'
      ? `${window.location.origin}/join/${roomCode}`
      : `/join/${roomCode}`;

    if (navigator.clipboard?.writeText) {
      navigator.clipboard.writeText(link).catch(() => fallbackCopy(link));
    } else {
      fallbackCopy(link);
    }
    setCopied(true);
    setTimeout(() => setCopied(false), 2000);
  }

  function fallbackCopy(text: string) {
    try {
      const el = document.createElement('textarea');
      el.value = text;
      el.style.cssText = 'position:fixed;opacity:0;top:0;left:0';
      document.body.appendChild(el);
      el.focus();
      el.select();
      document.execCommand('copy');
      document.body.removeChild(el);
    } catch {
      // ignore
    }
  }

  const isHost = players.length === 0 || players[0]?.username === state.username;
  const canStart = players.length >= 1; // allow starting with 1+ (solo in multi room)
  const joinLink = typeof window !== 'undefined' ? `${window.location.origin}/join/${roomCode}` : `/join/${roomCode}`;

  if (!crisis) return null;

  return (
    <div className="min-h-screen app-grid flex flex-col items-center px-4 py-12 overflow-y-auto">
      {/* Countdown overlay */}
      {countdown !== null && (
        <div className="fixed inset-0 z-50 flex items-center justify-center bg-black/80 backdrop-blur-sm">
          <div className="text-[12rem] font-black aurora-text scale-in leading-none" key={countdown}>
            {countdown}
          </div>
        </div>
      )}

      <div className="w-full max-w-2xl space-y-5">
        {/* Header */}
        <div className="text-center rise-in">
          <div className="text-4xl mb-2">👥</div>
          <h1 className="text-4xl font-black aurora-text mb-1">Лобби</h1>
          <p className="text-[var(--muted)] text-sm">{crisis.name}</p>
        </div>

        {/* Join link */}
        <div className="glass-panel rounded-2xl p-6 rise-in-1">
          <p className="text-[var(--muted)] text-sm mb-4 text-center">Ссылка для приглашения друзей</p>
          <div className="flex gap-4 items-center">
            {/* QR code */}
            <div
              className="flex-shrink-0 rounded-xl overflow-hidden p-1.5"
              style={{ background: '#fff' }}
            >
              {/* eslint-disable-next-line @next/next/no-img-element */}
              <img
                src={`https://api.qrserver.com/v1/create-qr-code/?size=110x110&data=${encodeURIComponent(joinLink)}&color=04110d&bgcolor=ffffff`}
                alt="QR код для входа"
                width={110}
                height={110}
              />
            </div>
            {/* Link + copy */}
            <div className="flex-1 min-w-0 space-y-2">
              <div
                className="flex items-center rounded-xl px-3 py-2 font-mono text-xs font-bold text-[var(--accent)] truncate"
                style={{ background: 'rgba(49,255,140,0.08)', border: '1px solid rgba(49,255,140,0.2)' }}
              >
                {joinLink}
              </div>
              <button
                onClick={copyLink}
                className="w-full py-2.5 rounded-xl font-bold text-sm transition-all hover:scale-105 active:scale-95"
                style={{
                  background: copied ? 'rgba(49,255,140,0.2)' : 'rgba(255,255,255,0.07)',
                  border: '1px solid var(--line-strong)',
                  color: copied ? 'var(--accent)' : 'var(--foreground)',
                }}
              >
                {copied ? '✓ Скопировано' : '📋 Копировать ссылку'}
              </button>
              <p className="text-center text-xs text-[var(--muted)] font-mono">Код: {roomCode}</p>
            </div>
          </div>
        </div>

        {/* Players list */}
        <div className="glass-panel rounded-2xl p-6 rise-in-2">
          <div className="flex items-center justify-between mb-4">
            <h2 className="font-bold text-lg">Игроки</h2>
            <div className="flex items-center gap-2">
              <span className="w-2 h-2 rounded-full bg-[var(--accent)] animate-pulse" />
              <span className="text-xs text-[var(--muted)]">{players.length} / 8</span>
            </div>
          </div>

          <div className="space-y-3">
            {players.map((player, i) => {
              const isYou = player.username === state.username;
              return (
                <div
                  key={player.id || player.username}
                  className="flex items-center gap-4 rounded-xl px-4 py-3 transition-all scale-in"
                  style={{
                    background: isYou ? 'rgba(49,255,140,0.08)' : 'rgba(255,255,255,0.03)',
                    border: isYou ? '1px solid rgba(49,255,140,0.2)' : '1px solid var(--line)',
                  }}
                >
                  <div className="text-2xl w-10 text-center">{AVATARS[i % AVATARS.length]}</div>
                  <div className="flex-1">
                    <div className="flex items-center gap-2">
                      <span className="font-bold">{player.username}</span>
                      {isYou && (
                        <span className="text-xs px-2 py-0.5 rounded-full text-[var(--accent)]"
                          style={{ background: 'rgba(49,255,140,0.15)' }}>
                          Вы
                        </span>
                      )}
                    </div>
                    <div className="text-xs text-[var(--muted)]">
                      {i === 0 ? '👑 Хост' : `Игрок ${i + 1}`}
                    </div>
                  </div>
                  <span className="text-sm font-bold text-[var(--accent)] flex items-center gap-1">
                    <span className="w-2 h-2 rounded-full bg-[var(--accent)] inline-block animate-pulse" />
                    В сети
                  </span>
                </div>
              );
            })}

            {/* Empty slots */}
            {Array.from({ length: Math.max(0, 3 - players.length) }).map((_, i) => (
              <div key={`empty_${i}`} className="flex items-center gap-4 rounded-xl px-4 py-3 opacity-30"
                style={{ border: '1px dashed var(--line)' }}>
                <div className="text-2xl w-10 text-center">⏳</div>
                <span className="text-[var(--muted)] text-sm">Ожидание игрока...</span>
              </div>
            ))}
          </div>
        </div>

        {/* Crisis info */}
        <div className="rounded-xl p-4 text-sm rise-in-3"
          style={{ background: crisis.color + '11', border: `1px solid ${crisis.color}33` }}>
          <div className="flex items-center gap-3 mb-2">
            <span className="text-xl">{crisis.emoji}</span>
            <span className="font-bold" style={{ color: crisis.color }}>{crisis.name}</span>
          </div>
          <div className="grid grid-cols-3 gap-4 text-center">
            <div>
              <div className="text-[var(--muted)] text-xs">Старт</div>
              <div className="font-bold">{crisis.years[0].year}</div>
            </div>
            <div>
              <div className="text-[var(--muted)] text-xs">Ходов</div>
              <div className="font-bold">{crisis.years.length}</div>
            </div>
            <div>
              <div className="text-[var(--muted)] text-xs">Капитал</div>
              <div className="font-bold text-[var(--accent)]">1 млн ₽</div>
            </div>
          </div>
        </div>

        {/* Action buttons */}
        <div className="flex gap-3 rise-in-4">
          {isHost && (
            <button
              onClick={handleStart}
              disabled={!canStart}
              className="flex-1 py-4 rounded-xl font-bold text-lg transition-all hover:scale-[1.02] active:scale-95 disabled:opacity-40 disabled:cursor-not-allowed pulse-ring"
              style={{
                background: 'linear-gradient(135deg, var(--accent), var(--accent-soft))',
                color: '#061712',
              }}
            >
              {players.length < 2 ? '🚀 Начать (соло)' : '🚀 Начать игру'}
            </button>
          )}
          {!isHost && (
            <div className="flex-1 py-4 rounded-xl font-bold text-lg text-center"
              style={{ background: 'rgba(255,255,255,0.05)', border: '1px solid var(--line)', color: 'var(--muted)' }}>
              ⏳ Ожидание хоста...
            </div>
          )}
        </div>

        <button onClick={() => router.push('/')}
          className="w-full py-3 text-[var(--muted)] text-sm hover:text-[var(--foreground)] transition-colors">
          ← Выйти из лобби
        </button>
      </div>
    </div>
  );
}
