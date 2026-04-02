/**
 * Клиентская сессия — лёгкая "псевдо-авторизация" через cookie.
 * Хранит минимальный набор данных, нужный для распознавания активной игры
 * после обновления страницы или перехода между вкладками.
 * Полное состояние игры хранится в localStorage.
 */

const COOKIE_NAME = 'sibinvest_session';
const COOKIE_DAYS = 30;

export interface SessionData {
  username: string;
  mode: string;       // 'solo' | 'multi' | 'realtime'
  crisisId: string;   // '' для realtime
  roomCode: string;   // '' для solo/realtime
}

function serialize(data: SessionData): string {
  return btoa(encodeURIComponent(JSON.stringify(data)));
}

function deserialize(value: string): SessionData | null {
  try {
    return JSON.parse(decodeURIComponent(atob(value)));
  } catch {
    return null;
  }
}

/** Прочитать сессию из cookie (только client-side) */
export function getSession(): SessionData | null {
  if (typeof document === 'undefined') return null;
  const match = document.cookie
    .split('; ')
    .find((row) => row.startsWith(`${COOKIE_NAME}=`));
  if (!match) return null;
  return deserialize(match.slice(COOKIE_NAME.length + 1));
}

/** Записать сессию в cookie (30 дней) */
export function setSession(data: SessionData): void {
  if (typeof document === 'undefined') return;
  const expires = new Date(Date.now() + COOKIE_DAYS * 24 * 3600 * 1000).toUTCString();
  document.cookie = `${COOKIE_NAME}=${serialize(data)}; expires=${expires}; path=/; SameSite=Lax`;
}

/** Удалить сессию (при старте новой игры) */
export function clearSession(): void {
  if (typeof document === 'undefined') return;
  document.cookie = `${COOKIE_NAME}=; expires=Thu, 01 Jan 1970 00:00:00 UTC; path=/`;
}
