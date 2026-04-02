#!/usr/bin/env python3
"""
news_parser.py — Комплексный парсер рыночных данных для СибИнвестиции
=======================================================================
Сохраняет данные в ту же PostgreSQL БД, что и Next.js бэкенд.

Источники (все БЕСПЛАТНЫЕ, без регистрации):
  1. MOEX ISS API   — цены, дивиденды, биржевые новости
  2. ЦБ РФ (cbr.ru) — история ключевой ставки + пресс-релизы
  3. Smart-lab.ru   — агрегированные рыночные новости с телом статьи

Зависимости:
  pip install requests beautifulsoup4 psycopg2-binary python-dotenv

Использование:
  python news_parser.py                      # всё за весь период игры
  python news_parser.py --year 2020 --month 3
  python news_parser.py --from 2014-09 --to 2015-02
  python news_parser.py --prices-only        # только цены и дивиденды
  python news_parser.py --news-only          # только новости
"""

import os
import re
import sys
import time
import gzip
import json
import logging
import argparse
from datetime import datetime, date
from typing import Optional
from urllib.parse import urlparse

import requests
import psycopg2
import psycopg2.extras
from bs4 import BeautifulSoup

# ── Env ───────────────────────────────────────────────────────────────
try:
    from dotenv import load_dotenv
    load_dotenv()
except ImportError:
    pass

logging.basicConfig(
    level=logging.INFO,
    format="%(asctime)s [%(levelname)s] %(message)s",
    datefmt="%H:%M:%S",
)
log = logging.getLogger("parser")

GAME_START = (2014, 9)
GAME_END   = (2026, 4)

TICKERS = [
    "SBER", "GAZP", "LKOH", "NVTK", "ROSN", "SNGS",
    "TATN", "GMKN", "CHMF", "NLMK", "ALRS", "PLZL",
    "MGNT", "MOEX", "VTBR", "AFLT", "MTSS", "IRAO",
]

# ── Классификатор тональности ─────────────────────────────────────────
_POS = [
    "рост", "восстановление", "прибыль", "рекорд", "дивиденд",
    "повысил", "снизил ставку", "открылся", "выплатит",
    "оптимизм", "сильный", "договорился", "вакцин",
]
_NEG = [
    "падение", "обвал", "кризис", "санкц", "убыток", "закрыт",
    "рухнул", "отменил дивиденд", "дефолт", "потерял",
    "повысил ставку", "повышение ставки", "антирекорд",
]
_RATE_KW   = ["ключевую ставку", "ставку до", "ставка составит", "ключевая ставка"]
_DIV_KW    = ["дивиденд", "дивидендов", "выплат"]
_SANCT_KW  = ["санкц", "swift", "заморозк"]
_EARN_KW   = ["прибыль", "выручка", "отчётн", "отчитался", "результаты"]


def classify(title: str, body: str = "") -> tuple[str, str]:
    """Вернуть (impact, category) для новости."""
    text = (title + " " + body).lower()

    category = "general"
    if any(k in text for k in _RATE_KW):
        category = "rate"
    elif any(k in text for k in _DIV_KW):
        category = "dividend"
    elif any(k in text for k in _SANCT_KW):
        category = "sanctions"
    elif any(k in text for k in _EARN_KW):
        category = "earnings"

    # Rate raises are negative for stocks
    if category == "rate" and re.search(r"повысил|повышение|поднял", text):
        return "negative", category
    if category == "rate" and re.search(r"снизил|снижение|опустил", text):
        return "positive", category

    pos = sum(1 for k in _POS if k in text)
    neg = sum(1 for k in _NEG if k in text)
    if pos > neg:
        return "positive", category
    if neg > pos:
        return "negative", category
    return "neutral", category


def mention_tickers(text: str) -> str:
    """Найти упомянутые тикеры в тексте."""
    found = [t for t in TICKERS if t in text.upper()]
    return ",".join(found) if found else ""


# ── DB ────────────────────────────────────────────────────────────────
class DB:
    """Тонкая обёртка над psycopg2."""

    def __init__(self, dsn: str):
        self.conn = psycopg2.connect(dsn)
        self.conn.autocommit = False
        self._ensure_tables()

    def _ensure_tables(self):
        """Создать таблицы если их нет (не затрагивает Prisma-таблицы)."""
        with self.conn.cursor() as cur:
            cur.execute("""
                CREATE TABLE IF NOT EXISTS market_news (
                    id          SERIAL PRIMARY KEY,
                    source      VARCHAR(50) NOT NULL,
                    title       TEXT        NOT NULL,
                    body        TEXT,
                    url         TEXT        UNIQUE,
                    published_at TIMESTAMP  NOT NULL,
                    year        INT         NOT NULL,
                    month       INT         NOT NULL,
                    tickers     TEXT,
                    impact      VARCHAR(20) DEFAULT 'neutral',
                    category    VARCHAR(50) DEFAULT 'general',
                    created_at  TIMESTAMP   DEFAULT NOW()
                );
                CREATE INDEX IF NOT EXISTS market_news_ym
                    ON market_news(year, month);

                CREATE TABLE IF NOT EXISTS dividend (
                    id           SERIAL PRIMARY KEY,
                    ticker       VARCHAR(10) NOT NULL,
                    per_share    FLOAT       NOT NULL,
                    payment_date DATE        NOT NULL,
                    year         INT         NOT NULL,
                    month        INT         NOT NULL,
                    currency     VARCHAR(5)  DEFAULT 'RUB',
                    source       VARCHAR(30) DEFAULT 'moex',
                    UNIQUE(ticker, payment_date)
                );
                CREATE INDEX IF NOT EXISTS dividend_ticker_ym
                    ON dividend(ticker, year, month);
            """)
        self.conn.commit()

    def save_news(
        self, source: str, title: str, body: Optional[str], url: Optional[str],
        published_at: datetime, tickers: str, impact: str, category: str,
    ) -> bool:
        """Вставить новость. False если уже существует."""
        with self.conn.cursor() as cur:
            cur.execute("""
                INSERT INTO market_news
                    (source, title, body, url, published_at, year, month,
                     tickers, impact, category)
                VALUES (%s,%s,%s,%s,%s,%s,%s,%s,%s,%s)
                ON CONFLICT (url) DO NOTHING
                RETURNING id
            """, (
                source, title[:500], (body or "")[:2000],
                url, published_at,
                published_at.year, published_at.month,
                tickers, impact, category,
            ))
            row = cur.fetchone()
        self.conn.commit()
        return row is not None

    def save_price(self, stonk_id: int, year: int, month: int, price: float):
        with self.conn.cursor() as cur:
            cur.execute("""
                INSERT INTO "Price" ("stonkId", year, month, price)
                VALUES (%s, %s, %s, %s)
                ON CONFLICT ("stonkId", year, month) DO UPDATE SET price = EXCLUDED.price
            """, (stonk_id, year, month, price))
        self.conn.commit()

    def save_dividend(self, ticker: str, per_share: float, payment_date: date):
        with self.conn.cursor() as cur:
            cur.execute("""
                INSERT INTO dividend (ticker, per_share, payment_date, year, month)
                VALUES (%s, %s, %s, %s, %s)
                ON CONFLICT (ticker, payment_date) DO NOTHING
            """, (ticker, per_share, payment_date, payment_date.year, payment_date.month))
        self.conn.commit()

    def get_stonk_id(self, ticker: str) -> Optional[int]:
        with self.conn.cursor() as cur:
            cur.execute('SELECT id FROM "Stonk" WHERE ticker = %s', (ticker,))
            row = cur.fetchone()
        return row[0] if row else None

    def news_exists(self, url: str) -> bool:
        with self.conn.cursor() as cur:
            cur.execute("SELECT 1 FROM market_news WHERE url = %s LIMIT 1", (url,))
            return cur.fetchone() is not None

    def close(self):
        self.conn.close()


# ── HTTP helper ───────────────────────────────────────────────────────
SESSION = requests.Session()
SESSION.headers["User-Agent"] = "SibInvest-Parser/2.0 (educational project)"

_MAX_429_WAIT = 60   # максимальная пауза при rate-limit, сек
_MAX_RETRIES  = 3


def get(url: str, params: dict = None, retries: int = _MAX_RETRIES,
        timeout: int = 12, verify: bool = True) -> Optional[requests.Response]:
    """HTTP GET с повторными попытками, обработкой 429 и таймаутом."""
    short = url[:80]
    for attempt in range(retries):
        try:
            r = SESSION.get(url, params=params,
                            timeout=(5, timeout),  # (connect, read) timeout
                            verify=verify)
            if r.status_code == 429:
                wait = min(_MAX_429_WAIT, 15 * (attempt + 1))
                log.warning("⚠️  429 Rate-limited [%s], жду %ds (попытка %d/%d)...",
                            short, wait, attempt + 1, retries)
                time.sleep(wait)
                continue
            if r.status_code >= 500:
                log.warning("⚠️  HTTP %d [%s] (попытка %d/%d)",
                            r.status_code, short, attempt + 1, retries)
                time.sleep(3 * (attempt + 1))
                continue
            r.raise_for_status()
            return r
        except requests.exceptions.Timeout:
            log.warning("⏱  Таймаут [%s] (попытка %d/%d)", short, attempt + 1, retries)
            time.sleep(2 ** attempt)
        except requests.exceptions.ConnectionError as e:
            log.warning("🔌 Ошибка соединения [%s]: %s (попытка %d/%d)",
                        short, e, attempt + 1, retries)
            time.sleep(3 * (attempt + 1))
        except requests.RequestException as e:
            log.warning("❌ Запрос [%s]: %s", short, e)
            if attempt < retries - 1:
                time.sleep(2 ** attempt)
    log.error("Не удалось получить %s после %d попыток", short, retries)
    return None


# ── MOEX ISS ─────────────────────────────────────────────────────────
BASE_ISS = "https://iss.moex.com/iss"


def iss_json(path: str, params: dict = None) -> Optional[dict]:
    r = get(f"{BASE_ISS}{path}", params=params)
    if not r:
        return None
    try:
        return r.json()
    except Exception as e:
        log.warning("❌ Не удалось разобрать JSON от ISS (%s): %s", path, e)
        return None


def _iss_df(data: dict, block: str) -> list[dict]:
    """Преобразовать ISS-ответ (columns+data) в список словарей."""
    if not data or block not in data:
        return []
    cols = data[block]["columns"]
    rows = data[block]["data"]
    return [dict(zip(cols, row)) for row in rows]


def fetch_moex_prices(db: DB, year_from: int, month_from: int,
                      year_to: int, month_to: int):
    """Загрузить месячные цены для всех тикеров и сохранить в БД."""
    log.info("📈 Загрузка цен MOEX (%d/%02d — %d/%02d)...",
             year_from, month_from, year_to, month_to)

    date_from = f"{year_from}-{month_from:02d}-01"
    date_to   = f"{year_to}-{month_to:02d}-28"

    for i, ticker in enumerate(TICKERS, 1):
        log.info("  [%d/%d] %s...", i, len(TICKERS), ticker)
        stonk_id = db.get_stonk_id(ticker)
        if stonk_id is None:
            log.warning("  %s не найден в БД — пропуск", ticker)
            continue

        start = 0
        saved = 0
        consecutive_failures = 0

        while True:
            data = iss_json(
                f"/history/engines/stock/markets/shares/securities/{ticker}.json",
                {
                    "from": date_from,
                    "till": date_to,
                    "interval": 31,
                    "start": start,
                    "limit": 100,
                },
            )
            if not data:
                consecutive_failures += 1
                if consecutive_failures >= 3:
                    log.warning("  %s: 3 неудачи подряд, пропускаем", ticker)
                    break
                time.sleep(5)
                continue

            consecutive_failures = 0
            rows = _iss_df(data, "history")
            if not rows:
                break

            for row in rows:
                try:
                    dt    = datetime.strptime(row["TRADEDATE"], "%Y-%m-%d")
                    price = row.get("WAPRICE") or row.get("CLOSE") or row.get("OPEN")
                    if price:
                        db.save_price(stonk_id, dt.year, dt.month, float(price))
                        saved += 1
                except Exception:
                    pass

            idx = _iss_df(data, "history.cursor")
            if not idx:
                break
            total = idx[0].get("TOTAL", 0)
            start += len(rows)
            if start >= total:
                break
            time.sleep(0.2)

        log.info("  %s → %d записей цен", ticker, saved)
        time.sleep(0.3)


def fetch_moex_dividends(db: DB):
    """Загрузить всю историю дивидендов и сохранить в БД."""
    log.info("💰 Загрузка дивидендов MOEX...")
    total_saved = 0

    for ticker in TICKERS:
        data = iss_json(f"/securities/{ticker}/dividends.json")
        if not data:
            continue

        rows = _iss_df(data, "dividends")
        saved = 0
        for row in rows:
            try:
                raw_date = row.get("registryclosedate") or row.get("paymentdate") or ""
                if not raw_date or raw_date == "0000-00-00":
                    continue
                pd_ = datetime.strptime(raw_date, "%Y-%m-%d").date()
                per_share = float(row.get("value") or 0)
                if per_share <= 0:
                    continue
                db.save_dividend(ticker, per_share, pd_)
                saved += 1
            except Exception:
                pass

        if saved:
            log.info("  %s → %d дивидендных выплат", ticker, saved)
            total_saved += saved
        time.sleep(0.2)

    log.info("  Итого дивидендов: %d", total_saved)


def fetch_moex_sitenews(db: DB, year: int, month: int, max_news: int = 0) -> int:
    """Загрузить новости биржи за указанный месяц.
    max_news=0 означает без лимита. Возвращает количество сохранённых новостей."""
    dt_from = datetime(year, month, 1)
    if month == 12:
        dt_to = datetime(year + 1, 1, 1)
    else:
        dt_to = datetime(year, month + 1, 1)

    log.info("📰 MOEX sitenews %d/%02d...", year, month)
    saved = 0
    start = 0

    while True:
        data = iss_json("/sitenews.json", {"start": start, "limit": 50})
        if not data:
            break

        rows = _iss_df(data, "sitenews")
        if not rows:
            break

        oldest_in_batch = None
        for row in rows:
            try:
                pub_str = row.get("published_at") or ""
                if not pub_str:
                    continue
                pub = datetime.strptime(pub_str[:19], "%Y-%m-%d %H:%M:%S")
                oldest_in_batch = pub

                if pub < dt_from:
                    return saved  # Прошли нужный период — стоп

                if pub >= dt_to:
                    continue  # Ещё не дошли до нашего месяца

                title = (row.get("title") or "").strip()
                if not title:
                    continue

                # Пытаемся получить тело статьи
                news_id = row.get("id")
                body = ""
                url = f"https://www.moex.com/n{news_id}" if news_id else None

                if url and not db.news_exists(url):
                    detail = get(url, timeout=10)
                    if detail:
                        soup = BeautifulSoup(detail.text, "html.parser")
                        content = (
                            soup.find("div", class_="news-item__text")
                            or soup.find("div", class_="article__text")
                            or soup.find("article")
                        )
                        if content:
                            body = content.get_text(" ", strip=True)[:1500]
                    time.sleep(0.15)

                impact, category = classify(title, body)
                tickers = mention_tickers(title + " " + body)

                if db.save_news("moex_sitenews", title, body or title, url,
                                pub, tickers, impact, category):
                    saved += 1
                    if max_news > 0 and saved >= max_news:
                        log.info("  MOEX sitenews → %d новостей (лимит)", saved)
                        return saved

            except Exception as e:
                log.debug("Ошибка строки sitenews: %s", e)

        if oldest_in_batch and oldest_in_batch < dt_from:
            break

        cursor = _iss_df(data, "sitenews.cursor")
        if not cursor:
            break
        total = cursor[0].get("TOTAL", 0)
        start += len(rows)
        if start >= total:
            break
        time.sleep(0.3)

    log.info("  MOEX sitenews → %d новостей", saved)
    return saved


# ── ЦБ РФ ─────────────────────────────────────────────────────────────
CBR_RATES_URL = "https://cbr.ru/hd_base/KeyRate/"


def fetch_cbr_key_rates(db: DB, year_from: int, month_from: int,
                        year_to: int, month_to: int):
    """Загрузить историю ключевых ставок ЦБ РФ и сохранить как новости."""
    log.info("🏦 Загрузка решений ЦБ РФ по ключевой ставке...")

    date_from = f"{year_from:04d}-{month_from:02d}-01"
    # last day in range
    date_to   = f"{year_to:04d}-{month_to:02d}-28"

    params = {"UniDbQuery.Posted": "True",
              "UniDbQuery.From": date_from.replace("-", "."),
              "UniDbQuery.To":   date_to.replace("-", ".")}

    r = get(CBR_RATES_URL, params=params, verify=False)
    if not r:
        log.warning("CBR: нет ответа")
        return

    soup = BeautifulSoup(r.text, "html.parser")
    # Table with key rates
    table = soup.find("table", class_="data")
    if not table:
        # Try generic table
        table = soup.find("table")
    if not table:
        log.warning("CBR: таблица ставок не найдена")
        return

    saved = 0
    rows = table.find_all("tr")[1:]  # skip header
    prev_rate: Optional[float] = None

    for tr in rows:
        cols = tr.find_all("td")
        if len(cols) < 2:
            continue
        try:
            date_str = cols[0].get_text(strip=True)
            rate_str = cols[1].get_text(strip=True).replace(",", ".").replace("%", "")
            dt = datetime.strptime(date_str, "%d.%m.%Y")
            rate = float(rate_str)

            if not (year_from <= dt.year <= year_to):
                continue

            # Generate news title from rate change
            if prev_rate is None:
                title = f"ЦБ РФ установил ключевую ставку {rate:.2f}%"
                impact = "neutral"
            elif rate > prev_rate:
                title = f"ЦБ повысил ключевую ставку: {prev_rate:.2f}% → {rate:.2f}%"
                impact = "negative"
            elif rate < prev_rate:
                title = f"ЦБ снизил ключевую ставку: {prev_rate:.2f}% → {rate:.2f}%"
                impact = "positive"
            else:
                prev_rate = rate
                continue  # no change — skip

            body = (
                f"Банк России принял решение {'повысить' if rate > (prev_rate or rate) else 'снизить'} "
                f"ключевую ставку до {rate:.2f}% годовых. "
                f"Решение вступает в силу с {dt.strftime('%d.%m.%Y')}."
            )

            url = f"cbr://keyrate/{dt.strftime('%Y-%m-%d')}"
            db.save_news("cbr", title, body, url, dt, "", impact, "rate")
            saved += 1
            prev_rate = rate

        except Exception as e:
            log.debug("CBR row error: %s", e)

    log.info("  ЦБ РФ → %d решений по ставке", saved)


# ── Smart-lab.ru ──────────────────────────────────────────────────────
SMARTLAB_NEWS_URL = "https://smart-lab.ru/news/"


def _parse_smartlab_page(html: str, dt_from: datetime,
                         dt_to: datetime) -> tuple[list[dict], bool]:
    """
    Парсит одну страницу новостей Smart-lab (текущая структура: h3.feed.title).
    Возвращает (items, should_stop).
    """
    soup = BeautifulSoup(html, "html.parser")
    items = []

    # Текущая структура: <h3 class="feed title bluid_XXXXX">
    # Внутри: <div class="inside"><span class="user">HH:MM</span><a href="...">Title</a></div>
    feed_items = soup.find_all("h3", class_=re.compile(r"\bfeed\b"))

    for art in feed_items:
        try:
            inside = art.find("div", class_="inside")
            if not inside:
                continue

            link_tag = inside.find("a")
            if not link_tag:
                continue

            title = (link_tag.get("title") or link_tag.get_text(" ", strip=True)).strip()
            if not title:
                continue

            url = link_tag.get("href", "")
            if url and not url.startswith("http"):
                url = "https://smart-lab.ru" + url

            # Время — только HH:MM, дату берём из запрошенного периода (dt_from)
            time_span = inside.find("span", class_="user")
            time_str  = time_span.get_text(strip=True) if time_span else ""
            pub = dt_from  # по умолчанию — начало запрошенного месяца
            if re.match(r"^\d{1,2}:\d{2}", time_str):
                h_val, m_val = map(int, time_str[:5].split(":"))
                pub = dt_from.replace(hour=h_val, minute=m_val)

            body = ""  # Smart-lab не показывает превью в списке новостей

            items.append({"title": title, "body": body, "url": url, "pub": pub})

        except Exception:
            pass

    return items, False  # smart-lab/news/ показывает только свежие новости, стоп не нужен


def fetch_smartlab_news(db: DB, year: int, month: int,
                        max_pages: int = 50, max_news: int = 0) -> int:
    """Загрузить новости Smart-lab за указанный месяц.
    max_news=0 означает без лимита. Возвращает количество сохранённых новостей."""
    dt_from = datetime(year, month, 1)
    dt_to   = datetime(year + 1, 1, 1) if month == 12 else datetime(year, month + 1, 1)

    log.info("📡 Smart-lab.ru %d/%02d (до %d стр.)...", year, month, max_pages)
    saved = 0

    for page in range(1, max_pages + 1):
        url = SMARTLAB_NEWS_URL if page == 1 else f"{SMARTLAB_NEWS_URL}page{page}/"
        r = get(url, timeout=20)
        if not r:
            break

        items, should_stop = _parse_smartlab_page(r.text, dt_from, dt_to)

        for item in items:
            impact, category = classify(item["title"], item["body"])
            tickers = mention_tickers(item["title"] + " " + item["body"])
            if db.save_news(
                "smartlab", item["title"], item["body"],
                item["url"], item["pub"], tickers, impact, category,
            ):
                saved += 1
                if max_news > 0 and saved >= max_news:
                    log.info("  Smart-lab → %d новостей (лимит)", saved)
                    return saved

        if should_stop:
            break

        time.sleep(0.5)

    log.info("  Smart-lab → %d новостей", saved)
    return saved


# ── Главный оркестратор ───────────────────────────────────────────────

def months_range(y_from: int, m_from: int, y_to: int, m_to: int):
    """Генератор (year, month) включительно."""
    y, m = y_from, m_from
    while (y, m) <= (y_to, m_to):
        yield y, m
        m += 1
        if m > 12:
            m = 1
            y += 1


def parse_dsn() -> str:
    """Получить DSN из DATABASE_URL."""
    raw = os.getenv("DATABASE_URL", "")
    if not raw:
        log.error("DATABASE_URL не задана в .env")
        sys.exit(1)

    # Next.js Prisma format: postgresql://user:pass@host:port/db
    # Strip possible ?schema= suffix
    raw = raw.split("?")[0]
    return raw


def main():
    ap = argparse.ArgumentParser(description="Парсер данных для СибИнвестиции")
    ap.add_argument("--year",  type=int, help="Год (вместе с --month)")
    ap.add_argument("--month", type=int, help="Месяц (вместе с --year)")
    ap.add_argument("--from",  dest="date_from", help="Начало диапазона YYYY-MM")
    ap.add_argument("--to",    dest="date_to",   help="Конец диапазона  YYYY-MM")
    ap.add_argument("--prices-only", action="store_true", help="Только цены и дивиденды")
    ap.add_argument("--news-only",   action="store_true", help="Только новости")
    ap.add_argument("--skip-smartlab", action="store_true",
                    help="Не парсить Smart-lab")
    ap.add_argument("--max-news", type=int, default=20,
                    help="Максимум новостей из внешних источников (0 = без лимита, по умолчанию 20)")
    ap.add_argument("--smartlab-pages", type=int, default=1,
                    help="Страниц smart-lab на месяц (по умолчанию 1)")
    args = ap.parse_args()

    # Определить период
    if args.year and args.month:
        y_from, m_from = args.year, args.month
        y_to,   m_to   = args.year, args.month
    elif args.date_from:
        parts = args.date_from.split("-")
        y_from, m_from = int(parts[0]), int(parts[1])
        if args.date_to:
            parts2 = args.date_to.split("-")
            y_to, m_to = int(parts2[0]), int(parts2[1])
        else:
            y_to, m_to = y_from, m_from
    else:
        y_from, m_from = GAME_START
        y_to,   m_to   = GAME_END

    log.info("=== СибИнвестиции Парсер ===")
    log.info("Период: %d/%02d — %d/%02d", y_from, m_from, y_to, m_to)
    log.info("Тикеры: %s", ", ".join(TICKERS))

    db = DB(parse_dsn())
    log.info("✅ Подключение к БД установлено")

    # 1. Рыночные данные (цены + дивиденды)
    if not args.news_only:
        fetch_moex_prices(db, y_from, m_from, y_to, m_to)
        fetch_moex_dividends(db)

    # 2. Новости: ЦБ РФ (всегда быстро) + Smart-lab (опционально)
    # MOEX sitenews не используем — слишком медленно (по запросу на каждую статью)
    if not args.prices_only:
        max_news = args.max_news          # 0 = без лимита
        news_budget = max_news if max_news > 0 else 10 ** 9
        news_total = 0

        # ЦБ — один запрос на весь период, быстро
        fetch_cbr_key_rates(db, y_from, m_from, y_to, m_to)

        # Smart-lab — только свежие данные (сайт показывает только сегодняшние новости,
        # для исторических периодов данных нет). Берём один раз для текущего месяца.
        if not args.skip_smartlab and news_budget > 0:
            import datetime as _dt
            now = _dt.date.today()
            log.info("── Smart-lab (текущий месяц: %d/%02d) ──", now.year, now.month)
            got = fetch_smartlab_news(db, now.year, now.month,
                                      max_pages=args.smartlab_pages,
                                      max_news=news_budget)
            news_budget -= got
            news_total += got

        log.info("Всего новостей сохранено: %d", news_total)

    db.close()
    log.info("✅ Парсинг завершён!")


if __name__ == "__main__":
    main()
