import { prisma } from '@/lib/prisma';
import type { NextRequest } from 'next/server';

export async function GET(
  _request: NextRequest,
  { params }: { params: Promise<{ code: string }> },
) {
  const { code } = await params;

  try {
    const room = await prisma.room.findUnique({
      where: { code },
      include: {
        scenario: true,
        stonkUsers: { include: { user: true } },
        leaderboard: {
          include: { user: true },
          orderBy: { netWorth: 'desc' },
        },
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
      hostUsername: room.hostUsername,
      currentStepIndex: room.currentStepIndex,
      readyJson: room.readyJson,
      createdAt: room.createdAt,
      scenario: {
        id: room.scenario.id,
        name: room.scenario.name,
        emoji: room.scenario.emoji,
        periodLabel: room.scenario.periodLabel,
      },
      players: room.stonkUsers.map((su) => ({
        id: su.id,
        username: su.user.username,
        budget: su.budget,
        portfolioJson: su.portfolioJson,
        finalNetWorth: su.finalNetWorth,
      })),
      leaderboard: room.leaderboard.map((lb, i) => ({
        rank: i + 1,
        username: lb.user.username,
        netWorth: lb.netWorth,
        startBudget: lb.startBudget,
      })),
    });
  } catch (e) {
    console.error(`[GET /api/rooms/${code}]`, e);
    return Response.json({ error: 'Ошибка сервера' }, { status: 500 });
  }
}

// PATCH /api/rooms/[code]  — обновить статус или шаг
// Body: { status?: 'active' | 'finished' } | { currentStepIndex: number }
export async function PATCH(
  request: NextRequest,
  { params }: { params: Promise<{ code: string }> },
) {
  const { code } = await params;
  let body: { status?: unknown; currentStepIndex?: unknown };
  try {
    body = await request.json();
  } catch {
    return Response.json({ error: 'Невалидный JSON' }, { status: 400 });
  }

  const updateData: { status?: string; currentStepIndex?: number } = {};

  if (body.status !== undefined) {
    const status = String(body.status);
    if (!['waiting', 'active', 'finished'].includes(status)) {
      return Response.json({ error: 'Неверный статус' }, { status: 400 });
    }
    updateData.status = status;
  }

  if (body.currentStepIndex !== undefined) {
    const idx = Number(body.currentStepIndex);
    if (!Number.isFinite(idx) || idx < 0) {
      return Response.json({ error: 'Неверный currentStepIndex' }, { status: 400 });
    }
    updateData.currentStepIndex = idx;
  }

  if (Object.keys(updateData).length === 0) {
    return Response.json({ error: 'Нет полей для обновления' }, { status: 400 });
  }

  try {
    const room = await prisma.room.update({ where: { code }, data: updateData });
    return Response.json({
      id: room.id, code: room.code, status: room.status,
      currentStepIndex: room.currentStepIndex,
    });
  } catch (e) {
    console.error(`[PATCH /api/rooms/${code}]`, e);
    return Response.json({ error: 'Комната не найдена' }, { status: 404 });
  }
}
