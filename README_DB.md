# База данных и архитектура данных — СибИнвестиции

ORM: **Prisma**  
СУБД: **PostgreSQL 16+**  
Миграции: `npx prisma db push` (schema-first, без migration files)  
Сид: `instrumentation.ts` — авто-сидирование при первом запуске (пустая БД)

---

## Источники данных

| Данные | Источник | Обновление |
|---|---|---|
| Цены акций (исторические) | БД → таблица `Price` | `moex_parser.py` |
| Дивиденды | БД → таблица `Dividend` | `moex_parser.py` |
| Сценарии / кризисы | БД → `Scenario` + `ScenarioStep` + `News` | `instrumentation.ts` при старте |
| Метаданные акций | БД → таблица `Stonk` | `instrumentation.ts` при старте |
| Ключевая ставка ЦБ | Хардкод → `lib/game-data.ts::KEY_RATES` | Вручную |
| Инфляция (ИПЦ Росстат) | Хардкод → `lib/game-data.ts::INFLATION_RATES` | Вручную |
| Цены в реальном времени | MOEX ISS API | Каждые 5 минут |
| Свечи (OHLCV) | MOEX ISS API | По запросу (кэш 60с–24ч) |
| Последние сделки | MOEX ISS API | Каждые 30 секунд |

---

## Схема БД (Prisma)

```prisma
// ─── Пользователи ───────────────────────────────────────────────
model User {
  id        Int      @id @default(autoincrement())
  username  String   @unique
  createdAt DateTime @default(now())

  stonkUsers  StonkUser[]
  leaderboard Leaderboard[]
}

// ─── Игровые комнаты ─────────────────────────────────────────────
model Room {
  id               Int      @id @default(autoincrement())
  code             String   @unique          // 6-символьный код: ABC123
  scenarioId       String                    // FK → Scenario.id
  status           String   @default("waiting")  // waiting | active | finished
  hostUsername     String   @default("")
  currentStepIndex Int      @default(0)      // шаг, до которого дошёл хост
  readyJson        String   @default("[]")  // JSON-массив готовых никнеймов
  createdAt        DateTime @default(now())

  scenario    Scenario    @relation(...)
  stonkUsers  StonkUser[]
  leaderboard Leaderboard[]
}

// ─── Состояние игрока в комнате ───────────────────────────────────
model StonkUser {
  id            Int     @id @default(autoincrement())
  userId        Int
  roomId        Int?
  budget        Float   @default(1000000)   // свободный кэш в ₽
  portfolioJson String  @default("{}")      // { SBER: {shares,avgBuyPrice}, ..., __bondsValue__: N }
  finalNetWorth Float?                      // NULL до конца игры

  user User  @relation(...)
  room Room? @relation(...)
}

// ─── Таблица лидеров ─────────────────────────────────────────────
model Leaderboard {
  id          Int      @id @default(autoincrement())
  userId      Int
  roomId      Int?
  netWorth    Float                         // итоговый капитал
  startBudget Float    @default(1000000)
  rank        Int?                          // рассчитывается при сохранении
  createdAt   DateTime @default(now())

  user User  @relation(...)
  room Room? @relation(...)
}

// ─── Сценарии (кризисы) ──────────────────────────────────────────
model Scenario {
  id          String @id   // 2014_ruble | 2020_covid | 2022_feb | 2023_rate
  name        String       // «Крах рубля 2014»
  description String
  emoji       String       // «📉»
  color       String       // hex: «#ffc266»
  parserKey   String       // совпадает с ключом SCENARIOS в moex_parser.py
  periodLabel String       // «Сен 2014 — Фев 2015»

  rooms Room[]
  news  News[]
  steps ScenarioStep[]
}

// ─── Шаги сценария (по одному на месяц, до апреля 2026) ──────────
model ScenarioStep {
  id               Int     @id @default(autoincrement())
  scenarioId       String
  stepIndex        Int                      // 0-based порядковый номер
  year             Int
  month            Int                      // 1–12
  label            String                   // «Сен 2014»
  eventName        String?                  // «💥 ЧЁРНЫЙ ВТОРНИК»
  eventDescription String?
  eventColor       String?                  // hex для оформления события

  scenario Scenario @relation(...)

  @@unique([scenarioId, stepIndex])
}

// ─── Новости шага ────────────────────────────────────────────────
model News {
  id         Int     @id @default(autoincrement())
  scenarioId String
  stepIndex  Int
  title      String
  body       String
  impact     String  // positive | negative | neutral
  sector     String?  // «Нефть и газ» | «Банки» | ...

  scenario Scenario @relation(...)
}

// ─── Акции (тикеры MOEX) ─────────────────────────────────────────
model Stonk {
  id     Int    @id @default(autoincrement())
  ticker String @unique   // SBER, GAZP, LKOH, ...
  name   String           // «Сбербанк»
  sector String           // «Банки»
  color  String           // hex для UI

  prices Price[]
}

// ─── Дивиденды ───────────────────────────────────────────────────
model Dividend {
  id          Int      @id @default(autoincrement())
  ticker      String
  perShare    Float    @map("per_share")
  paymentDate DateTime @map("payment_date")
  year        Int
  month       Int
  currency    String   @default("RUB")
  source      String   @default("moex")

  @@unique([ticker, paymentDate])
  @@index([ticker, year, month])
  @@map("dividend")
}

// ─── Рыночные новости (из внешних парсеров) ──────────────────────
model MarketNews {
  id          Int      @id @default(autoincrement())
  source      String   // moex_sitenews | cbr | smartlab
  title       String
  body        String?
  url         String?  @unique
  publishedAt DateTime @map("published_at")
  year        Int
  month       Int
  tickers     String?  // «SBER,GAZP» — comma-separated
  impact      String?  // positive | negative | neutral
  category    String?  // rate | dividend | earnings | sanctions | general

  @@index([year, month])
  @@index([source])
  @@map("market_news")
}

// ─── Исторические цены (месячные) ────────────────────────────────
model Price {
  id      Int   @id @default(autoincrement())
  stonkId Int
  year    Int
  month   Int
  price   Float                            // цена закрытия месяца в ₽

  stonk Stonk @relation(...)

  @@unique([stonkId, year, month])
  @@index([stonkId])
  @@index([year, month])
}
```

---

## Таблицы — краткое описание

### `User` — Игроки
Один никнейм = один пользователь. Идентификатор без пароля/почты.  
Один пользователь может участвовать в нескольких комнатах (через `StonkUser`).

### `Room` — Игровые комнаты (мультиплеер)
| Поле | Описание |
|---|---|
| `code` | 6-символьный код приглашения (напр. `AB3X7K`) |
| `status` | `waiting` → `active` → `finished` |
| `hostUsername` | Никнейм хоста — только он может двигать шаги |
| `currentStepIndex` | Текущий шаг игры (синхронизирован для всей комнаты) |
| `readyJson` | `["Иван","Петя"]` — список готовых к переходу |

### `StonkUser` — Состояние игрока
Связывает `User` ↔ `Room`. Хранит текущий кэш, портфель и итоговый результат.

`portfolioJson` формат:
```json
{
  "SBER": { "ticker": "SBER", "shares": 100, "avgBuyPrice": 250.0 },
  "GAZP": { "ticker": "GAZP", "shares": 50,  "avgBuyPrice": 160.5 },
  "__bondsValue__": 200000
}
```

### `Leaderboard` — Итоги
Запись создаётся при завершении игры (переход на `/results`).  
`rank` — позиция в рамках `roomId` (или глобально если `roomId = null`).

### `Scenario` + `ScenarioStep` + `News` — Сценарии
Каждый сценарий имеет N шагов (по одному на месяц), расширенных до **апреля 2026**.  
Шаги и новости сидируются из `lib/seed-data.ts` через `instrumentation.ts` при первом запуске.

**Текущие сценарии:**
| id | Название | Начало | Конец сценария | Шагов до апр 2026 |
|---|---|---|---|---|
| `2014_ruble` | Крах рубля 2014 | Сен 2014 | Фев 2015 | ~139 |
| `2020_covid` | COVID-19 пандемия | Янв 2020 | Июн 2020 | ~75 |
| `2022_feb` | Февраль 2022 | Янв 2022 | Апр 2022 | ~52 |
| `2023_rate` | Рост ключевой ставки | Июн 2023 | Мар 2024 | ~23 |

### `Stonk` — Акции
18 тикеров MOEX: SBER, GAZP, LKOH, NVTK, ROSN, SNGS, TATN, GMKN, CHMF, NLMK, ALRS, PLZL, MGNT, MOEX, VTBR, AFLT, MTSS, IRAO.

### `Price` — Исторические цены
Месячные цены закрытия. Заполняются `moex_parser.py` через MOEX ISS API.  
Если данных на месяц нет — применяется линейная интерполяция (`/api/stocks/[ticker]/route.ts`).

### `Dividend` — Дивиденды
Исторические дивиденды за весь игровой период. При переходе шага начисляются автоматически.

### `MarketNews` — Внешние новости
Таблица для парсера `news_parser.py`. В текущей игре не используется напрямую (используются `News` сценария).

---

## Связи (ERD)

```
User ────────────────────── StonkUser       (1:N  id → userId)
Room ────────────────────── StonkUser       (1:N  id → roomId)
User ────────────────────── Leaderboard     (1:N  id → userId)
Room ────────────────────── Leaderboard     (1:N  id → roomId)
Scenario ───────────────── Room             (1:N  id → scenarioId)
Scenario ───────────────── ScenarioStep     (1:N  id → scenarioId)
Scenario ───────────────── News             (1:N  id → scenarioId)
ScenarioStep ←─ stepIndex ─ News            (логическая: news.stepIndex = step.stepIndex)
Stonk ──────────────────── Price            (1:N  id → stonkId)
```

---

## API-маршруты

| Метод | Путь | Источник данных |
|---|---|---|
| GET | `/api/crises` | `Scenario` + `ScenarioStep` + `News` |
| GET | `/api/crises/[id]` | то же |
| GET | `/api/stocks` | `Stonk` |
| GET | `/api/stocks/[ticker]` | `Stonk` + `Price` (с интерполяцией) |
| GET | `/api/stocks/realtime` | MOEX ISS API |
| GET | `/api/stocks/[ticker]/candles?tf=` | MOEX ISS API |
| GET | `/api/stocks/[ticker]/trades` | MOEX ISS API |
| GET | `/api/prices/snapshot?year=&month=` | `Price` |
| GET | `/api/prices/range?from=&to=` | `Price` |
| GET | `/api/dividends/[ticker]` | `Dividend` |
| GET | `/api/dividends?from=&to=` | `Dividend` |
| GET | `/api/orderbook?ticker=` | Алгоритмически (не БД) |
| GET | `/api/leaderboard?roomCode=` | `Leaderboard` + `User` |
| POST | `/api/leaderboard` | → `Leaderboard` |
| POST | `/api/users` | → `User` (upsert) |
| GET | `/api/users?username=` | `User` |
| POST | `/api/rooms` | → `Room` + `StonkUser` |
| GET | `/api/rooms/[code]` | `Room` + `StonkUser` + `User` |
| PATCH | `/api/rooms/[code]` | → `Room` (status / currentStepIndex) |
| POST | `/api/rooms/[code]/join` | → `User` + `StonkUser` |
| POST | `/api/rooms/[code]/ready` | → `Room.readyJson` |
| POST | `/api/game` | → `StonkUser` (budget / portfolioJson) |

---

## Хардкод (не в БД)

Эти данные намеренно остаются в коде — они меняются редко и не требуют DB-round-trip:

| Константа | Файл | Описание |
|---|---|---|
| `STOCKS` | `lib/game-data.ts` | Метаданные тикеров (название, сектор, hex-цвет) |
| `KEY_RATES` | `lib/game-data.ts` | Ключевая ставка ЦБ РФ по месяцам (2014–2026) |
| `INFLATION_RATES` | `lib/game-data.ts` | Годовой ИПЦ Росстат (2013–2026) |
| `BOT_NAMES` | `lib/game-data.ts` | Имена ботов для соло-режима |
| `CRISES` + `EXTRA_NEWS` | `lib/seed-data.ts` | Исходные данные для сидирования БД (только server-side) |

> `lib/seed-data.ts` импортируется только в `instrumentation.ts` (серверный код).  
> Клиентский код (`app/`, `lib/game-context.tsx`) получает данные **только через API**.

---

## Поток данных: один шаг вперёд (мультиплеер)

```
1. Хост нажимает «Следующий месяц»
   → PATCH /api/rooms/[code]  { currentStepIndex: N+1 }
   → Room.currentStepIndex обновляется в БД

2. Участники видят шаг через поллинг (каждые 3с)
   → GET /api/rooms/[code]
   → Клиент сравнивает room.currentStepIndex с lastAnimatedStepRef

3. Загружаются новые цены (из fullPriceMap, предзагруженного при старте)
   → GET /api/prices/range?from=SCENARIO_START&to=APR_2026

4. Начисляются дивиденды (из dividendMap, предзагруженного аналогично)
   → GET /api/dividends?from=...&to=...

5. Обновляется состояние игрока
   → POST /api/game  { username, budget, portfolioJson }
   → StonkUser.budget и StonkUser.portfolioJson обновляются

6. При достижении последнего шага или ранней остановке
   → PATCH /api/rooms/[code]  { status: "finished" }
   → POST /api/leaderboard  { username, netWorth, roomCode }
   → Все участники переходят на /results
```

---

## Индексы — сводка

| Таблица | Индекс | Назначение |
|---|---|---|
| `User` | `username` UNIQUE | Быстрый поиск по нику |
| `Room` | `code` UNIQUE | Поиск по коду приглашения |
| `StonkUser` | `(userId, roomId)` | Состояние игрока в комнате |
| `Leaderboard` | `(userId, roomId)` | Результаты игрока |
| `ScenarioStep` | `(scenarioId, stepIndex)` UNIQUE | Шаг сценария |
| `Price` | `(stonkId, year, month)` UNIQUE | Цена тикера на дату |
| `Price` | `(year, month)` | Все цены за месяц (18 строк) |
| `Dividend` | `(ticker, paymentDate)` UNIQUE | Дивиденд |
| `Dividend` | `(ticker, year, month)` | Дивиденды за период |
| `MarketNews` | `(year, month)`, `source` | Фильтрация новостей |

---

## Сидирование

```
Первый запуск (пустая БД):
  instrumentation.ts::register()
    ├── import STOCKS from lib/game-data         → upsert 18 записей в Stonk
    └── import CRISES, buildCrisisTimeline        ← lib/seed-data.ts (server-only)
         └── buildCrisisTimeline(crisis)           расширяет steps до апр 2026
              └── upsert Scenario + ScenarioStep + News

После сидирования:
  moex_parser.py → заполняет Price + Dividend через MOEX ISS API
```

Для пересидирования: очистить таблицу `Scenario` (каскадно удалятся `ScenarioStep` и `News`), затем перезапустить сервер.
