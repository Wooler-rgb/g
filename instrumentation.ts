/**
 * Next.js instrumentation hook — runs once on server startup.
 * Automatically seeds the database with mock data if it is empty.
 */
export async function register() {
  if (process.env.NEXT_RUNTIME !== 'nodejs') return;

  try {
    const { prisma } = await import('@/lib/prisma');
    // Ensure realtime_price table exists (added after initial deploy — safe no-op if already present)
    await prisma.$executeRaw`
      CREATE TABLE IF NOT EXISTS realtime_price (
        id         SERIAL PRIMARY KEY,
        ticker     VARCHAR(10) NOT NULL UNIQUE,
        price      FLOAT       NOT NULL,
        updated_at TIMESTAMPTZ NOT NULL DEFAULT NOW()
      )
    `.catch(() => {});

    // Check that the DB has steps extended all the way to April 2026.
    // If not (fresh DB or old DB seeded before the timeline extension), run full seed.
    const hasExtended = await prisma.scenarioStep.findFirst({ where: { year: 2026, month: 4 } });
    if (hasExtended) return; // fully seeded

    console.log('[instrumentation] БД пустая — авто-сидирование...');

    const { STOCKS } = await import('@/lib/game-data');
    const { CRISES, buildCrisisTimeline } = await import('@/lib/seed-data');

    // Seed stocks
    for (const s of STOCKS) {
      await prisma.stonk.upsert({
        where: { ticker: s.ticker },
        update: {},
        create: { ticker: s.ticker, name: s.name, sector: s.sector, color: s.color },
      });
    }

    // Seed scenarios + steps + news (all 4 crises, fully expanded)
    for (const baseCrisis of CRISES) {
      const crisis = buildCrisisTimeline(baseCrisis);

      await prisma.scenario.upsert({
        where: { id: crisis.id },
        update: {},
        create: {
          id: crisis.id,
          name: crisis.name,
          description: crisis.description,
          emoji: crisis.emoji,
          color: crisis.color,
          parserKey: crisis.parserKey,
          periodLabel: crisis.periodLabel,
        },
      });

      for (let i = 0; i < crisis.years.length; i++) {
        const step = crisis.years[i];

        await prisma.scenarioStep.upsert({
          where: { scenarioId_stepIndex: { scenarioId: crisis.id, stepIndex: i } },
          update: {},
          create: {
            scenarioId: crisis.id,
            stepIndex: i,
            year: step.year,
            month: step.month,
            label: step.label,
            eventName: step.eventName ?? null,
            eventDescription: step.eventDescription ?? null,
            eventColor: step.eventColor ?? null,
          },
        });
      }
    }

    console.log('[instrumentation] Авто-сидирование завершено ✓');
  } catch (e) {
    console.warn('[instrumentation] Пропущено (БД недоступна):', (e as Error).message?.slice(0, 100));
  }
}
