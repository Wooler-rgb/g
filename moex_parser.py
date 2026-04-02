"""
Парсер данных Московской биржи (MOEX ISS API).

Использует открытый API ISS (https://iss.moex.com) — авторизация не требуется.
Поддерживает: акции, облигации, валюты, фьючерсы.

Расширенный для тренажёра:
  - get_blue_chips()          — актуальный список голубых фишек (MOEXBC)
  - get_dividends()           — дивидендная история
  - poll_realtime()           — опрос котировок в реальном времени
  - preload_scenario()        — предзагрузка кризисных сценариев
  - get_index() / get_currency() — бенчмарки
"""

import json
import time
import threading
from pathlib import Path
from datetime import datetime, timedelta

import requests
import pandas as pd


BASE_URL = "https://iss.moex.com/iss"

SCENARIOS = {
    "2014_ruble": {
        "name": "Крах рубля 2014",
        "start": "2014-09-01",
        "end": "2015-02-28",
        "description": "Рубль -50%, санкции, обвал нефти. Чёрный вторник 16 декабря.",
    },
    "2020_covid": {
        "name": "COVID-19 2020",
        "start": "2020-01-15",
        "end": "2020-06-30",
        "description": "IMOEX -35% за месяц, V-образное восстановление.",
    },
    "2022_feb": {
        "name": "Февраль 2022",
        "start": "2022-01-10",
        "end": "2022-04-30",
        "description": "IMOEX -45% за день. Биржа закрыта 28.02–24.03.",
    },
    "2023_rate": {
        "name": "Рост ключевой ставки 2023–2024",
        "start": "2023-06-01",
        "end": "2024-03-31",
        "description": "Ключевая ставка ЦБ с 7.5% до 16%. Давление на акции роста, переток в облигации и депозиты.",
    },
}

CACHE_DIR = Path(__file__).parent / ".moex_cache"


class MOEXParser:
    """Парсер данных с Московской биржи через ISS API."""

    def __init__(self):
        self.session = requests.Session()
        self.session.headers.update({"User-Agent": "MOEXParser/1.0"})
        self._polling = False
        self._poll_thread: threading.Thread | None = None

    # ==================================================================
    # ТРЕНАЖЁР — голубые фишки
    # ==================================================================

    def get_blue_chips(self) -> pd.DataFrame:
        """Актуальный состав индекса голубых фишек MOEXBC.

        Returns:
            DataFrame с колонками: ticker, shortnames, weight и др.
        """
        url = f"{BASE_URL}/statistics/engines/stock/markets/index/analytics/MOEXBC.json"
        all_rows = []
        cursor_start = 0

        while True:
            data = self._request(url, {"start": cursor_start})
            df = self._to_dataframe(data, "analytics")
            if df.empty:
                break
            all_rows.append(df)
            cursor_start += len(df)
            if len(df) < 20:
                break

        if not all_rows:
            return pd.DataFrame()
        return pd.concat(all_rows, ignore_index=True)

    def get_blue_chip_tickers(self) -> list[str]:
        """Список тикеров голубых фишек."""
        df = self.get_blue_chips()
        if df.empty:
            return []
        col = "ticker" if "ticker" in df.columns else df.columns[0]
        return df[col].tolist()

    # ==================================================================
    # ТРЕНАЖЁР — дивиденды
    # ==================================================================

    def get_dividends(self, ticker: str) -> pd.DataFrame:
        """Дивидендная история инструмента.

        Returns:
            DataFrame: registryclosedate, value, currencyid и др.
        """
        url = f"{BASE_URL}/securities/{ticker}/dividends.json"
        data = self._request(url)
        df = self._to_dataframe(data, "dividends")
        if not df.empty and "registryclosedate" in df.columns:
            df["registryclosedate"] = pd.to_datetime(
                df["registryclosedate"], errors="coerce"
            )
        return df

    def get_dividends_bulk(self, tickers: list[str] | None = None) -> pd.DataFrame:
        """Дивиденды по списку тикеров (по умолчанию — все голубые фишки).

        Returns:
            Единый DataFrame со столбцом 'ticker'.
        """
        if tickers is None:
            tickers = self.get_blue_chip_tickers()

        frames = []
        for t in tickers:
            df = self.get_dividends(t)
            if not df.empty:
                df = df.copy()
                df.insert(0, "ticker", t)
                frames.append(df)

        if not frames:
            return pd.DataFrame()
        return pd.concat(frames, ignore_index=True)

    # ==================================================================
    # ТРЕНАЖЁР — опрос котировок в реальном времени
    # ==================================================================

    def poll_realtime(
        self,
        tickers: list[str] | None = None,
        interval_sec: int = 300,
        callback=None,
        max_iterations: int | None = None,
    ) -> None:
        """Запуск опроса котировок в фоновом потоке.

        Args:
            tickers:        Список тикеров (по умолчанию — голубые фишки)
            interval_sec:   Интервал опроса в секундах (300 = 5 мин)
            callback:       Функция callback(df: DataFrame) — вызывается после
                            каждого опроса с новым срезом котировок
            max_iterations: Макс. число опросов (None = бесконечно)
        """
        if tickers is None:
            tickers = self.get_blue_chip_tickers()

        self._polling = True

        def _loop():
            iteration = 0
            while self._polling:
                if max_iterations is not None and iteration >= max_iterations:
                    break
                df = self.fetch_realtime_snapshot(tickers)
                if callback is not None:
                    callback(df)
                iteration += 1
                if self._polling and (
                    max_iterations is None or iteration < max_iterations
                ):
                    time.sleep(interval_sec)
            self._polling = False

        self._poll_thread = threading.Thread(target=_loop, daemon=True)
        self._poll_thread.start()

    def stop_polling(self) -> None:
        """Остановить фоновый опрос котировок."""
        self._polling = False
        if self._poll_thread is not None:
            self._poll_thread.join(timeout=10)
            self._poll_thread = None

    def fetch_realtime_snapshot(self, tickers: list[str]) -> pd.DataFrame:
        """Один снимок котировок по списку тикеров.

        Returns:
            DataFrame с колонками: SECID, SHORTNAME, LAST, OPEN, HIGH, LOW,
            BID, OFFER, CHANGE, VOLTODAY, VALTODAY, WAPRICE, UPDATETIME,
            LOTSIZE, PREVPRICE, ...
        """
        url = (
            f"{BASE_URL}/engines/stock/markets/shares"
            f"/boards/TQBR/securities.json"
        )
        params = {"securities": ",".join(tickers)}
        data = self._request(url, params)

        securities = self._to_dataframe(data, "securities")
        marketdata = self._to_dataframe(data, "marketdata")

        if securities.empty and marketdata.empty:
            return pd.DataFrame()

        if not securities.empty and not marketdata.empty:
            sec_cols = ["SECID", "SHORTNAME", "PREVPRICE", "LOTSIZE"]
            sec_cols = [c for c in sec_cols if c in securities.columns]
            md_cols = [
                "SECID", "LAST", "OPEN", "HIGH", "LOW", "BID", "OFFER",
                "SPREAD", "WAPRICE", "CHANGE", "LASTTOPREVPRICE",
                "VOLTODAY", "VALTODAY", "NUMTRADES", "UPDATETIME",
            ]
            md_cols = [c for c in md_cols if c in marketdata.columns]
            merged = securities[sec_cols].merge(
                marketdata[md_cols], on="SECID", how="outer"
            )
            merged["snapshot_time"] = datetime.now().strftime("%Y-%m-%d %H:%M:%S")
            return merged

        return marketdata if not marketdata.empty else securities

    # ==================================================================
    # ТРЕНАЖЁР — предзагрузка стресс-сценариев
    # ==================================================================

    @staticmethod
    def list_scenarios() -> dict:
        """Список доступных кризисных сценариев."""
        return {k: v["name"] for k, v in SCENARIOS.items()}

    def preload_scenario(
        self,
        scenario_key: str,
        tickers: list[str] | None = None,
        use_cache: bool = True,
    ) -> dict[str, pd.DataFrame]:
        """Загрузить полный набор данных для стресс-сценария.

        Args:
            scenario_key: Ключ сценария из SCENARIOS
                          ('2014_ruble', '2020_covid', '2022_feb', '2023_rate')
            tickers:      Тикеры для загрузки (по умолчанию — голубые фишки)
            use_cache:    Кэшировать на диск для ускорения повторной загрузки

        Returns:
            dict с ключами:
              'meta'      — описание сценария
              'stocks'    — {ticker: DataFrame свечей}
              'index'     — DataFrame IMOEX
              'currency'  — DataFrame USD/RUB
              'dividends' — DataFrame дивидендов за период
        """
        if scenario_key not in SCENARIOS:
            raise ValueError(
                f"Неизвестный сценарий '{scenario_key}'. "
                f"Доступные: {list(SCENARIOS.keys())}"
            )

        scenario = SCENARIOS[scenario_key]
        start = scenario["start"]
        end = scenario["end"]

        if use_cache:
            cached = self._load_cache(scenario_key)
            if cached is not None:
                return cached

        if tickers is None:
            tickers = self.get_blue_chip_tickers()
            if not tickers:
                tickers = [
                    "SBER", "GAZP", "LKOH", "GMKN", "NVTK", "ROSN",
                    "SNGS", "MGNT", "TATN", "VTBR", "CHMF", "NLMK",
                    "MTSS", "ALRS", "PLZL", "MOEX", "AFLT", "IRAO",
                ]

        print(f"Загрузка сценария «{scenario['name']}» ({start} — {end})...")

        stocks = {}
        for i, t in enumerate(tickers, 1):
            print(f"  [{i}/{len(tickers)}] {t}...", end=" ")
            df = self.candles(t, start=start, end=end, interval=24)
            if not df.empty:
                stocks[t] = df
                print(f"{len(df)} записей")
            else:
                print("нет данных")

        print("  Индекс IMOEX...", end=" ")
        index_df = self.index_history("IMOEX", start=start, end=end)
        print(f"{len(index_df)} записей")

        print("  USD/RUB...", end=" ")
        currency_df = self.currency_candles("USD000UTSTOM", start=start, end=end)
        print(f"{len(currency_df)} записей")

        print("  Дивиденды...", end=" ")
        divs = self.get_dividends_bulk(list(stocks.keys()))
        if not divs.empty and "registryclosedate" in divs.columns:
            divs = divs[
                (divs["registryclosedate"] >= start)
                & (divs["registryclosedate"] <= end)
            ]
        print(f"{len(divs)} записей")

        result = {
            "meta": scenario,
            "stocks": stocks,
            "index": index_df,
            "currency": currency_df,
            "dividends": divs,
        }

        if use_cache:
            self._save_cache(scenario_key, result)

        print("Готово!\n")
        return result

    # ==================================================================
    # ТРЕНАЖЁР — история цены акции (для графика тренда)
    # ==================================================================

    def price_history(
        self,
        ticker: str,
        period: str = "month",
        board: str = "TQBR",
        engine: str = "stock",
        market: str = "shares",
    ) -> pd.DataFrame:
        """История цены акции за выбранный период.

        Args:
            ticker: Тикер инструмента (SBER, GAZP, …)
            period: Временной горизонт:
                    'day'     — 1 день (10-минутные свечи)
                    'week'    — 1 неделя (часовые свечи)
                    'month'   — 1 месяц (дневные свечи)
                    '3month'  — 3 месяца (дневные свечи)
                    'year'    — 1 год (дневные свечи)

        Returns:
            DataFrame с колонками: open, close, high, low, volume, value, begin, end
        """
        period_map = {
            "day":    (timedelta(days=1),   10),
            "week":   (timedelta(weeks=1),  60),
            "month":  (timedelta(days=30),  24),
            "3month": (timedelta(days=90),  24),
            "year":   (timedelta(days=365), 24),
        }

        if period not in period_map:
            raise ValueError(
                f"Неизвестный период '{period}'. "
                f"Доступные: {list(period_map.keys())}"
            )

        delta, interval = period_map[period]
        start = (datetime.now() - delta).strftime("%Y-%m-%d")

        return self.candles(
            ticker=ticker,
            start=start,
            interval=interval,
            board=board,
            engine=engine,
            market=market,
        )

    # ==================================================================
    # ТРЕНАЖЁР — лента сделок (trades)
    # ==================================================================

    def trades(
        self,
        ticker: str,
        limit: int = 50,
        board: str = "TQBR",
        engine: str = "stock",
        market: str = "shares",
    ) -> pd.DataFrame:
        """Последние сделки по инструменту (лента сделок).

        Каждая сделка содержит цену, объём и направление (покупка/продажа).

        Args:
            ticker: Тикер инструмента
            limit:  Максимальное количество сделок (от конца)

        Returns:
            DataFrame с колонками: TRADENO, TRADETIME, PRICE, QUANTITY,
            VALUE, BUYSELL, SECID и др.
        """
        url = (
            f"{BASE_URL}/engines/{engine}/markets/{market}"
            f"/boards/{board}/securities/{ticker}/trades.json"
        )
        data = self._request(url)
        df = self._to_dataframe(data, "trades")
        if df.empty:
            return df
        df = df.tail(limit).reset_index(drop=True)
        if "TRADETIME" in df.columns:
            df["TRADETIME"] = pd.to_datetime(
                df["TRADETIME"], format="%H:%M:%S", errors="coerce"
            ).dt.time
        return df

    # ==================================================================
    # ТРЕНАЖЁР — корреляции и бета
    # ==================================================================

    def correlations(self, ticker: str | None = None) -> pd.DataFrame:
        """Корреляции и бета-коэффициенты акций относительно индексов.

        Args:
            ticker: Фильтр по тикеру (None = все бумаги)

        Returns:
            DataFrame: SECID, FXSECID (пара), TRADEDATE,
                       COEFF_CORRELATION, COEFF_BETA
        """
        url = f"{BASE_URL}/statistics/engines/stock/markets/shares/correlations.json"
        all_rows = []
        cursor_start = 0

        while True:
            params = {"start": cursor_start}
            if ticker:
                params["security"] = ticker
            data = self._request(url, params)
            df = self._to_dataframe(data, "correlations")
            if df.empty:
                break
            all_rows.append(df)
            cursor_start += len(df)
            if len(df) < 100:
                break

        if not all_rows:
            return pd.DataFrame()
        return pd.concat(all_rows, ignore_index=True)

    # ==================================================================
    # ТРЕНАЖЁР — ОФЗ (безрисковая ставка для Шарпа)
    # ==================================================================

    def ofz_list(self) -> pd.DataFrame:
        """Список ОФЗ (гос. облигации) с доходностью и купонами.

        Returns:
            DataFrame: SECID, SHORTNAME, YIELDATPREVWAPRICE,
                       COUPONPERCENT, COUPONVALUE, NEXTCOUPON,
                       MATDATE, ACCRUEDINT, ...
        """
        url = (
            f"{BASE_URL}/engines/stock/markets/bonds"
            f"/boards/TQOB/securities.json"
        )
        data = self._request(url)
        securities = self._to_dataframe(data, "securities")
        marketdata = self._to_dataframe(data, "marketdata")

        if not securities.empty and not marketdata.empty:
            sec_cols = [c for c in securities.columns if c not in marketdata.columns or c == "SECID"]
            return securities[sec_cols].merge(marketdata, on="SECID", how="outer")
        return securities if not securities.empty else marketdata

    def risk_free_rate(self) -> float | None:
        """Безрисковая ставка — доходность короткой ОФЗ (< 1 года).

        Используется в формуле коэффициента Шарпа.
        Returns:
            Годовая доходность в % (например, 16.5) или None
        """
        df = self.ofz_list()
        if df.empty or "MATDATE" not in df.columns:
            return None

        df = df.copy()
        df["MATDATE"] = pd.to_datetime(df["MATDATE"], errors="coerce")
        now = pd.Timestamp.now()
        one_year = now + pd.Timedelta(days=365)

        short = df[
            (df["MATDATE"] > now)
            & (df["MATDATE"] <= one_year)
            & (df.get("YIELDATPREVWAPRICE") is not None)
        ]

        if "YIELDATPREVWAPRICE" not in short.columns or short.empty:
            return None

        short = short[short["YIELDATPREVWAPRICE"].notna() & (short["YIELDATPREVWAPRICE"] > 0)]
        if short.empty:
            return None

        return round(short["YIELDATPREVWAPRICE"].median(), 2)

    # ==================================================================
    # ТРЕНАЖЁР — новости биржи
    # ==================================================================

    def news(self, limit: int = 20) -> pd.DataFrame:
        """Лента новостей Московской биржи.

        Returns:
            DataFrame: id, tag, title, published_at, modified_at
        """
        url = f"{BASE_URL}/sitenews.json"
        data = self._request(url)
        df = self._to_dataframe(data, "sitenews")
        if df.empty:
            return df
        if "published_at" in df.columns:
            df["published_at"] = pd.to_datetime(df["published_at"], errors="coerce")
        return df.head(limit)

    # ==================================================================
    # ТРЕНАЖЁР — капитализация рынка
    # ==================================================================

    def market_capitalization(self) -> dict:
        """Общая капитализация фондового рынка MOEX.

        Returns:
            dict с ключами 'capitalization' (на закрытие) и
            'issuecapitalization' (внутридневная)
        """
        url = f"{BASE_URL}/statistics/engines/stock/capitalization.json"
        data = self._request(url)
        result = {}
        for block in ("capitalization", "issuecapitalization"):
            df = self._to_dataframe(data, block)
            if not df.empty:
                result[block] = df
        return result

    # ==================================================================
    # ТРЕНАЖЁР — бенчмарки (удобные обёртки)
    # ==================================================================

    def get_index(
        self,
        start: str | None = None,
        end: str | None = None,
        index: str = "IMOEX",
    ) -> pd.DataFrame:
        """Получить историю индекса (обёртка для тренажёра)."""
        return self.index_history(index=index, start=start, end=end)

    def get_currency(
        self,
        start: str | None = None,
        end: str | None = None,
        pair: str = "USD000UTSTOM",
    ) -> pd.DataFrame:
        """Получить историю валютной пары (обёртка для тренажёра)."""
        return self.currency_candles(pair=pair, start=start, end=end)

    # ==================================================================
    # Поиск инструментов
    # ==================================================================

    def search(self, query: str, limit: int = 10) -> pd.DataFrame:
        """Поиск инструментов по названию или тикеру."""
        url = f"{BASE_URL}/securities.json"
        params = {"q": query, "limit": limit}
        data = self._request(url, params)
        return self._to_dataframe(data, "securities")

    # ==================================================================
    # Информация об инструменте
    # ==================================================================

    def security_info(self, ticker: str) -> dict[str, pd.DataFrame]:
        """Подробная информация об инструменте."""
        url = f"{BASE_URL}/securities/{ticker}.json"
        data = self._request(url)
        return {
            "description": self._to_dataframe(data, "description"),
            "boards": self._to_dataframe(data, "boards"),
        }

    # ==================================================================
    # Исторические свечи (OHLCV)
    # ==================================================================

    def candles(
        self,
        ticker: str,
        start: str | None = None,
        end: str | None = None,
        interval: int = 24,
        board: str = "TQBR",
        engine: str = "stock",
        market: str = "shares",
    ) -> pd.DataFrame:
        """Загрузка исторических свечей (OHLCV).

        Args:
            ticker:   Тикер инструмента (SBER, GAZP, …)
            start:    Дата начала "YYYY-MM-DD" (по умолчанию — год назад)
            end:      Дата окончания "YYYY-MM-DD" (по умолчанию — сегодня)
            interval: Интервал свечи в минутах:
                      1, 10, 60, 24 (=дневная), 7 (=недельная), 31 (=месячная)
            board:    Режим торгов (TQBR — акции, RFUD — фьючерсы, CETS — валюта)
            engine:   Торговая система (stock, currency, futures)
            market:   Рынок (shares, bonds, index, futures)
        """
        if start is None:
            start = (datetime.now() - timedelta(days=365)).strftime("%Y-%m-%d")
        if end is None:
            end = datetime.now().strftime("%Y-%m-%d")

        url = (
            f"{BASE_URL}/engines/{engine}/markets/{market}"
            f"/boards/{board}/securities/{ticker}/candles.json"
        )

        all_rows = []
        cursor_start = 0

        while True:
            params = {
                "from": start,
                "till": end,
                "interval": interval,
                "start": cursor_start,
            }
            data = self._request(url, params)
            df = self._to_dataframe(data, "candles")
            if df.empty:
                break
            all_rows.append(df)
            cursor_start += len(df)
            if len(df) < 500:
                break

        if not all_rows:
            return pd.DataFrame()

        result = pd.concat(all_rows, ignore_index=True)
        if "begin" in result.columns:
            result["begin"] = pd.to_datetime(result["begin"])
        if "end" in result.columns:
            result["end"] = pd.to_datetime(result["end"])
        return result

    # ==================================================================
    # История торгов (итоги дня)
    # ==================================================================

    def history(
        self,
        ticker: str,
        start: str | None = None,
        end: str | None = None,
        board: str = "TQBR",
        engine: str = "stock",
        market: str = "shares",
    ) -> pd.DataFrame:
        """Загрузка итогов торгов по дням."""
        if start is None:
            start = (datetime.now() - timedelta(days=365)).strftime("%Y-%m-%d")
        if end is None:
            end = datetime.now().strftime("%Y-%m-%d")

        url = (
            f"{BASE_URL}/history/engines/{engine}/markets/{market}"
            f"/boards/{board}/securities/{ticker}.json"
        )

        all_rows = []
        cursor_start = 0

        while True:
            params = {"from": start, "till": end, "start": cursor_start}
            data = self._request(url, params)
            df = self._to_dataframe(data, "history")
            if df.empty:
                break
            all_rows.append(df)
            cursor_start += len(df)
            if len(df) < 100:
                break

        if not all_rows:
            return pd.DataFrame()

        result = pd.concat(all_rows, ignore_index=True)
        if "TRADEDATE" in result.columns:
            result["TRADEDATE"] = pd.to_datetime(result["TRADEDATE"])
        return result

    # ==================================================================
    # Текущие котировки
    # ==================================================================

    def quotes(
        self,
        ticker: str,
        board: str = "TQBR",
        engine: str = "stock",
        market: str = "shares",
    ) -> pd.DataFrame:
        """Текущие котировки инструмента (последняя цена, bid/ask, объём)."""
        url = (
            f"{BASE_URL}/engines/{engine}/markets/{market}"
            f"/boards/{board}/securities/{ticker}.json"
        )
        data = self._request(url)
        marketdata = self._to_dataframe(data, "marketdata")
        securities = self._to_dataframe(data, "securities")
        if not marketdata.empty and not securities.empty:
            return pd.concat([securities, marketdata], axis=1)
        return marketdata if not marketdata.empty else securities

    # ==================================================================
    # Список бумаг на доске
    # ==================================================================

    def list_securities(
        self,
        board: str = "TQBR",
        engine: str = "stock",
        market: str = "shares",
    ) -> pd.DataFrame:
        """Список всех инструментов на заданной доске."""
        url = (
            f"{BASE_URL}/engines/{engine}/markets/{market}"
            f"/boards/{board}/securities.json"
        )
        data = self._request(url)
        return self._to_dataframe(data, "securities")

    # ==================================================================
    # Индексы
    # ==================================================================

    def index_history(
        self,
        index: str = "IMOEX",
        start: str | None = None,
        end: str | None = None,
    ) -> pd.DataFrame:
        """История значений индекса (IMOEX, RTSI, MOEXBC и др.)."""
        if start is None:
            start = (datetime.now() - timedelta(days=365)).strftime("%Y-%m-%d")
        if end is None:
            end = datetime.now().strftime("%Y-%m-%d")

        url = (
            f"{BASE_URL}/history/engines/stock/markets/index"
            f"/boards/SNDX/securities/{index}.json"
        )

        all_rows = []
        cursor_start = 0

        while True:
            params = {"from": start, "till": end, "start": cursor_start}
            data = self._request(url, params)
            df = self._to_dataframe(data, "history")
            if df.empty:
                break
            all_rows.append(df)
            cursor_start += len(df)
            if len(df) < 100:
                break

        if not all_rows:
            return pd.DataFrame()

        result = pd.concat(all_rows, ignore_index=True)
        if "TRADEDATE" in result.columns:
            result["TRADEDATE"] = pd.to_datetime(result["TRADEDATE"])
        return result

    # ==================================================================
    # Валютные курсы
    # ==================================================================

    def currency_candles(
        self,
        pair: str = "USD000UTSTOM",
        start: str | None = None,
        end: str | None = None,
        interval: int = 24,
    ) -> pd.DataFrame:
        """Свечи валютной пары (USD000UTSTOM = USD/RUB, EUR_RUB__TOM = EUR/RUB)."""
        return self.candles(
            ticker=pair,
            start=start,
            end=end,
            interval=interval,
            board="CETS",
            engine="currency",
            market="selt",
        )

    # ==================================================================
    # Кэширование сценариев
    # ==================================================================

    @staticmethod
    def _save_cache(scenario_key: str, data: dict) -> None:
        """Сохранить сценарий на диск."""
        cache_dir = CACHE_DIR / scenario_key
        cache_dir.mkdir(parents=True, exist_ok=True)

        with open(cache_dir / "meta.json", "w", encoding="utf-8") as f:
            json.dump(data["meta"], f, ensure_ascii=False, indent=2)

        stocks_dir = cache_dir / "stocks"
        stocks_dir.mkdir(exist_ok=True)
        for ticker, df in data["stocks"].items():
            df.to_parquet(stocks_dir / f"{ticker}.parquet", index=False)

        if not data["index"].empty:
            data["index"].to_parquet(cache_dir / "index.parquet", index=False)
        if not data["currency"].empty:
            data["currency"].to_parquet(cache_dir / "currency.parquet", index=False)
        if not data["dividends"].empty:
            data["dividends"].to_parquet(cache_dir / "dividends.parquet", index=False)

    @staticmethod
    def _load_cache(scenario_key: str) -> dict | None:
        """Загрузить сценарий из дискового кэша."""
        cache_dir = CACHE_DIR / scenario_key
        meta_path = cache_dir / "meta.json"
        if not meta_path.exists():
            return None

        print(f"Загрузка сценария '{scenario_key}' из кэша...")

        with open(meta_path, encoding="utf-8") as f:
            meta = json.load(f)

        stocks = {}
        stocks_dir = cache_dir / "stocks"
        if stocks_dir.exists():
            for p in stocks_dir.glob("*.parquet"):
                stocks[p.stem] = pd.read_parquet(p)

        def _read_if_exists(path):
            return pd.read_parquet(path) if path.exists() else pd.DataFrame()

        return {
            "meta": meta,
            "stocks": stocks,
            "index": _read_if_exists(cache_dir / "index.parquet"),
            "currency": _read_if_exists(cache_dir / "currency.parquet"),
            "dividends": _read_if_exists(cache_dir / "dividends.parquet"),
        }

    # ==================================================================
    # Внутренние методы
    # ==================================================================

    def _request(self, url: str, params: dict | None = None) -> dict:
        """Выполнить GET-запрос к ISS API."""
        resp = self.session.get(url, params=params, timeout=30)
        resp.raise_for_status()
        return resp.json()

    @staticmethod
    def _to_dataframe(data: dict, block: str) -> pd.DataFrame:
        """Преобразовать блок ISS-ответа в DataFrame."""
        if block not in data:
            return pd.DataFrame()
        columns = data[block].get("columns", [])
        rows = data[block].get("data", [])
        if not columns or not rows:
            return pd.DataFrame(columns=columns)
        return pd.DataFrame(rows, columns=columns)


# ======================================================================
# Демонстрация (запускается как скрипт)
# ======================================================================

if __name__ == "__main__":
    parser = MOEXParser()

    # --- 1. Голубые фишки ---
    print("=" * 60)
    print("1. Голубые фишки (MOEXBC)")
    print("=" * 60)
    chips = parser.get_blue_chips()
    if not chips.empty:
        print(chips.to_string(max_rows=10))
    tickers = parser.get_blue_chip_tickers()
    print(f"\nТикеры ({len(tickers)}): {tickers}")

    # --- 2. Снимок котировок (realtime) ---
    print("\n" + "=" * 60)
    print("2. Снимок котировок топ-5 фишек")
    print("=" * 60)
    top5 = tickers[:5] if tickers else ["SBER", "GAZP", "LKOH", "GMKN", "NVTK"]
    snap = parser.fetch_realtime_snapshot(top5)
    if not snap.empty:
        show_cols = [c for c in [
            "SECID", "SHORTNAME", "LAST", "CHANGE", "VOLTODAY", "UPDATETIME"
        ] if c in snap.columns]
        print(snap[show_cols].to_string())

    # --- 3. Дивиденды SBER ---
    print("\n" + "=" * 60)
    print("3. Дивиденды SBER")
    print("=" * 60)
    divs = parser.get_dividends("SBER")
    if not divs.empty:
        print(divs.to_string(max_rows=10))

    # --- 4. Список сценариев ---
    print("\n" + "=" * 60)
    print("4. Доступные стресс-сценарии")
    print("=" * 60)
    for key, name in parser.list_scenarios().items():
        info = SCENARIOS[key]
        print(f"  {key:15s} | {name} ({info['start']} — {info['end']})")

    # --- 5. Загрузка сценария COVID ---
    print("\n" + "=" * 60)
    print("5. Предзагрузка сценария COVID-2020 (3 тикера для демо)")
    print("=" * 60)
    demo_data = parser.preload_scenario(
        "2020_covid",
        tickers=["SBER", "GAZP", "LKOH"],
        use_cache=True,
    )
    print(f"  Акций загружено: {len(demo_data['stocks'])}")
    for t, df in demo_data["stocks"].items():
        print(f"    {t}: {len(df)} свечей, "
              f"период {df['begin'].min().date()} — {df['begin'].max().date()}")
    print(f"  Индекс IMOEX: {len(demo_data['index'])} записей")
    print(f"  USD/RUB: {len(demo_data['currency'])} записей")
    print(f"  Дивиденды: {len(demo_data['dividends'])} записей")

    # --- 6. Демо poll_realtime (1 итерация) ---
    print("\n" + "=" * 60)
    print("6. Демо poll_realtime (1 итерация, 3 тикера)")
    print("=" * 60)
    results = []
    parser.poll_realtime(
        tickers=["SBER", "GAZP", "LKOH"],
        interval_sec=5,
        callback=lambda df: results.append(df),
        max_iterations=1,
    )
    parser._poll_thread.join(timeout=15)
    if results:
        df = results[0]
        show_cols = [c for c in [
            "SECID", "LAST", "CHANGE", "snapshot_time"
        ] if c in df.columns]
        print(df[show_cols].to_string())

    # --- 7. История цены SBER (разные периоды) ---
    print("\n" + "=" * 60)
    print("7. История цены SBER")
    print("=" * 60)
    for period in ["day", "week", "month", "3month", "year"]:
        df = parser.price_history("SBER", period=period)
        if not df.empty:
            print(f"  {period:8s}: {len(df)} свечей, "
                  f"{df['begin'].min()} — {df['begin'].max()}")

    # --- 8. Лента сделок SBER ---
    print("\n" + "=" * 60)
    print("8. Последние 10 сделок SBER")
    print("=" * 60)
    trades = parser.trades("SBER", limit=10)
    if not trades.empty:
        show_cols = [c for c in [
            "TRADETIME", "PRICE", "QUANTITY", "BUYSELL"
        ] if c in trades.columns]
        print(trades[show_cols].to_string())

    # --- 9. Корреляции SBER ---
    print("\n" + "=" * 60)
    print("9. Корреляции SBER")
    print("=" * 60)
    corr = parser.correlations("SBER")
    if not corr.empty:
        show_cols = [c for c in [
            "SECID", "FXSECID", "COEFF_CORRELATION", "COEFF_BETA"
        ] if c in corr.columns]
        print(corr[show_cols].to_string(max_rows=10))

    # --- 10. Безрисковая ставка (ОФЗ) ---
    print("\n" + "=" * 60)
    print("10. Безрисковая ставка (короткие ОФЗ)")
    print("=" * 60)
    rf = parser.risk_free_rate()
    print(f"  Безрисковая ставка: {rf}% годовых" if rf else "  Нет данных")

    # --- 11. Новости биржи ---
    print("\n" + "=" * 60)
    print("11. Последние 5 новостей MOEX")
    print("=" * 60)
    news = parser.news(limit=5)
    if not news.empty:
        for _, row in news.iterrows():
            title = row.get("title", "")
            date = row.get("published_at", "")
            print(f"  [{date}] {title}")

    # --- 12. Капитализация рынка ---
    print("\n" + "=" * 60)
    print("12. Капитализация фондового рынка")
    print("=" * 60)
    cap = parser.market_capitalization()
    for block_name, df in cap.items():
        if not df.empty:
            print(f"  {block_name}:")
            print(f"    {df.to_string(max_rows=3)}")
