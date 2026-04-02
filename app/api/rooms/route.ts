import { prisma } from '@/lib/prisma';
import type { NextRequest } from 'next/server';

function randomCode(len = 6): string {
  const chars = 'ABCDEFGHJKLMNPQRSTUVWXYZ23456789';
  let out = '';
  for (let i = 0; i < len; i++) {
    out += chars[Math.floor(Math.random() * chars.length)];
  }
  return out;
}

// GET /api/rooms?code=ABC123
export async function GET(request: NextRequest) {
  const code = request.nextUrl.searchParams.get('code');
  if (!code) {
    return Response.json({ error: 'Параметр code обязателен' }, { status: 400 });
  }

  try {
    const room = await prisma.room.findUnique({
      where: { code },
      include: {
        scenario: true,
        stonkUsers: { include: { user: true } },
        leaderboard: { include: { user: true }, orderBy: { netWorth: 'desc' } },
      },
    });
    if (!room) {
      return Response.json({ error: 'Комната не найдена' }, { status: 404 });
    }
    return Response.json({
      id: room.id,
      code: room.code,
      status: room.status,
      scenarioId: room.scenarioId,
      createdAt: room.createdAt,
      players: room.stonkUsers.map((su) => ({
        id: su.id,
        username: su.user.username,
        budget: su.budget,
        finalNetWorth: su.finalNetWorth,
      })),
    });
  } catch (e) {
    console.error('[GET /api/rooms]', e);
    return Response.json({ error: 'Ошибка сервера' }, { status: 500 });
  }
}

// POST /api/rooms  — создать комнату
// Body: { scenarioId: string, username: string }
export async function POST(request: NextRequest) {
  let body: { scenarioId?: unknown; username?: unknown };
  try {
    body = await request.json();
  } catch {
    return Response.json({ error: 'Невалидный JSON' }, { status: 400 });
  }

  const scenarioId = String(body.scenarioId ?? '').trim();
  const username   = String(body.username ?? '').trim();

  if (!scenarioId || !username) {
    return Response.json({ error: 'scenarioId и username обязательны' }, { status: 400 });
  }

  try {
    const scenario = await prisma.scenario.findUnique({ where: { id: scenarioId } });
    if (!scenario) {
      return Response.json({ error: 'Сценарий не найден' }, { status: 404 });
    }

    const user = await prisma.user.upsert({
      where: { username },
      update: {},
      create: { username },
    });

    // Генерируем уникальный код
    let code = randomCode();
    let attempts = 0;
    while (await prisma.room.findUnique({ where: { code } })) {
      code = randomCode();
      if (++attempts > 20) {
        return Response.json({ error: 'Не удалось создать комнату' }, { status: 500 });
      }
    }

    const room = await prisma.room.create({
      data: {
        code,
        scenarioId,
        hostUsername: username,
        stonkUsers: {
          create: { userId: user.id, budget: 1_000_000 },
        },
      },
    });

    return Response.json(
      { id: room.id, code: room.code, scenarioId: room.scenarioId, status: room.status },
      { status: 201 },
    );
  } catch (e) {
    console.error('[POST /api/rooms]', e);
    return Response.json({ error: 'Ошибка сервера' }, { status: 500 });
  }
}
