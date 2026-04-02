import { prisma } from '@/lib/prisma';
import type { NextRequest } from 'next/server';

// GET /api/leaderboard?roomCode=XXX  — таблица комнаты
// GET /api/leaderboard               — глобальный топ-50
export async function GET(request: NextRequest) {
  const roomCode = request.nextUrl.searchParams.get('roomCode');

  try {
    if (roomCode) {
      const room = await prisma.room.findUnique({ where: { code: roomCode } });
      if (!room) {
        return Response.json({ error: 'Комната не найдена' }, { status: 404 });
      }

      const rows = await prisma.leaderboard.findMany({
        where: { roomId: room.id },
        include: { user: true },
        orderBy: { netWorth: 'desc' },
      });

      return Response.json(
        rows.map((r, i) => ({
          rank: i + 1,
          username: r.user.username,
          netWorth: r.netWorth,
          startBudget: r.startBudget,
          pnlPct: ((r.netWorth - r.startBudget) / r.startBudget) * 100,
          createdAt: r.createdAt,
        })),
      );
    }

    // Глобальный топ
    const rows = await prisma.leaderboard.findMany({
      orderBy: { netWorth: 'desc' },
      take: 50,
      include: { user: true, room: true },
    });

    return Response.json(
      rows.map((r, i) => ({
        rank: i + 1,
        username: r.user.username,
        netWorth: r.netWorth,
        startBudget: r.startBudget,
        pnlPct: ((r.netWorth - r.startBudget) / r.startBudget) * 100,
        roomCode: r.room?.code ?? null,
        createdAt: r.createdAt,
      })),
    );
  } catch (e) {
    console.error('[GET /api/leaderboard]', e);
    return Response.json({ error: 'Ошибка сервера' }, { status: 500 });
  }
}

// POST /api/leaderboard  — сохранить результат
// Body: { username, netWorth, startBudget?, roomCode? }
export async function POST(request: NextRequest) {
  let body: {
    username?: unknown;
    netWorth?: unknown;
    startBudget?: unknown;
    roomCode?: unknown;
  };
  try {
    body = await request.json();
  } catch {
    return Response.json({ error: 'Невалидный JSON' }, { status: 400 });
  }

  const username    = String(body.username ?? '').trim();
  const netWorth    = Number(body.netWorth);
  const startBudget = Number(body.startBudget ?? 1_000_000);
  const roomCode    = body.roomCode ? String(body.roomCode) : null;

  if (!username || isNaN(netWorth)) {
    return Response.json({ error: 'username и netWorth обязательны' }, { status: 400 });
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

    const entry = await prisma.leaderboard.create({
      data: { userId: user.id, roomId, netWorth, startBudget },
    });

    // Обновить ранг в рамках комнаты или глобально
    const rows = await prisma.leaderboard.findMany({
      where: roomId ? { roomId } : {},
      orderBy: { netWorth: 'desc' },
      select: { id: true },
    });
    const rank = rows.findIndex((r) => r.id === entry.id) + 1;
    await prisma.leaderboard.update({ where: { id: entry.id }, data: { rank } });

    return Response.json(
      { id: entry.id, username, netWorth, rank, createdAt: entry.createdAt },
      { status: 201 },
    );
  } catch (e) {
    console.error('[POST /api/leaderboard]', e);
    return Response.json({ error: 'Ошибка сервера' }, { status: 500 });
  }
}
