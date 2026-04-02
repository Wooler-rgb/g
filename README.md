# СибИнвестиции — fintech2026

Образовательный симулятор торговли акциями на базе реальных российских кризисов (2014, COVID-2020, февраль 2022, ставка 2023–2024) с выходом на реальные данные MOEX.

## Запуск

```bash
npm install
npm run dev
```

Открыть [http://localhost:3000](http://localhost:3000).

Переменные среды — файл `.env`:
```
DATABASE_URL=postgresql://...
```

---

## Схемы базы данных

База данных — PostgreSQL. ORM — Prisma.

---

### `User` — Пользователи

| Поле | Тип | Описание |
|------|-----|----------|
| `id` | Int (PK) | Уникальный идентификатор |
| `username` | String (unique) | Имя пользователя (никнейм) |
| `createdAt` | DateTime | Дата регистрации |

Связи: один пользователь → много записей `StonkUser` (состояния в комнатах) и `Leaderboard`.

---

### `Room` — Игровые комнаты

| Поле | Тип | Описание |
|------|-----|----------|
| `id` | Int (PK) | Уникальный идентификатор |
| `code` | String (unique) | Короткий код комнаты (6 символов) |
| `scenarioId` | String (FK) | Ссылка на сценарий (кризис) |
| `status` | String | Статус: `waiting` / `active` / `finished` |
| `hostUsername` | String | Никнейм создателя комнаты |
| `currentStepIndex` | Int | Текущий шаг (месяц) игры |
| `readyJson` | String | JSON-массив готовых игроков |
| `createdAt` | DateTime | Дата создания |

Связи: комната → один сценарий, много `StonkUser`, много `Leaderboard`.

---

### `StonkUser` — Состояние игрока в комнате

| Поле | Тип | Описание |
|------|-----|----------|
| `id` | Int (PK) | Уникальный идентификатор |
| `userId` | Int (FK) | Ссылка на `User` |
| `roomId` | Int? (FK) | Ссылка на `Room` (null — соло) |
| `budget` | Float | Свободные деньги игрока (₽) |
| `portfolioJson` | String | JSON: `{ TICKER: { shares, avgBuyPrice } }` |
| `finalNetWorth` | Float? | Итоговый капитал (заполняется при завершении) |

---

### `Leaderboard` — Таблица лидеров

| Поле | Тип | Описание |
|------|-----|----------|
| `id` | Int (PK) | Уникальный идентификатор |
| `userId` | Int (FK) | Ссылка на `User` |
| `roomId` | Int? (FK) | Ссылка на `Room` (null — соло) |
| `netWorth` | Float | Итоговый капитал (₽) |
| `startBudget` | Float | Стартовый бюджет (по умолчанию 1 000 000 ₽) |
| `rank` | Int? | Место в рейтинге |
| `createdAt` | DateTime | Дата записи |

---

### `Scenario` — Сценарии (кризисы)

| Поле | Тип | Описание |
|------|-----|----------|
| `id` | String (PK) | Идентификатор: `2014_ruble`, `2020_covid`, `2022_feb`, `2023_rate` |
| `name` | String | Название кризиса |
| `description` | String | Краткое описание |
| `emoji` | String | Эмодзи для интерфейса |
| `color` | String | Цвет (hex) |
| `parserKey` | String | Ключ для парсера исторических данных |
| `periodLabel` | String | Читаемый период: `2014–2026` |

Связи: сценарий → много `Room`, `News`, `ScenarioStep`.

---

### `ScenarioStep` — Шаги сценария (месяцы)

| Поле | Тип | Описание |
|------|-----|----------|
| `id` | Int (PK) | Уникальный идентификатор |
| `scenarioId` | String (FK) | Ссылка на `Scenario` |
| `stepIndex` | Int | Порядковый номер шага (0-based) |
| `year` | Int | Год шага |
| `month` | Int | Месяц шага (1–12) |
| `label` | String | Читаемая метка: `Янв 2014` |
| `eventName` | String? | Название события (например, `⚔️ 24 ФЕВРАЛЯ 2022`) |
| `eventDescription` | String? | Описание события |
| `eventColor` | String? | Цвет события (hex) |

Уникальный индекс: `(scenarioId, stepIndex)`. Каждый сценарий содержит шаги с начала кризиса до апреля 2026.

---

### `News` — Новости шага

| Поле | Тип | Описание |
|------|-----|----------|
| `id` | Int (PK) | Уникальный идентификатор |
| `scenarioId` | String (FK) | Ссылка на `Scenario` |
| `stepIndex` | Int | К какому шагу относится новость |
| `title` | String | Заголовок |
| `body` | String | Текст новости |
| `impact` | String | Влияние: `positive` / `negative` / `neutral` |
| `sector` | String? | Сектор: `oil`, `banking`, `retail` и т.д. |

---

### `Stonk` — Акции (тикеры MOEX)

| Поле | Тип | Описание |
|------|-----|----------|
| `id` | Int (PK) | Уникальный идентификатор |
| `ticker` | String (unique) | Тикер MOEX: `SBER`, `GAZP`, `LKOH` и т.д. |
| `name` | String | Полное название компании |
| `sector` | String | Сектор экономики |
| `color` | String | Цвет для интерфейса (hex) |

Связи: акция → много `Price`.

---

### `Price` — Исторические цены (месячные)

| Поле | Тип | Описание |
|------|-----|----------|
| `id` | Int (PK) | Уникальный идентификатор |
| `stonkId` | Int (FK) | Ссылка на `Stonk` |
| `year` | Int | Год |
| `month` | Int | Месяц |
| `price` | Float | Цена закрытия (₽) |

Уникальный индекс: `(stonkId, year, month)`. Используется в историческом режиме.

---

### `Dividend` — Дивиденды

| Поле | Тип | Описание |
|------|-----|----------|
| `id` | Int (PK) | Уникальный идентификатор |
| `ticker` | String | Тикер MOEX |
| `perShare` | Float | Дивиденд на акцию (₽) |
| `paymentDate` | DateTime | Дата выплаты |
| `year` | Int | Год выплаты |
| `month` | Int | Месяц выплаты |
| `currency` | String | Валюта (по умолчанию `RUB`) |
| `source` | String | Источник (по умолчанию `moex`) |

Уникальный индекс: `(ticker, paymentDate)`.

---

### `RealtimePrice` — Кэш реальных цен MOEX ISS

| Поле | Тип | Описание |
|------|-----|----------|
| `id` | Int (PK) | Уникальный идентификатор |
| `ticker` | String (unique) | Тикер MOEX |
| `price` | Float | Последняя известная цена (₽) |
| `updatedAt` | DateTime | Время последнего обновления |

Используется для live-режима: сначала отдаются данные из этой таблицы (`?dbOnly=1`), параллельно делается запрос к MOEX ISS и кэш обновляется.

---

### `MarketNews` — Спарсенные новости (внешние источники)

| Поле | Тип | Описание |
|------|-----|----------|
| `id` | Int (PK) | Уникальный идентификатор |
| `source` | String | Источник: `moex_sitenews` / `cbr` / `smartlab` |
| `title` | String | Заголовок |
| `body` | String? | Текст |
| `url` | String? (unique) | Ссылка на оригинал |
| `publishedAt` | DateTime | Дата публикации |
| `year` | Int | Год (для индексации) |
| `month` | Int | Месяц (для индексации) |
| `tickers` | String? | Связанные тикеры через запятую: `SBER,GAZP` |
| `impact` | String? | Тональность: `positive` / `negative` / `neutral` |
| `category` | String? | Категория: `rate` / `dividend` / `earnings` / `sanctions` / `general` |

---

## Связи между схемами

```
User ──< StonkUser >── Room ──> Scenario ──< ScenarioStep
 │                       │                 └──< News
 └──< Leaderboard >──────┘
Stonk ──< Price
Stonk (ticker) ← Dividend
Stonk (ticker) ← RealtimePrice
```
