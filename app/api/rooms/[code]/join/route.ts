import { prisma } from '@/lib/prisma';
import type { NextRequest } from 'next/server';

// POST /api/rooms/[code]/join
// Body: { username: string }
export async function POST(
  request: NextRequest,
  { params }: { params: Promise<{ code: string }> },
) {
  const { code } = await params;

  let body: { username?: unknown };
  try {
    body = await request.json();
  } catch {
    return Response.json({ error: 'Невалидный JSON' }, { status: 400 });
  }

  const username = String(body.username ?? '').trim();
  if (!username) {
    return Response.json({ error: 'username обязателен' }, { status: 400 });
  }

  try {
    const room = await prisma.room.findUnique({
      where: { code },
      include: { stonkUsers: { include: { user: true } } },
    });

    if (!room) {
      return Response.json({ error: 'Комната не найдена' }, { status: 404 });
    }
    if (room.status === 'finished') {
      return Response.json({ error: 'Игра уже завершена' }, { status: 409 });
    }
    if (room.stonkUsers.length >= 8) {
      return Response.json({ error: 'Комната заполнена (макс. 8 игроков)' }, { status: 409 });
    }

    // Block if username is already taken by any player in this room
    const nameTaken = room.stonkUsers.some((su) => su.user.username === username);
    if (nameTaken) {
      return Response.json({ error: 'Этот никнейм уже занят в комнате, выбери другой' }, { status: 409 });
    }

    const user = await prisma.user.upsert({
      where: { username },
      update: {},
      create: { username },
    });

    // Не добавлять повторно
    const already = await prisma.stonkUser.findFirst({
      where: { userId: user.id, roomId: room.id },
    });

    if (!already) {
      await prisma.stonkUser.create({
        data: { userId: user.id, roomId: room.id, budget: 1_000_000 },
      });
    }

    return Response.json({
      code: room.code,
      scenarioId: room.scenarioId,
      userId: user.id,
      username: user.username,
    });
  } catch (e) {
    console.error(`[POST /api/rooms/${code}/join]`, e);
    return Response.json({ error: 'Ошибка сервера' }, { status: 500 });
  }
}
