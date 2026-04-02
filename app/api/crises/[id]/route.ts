import { prisma } from '@/lib/prisma';
import { buildCrisisTimeline } from '@/lib/seed-data';
import type { NextRequest } from 'next/server';

export async function GET(
  _request: NextRequest,
  { params }: { params: Promise<{ id: string }> },
) {
  const { id } = await params;

  try {
    const sc = await prisma.scenario.findUnique({
      where: { id },
      include: {
        steps: { orderBy: { stepIndex: 'asc' } },
      },
    });

    if (!sc) {
      return Response.json({ error: 'Кризис не найден' }, { status: 404 });
    }

    const base = {
      id: sc.id,
      name: sc.name,
      description: sc.description,
      emoji: sc.emoji,
      color: sc.color,
      parserKey: sc.parserKey,
      periodLabel: sc.periodLabel,
      years: sc.steps.map((step) => ({
        year: step.year,
        month: step.month,
        label: step.label,
        eventName: step.eventName ?? undefined,
        eventDescription: step.eventDescription ?? undefined,
        eventColor: step.eventColor ?? undefined,
        news: [] as { title: string; body: string; impact: 'positive' | 'negative' | 'neutral'; sector?: string }[],
      })),
    };
    // Extend to April 2026 if DB was seeded before the timeline extension (idempotent)
    return Response.json(buildCrisisTimeline(base));
  } catch (e) {
    console.error(`[GET /api/crises/${id}]`, e);
    return Response.json({ error: 'Ошибка сервера' }, { status: 500 });
  }
}
