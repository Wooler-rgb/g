import { prisma } from '@/lib/prisma';
import type { NextRequest } from 'next/server';

const PAGE_SIZE = 20;
const MAX_LIMIT = 50;

// GET /api/news?year=2024&month=3&page=1&limit=5
// GET /api/news?search=нефть&page=1
export async function GET(request: NextRequest) {
  const { searchParams } = request.nextUrl;
  const search = searchParams.get('search')?.trim();
  const page   = Math.max(1, Number(searchParams.get('page') ?? '1'));
  const limit  = Math.min(MAX_LIMIT, Math.max(1, Number(searchParams.get('limit') ?? PAGE_SIZE)));
  const skip   = (page - 1) * limit;

  const select = { url: true, title: true, rating: true, commentsCount: true, newsDate: true, yearMonth: true } as const;

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
        prisma.news.findMany({ where, orderBy: [{ rating: 'desc' }, { newsDate: 'desc' }], skip, take: limit, select }),
      ]);
      return Response.json({ news: items, total, page, pageSize: limit, hasMore: skip + limit < total });
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
      prisma.news.findMany({ where, orderBy: [{ rating: 'desc' }, { newsDate: 'desc' }], skip, take: limit, select }),
    ]);

    return Response.json({ news: items, total, page, pageSize: limit, hasMore: skip + limit < total });
  } catch (e) {
    console.error('[GET /api/news]', e);
    return Response.json({ error: 'Ошибка сервера' }, { status: 500 });
  }
}
