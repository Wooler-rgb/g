import { prisma } from '@/lib/prisma';
import type { NextRequest } from 'next/server';

// POST /api/rooms/[code]/ready  — toggle ready state for a player
// Body: { username: string, isReady: boolean }
export async function POST(
  request: NextRequest,
  { params }: { params: Promise<{ code: string }> },
) {
  const { code } = await params;
  let body: { username?: unknown; isReady?: unknown };
  try {
    body = await request.json();
  } catch {
    return Response.json({ error: 'Невалидный JSON' }, { status: 400 });
  }

  const username = String(body.username ?? '').trim();
  const isReady = Boolean(body.isReady);
  const clearAll = username === '__clear__';

  if (!username) {
    return Response.json({ error: 'username обязателен' }, { status: 400 });
  }

  try {
    const room = await prisma.room.findUnique({ where: { code } });
    if (!room) return Response.json({ error: 'Комната не найдена' }, { status: 404 });

    let readySet: string[] = [];
    try { readySet = JSON.parse(room.readyJson); } catch { readySet = []; }

    if (clearAll) {
      readySet = [];
    } else if (isReady) {
      if (!readySet.includes(username)) readySet.push(username);
    } else {
      readySet = readySet.filter((u) => u !== username);
    }

    const updated = await prisma.room.update({
      where: { code },
      data: { readyJson: JSON.stringify(readySet) },
    });

    return Response.json({ readyJson: updated.readyJson });
  } catch (e) {
    console.error(`[POST /api/rooms/${code}/ready]`, e);
    return Response.json({ error: 'Ошибка сервера' }, { status: 500 });
  }
}
