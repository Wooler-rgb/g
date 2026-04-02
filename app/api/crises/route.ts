import { prisma } from '@/lib/prisma';
import { buildCrisisTimeline } from '@/lib/seed-data';

export async function GET() {
  try {
    const scenarios = await prisma.scenario.findMany({
      include: {
        steps: { orderBy: { stepIndex: 'asc' } },
        news: true,
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
          news: sc.news
            .filter((n) => n.stepIndex === step.stepIndex)
            .map((n) => ({
              title: n.title,
              body: n.body,
              impact: n.impact as 'positive' | 'negative' | 'neutral',
              sector: n.sector ?? undefined,
            })),
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
