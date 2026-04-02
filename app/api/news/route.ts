import { prisma } from '@/lib/prisma';
import type { NextRequest } from 'next/server';

const PAGE_SIZE = 20;

// GET /api/news?year=2024&month=3&page=1
// GET /api/news?search=нефть&page=1
export async function GET(request: NextRequest) {
  const { searchParams } = request.nextUrl;
  const search = searchParams.get('search')?.trim();
  const page   = Math.max(1, Number(searchParams.get('page') ?? '1'));
  const skip   = (page - 1) * PAGE_SIZE;

  try {
    // ── SEARCH MODE ──────────────────────────────────────────────────────────
    if (search) {
      const year  = Number(searchParams.get('year'));
      const month = Number(searchParams.get('month'));
      const yearMonth = year && month ? `${year}-${String(month).padStart(2, '0')}` : undefined;

      const where = {
        title: { contains: search, mode: 'insensitive' as const },
        ...(yearMonth ? { yearMonth } : {}),
      };
      const [total, items] = await Promise.all([
        prisma.news.count({ where }),
        prisma.news.findMany({
          where,
          orderBy: [{ rating: 'desc' }, { newsDate: 'desc' }],
          skip,
          take: PAGE_SIZE,
          select: { id: true, url: true, title: true, rating: true, commentsCount: true, newsDate: true, yearMonth: true },
        }),
      ]);
      return Response.json({ news: items, total, page, pageSize: PAGE_SIZE, hasMore: skip + PAGE_SIZE < total });
    }

    // ── STEP MODE ────────────────────────────────────────────────────────────
    const year  = Number(searchParams.get('year'));
    const month = Number(searchParams.get('month'));

    if (!year || !month) {
      return Response.json({ error: 'year and month required' }, { status: 400 });
    }

    const yearMonth = `${year}-${String(month).padStart(2, '0')}`;
    const where = { yearMonth };

    const [total, items] = await Promise.all([
      prisma.news.count({ where }),
      prisma.news.findMany({
        where,
        orderBy: [{ rating: 'desc' }, { newsDate: 'desc' }],
        skip,
        take: PAGE_SIZE,
        select: { id: true, url: true, title: true, rating: true, commentsCount: true, newsDate: true, yearMonth: true },
      }),
    ]);

    return Response.json({ news: items, total, page, pageSize: PAGE_SIZE, hasMore: skip + PAGE_SIZE < total });
  } catch (e) {
    console.error('[GET /api/news]', e);
    return Response.json({ error: 'Ошибка сервера' }, { status: 500 });
  }
}
