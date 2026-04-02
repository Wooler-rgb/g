import { prisma } from '@/lib/prisma';
import type { NextRequest } from 'next/server';

// POST /api/game  — сохранить/обновить состояние игрока
// Body: { username, roomCode?, budget, portfolioJson, finalNetWorth? }
export async function POST(request: NextRequest) {
  let body: {
    username?: unknown;
    roomCode?: unknown;
    budget?: unknown;
    portfolioJson?: unknown;
    finalNetWorth?: unknown;
  };
  try {
    body = await request.json();
  } catch {
    return Response.json({ error: 'Невалидный JSON' }, { status: 400 });
  }

  const username      = String(body.username ?? '').trim();
  const roomCode      = body.roomCode ? String(body.roomCode) : null;
  const budget        = Number(body.budget ?? 0);
  const portfolioJson = body.portfolioJson
    ? (typeof body.portfolioJson === 'string'
        ? body.portfolioJson
        : JSON.stringify(body.portfolioJson))
    : '{}';
  const finalNetWorth = body.finalNetWorth != null ? Number(body.finalNetWorth) : null;

  if (!username || isNaN(budget)) {
    return Response.json({ error: 'username и budget обязательны' }, { status: 400 });
  }

  try {
    const user = await prisma.user.upsert({
      where: { username },
      update: {},
      create: { username },
    });

    let roomId: number | null = null;
    if (roomCode) {
      const room = await prisma.room.findUnique({ where: { code: roomCode } });
      roomId = room?.id ?? null;
    }

    // Найти существующую запись или создать новую
    const existing = await prisma.stonkUser.findFirst({
      where: { userId: user.id, roomId },
    });

    let record;
    if (existing) {
      record = await prisma.stonkUser.update({
        where: { id: existing.id },
        data: { budget, portfolioJson, finalNetWorth },
      });
    } else {
      record = await prisma.stonkUser.create({
        data: { userId: user.id, roomId, budget, portfolioJson, finalNetWorth },
      });
    }

    return Response.json({ id: record.id, budget: record.budget });
  } catch (e) {
    console.error('[POST /api/game]', e);
    return Response.json({ error: 'Ошибка сервера' }, { status: 500 });
  }
}
