import type { Metadata } from 'next';
import { PT_Sans } from 'next/font/google';
import { Providers } from './providers';
import './globals.css';

const ptSans = PT_Sans({
  subsets: ['latin', 'cyrillic'],
  
  weight: ['400', '700'],
  variable: '--font-pt-sans',
  display: 'swap',
});

export const metadata: Metadata = {
  title: 'СибИнвестиции — Торговый симулятор',
  description: 'Симулятор трейдинга через российские финансовые кризисы. Торгуй акциями MOEX и стань лучшим инвестором.',
};

export default function RootLayout({ children }: Readonly<{ children: React.ReactNode }>) {
  return (
    <html lang="ru" className={`${ptSans.variable} h-full antialiased`}>
      <body className="min-h-full">
        <Providers>{children}</Providers>
      </body>
    </html>
  );
}
