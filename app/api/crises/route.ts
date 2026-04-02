import { prisma } from '@/lib/prisma';
import { buildCrisisTimeline } from '@/lib/seed-data';

export async function GET() {
  try {
    const scenarios = await prisma.scenario.findMany({
      include: {
        steps: { orderBy: { stepIndex: 'asc' } },
      },
    });

    const result = scenarios.map((sc) => {
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
      return buildCrisisTimeline(base);
    });

    return Response.json(result);
  } catch (e) {
    console.error('[GET /api/crises]', e);
    return Response.json({ error: 'Ошибка сервера' }, { status: 500 });
  }
}
