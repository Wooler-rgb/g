import { prisma } from '@/lib/prisma';
import type { NextRequest } from 'next/server';

// GET /api/news?scenarioId=2014_ruble&year=2014&month=9
// GET /api/news?scenarioId=2014_ruble&search=нефть  — keyword search across all scenario news
export async function GET(request: NextRequest) {
  const { searchParams } = request.nextUrl;
  const scenarioId = searchParams.get('scenarioId');
  const search = searchParams.get('search')?.trim();

  if (!scenarioId) {
    return Response.json({ error: 'scenarioId required' }, { status: 400 });
  }

  try {
    // ── SEARCH MODE ──────────────────────────────────────────────────────────
    if (search) {
      const scenarioNews = await prisma.news.findMany({
        where: {
          scenarioId,
          OR: [
            { title: { contains: search, mode: 'insensitive' } },
            { body:  { contains: search, mode: 'insensitive' } },
            { sector:{ contains: search, mode: 'insensitive' } },
          ],
        },
        orderBy: { id: 'asc' },
        take: 30,
        select: { title: true, body: true, impact: true, sector: true },
      });

      const marketNews = await prisma.marketNews.findMany({
        where: {
          OR: [
            { title:   { contains: search, mode: 'insensitive' } },
            { body:    { contains: search, mode: 'insensitive' } },
            { tickers: { contains: search, mode: 'insensitive' } },
          ],
        },
        orderBy: { publishedAt: 'desc' },
        take: 20,
        select: { title: true, body: true, impact: true, tickers: true, year: true, month: true },
      }).catch(() => []);

      const scenarioTitles = new Set(scenarioNews.map((n) => n.title.toLowerCase()));
      const results = [
        ...scenarioNews.map((n) => ({
          title: n.title, body: n.body, impact: n.impact,
          sector: n.sector ?? undefined,
        })),
        ...marketNews
          .filter((n) => !scenarioTitles.has(n.title.toLowerCase()))
          .map((n) => ({
            title: n.title, body: n.body ?? '', impact: n.impact ?? 'neutral',
            sector: n.tickers ?? undefined,
            year: n.year, month: n.month,
          })),
      ];

      return Response.json({ news: results, fromSearch: true });
    }

    // ── STEP MODE (current month news) ───────────────────────────────────────
    const year  = Number(searchParams.get('year'));
    const month = Number(searchParams.get('month'));

    if (!year || !month) {
      return Response.json({ error: 'year and month required when not searching' }, { status: 400 });
    }

    // 1. Scenario-specific news from DB (curated, always shown first)
    const step = await prisma.scenarioStep.findFirst({
      where: { scenarioId, year, month },
    });

    const scenarioNews = step
      ? await prisma.news.findMany({
          where: { scenarioId, stepIndex: step.stepIndex },
          orderBy: { id: 'asc' },
          select: { title: true, body: true, impact: true, sector: true },
        })
      : [];

    // 2. Scraped market news for this month (from Python parser)
    const marketNews = await prisma.marketNews.findMany({
      where: { year, month },
      orderBy: { publishedAt: 'desc' },
      take: 8,
      select: { title: true, body: true, impact: true, tickers: true },
    }).catch(() => []);

    // Merge: scenario news first, then market news (no duplicates by title)
    const scenarioTitles = new Set(scenarioNews.map((n) => n.title.toLowerCase()));
    const merged = [
      ...scenarioNews.map((n) => ({
        title: n.title, body: n.body, impact: n.impact, sector: n.sector ?? undefined,
      })),
      ...marketNews
        .filter((n) => !scenarioTitles.has(n.title.toLowerCase()))
        .map((n) => ({
          title: n.title, body: n.body ?? '', impact: n.impact ?? 'neutral',
          sector: n.tickers ?? undefined,
        })),
    ];

    return Response.json({ news: merged, fromDb: merged.length > 0 });
  } catch (e) {
    console.error('[GET /api/news]', e);
    return Response.json({ error: 'Ошибка сервера' }, { status: 500 });
  }
}
