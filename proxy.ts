import { NextResponse } from 'next/server';
import type { NextRequest } from 'next/server';

const ALLOWED_ORIGINS = [
  'http://localhost:3000',
  'http://localhost:3001',
  'https://sibinvest.vercel.app',
];

export function proxy(request: NextRequest) {
  const origin = request.headers.get('origin') ?? '';
  const isAllowed =
    ALLOWED_ORIGINS.includes(origin) ||
    origin.startsWith('http://localhost:');

  const corsHeaders: Record<string, string> = {
    'Access-Control-Allow-Methods': 'GET, POST, PUT, PATCH, DELETE, OPTIONS',
    'Access-Control-Allow-Headers': 'Content-Type, Authorization',
    'Access-Control-Max-Age': '86400',
  };

  if (isAllowed) {
    corsHeaders['Access-Control-Allow-Origin'] = origin;
  }

  // Preflight
  if (request.method === 'OPTIONS') {
    return new NextResponse(null, { status: 204, headers: corsHeaders });
  }

  const response = NextResponse.next();
  for (const [k, v] of Object.entries(corsHeaders)) {
    response.headers.set(k, v);
  }
  return response;
}

export const config = {
  matcher: '/api/:path*',
};
