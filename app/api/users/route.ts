import { prisma } from '@/lib/prisma';
import type { NextRequest } from 'next/server';

// GET /api/users?username=Mark  — найти пользователя
export async function GET(request: NextRequest) {
  const username = request.nextUrl.searchParams.get('username');
  if (!username) {
    return Response.json({ error: 'Параметр username обязателен' }, { status: 400 });
  }

  try {
    const user = await prisma.user.findUnique({ where: { username } });
    if (!user) {
      return Response.json({ error: 'Пользователь не найден' }, { status: 404 });
    }
    return Response.json({ id: user.id, username: user.username, createdAt: user.createdAt });
  } catch (e) {
    console.error('[GET /api/users]', e);
    return Response.json({ error: 'Ошибка сервера' }, { status: 500 });
  }
}

// POST /api/users  — создать или вернуть существующего пользователя
// Body: { username: string }
export async function POST(request: NextRequest) {
  let body: { username?: unknown };
  try {
    body = await request.json();
  } catch {
    return Response.json({ error: 'Невалидный JSON' }, { status: 400 });
  }

  const username = String(body.username ?? '').trim();
  if (!username || username.length < 2 || username.length > 32) {
    return Response.json(
      { error: 'username должен быть от 2 до 32 символов' },
      { status: 400 },
    );
  }

  try {
    const user = await prisma.user.upsert({
      where: { username },
      update: {},
      create: { username },
    });
    return Response.json(
      { id: user.id, username: user.username, createdAt: user.createdAt },
      { status: 201 },
    );
  } catch (e) {
    console.error('[POST /api/users]', e);
    return Response.json({ error: 'Ошибка сервера' }, { status: 500 });
  }
}
