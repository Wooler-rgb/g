--
-- PostgreSQL database dump
--

\restrict okT3FqBqxGgYZZ3nu5LRZhAFrm8eWOE0PkXP8UxNISvKqEtTGFeQsCQQRyKXMyC

-- Dumped from database version 17.9
-- Dumped by pg_dump version 17.9

SET statement_timeout = 0;
SET lock_timeout = 0;
SET idle_in_transaction_session_timeout = 0;
SET transaction_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SELECT pg_catalog.set_config('search_path', '', false);
SET check_function_bodies = false;
SET xmloption = content;
SET client_min_messages = warning;
SET row_security = off;

SET default_tablespace = '';

SET default_table_access_method = heap;

--
-- Name: Leaderboard; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public."Leaderboard" (
    id integer NOT NULL,
    "userId" integer NOT NULL,
    "roomId" integer,
    "netWorth" double precision NOT NULL,
    "startBudget" double precision DEFAULT 1000000 NOT NULL,
    rank integer,
    "createdAt" timestamp(3) without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL
);


ALTER TABLE public."Leaderboard" OWNER TO postgres;

--
-- Name: Leaderboard_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public."Leaderboard_id_seq"
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public."Leaderboard_id_seq" OWNER TO postgres;

--
-- Name: Leaderboard_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public."Leaderboard_id_seq" OWNED BY public."Leaderboard".id;


--
-- Name: News; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public."News" (
    id integer NOT NULL,
    "scenarioId" text NOT NULL,
    "stepIndex" integer NOT NULL,
    title text NOT NULL,
    body text NOT NULL,
    impact text NOT NULL,
    sector text
);


ALTER TABLE public."News" OWNER TO postgres;

--
-- Name: News_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public."News_id_seq"
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public."News_id_seq" OWNER TO postgres;

--
-- Name: News_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public."News_id_seq" OWNED BY public."News".id;


--
-- Name: Price; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public."Price" (
    id integer NOT NULL,
    "stonkId" integer NOT NULL,
    year integer NOT NULL,
    month integer NOT NULL,
    price double precision NOT NULL
);


ALTER TABLE public."Price" OWNER TO postgres;

--
-- Name: Price_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public."Price_id_seq"
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public."Price_id_seq" OWNER TO postgres;

--
-- Name: Price_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public."Price_id_seq" OWNED BY public."Price".id;


--
-- Name: Room; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public."Room" (
    id integer NOT NULL,
    code text NOT NULL,
    "scenarioId" text NOT NULL,
    status text DEFAULT 'waiting'::text NOT NULL,
    "createdAt" timestamp(3) without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    "currentStepIndex" integer DEFAULT 0 NOT NULL,
    "hostUsername" text DEFAULT ''::text NOT NULL,
    "readyJson" text DEFAULT '[]'::text NOT NULL
);


ALTER TABLE public."Room" OWNER TO postgres;

--
-- Name: Room_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public."Room_id_seq"
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public."Room_id_seq" OWNER TO postgres;

--
-- Name: Room_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public."Room_id_seq" OWNED BY public."Room".id;


--
-- Name: Scenario; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public."Scenario" (
    id text NOT NULL,
    name text NOT NULL,
    description text NOT NULL,
    emoji text NOT NULL,
    color text NOT NULL,
    "parserKey" text NOT NULL,
    "periodLabel" text NOT NULL
);


ALTER TABLE public."Scenario" OWNER TO postgres;

--
-- Name: ScenarioStep; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public."ScenarioStep" (
    id integer NOT NULL,
    "scenarioId" text NOT NULL,
    "stepIndex" integer NOT NULL,
    year integer NOT NULL,
    month integer NOT NULL,
    label text NOT NULL,
    "eventName" text,
    "eventDescription" text,
    "eventColor" text
);


ALTER TABLE public."ScenarioStep" OWNER TO postgres;

--
-- Name: ScenarioStep_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public."ScenarioStep_id_seq"
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public."ScenarioStep_id_seq" OWNER TO postgres;

--
-- Name: ScenarioStep_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public."ScenarioStep_id_seq" OWNED BY public."ScenarioStep".id;


--
-- Name: Stonk; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public."Stonk" (
    id integer NOT NULL,
    ticker text NOT NULL,
    name text NOT NULL,
    sector text NOT NULL,
    color text NOT NULL
);


ALTER TABLE public."Stonk" OWNER TO postgres;

--
-- Name: StonkUser; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public."StonkUser" (
    id integer NOT NULL,
    "userId" integer NOT NULL,
    "roomId" integer,
    budget double precision DEFAULT 1000000 NOT NULL,
    "portfolioJson" text DEFAULT '{}'::text NOT NULL,
    "finalNetWorth" double precision
);


ALTER TABLE public."StonkUser" OWNER TO postgres;

--
-- Name: StonkUser_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public."StonkUser_id_seq"
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public."StonkUser_id_seq" OWNER TO postgres;

--
-- Name: StonkUser_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public."StonkUser_id_seq" OWNED BY public."StonkUser".id;


--
-- Name: Stonk_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public."Stonk_id_seq"
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public."Stonk_id_seq" OWNER TO postgres;

--
-- Name: Stonk_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public."Stonk_id_seq" OWNED BY public."Stonk".id;


--
-- Name: User; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public."User" (
    id integer NOT NULL,
    username text NOT NULL,
    "createdAt" timestamp(3) without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL
);


ALTER TABLE public."User" OWNER TO postgres;

--
-- Name: User_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public."User_id_seq"
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public."User_id_seq" OWNER TO postgres;

--
-- Name: User_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public."User_id_seq" OWNED BY public."User".id;


--
-- Name: dividend; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.dividend (
    id integer NOT NULL,
    ticker text NOT NULL,
    year integer NOT NULL,
    month integer NOT NULL,
    currency text DEFAULT 'RUB'::text NOT NULL,
    source text DEFAULT 'moex'::text NOT NULL,
    payment_date timestamp(3) without time zone NOT NULL,
    per_share double precision NOT NULL
);


ALTER TABLE public.dividend OWNER TO postgres;

--
-- Name: dividend_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.dividend_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.dividend_id_seq OWNER TO postgres;

--
-- Name: dividend_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.dividend_id_seq OWNED BY public.dividend.id;


--
-- Name: market_news; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.market_news (
    id integer NOT NULL,
    source text NOT NULL,
    title text NOT NULL,
    body text,
    url text,
    year integer NOT NULL,
    month integer NOT NULL,
    tickers text,
    impact text,
    category text,
    published_at timestamp(3) without time zone NOT NULL
);


ALTER TABLE public.market_news OWNER TO postgres;

--
-- Name: market_news_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.market_news_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.market_news_id_seq OWNER TO postgres;

--
-- Name: market_news_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.market_news_id_seq OWNED BY public.market_news.id;


--
-- Name: realtime_price; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.realtime_price (
    id integer NOT NULL,
    ticker character varying(10) NOT NULL,
    price double precision NOT NULL,
    updated_at timestamp with time zone DEFAULT now() NOT NULL
);


ALTER TABLE public.realtime_price OWNER TO postgres;

--
-- Name: realtime_price_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.realtime_price_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.realtime_price_id_seq OWNER TO postgres;

--
-- Name: realtime_price_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.realtime_price_id_seq OWNED BY public.realtime_price.id;


--
-- Name: Leaderboard id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."Leaderboard" ALTER COLUMN id SET DEFAULT nextval('public."Leaderboard_id_seq"'::regclass);


--
-- Name: News id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."News" ALTER COLUMN id SET DEFAULT nextval('public."News_id_seq"'::regclass);


--
-- Name: Price id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."Price" ALTER COLUMN id SET DEFAULT nextval('public."Price_id_seq"'::regclass);


--
-- Name: Room id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."Room" ALTER COLUMN id SET DEFAULT nextval('public."Room_id_seq"'::regclass);


--
-- Name: ScenarioStep id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."ScenarioStep" ALTER COLUMN id SET DEFAULT nextval('public."ScenarioStep_id_seq"'::regclass);


--
-- Name: Stonk id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."Stonk" ALTER COLUMN id SET DEFAULT nextval('public."Stonk_id_seq"'::regclass);


--
-- Name: StonkUser id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."StonkUser" ALTER COLUMN id SET DEFAULT nextval('public."StonkUser_id_seq"'::regclass);


--
-- Name: User id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."User" ALTER COLUMN id SET DEFAULT nextval('public."User_id_seq"'::regclass);


--
-- Name: dividend id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.dividend ALTER COLUMN id SET DEFAULT nextval('public.dividend_id_seq'::regclass);


--
-- Name: market_news id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.market_news ALTER COLUMN id SET DEFAULT nextval('public.market_news_id_seq'::regclass);


--
-- Name: realtime_price id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.realtime_price ALTER COLUMN id SET DEFAULT nextval('public.realtime_price_id_seq'::regclass);


--
-- Data for Name: Leaderboard; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO public."Leaderboard" (id, "userId", "roomId", "netWorth", "startBudget", rank, "createdAt") VALUES (1, 1, NULL, 1000000, 1000000, 1, '2026-04-02 07:51:03.031');
INSERT INTO public."Leaderboard" (id, "userId", "roomId", "netWorth", "startBudget", rank, "createdAt") VALUES (2, 1, NULL, 1000000, 1000000, 2, '2026-04-02 07:51:03.029');
INSERT INTO public."Leaderboard" (id, "userId", "roomId", "netWorth", "startBudget", rank, "createdAt") VALUES (3, 1, NULL, 1144976.65, 1000000, 1, '2026-04-02 10:48:15.758');
INSERT INTO public."Leaderboard" (id, "userId", "roomId", "netWorth", "startBudget", rank, "createdAt") VALUES (4, 1, NULL, 1144976.65, 1000000, 2, '2026-04-02 10:48:15.759');
INSERT INTO public."Leaderboard" (id, "userId", "roomId", "netWorth", "startBudget", rank, "createdAt") VALUES (6, 7, 6, 1238123.44, 1000000, 2, '2026-04-02 12:11:15.4');
INSERT INTO public."Leaderboard" (id, "userId", "roomId", "netWorth", "startBudget", rank, "createdAt") VALUES (5, 7, 6, 1238123.44, 1000000, 1, '2026-04-02 12:11:15.399');
INSERT INTO public."Leaderboard" (id, "userId", "roomId", "netWorth", "startBudget", rank, "createdAt") VALUES (8, 7, 8, 979545.6333333333, 1000000, 2, '2026-04-02 12:19:16.687');
INSERT INTO public."Leaderboard" (id, "userId", "roomId", "netWorth", "startBudget", rank, "createdAt") VALUES (7, 7, 8, 979545.6333333333, 1000000, 1, '2026-04-02 12:19:16.686');
INSERT INTO public."Leaderboard" (id, "userId", "roomId", "netWorth", "startBudget", rank, "createdAt") VALUES (9, 1, 8, 964778.78, 1000000, 3, '2026-04-02 12:19:17.152');
INSERT INTO public."Leaderboard" (id, "userId", "roomId", "netWorth", "startBudget", rank, "createdAt") VALUES (10, 1, 8, 964778.78, 1000000, 3, '2026-04-02 12:19:17.155');
INSERT INTO public."Leaderboard" (id, "userId", "roomId", "netWorth", "startBudget", rank, "createdAt") VALUES (11, 19, NULL, 1695250.516083333, 1000000, 1, '2026-04-02 12:31:52.944');
INSERT INTO public."Leaderboard" (id, "userId", "roomId", "netWorth", "startBudget", rank, "createdAt") VALUES (12, 19, NULL, 1695250.516083333, 1000000, 1, '2026-04-02 12:31:52.985');
INSERT INTO public."Leaderboard" (id, "userId", "roomId", "netWorth", "startBudget", rank, "createdAt") VALUES (14, 24, 14, 1134059.25, 1000000, 1, '2026-04-02 12:59:25.487');
INSERT INTO public."Leaderboard" (id, "userId", "roomId", "netWorth", "startBudget", rank, "createdAt") VALUES (13, 24, 14, 1134059.25, 1000000, 2, '2026-04-02 12:59:25.486');
INSERT INTO public."Leaderboard" (id, "userId", "roomId", "netWorth", "startBudget", rank, "createdAt") VALUES (15, 11, 14, 958964.7100000001, 1000000, 3, '2026-04-02 12:59:27.691');
INSERT INTO public."Leaderboard" (id, "userId", "roomId", "netWorth", "startBudget", rank, "createdAt") VALUES (16, 11, 14, 958964.7100000001, 1000000, 3, '2026-04-02 12:59:27.694');
INSERT INTO public."Leaderboard" (id, "userId", "roomId", "netWorth", "startBudget", rank, "createdAt") VALUES (17, 28, NULL, 1001415.451666667, 1000000, 10, '2026-04-02 13:19:01.89');
INSERT INTO public."Leaderboard" (id, "userId", "roomId", "netWorth", "startBudget", rank, "createdAt") VALUES (18, 28, NULL, 1001415.451666667, 1000000, 9, '2026-04-02 13:19:01.89');
INSERT INTO public."Leaderboard" (id, "userId", "roomId", "netWorth", "startBudget", rank, "createdAt") VALUES (19, 6, NULL, 1000000, 1000000, 13, '2026-04-02 13:26:41.336');
INSERT INTO public."Leaderboard" (id, "userId", "roomId", "netWorth", "startBudget", rank, "createdAt") VALUES (20, 6, NULL, 1000000, 1000000, 11, '2026-04-02 13:26:41.338');
INSERT INTO public."Leaderboard" (id, "userId", "roomId", "netWorth", "startBudget", rank, "createdAt") VALUES (22, 6, NULL, 1000000, 1000000, 15, '2026-04-02 13:27:39.691');
INSERT INTO public."Leaderboard" (id, "userId", "roomId", "netWorth", "startBudget", rank, "createdAt") VALUES (21, 6, NULL, 1000000, 1000000, 11, '2026-04-02 13:27:39.69');
INSERT INTO public."Leaderboard" (id, "userId", "roomId", "netWorth", "startBudget", rank, "createdAt") VALUES (23, 29, NULL, 1000000, 1000000, 11, '2026-04-02 13:41:30.701');
INSERT INTO public."Leaderboard" (id, "userId", "roomId", "netWorth", "startBudget", rank, "createdAt") VALUES (24, 29, NULL, 1000000, 1000000, 11, '2026-04-02 13:41:30.699');
INSERT INTO public."Leaderboard" (id, "userId", "roomId", "netWorth", "startBudget", rank, "createdAt") VALUES (25, 29, NULL, 1000000, 1000000, 11, '2026-04-02 13:41:56.279');
INSERT INTO public."Leaderboard" (id, "userId", "roomId", "netWorth", "startBudget", rank, "createdAt") VALUES (26, 29, NULL, 1000000, 1000000, 11, '2026-04-02 14:13:40.651');
INSERT INTO public."Leaderboard" (id, "userId", "roomId", "netWorth", "startBudget", rank, "createdAt") VALUES (27, 29, NULL, 1000000, 1000000, 17, '2026-04-02 14:13:40.649');


--
-- Data for Name: News; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO public."News" (id, "scenarioId", "stepIndex", title, body, impact, sector) VALUES (1, '2014_ruble', 0, 'Рубль начинает падать', 'Курс доллара пробил 38 рублей впервые за несколько лет.', 'negative', NULL);
INSERT INTO public."News" (id, "scenarioId", "stepIndex", title, body, impact, sector) VALUES (2, '2014_ruble', 0, 'Нефть падает', 'Brent опустилась ниже $90 — первый раз с 2012 года.', 'negative', 'Нефть и газ');
INSERT INTO public."News" (id, "scenarioId", "stepIndex", title, body, impact, sector) VALUES (3, '2014_ruble', 0, 'Санкции расширяются', 'США и ЕС ввели новый пакет секторальных санкций.', 'negative', NULL);
INSERT INTO public."News" (id, "scenarioId", "stepIndex", title, body, impact, sector) VALUES (4, '2014_ruble', 1, 'Рубль ниже 42', 'Курс доллара пробил 42 рубля. ЦБ тратит $3 млрд резервов за неделю.', 'negative', NULL);
INSERT INTO public."News" (id, "scenarioId", "stepIndex", title, body, impact, sector) VALUES (5, '2014_ruble', 1, 'Нефть $82', 'Нефть упала до $82 — ОПЕК пока не планирует сокращать добычу.', 'negative', 'Нефть и газ');
INSERT INTO public."News" (id, "scenarioId", "stepIndex", title, body, impact, sector) VALUES (6, '2014_ruble', 1, 'Норникель держится', 'Слабый рубль поддерживает рублёвую выручку металлургов.', 'positive', 'Металлы');
INSERT INTO public."News" (id, "scenarioId", "stepIndex", title, body, impact, sector) VALUES (7, '2014_ruble', 2, 'ОПЕК: без сокращений', 'ОПЕК проголосовал за сохранение добычи. Нефть рухнула на 6% за день.', 'negative', 'Нефть и газ');
INSERT INTO public."News" (id, "scenarioId", "stepIndex", title, body, impact, sector) VALUES (8, '2014_ruble', 2, 'Рубль 48', 'Рубль продолжает падение. ЦБ повысил ставку до 9.5%.', 'negative', NULL);
INSERT INTO public."News" (id, "scenarioId", "stepIndex", title, body, impact, sector) VALUES (9, '2014_ruble', 2, 'Золото растёт', 'Золото растёт на фоне паники. Полюс выигрывает от слабого рубля.', 'positive', 'Металлы');
INSERT INTO public."News" (id, "scenarioId", "stepIndex", title, body, impact, sector) VALUES (10, '2014_ruble', 3, 'Чёрный вторник 16.12', 'Рубль обвалился до 80/$. ЦБ поднял ставку до 17% в 01:00 ночи.', 'negative', NULL);
INSERT INTO public."News" (id, "scenarioId", "stepIndex", title, body, impact, sector) VALUES (11, '2014_ruble', 3, 'Доллар 80 рублей', 'Банки останавливают продажу валюты. Люди штурмуют обменники.', 'negative', NULL);
INSERT INTO public."News" (id, "scenarioId", "stepIndex", title, body, impact, sector) VALUES (12, '2014_ruble', 3, 'MOEX закрылся в минус', 'Индекс MOEX потерял 15% за месяц.', 'negative', NULL);
INSERT INTO public."News" (id, "scenarioId", "stepIndex", title, body, impact, sector) VALUES (13, '2014_ruble', 4, 'Стабилизация', 'ЦБ интервенции помогли: рубль вернулся к 65. Рынок выдохнул.', 'positive', NULL);
INSERT INTO public."News" (id, "scenarioId", "stepIndex", title, body, impact, sector) VALUES (14, '2014_ruble', 4, 'Нефть $46', 'Нефть продолжает падение. Но рублёвые цены акций нефтяников выросли.', 'neutral', 'Нефть и газ');
INSERT INTO public."News" (id, "scenarioId", "stepIndex", title, body, impact, sector) VALUES (15, '2014_ruble', 4, 'Акции отскочили', 'SBER, GAZP и металлурги отскочили от дна.', 'positive', NULL);
INSERT INTO public."News" (id, "scenarioId", "stepIndex", title, body, impact, sector) VALUES (16, '2014_ruble', 5, 'Восстановление рынка', 'MOEX вырос на 20% от декабрьских минимумов.', 'positive', NULL);
INSERT INTO public."News" (id, "scenarioId", "stepIndex", title, body, impact, sector) VALUES (17, '2014_ruble', 5, 'Минские соглашения', 'Перемирие на Украине снижает геополитическую премию.', 'positive', NULL);
INSERT INTO public."News" (id, "scenarioId", "stepIndex", title, body, impact, sector) VALUES (18, '2014_ruble', 5, 'Рубль 62', 'Рубль укрепился до 62. Инфляция ещё высокая, но пик пройден.', 'positive', NULL);
INSERT INTO public."News" (id, "scenarioId", "stepIndex", title, body, impact, sector) VALUES (19, '2020_covid', 0, 'Первые новости из Китая', 'ВОЗ сообщает о новом вирусе в Ухане.', 'neutral', NULL);
INSERT INTO public."News" (id, "scenarioId", "stepIndex", title, body, impact, sector) VALUES (20, '2020_covid', 0, 'MOEX на максимумах', 'Российский рынок торгуется вблизи исторических максимумов.', 'positive', NULL);
INSERT INTO public."News" (id, "scenarioId", "stepIndex", title, body, impact, sector) VALUES (21, '2020_covid', 0, 'Нефть $65', 'Нефть стабильна. Газпром объявил рекордные дивиденды за 2019 год.', 'positive', 'Нефть и газ');
INSERT INTO public."News" (id, "scenarioId", "stepIndex", title, body, impact, sector) VALUES (22, '2020_covid', 1, 'Вирус идёт в Европу', 'Вспышки в Италии и Иране. Инвесторы начинают продавать.', 'negative', NULL);
INSERT INTO public."News" (id, "scenarioId", "stepIndex", title, body, impact, sector) VALUES (23, '2020_covid', 1, 'Нефть падает', 'Нефть упала ниже $55.', 'negative', 'Нефть и газ');
INSERT INTO public."News" (id, "scenarioId", "stepIndex", title, body, impact, sector) VALUES (24, '2020_covid', 1, 'ОПЕК+ переговоры', 'Россия и Саудовская Аравия не договорились о сокращении.', 'negative', 'Нефть и газ');
INSERT INTO public."News" (id, "scenarioId", "stepIndex", title, body, impact, sector) VALUES (25, '2020_covid', 2, 'ВОЗ: пандемия', '11 марта ВОЗ официально объявила пандемию COVID-19.', 'negative', NULL);
INSERT INTO public."News" (id, "scenarioId", "stepIndex", title, body, impact, sector) VALUES (26, '2020_covid', 2, 'Нефть −30% за день', 'ОПЕК+ распался. Нефть рухнула до $30.', 'negative', 'Нефть и газ');
INSERT INTO public."News" (id, "scenarioId", "stepIndex", title, body, impact, sector) VALUES (27, '2020_covid', 2, 'IMOEX −35%', 'Российский рынок потерял 35% за март.', 'negative', NULL);
INSERT INTO public."News" (id, "scenarioId", "stepIndex", title, body, impact, sector) VALUES (28, '2020_covid', 2, 'Рубль 81', 'Рубль ослаб до 81 за доллар.', 'negative', NULL);
INSERT INTO public."News" (id, "scenarioId", "stepIndex", title, body, impact, sector) VALUES (29, '2020_covid', 3, 'Нефть WTI в минус', '21 апреля фьючерсы WTI ушли на −$37.', 'negative', 'Нефть и газ');
INSERT INTO public."News" (id, "scenarioId", "stepIndex", title, body, impact, sector) VALUES (30, '2020_covid', 3, 'ОПЕК+ договорился', 'Рекордное сокращение на 9.7 млн б/сут.', 'positive', 'Нефть и газ');
INSERT INTO public."News" (id, "scenarioId", "stepIndex", title, body, impact, sector) VALUES (31, '2020_covid', 3, 'IT-компании растут', 'Яндекс и сервисы доставки фиксируют рекордные показатели.', 'positive', 'Технологии');
INSERT INTO public."News" (id, "scenarioId", "stepIndex", title, body, impact, sector) VALUES (32, '2020_covid', 4, 'Рынки отскакивают', 'Глобальные рынки выросли на 30%+ от мартовских минимумов.', 'positive', NULL);
INSERT INTO public."News" (id, "scenarioId", "stepIndex", title, body, impact, sector) VALUES (33, '2020_covid', 4, 'Нефть возвращается', 'Нефть вернулась выше $30.', 'positive', 'Нефть и газ');
INSERT INTO public."News" (id, "scenarioId", "stepIndex", title, body, impact, sector) VALUES (34, '2020_covid', 4, 'Сбер держится', 'Сбербанк подтвердил дивиденды за 2019 год.', 'positive', 'Банки');
INSERT INTO public."News" (id, "scenarioId", "stepIndex", title, body, impact, sector) VALUES (35, '2020_covid', 5, 'V-образное восстановление', 'MOEX вернул большую часть потерь марта.', 'positive', NULL);
INSERT INTO public."News" (id, "scenarioId", "stepIndex", title, body, impact, sector) VALUES (36, '2020_covid', 5, 'Нефть $42', 'Нефть восстановилась до $42.', 'positive', 'Нефть и газ');
INSERT INTO public."News" (id, "scenarioId", "stepIndex", title, body, impact, sector) VALUES (37, '2020_covid', 5, 'Итоги полугодия', 'IT выиграл, авиация и нефть — проиграли.', 'neutral', NULL);
INSERT INTO public."News" (id, "scenarioId", "stepIndex", title, body, impact, sector) VALUES (38, '2022_feb', 0, 'MOEX на рекордах', 'Январь начался с рекордов: IMOEX выше 3900 пунктов.', 'positive', NULL);
INSERT INTO public."News" (id, "scenarioId", "stepIndex", title, body, impact, sector) VALUES (39, '2022_feb', 0, 'Напряжение на границе', 'США предупреждает о риске военной операции.', 'neutral', NULL);
INSERT INTO public."News" (id, "scenarioId", "stepIndex", title, body, impact, sector) VALUES (40, '2022_feb', 0, 'Газпром — рекорд', 'Газпром объявил дивиденды 52 руб/акцию.', 'positive', 'Нефть и газ');
INSERT INTO public."News" (id, "scenarioId", "stepIndex", title, body, impact, sector) VALUES (41, '2022_feb', 1, 'MOEX −45% за день', '24 февраля — исторический антирекорд.', 'negative', NULL);
INSERT INTO public."News" (id, "scenarioId", "stepIndex", title, body, impact, sector) VALUES (42, '2022_feb', 1, 'Сбер −80%', 'Сбербанк потерял 80% капитализации за день.', 'negative', 'Банки');
INSERT INTO public."News" (id, "scenarioId", "stepIndex", title, body, impact, sector) VALUES (43, '2022_feb', 1, 'SWIFT отключение', 'Крупнейшие банки России отключены от SWIFT.', 'negative', 'Банки');
INSERT INTO public."News" (id, "scenarioId", "stepIndex", title, body, impact, sector) VALUES (44, '2022_feb', 1, 'ЦБ: ставка 20%', 'Ставка поднята до 20% для защиты рубля.', 'negative', NULL);
INSERT INTO public."News" (id, "scenarioId", "stepIndex", title, body, impact, sector) VALUES (45, '2022_feb', 1, 'Биржа закрыта', 'Московская биржа приостановила торги до 24 марта.', 'negative', NULL);
INSERT INTO public."News" (id, "scenarioId", "stepIndex", title, body, impact, sector) VALUES (46, '2022_feb', 2, 'Биржа открылась', '24 марта торги возобновились.', 'neutral', NULL);
INSERT INTO public."News" (id, "scenarioId", "stepIndex", title, body, impact, sector) VALUES (47, '2022_feb', 2, 'Нефть $130', 'Нефть Brent взлетела к $130 — рекорд с 2008 года.', 'positive', 'Нефть и газ');
INSERT INTO public."News" (id, "scenarioId", "stepIndex", title, body, impact, sector) VALUES (48, '2022_feb', 2, 'Рубль стабилизируется', 'ЦБ ввёл обязательную продажу 80% выручки экспортёрами.', 'positive', NULL);
INSERT INTO public."News" (id, "scenarioId", "stepIndex", title, body, impact, sector) VALUES (49, '2022_feb', 2, 'Заморозка резервов', 'Запад заморозил $300 млрд золотовалютных резервов ЦБ.', 'negative', NULL);
INSERT INTO public."News" (id, "scenarioId", "stepIndex", title, body, impact, sector) VALUES (50, '2022_feb', 3, 'Рынок адаптируется', 'MOEX восстановил часть потерь.', 'positive', NULL);
INSERT INTO public."News" (id, "scenarioId", "stepIndex", title, body, impact, sector) VALUES (51, '2022_feb', 3, 'ЦБ снижает ставку', 'ЦБ снизил ставку с 20% до 17%.', 'positive', NULL);
INSERT INTO public."News" (id, "scenarioId", "stepIndex", title, body, impact, sector) VALUES (52, '2022_feb', 3, 'Дивиденды под вопросом', 'Ряд компаний отменил дивиденды.', 'negative', NULL);
INSERT INTO public."News" (id, "scenarioId", "stepIndex", title, body, impact, sector) VALUES (53, '2022_feb', 3, 'Нефть по скидке', 'Российская нефть Urals продаётся с дисконтом $30.', 'neutral', 'Нефть и газ');
INSERT INTO public."News" (id, "scenarioId", "stepIndex", title, body, impact, sector) VALUES (54, '2023_rate', 0, 'ЦБ повышает ставку', 'ЦБ поднял ставку с 7.5% до 8.5%.', 'negative', NULL);
INSERT INTO public."News" (id, "scenarioId", "stepIndex", title, body, impact, sector) VALUES (55, '2023_rate', 0, 'MOEX восстанавливается', 'MOEX вырос на 40% с февральских минимумов 2022.', 'positive', NULL);
INSERT INTO public."News" (id, "scenarioId", "stepIndex", title, body, impact, sector) VALUES (56, '2023_rate', 0, 'Мятеж Пригожина', 'Кратковременный мятеж ЧВК Вагнер. Рынок быстро восстановился.', 'negative', NULL);
INSERT INTO public."News" (id, "scenarioId", "stepIndex", title, body, impact, sector) VALUES (57, '2023_rate', 1, 'Ставка 8.5% → 12%', 'Экстренное заседание ЦБ: ставка до 12% из-за обвала рубля.', 'negative', NULL);
INSERT INTO public."News" (id, "scenarioId", "stepIndex", title, body, impact, sector) VALUES (58, '2023_rate', 1, 'Рубль 100', 'Рубль впервые преодолел отметку 100 за доллар.', 'negative', NULL);
INSERT INTO public."News" (id, "scenarioId", "stepIndex", title, body, impact, sector) VALUES (59, '2023_rate', 1, 'Лукойл отчитался', 'Лукойл показал рекордную прибыль.', 'positive', 'Нефть и газ');
INSERT INTO public."News" (id, "scenarioId", "stepIndex", title, body, impact, sector) VALUES (60, '2023_rate', 2, 'Ставка 12% → 13%', 'ЦБ продолжает цикл повышения.', 'negative', NULL);
INSERT INTO public."News" (id, "scenarioId", "stepIndex", title, body, impact, sector) VALUES (61, '2023_rate', 2, 'Обязательная продажа', 'Правительство обязало экспортёров продавать 90% валютной выручки.', 'positive', NULL);
INSERT INTO public."News" (id, "scenarioId", "stepIndex", title, body, impact, sector) VALUES (62, '2023_rate', 2, 'IPO Астра', 'Группа Астра провела IPO на MOEX.', 'positive', 'Технологии');
INSERT INTO public."News" (id, "scenarioId", "stepIndex", title, body, impact, sector) VALUES (63, '2023_rate', 3, 'Ставка 13% → 15%', 'ЦБ снова повышает: 15%.', 'negative', NULL);
INSERT INTO public."News" (id, "scenarioId", "stepIndex", title, body, impact, sector) VALUES (64, '2023_rate', 3, 'Рубль 90', 'Рубль стабилизировался у 90.', 'positive', NULL);
INSERT INTO public."News" (id, "scenarioId", "stepIndex", title, body, impact, sector) VALUES (65, '2023_rate', 3, 'Нефть $95', 'Нефть поднялась до $95.', 'positive', 'Нефть и газ');
INSERT INTO public."News" (id, "scenarioId", "stepIndex", title, body, impact, sector) VALUES (66, '2023_rate', 4, 'Ставка 16%', 'ЦБ поднял ставку до 16%.', 'negative', NULL);
INSERT INTO public."News" (id, "scenarioId", "stepIndex", title, body, impact, sector) VALUES (67, '2023_rate', 4, 'Сбер: рекордная прибыль', 'Сбербанк заработал 1.3 трлн руб. за 9 месяцев.', 'positive', 'Банки');
INSERT INTO public."News" (id, "scenarioId", "stepIndex", title, body, impact, sector) VALUES (68, '2023_rate', 4, 'MOEX корректируется', 'MOEX потерял 8% от максимумов.', 'negative', NULL);
INSERT INTO public."News" (id, "scenarioId", "stepIndex", title, body, impact, sector) VALUES (69, '2023_rate', 5, 'Пик ставки?', 'Аналитики ожидают паузу в цикле повышения.', 'positive', NULL);
INSERT INTO public."News" (id, "scenarioId", "stepIndex", title, body, impact, sector) VALUES (70, '2023_rate', 5, 'Дивиденды ЛКОХ', 'Лукойл объявил промежуточные дивиденды. Доходность 8% за полгода.', 'positive', 'Нефть и газ');
INSERT INTO public."News" (id, "scenarioId", "stepIndex", title, body, impact, sector) VALUES (71, '2023_rate', 6, 'ЦБ держит ставку', 'ЦБ оставил ставку на 16%.', 'positive', NULL);
INSERT INTO public."News" (id, "scenarioId", "stepIndex", title, body, impact, sector) VALUES (72, '2023_rate', 6, 'Итоги 2023 года', 'MOEX вырос на 44% за год — лучший результат с 2009.', 'positive', NULL);
INSERT INTO public."News" (id, "scenarioId", "stepIndex", title, body, impact, sector) VALUES (73, '2023_rate', 6, 'Норникель дивиденды', 'Норникель сохранил дивиденды.', 'positive', 'Металлы');
INSERT INTO public."News" (id, "scenarioId", "stepIndex", title, body, impact, sector) VALUES (74, '2023_rate', 7, 'Старт 2024 — сильный', 'MOEX вырос на 5% в январе.', 'positive', NULL);
INSERT INTO public."News" (id, "scenarioId", "stepIndex", title, body, impact, sector) VALUES (75, '2023_rate', 7, 'Нефть $80', 'Дисконт Urals сократился до $12.', 'positive', 'Нефть и газ');
INSERT INTO public."News" (id, "scenarioId", "stepIndex", title, body, impact, sector) VALUES (76, '2023_rate', 7, 'Сбер: 1.5 трлн прибыли', 'Годовая прибыль Сбера — рекорд за всю историю.', 'positive', 'Банки');
INSERT INTO public."News" (id, "scenarioId", "stepIndex", title, body, impact, sector) VALUES (77, '2023_rate', 8, 'Инфляция снижается', 'Инфляция замедлилась до 7.4%.', 'positive', NULL);
INSERT INTO public."News" (id, "scenarioId", "stepIndex", title, body, impact, sector) VALUES (78, '2023_rate', 8, 'ЦБ сохранил 16%', 'Тон ЦБ стал мягче.', 'positive', NULL);
INSERT INTO public."News" (id, "scenarioId", "stepIndex", title, body, impact, sector) VALUES (79, '2023_rate', 9, 'Выборы прошли', 'Президентские выборы прошли без потрясений.', 'neutral', NULL);
INSERT INTO public."News" (id, "scenarioId", "stepIndex", title, body, impact, sector) VALUES (80, '2023_rate', 9, 'Ставка всё ещё 16%', 'Снижения не раньше второго полугодия.', 'negative', NULL);
INSERT INTO public."News" (id, "scenarioId", "stepIndex", title, body, impact, sector) VALUES (81, '2023_rate', 9, 'Итоги сценария', '10 месяцев роста ставки: дивидендные бумаги выиграли.', 'positive', NULL);
INSERT INTO public."News" (id, "scenarioId", "stepIndex", title, body, impact, sector) VALUES (82, '2014_ruble', 0, 'Рубль начинает падать', 'Курс доллара пробил 38 рублей впервые за несколько лет. Инвесторы нервничают.', 'negative', NULL);
INSERT INTO public."News" (id, "scenarioId", "stepIndex", title, body, impact, sector) VALUES (83, '2014_ruble', 0, 'Нефть падает', 'Brent опустилась ниже $90 — первый раз с 2012 года. Российский бюджет под давлением.', 'negative', 'Нефть и газ');
INSERT INTO public."News" (id, "scenarioId", "stepIndex", title, body, impact, sector) VALUES (84, '2014_ruble', 0, 'Санкции расширяются', 'США и ЕС ввели новый пакет секторальных санкций против России.', 'negative', NULL);
INSERT INTO public."News" (id, "scenarioId", "stepIndex", title, body, impact, sector) VALUES (85, '2014_ruble', 1, 'Рубль ниже 42', 'Курс доллара пробил 42 рубля. ЦБ тратит $3 млрд резервов за неделю.', 'negative', NULL);
INSERT INTO public."News" (id, "scenarioId", "stepIndex", title, body, impact, sector) VALUES (86, '2014_ruble', 1, 'Нефть $82', 'Нефть упала до $82 — ОПЕК пока не планирует сокращать добычу.', 'negative', 'Нефть и газ');
INSERT INTO public."News" (id, "scenarioId", "stepIndex", title, body, impact, sector) VALUES (87, '2014_ruble', 1, 'Норникель держится', 'Слабый рубль поддерживает рублёвую выручку металлургов.', 'positive', 'Металлы');
INSERT INTO public."News" (id, "scenarioId", "stepIndex", title, body, impact, sector) VALUES (88, '2014_ruble', 2, 'ОПЕК: без сокращений', 'ОПЕК проголосовал за сохранение добычи. Нефть рухнула на 6% за день.', 'negative', 'Нефть и газ');
INSERT INTO public."News" (id, "scenarioId", "stepIndex", title, body, impact, sector) VALUES (89, '2014_ruble', 2, 'Рубль 48', 'Рубль продолжает падение. ЦБ повысил ставку до 9.5%.', 'negative', NULL);
INSERT INTO public."News" (id, "scenarioId", "stepIndex", title, body, impact, sector) VALUES (90, '2014_ruble', 2, 'Золото растёт', 'Золото растёт на фоне паники. Полюс выигрывает от слабого рубля.', 'positive', 'Металлы');
INSERT INTO public."News" (id, "scenarioId", "stepIndex", title, body, impact, sector) VALUES (91, '2014_ruble', 3, 'Чёрный вторник 16.12', 'Рубль обвалился до 80/$. ЦБ поднял ставку до 17% в 01:00 ночи. Исторический кризис.', 'negative', NULL);
INSERT INTO public."News" (id, "scenarioId", "stepIndex", title, body, impact, sector) VALUES (92, '2014_ruble', 3, 'Доллар 80 рублей', 'Банки останавливают продажу валюты. Люди штурмуют обменники и магазины электроники.', 'negative', NULL);
INSERT INTO public."News" (id, "scenarioId", "stepIndex", title, body, impact, sector) VALUES (93, '2014_ruble', 3, 'MOEX закрылся в минус', 'Индекс MOEX потерял 15% за месяц. Часть акций заморожена из-за волатильности.', 'negative', NULL);
INSERT INTO public."News" (id, "scenarioId", "stepIndex", title, body, impact, sector) VALUES (94, '2014_ruble', 4, 'Стабилизация', 'ЦБ интервенции помогли: рубль вернулся к 65. Рынок выдохнул.', 'positive', NULL);
INSERT INTO public."News" (id, "scenarioId", "stepIndex", title, body, impact, sector) VALUES (95, '2014_ruble', 4, 'Нефть $46', 'Нефть продолжает падение. Но рублёвые цены акций нефтяников выросли.', 'neutral', 'Нефть и газ');
INSERT INTO public."News" (id, "scenarioId", "stepIndex", title, body, impact, sector) VALUES (96, '2014_ruble', 4, 'Акции отскочили', 'SBER, GAZP и металлурги отскочили от дна. Время покупать?', 'positive', NULL);
INSERT INTO public."News" (id, "scenarioId", "stepIndex", title, body, impact, sector) VALUES (97, '2014_ruble', 5, 'Восстановление рынка', 'MOEX вырос на 20% от декабрьских минимумов. Кризис разворачивается.', 'positive', NULL);
INSERT INTO public."News" (id, "scenarioId", "stepIndex", title, body, impact, sector) VALUES (98, '2014_ruble', 5, 'Минские соглашения', 'Перемирие на Украине снижает геополитическую премию. Рынок реагирует позитивно.', 'positive', NULL);
INSERT INTO public."News" (id, "scenarioId", "stepIndex", title, body, impact, sector) VALUES (99, '2014_ruble', 5, 'Рубль 62', 'Рубль укрепился до 62. Инфляция ещё высокая, но пик пройден.', 'positive', NULL);
INSERT INTO public."News" (id, "scenarioId", "stepIndex", title, body, impact, sector) VALUES (100, '2014_ruble', 12, 'ЦБ снизил ставку до 11%', 'Центробанк начал цикл снижения ставки. Банковский сектор получил поддержку.', 'positive', NULL);
INSERT INTO public."News" (id, "scenarioId", "stepIndex", title, body, impact, sector) VALUES (101, '2014_ruble', 16, 'Нефть $28 — многолетний минимум', 'Нефть обновила 12-летний минимум. Рубль ослаб до 82. Бюджет дефицитный.', 'negative', 'Нефть и газ');
INSERT INTO public."News" (id, "scenarioId", "stepIndex", title, body, impact, sector) VALUES (102, '2014_ruble', 16, 'ЦБ держит ставку 11%', 'Ставка осталась 11% несмотря на волатильность рубля.', 'neutral', NULL);
INSERT INTO public."News" (id, "scenarioId", "stepIndex", title, body, impact, sector) VALUES (103, '2014_ruble', 26, 'ОПЕК+ договорился!', 'Впервые за 8 лет ОПЕК договорился с Россией о сокращении добычи. Нефть +10%.', 'positive', 'Нефть и газ');
INSERT INTO public."News" (id, "scenarioId", "stepIndex", title, body, impact, sector) VALUES (104, '2014_ruble', 26, 'Трамп победил на выборах', 'Рынки ожидают потепления отношений США-Россия. MOEX отреагировал ростом.', 'positive', NULL);
INSERT INTO public."News" (id, "scenarioId", "stepIndex", title, body, impact, sector) VALUES (105, '2014_ruble', 31, 'ОПЕК+ продлевает сделку', 'Россия и ОПЕК продлили сокращение добычи до конца 2017.', 'positive', 'Нефть и газ');
INSERT INTO public."News" (id, "scenarioId", "stepIndex", title, body, impact, sector) VALUES (106, '2014_ruble', 43, 'Санкции США против Русала', 'Rusal и Дерипаска под санкциями. Акции металлургов рухнули на 30-50% за день.', 'negative', 'Металлы');
INSERT INTO public."News" (id, "scenarioId", "stepIndex", title, body, impact, sector) VALUES (107, '2014_ruble', 43, 'Рубль ослаб до 65', 'Санкции против олигархов спровоцировали волну продаж рубля.', 'negative', NULL);
INSERT INTO public."News" (id, "scenarioId", "stepIndex", title, body, impact, sector) VALUES (108, '2014_ruble', 54, 'Газпром: рекордные дивиденды', 'ГАЗП перешёл на выплату 50% прибыли. Дивидендная доходность ~17%. Акции +30%.', 'positive', 'Нефть и газ');
INSERT INTO public."News" (id, "scenarioId", "stepIndex", title, body, impact, sector) VALUES (109, '2014_ruble', 74, 'Вакцина Pfizer 90%+', 'Pfizer объявила эффективность вакцины. Мировые рынки +5-10% за день.', 'positive', NULL);
INSERT INTO public."News" (id, "scenarioId", "stepIndex", title, body, impact, sector) VALUES (110, '2014_ruble', 74, 'Спутник V зарегистрирован', 'Россия первой зарегистрировала вакцину от COVID-19.', 'positive', NULL);
INSERT INTO public."News" (id, "scenarioId", "stepIndex", title, body, impact, sector) VALUES (111, '2014_ruble', 80, 'IMOEX побил рекорд 3800', 'Российский рынок обновил исторический максимум. Нефть вернулась к $70.', 'positive', NULL);
INSERT INTO public."News" (id, "scenarioId", "stepIndex", title, body, impact, sector) VALUES (112, '2014_ruble', 93, 'ГАЗП отказался от дивидендов!', 'Газпром отказался выплатить дивиденды за 2021 год. Акция рухнула на 30% за день. Исторический удар по доверию инвесторов.', 'negative', 'Нефть и газ');
INSERT INTO public."News" (id, "scenarioId", "stepIndex", title, body, impact, sector) VALUES (113, '2014_ruble', 93, 'ЕС: 6-й пакет санкций', 'Евросоюз запретил импорт российской нефти. Рынок нефти перестраивается.', 'negative', 'Нефть и газ');
INSERT INTO public."News" (id, "scenarioId", "stepIndex", title, body, impact, sector) VALUES (114, '2014_ruble', 97, 'ОПЕК+ сократил добычу на 2 млн б/с', 'ОПЕК+ шокировал рынок масштабным сокращением. Нефть выросла до $97.', 'positive', 'Нефть и газ');
INSERT INTO public."News" (id, "scenarioId", "stepIndex", title, body, impact, sector) VALUES (115, '2014_ruble', 101, 'Сбер вернул дивиденды!', 'Сбербанк объявил дивиденды 25 руб/акцию за 2022 год. Акции выросли на 10%.', 'positive', 'Банки');
INSERT INTO public."News" (id, "scenarioId", "stepIndex", title, body, impact, sector) VALUES (116, '2014_ruble', 115, 'ЦБ сохранил ставку 16%', 'Апрельское заседание без изменений. Рынок рассчитывал на снижение — ждёт июня.', 'negative', NULL);
INSERT INTO public."News" (id, "scenarioId", "stepIndex", title, body, impact, sector) VALUES (117, '2014_ruble', 115, 'Нефть $90', 'Нефть дорожает на фоне напряжённости на Ближнем Востоке. Нефтяники в плюсе.', 'positive', 'Нефть и газ');
INSERT INTO public."News" (id, "scenarioId", "stepIndex", title, body, impact, sector) VALUES (118, '2014_ruble', 118, 'ЦБ поднял ставку до 18%!', 'Инфляция не снижается. ЦБ поднял ставку до 18% — максимум с 2022 года. Акции роста под давлением.', 'negative', NULL);
INSERT INTO public."News" (id, "scenarioId", "stepIndex", title, body, impact, sector) VALUES (119, '2014_ruble', 118, 'Рубль слабеет', 'Рубль ослаб на фоне бюджетных расходов и санкционного давления.', 'negative', NULL);
INSERT INTO public."News" (id, "scenarioId", "stepIndex", title, body, impact, sector) VALUES (120, '2014_ruble', 121, 'ЦБ повысил до 21%!', 'Ключевая ставка 21% — исторический максимум. Рынок упал на 5%. Банки предлагают вклады под 20%+.', 'negative', NULL);
INSERT INTO public."News" (id, "scenarioId", "stepIndex", title, body, impact, sector) VALUES (121, '2014_ruble', 125, 'Сигналы к переговорам', 'Первые контакты по урегулированию конфликта. MOEX отреагировал ростом на 3%.', 'positive', NULL);
INSERT INTO public."News" (id, "scenarioId", "stepIndex", title, body, impact, sector) VALUES (122, '2014_ruble', 125, 'ЦБ: пауза в повышении', 'ЦБ оставил ставку на 21%. Риторика стала заметно мягче.', 'positive', NULL);
INSERT INTO public."News" (id, "scenarioId", "stepIndex", title, body, impact, sector) VALUES (123, '2014_ruble', 129, 'ЦБ снизил ставку до 19%!', 'Первое снижение ставки с 2022 года. Рынок вырос на 4% за день. Цикл смягчения начался.', 'positive', NULL);
INSERT INTO public."News" (id, "scenarioId", "stepIndex", title, body, impact, sector) VALUES (124, '2014_ruble', 129, 'Инфляция замедлилась', 'Инфляция упала ниже 10%. Аналитики ждут продолжения снижения ставки.', 'positive', NULL);
INSERT INTO public."News" (id, "scenarioId", "stepIndex", title, body, impact, sector) VALUES (125, '2014_ruble', 134, 'ЦБ снизил ставку до 17%', 'Последовательное снижение: 21% → 19% → 17%. IMOEX достиг нового максимума.', 'positive', NULL);
INSERT INTO public."News" (id, "scenarioId", "stepIndex", title, body, impact, sector) VALUES (126, '2014_ruble', 134, 'IMOEX 3500', 'Рынок восстановился к уровням начала 2024. Дивидендный сезон радует инвесторов.', 'positive', NULL);
INSERT INTO public."News" (id, "scenarioId", "stepIndex", title, body, impact, sector) VALUES (127, '2014_ruble', 136, 'ЦБ снизил ставку до 16%', 'Ставка вернулась к уровням начала 2024. Рынок продолжает рост.', 'positive', NULL);
INSERT INTO public."News" (id, "scenarioId", "stepIndex", title, body, impact, sector) VALUES (128, '2014_ruble', 136, 'Норникель: открытие в Арктике', 'ГМКН объявил о крупном месторождении. Акции +8% за день.', 'positive', 'Металлы');
INSERT INTO public."News" (id, "scenarioId", "stepIndex", title, body, impact, sector) VALUES (129, '2020_covid', 0, 'Первые новости из Китая', 'ВОЗ сообщает о новом вирусе в Ухане. Рынки пока спокойны — "просто грипп".', 'neutral', NULL);
INSERT INTO public."News" (id, "scenarioId", "stepIndex", title, body, impact, sector) VALUES (130, '2020_covid', 0, 'MOEX на максимумах', 'Российский рынок торгуется вблизи исторических максимумов. Дивидендный сезон впереди.', 'positive', NULL);
INSERT INTO public."News" (id, "scenarioId", "stepIndex", title, body, impact, sector) VALUES (131, '2020_covid', 0, 'Нефть $65', 'Нефть стабильна. Газпром объявил рекордные дивиденды за 2019 год.', 'positive', 'Нефть и газ');
INSERT INTO public."News" (id, "scenarioId", "stepIndex", title, body, impact, sector) VALUES (132, '2020_covid', 1, 'Вирус идёт в Европу', 'Вспышки в Италии и Иране. Инвесторы начинают продавать рискованные активы.', 'negative', NULL);
INSERT INTO public."News" (id, "scenarioId", "stepIndex", title, body, impact, sector) VALUES (133, '2020_covid', 1, 'Нефть падает', 'Нефть упала ниже $55 на опасениях снижения спроса.', 'negative', 'Нефть и газ');
INSERT INTO public."News" (id, "scenarioId", "stepIndex", title, body, impact, sector) VALUES (134, '2020_covid', 1, 'ОПЕК+ переговоры', 'Россия и Саудовская Аравия не могут договориться о сокращении добычи.', 'negative', 'Нефть и газ');
INSERT INTO public."News" (id, "scenarioId", "stepIndex", title, body, impact, sector) VALUES (135, '2020_covid', 2, 'ВОЗ: пандемия', '11 марта ВОЗ официально объявила пандемию COVID-19. Локдауны по всему миру.', 'negative', NULL);
INSERT INTO public."News" (id, "scenarioId", "stepIndex", title, body, impact, sector) VALUES (136, '2020_covid', 2, 'Нефть −30% за день', 'ОПЕК+ распался. Саудовская Аравия начала ценовую войну. Нефть рухнула до $30.', 'negative', 'Нефть и газ');
INSERT INTO public."News" (id, "scenarioId", "stepIndex", title, body, impact, sector) VALUES (137, '2020_covid', 2, 'IMOEX −35%', 'Российский рынок потерял 35% за март. Один из худших месяцев в истории биржи.', 'negative', NULL);
INSERT INTO public."News" (id, "scenarioId", "stepIndex", title, body, impact, sector) VALUES (138, '2020_covid', 2, 'Рубль 81', 'Рубль ослаб до 81 за доллар. ЦБ начал продавать валюту.', 'negative', NULL);
INSERT INTO public."News" (id, "scenarioId", "stepIndex", title, body, impact, sector) VALUES (139, '2020_covid', 3, 'Нефть WTI в минус', '21 апреля фьючерсы WTI ушли на −$37 — хранилища переполнены. Исторический случай.', 'negative', 'Нефть и газ');
INSERT INTO public."News" (id, "scenarioId", "stepIndex", title, body, impact, sector) VALUES (140, '2020_covid', 3, 'ОПЕК+ договорился', 'Рекордное сокращение на 9.7 млн баррелей в сутки. Нефть немного отскочила.', 'positive', 'Нефть и газ');
INSERT INTO public."News" (id, "scenarioId", "stepIndex", title, body, impact, sector) VALUES (141, '2020_covid', 3, 'IT-компании растут', 'Яндекс, Mail.ru и сервисы доставки фиксируют рекордные показатели.', 'positive', 'Технологии');
INSERT INTO public."News" (id, "scenarioId", "stepIndex", title, body, impact, sector) VALUES (142, '2020_covid', 4, 'Рынки отскакивают', 'Глобальные рынки выросли на 30%+ от мартовских минимумов. Деньги ФРС работают.', 'positive', NULL);
INSERT INTO public."News" (id, "scenarioId", "stepIndex", title, body, impact, sector) VALUES (143, '2020_covid', 4, 'Нефть возвращается', 'Нефть вернулась выше $30. Спрос постепенно восстанавливается.', 'positive', 'Нефть и газ');
INSERT INTO public."News" (id, "scenarioId", "stepIndex", title, body, impact, sector) VALUES (144, '2020_covid', 4, 'Сбер держится', 'Сбербанк подтвердил дивиденды за 2019 год. Акции восстанавливаются.', 'positive', 'Банки');
INSERT INTO public."News" (id, "scenarioId", "stepIndex", title, body, impact, sector) VALUES (145, '2020_covid', 5, 'V-образное восстановление', 'MOEX вернул большую часть потерь марта. Оптимизм по поводу открытия экономик.', 'positive', NULL);
INSERT INTO public."News" (id, "scenarioId", "stepIndex", title, body, impact, sector) VALUES (146, '2020_covid', 5, 'Нефть $42', 'Нефть восстановилась до $42. ОПЕК+ соблюдает договорённости.', 'positive', 'Нефть и газ');
INSERT INTO public."News" (id, "scenarioId", "stepIndex", title, body, impact, sector) VALUES (147, '2020_covid', 5, 'Итоги полугодия', 'Полгода пандемии: IT выиграл, авиация и нефть — проиграли. Новая реальность.', 'neutral', NULL);
INSERT INTO public."News" (id, "scenarioId", "stepIndex", title, body, impact, sector) VALUES (148, '2020_covid', 10, 'Вакцина Pfizer 90%+', 'Pfizer объявила эффективность вакцины. Мировые рынки +5-10% за день.', 'positive', NULL);
INSERT INTO public."News" (id, "scenarioId", "stepIndex", title, body, impact, sector) VALUES (149, '2020_covid', 10, 'Спутник V зарегистрирован', 'Россия первой зарегистрировала вакцину от COVID-19.', 'positive', NULL);
INSERT INTO public."News" (id, "scenarioId", "stepIndex", title, body, impact, sector) VALUES (150, '2020_covid', 16, 'IMOEX побил рекорд 3800', 'Российский рынок обновил исторический максимум. Нефть вернулась к $70.', 'positive', NULL);
INSERT INTO public."News" (id, "scenarioId", "stepIndex", title, body, impact, sector) VALUES (151, '2020_covid', 29, 'ГАЗП отказался от дивидендов!', 'Газпром отказался выплатить дивиденды за 2021 год. Акция рухнула на 30% за день. Исторический удар по доверию инвесторов.', 'negative', 'Нефть и газ');
INSERT INTO public."News" (id, "scenarioId", "stepIndex", title, body, impact, sector) VALUES (152, '2020_covid', 29, 'ЕС: 6-й пакет санкций', 'Евросоюз запретил импорт российской нефти. Рынок нефти перестраивается.', 'negative', 'Нефть и газ');
INSERT INTO public."News" (id, "scenarioId", "stepIndex", title, body, impact, sector) VALUES (153, '2020_covid', 33, 'ОПЕК+ сократил добычу на 2 млн б/с', 'ОПЕК+ шокировал рынок масштабным сокращением. Нефть выросла до $97.', 'positive', 'Нефть и газ');
INSERT INTO public."News" (id, "scenarioId", "stepIndex", title, body, impact, sector) VALUES (154, '2020_covid', 37, 'Сбер вернул дивиденды!', 'Сбербанк объявил дивиденды 25 руб/акцию за 2022 год. Акции выросли на 10%.', 'positive', 'Банки');
INSERT INTO public."News" (id, "scenarioId", "stepIndex", title, body, impact, sector) VALUES (155, '2020_covid', 51, 'ЦБ сохранил ставку 16%', 'Апрельское заседание без изменений. Рынок рассчитывал на снижение — ждёт июня.', 'negative', NULL);
INSERT INTO public."News" (id, "scenarioId", "stepIndex", title, body, impact, sector) VALUES (156, '2020_covid', 51, 'Нефть $90', 'Нефть дорожает на фоне напряжённости на Ближнем Востоке. Нефтяники в плюсе.', 'positive', 'Нефть и газ');
INSERT INTO public."News" (id, "scenarioId", "stepIndex", title, body, impact, sector) VALUES (157, '2020_covid', 54, 'ЦБ поднял ставку до 18%!', 'Инфляция не снижается. ЦБ поднял ставку до 18% — максимум с 2022 года. Акции роста под давлением.', 'negative', NULL);
INSERT INTO public."News" (id, "scenarioId", "stepIndex", title, body, impact, sector) VALUES (158, '2020_covid', 54, 'Рубль слабеет', 'Рубль ослаб на фоне бюджетных расходов и санкционного давления.', 'negative', NULL);
INSERT INTO public."News" (id, "scenarioId", "stepIndex", title, body, impact, sector) VALUES (159, '2020_covid', 57, 'ЦБ повысил до 21%!', 'Ключевая ставка 21% — исторический максимум. Рынок упал на 5%. Банки предлагают вклады под 20%+.', 'negative', NULL);
INSERT INTO public."News" (id, "scenarioId", "stepIndex", title, body, impact, sector) VALUES (160, '2020_covid', 61, 'Сигналы к переговорам', 'Первые контакты по урегулированию конфликта. MOEX отреагировал ростом на 3%.', 'positive', NULL);
INSERT INTO public."News" (id, "scenarioId", "stepIndex", title, body, impact, sector) VALUES (161, '2020_covid', 61, 'ЦБ: пауза в повышении', 'ЦБ оставил ставку на 21%. Риторика стала заметно мягче.', 'positive', NULL);
INSERT INTO public."News" (id, "scenarioId", "stepIndex", title, body, impact, sector) VALUES (162, '2020_covid', 65, 'ЦБ снизил ставку до 19%!', 'Первое снижение ставки с 2022 года. Рынок вырос на 4% за день. Цикл смягчения начался.', 'positive', NULL);
INSERT INTO public."News" (id, "scenarioId", "stepIndex", title, body, impact, sector) VALUES (163, '2020_covid', 65, 'Инфляция замедлилась', 'Инфляция упала ниже 10%. Аналитики ждут продолжения снижения ставки.', 'positive', NULL);
INSERT INTO public."News" (id, "scenarioId", "stepIndex", title, body, impact, sector) VALUES (164, '2020_covid', 70, 'ЦБ снизил ставку до 17%', 'Последовательное снижение: 21% → 19% → 17%. IMOEX достиг нового максимума.', 'positive', NULL);
INSERT INTO public."News" (id, "scenarioId", "stepIndex", title, body, impact, sector) VALUES (165, '2020_covid', 70, 'IMOEX 3500', 'Рынок восстановился к уровням начала 2024. Дивидендный сезон радует инвесторов.', 'positive', NULL);
INSERT INTO public."News" (id, "scenarioId", "stepIndex", title, body, impact, sector) VALUES (166, '2020_covid', 72, 'ЦБ снизил ставку до 16%', 'Ставка вернулась к уровням начала 2024. Рынок продолжает рост.', 'positive', NULL);
INSERT INTO public."News" (id, "scenarioId", "stepIndex", title, body, impact, sector) VALUES (167, '2020_covid', 72, 'Норникель: открытие в Арктике', 'ГМКН объявил о крупном месторождении. Акции +8% за день.', 'positive', 'Металлы');
INSERT INTO public."News" (id, "scenarioId", "stepIndex", title, body, impact, sector) VALUES (168, '2022_feb', 0, 'MOEX на рекордах', 'Январь начался с рекордов: IMOEX выше 3900 пунктов. Дивидендный сезон впереди.', 'positive', NULL);
INSERT INTO public."News" (id, "scenarioId", "stepIndex", title, body, impact, sector) VALUES (169, '2022_feb', 0, 'Напряжение на границе', 'США предупреждает о риске военной операции. Рынок пока игнорирует угрозу.', 'neutral', NULL);
INSERT INTO public."News" (id, "scenarioId", "stepIndex", title, body, impact, sector) VALUES (170, '2022_feb', 0, 'Газпром — рекорд', 'Газпром объявил дивиденды 52 руб/акцию. Инвесторы ликуют.', 'positive', 'Нефть и газ');
INSERT INTO public."News" (id, "scenarioId", "stepIndex", title, body, impact, sector) VALUES (171, '2022_feb', 1, 'MOEX −45% за день', '24 февраля — исторический антирекорд. MOEX потерял 45% за одну торговую сессию.', 'negative', NULL);
INSERT INTO public."News" (id, "scenarioId", "stepIndex", title, body, impact, sector) VALUES (172, '2022_feb', 1, 'Сбер −80%', 'Сбербанк потерял 80% капитализации за день. Западные инвесторы бегут.', 'negative', 'Банки');
INSERT INTO public."News" (id, "scenarioId", "stepIndex", title, body, impact, sector) VALUES (173, '2022_feb', 1, 'SWIFT отключение', 'Крупнейшие банки России отключены от SWIFT. Международные платежи заблокированы.', 'negative', 'Банки');
INSERT INTO public."News" (id, "scenarioId", "stepIndex", title, body, impact, sector) VALUES (174, '2022_feb', 1, 'ЦБ: ставка 20%', 'Экстренное заседание ЦБ в 22:30. Ставка поднята до 20% для защиты рубля.', 'negative', NULL);
INSERT INTO public."News" (id, "scenarioId", "stepIndex", title, body, impact, sector) VALUES (175, '2022_feb', 1, 'Биржа закрыта', 'Московская биржа приостановила торги до 24 марта. Инвесторы в панике.', 'negative', NULL);
INSERT INTO public."News" (id, "scenarioId", "stepIndex", title, body, impact, sector) VALUES (176, '2022_feb', 2, 'Биржа открылась', '24 марта торги возобновились. Доступ иностранцев к продаже ограничен.', 'neutral', NULL);
INSERT INTO public."News" (id, "scenarioId", "stepIndex", title, body, impact, sector) VALUES (177, '2022_feb', 2, 'Нефть $130', 'Нефть Brent взлетела к $130 — рекорд с 2008 года. Нефтяники в плюсе.', 'positive', 'Нефть и газ');
INSERT INTO public."News" (id, "scenarioId", "stepIndex", title, body, impact, sector) VALUES (178, '2022_feb', 2, 'Рубль стабилизируется', 'ЦБ ввёл обязательную продажу 80% выручки экспортёрами. Рубль стабилизировался.', 'positive', NULL);
INSERT INTO public."News" (id, "scenarioId", "stepIndex", title, body, impact, sector) VALUES (179, '2022_feb', 2, 'Заморозка резервов', 'Запад заморозил $300 млрд золотовалютных резервов ЦБ.', 'negative', NULL);
INSERT INTO public."News" (id, "scenarioId", "stepIndex", title, body, impact, sector) VALUES (180, '2022_feb', 3, 'Рынок адаптируется', 'MOEX восстановил часть потерь. Институциональные инвесторы выкупают позиции.', 'positive', NULL);
INSERT INTO public."News" (id, "scenarioId", "stepIndex", title, body, impact, sector) VALUES (181, '2022_feb', 3, 'ЦБ снижает ставку', 'ЦБ снизил ставку с 20% до 17%. Рынок воспринимает позитивно.', 'positive', NULL);
INSERT INTO public."News" (id, "scenarioId", "stepIndex", title, body, impact, sector) VALUES (182, '2022_feb', 3, 'Дивиденды под вопросом', 'Ряд компаний отменил дивиденды. Инвесторы переоценивают доходность.', 'negative', NULL);
INSERT INTO public."News" (id, "scenarioId", "stepIndex", title, body, impact, sector) VALUES (183, '2022_feb', 3, 'Нефть по скидке', 'Российская нефть Urals продаётся с дисконтом $30. Но объёмы сохраняются.', 'neutral', 'Нефть и газ');
INSERT INTO public."News" (id, "scenarioId", "stepIndex", title, body, impact, sector) VALUES (184, '2022_feb', 5, 'ГАЗП отказался от дивидендов!', 'Газпром отказался выплатить дивиденды за 2021 год. Акция рухнула на 30% за день. Исторический удар по доверию инвесторов.', 'negative', 'Нефть и газ');
INSERT INTO public."News" (id, "scenarioId", "stepIndex", title, body, impact, sector) VALUES (185, '2022_feb', 5, 'ЕС: 6-й пакет санкций', 'Евросоюз запретил импорт российской нефти. Рынок нефти перестраивается.', 'negative', 'Нефть и газ');
INSERT INTO public."News" (id, "scenarioId", "stepIndex", title, body, impact, sector) VALUES (186, '2022_feb', 9, 'ОПЕК+ сократил добычу на 2 млн б/с', 'ОПЕК+ шокировал рынок масштабным сокращением. Нефть выросла до $97.', 'positive', 'Нефть и газ');
INSERT INTO public."News" (id, "scenarioId", "stepIndex", title, body, impact, sector) VALUES (187, '2022_feb', 13, 'Сбер вернул дивиденды!', 'Сбербанк объявил дивиденды 25 руб/акцию за 2022 год. Акции выросли на 10%.', 'positive', 'Банки');
INSERT INTO public."News" (id, "scenarioId", "stepIndex", title, body, impact, sector) VALUES (188, '2022_feb', 27, 'ЦБ сохранил ставку 16%', 'Апрельское заседание без изменений. Рынок рассчитывал на снижение — ждёт июня.', 'negative', NULL);
INSERT INTO public."News" (id, "scenarioId", "stepIndex", title, body, impact, sector) VALUES (189, '2022_feb', 27, 'Нефть $90', 'Нефть дорожает на фоне напряжённости на Ближнем Востоке. Нефтяники в плюсе.', 'positive', 'Нефть и газ');
INSERT INTO public."News" (id, "scenarioId", "stepIndex", title, body, impact, sector) VALUES (190, '2022_feb', 30, 'ЦБ поднял ставку до 18%!', 'Инфляция не снижается. ЦБ поднял ставку до 18% — максимум с 2022 года. Акции роста под давлением.', 'negative', NULL);
INSERT INTO public."News" (id, "scenarioId", "stepIndex", title, body, impact, sector) VALUES (191, '2022_feb', 30, 'Рубль слабеет', 'Рубль ослаб на фоне бюджетных расходов и санкционного давления.', 'negative', NULL);
INSERT INTO public."News" (id, "scenarioId", "stepIndex", title, body, impact, sector) VALUES (192, '2022_feb', 33, 'ЦБ повысил до 21%!', 'Ключевая ставка 21% — исторический максимум. Рынок упал на 5%. Банки предлагают вклады под 20%+.', 'negative', NULL);
INSERT INTO public."News" (id, "scenarioId", "stepIndex", title, body, impact, sector) VALUES (193, '2022_feb', 37, 'Сигналы к переговорам', 'Первые контакты по урегулированию конфликта. MOEX отреагировал ростом на 3%.', 'positive', NULL);
INSERT INTO public."News" (id, "scenarioId", "stepIndex", title, body, impact, sector) VALUES (194, '2022_feb', 37, 'ЦБ: пауза в повышении', 'ЦБ оставил ставку на 21%. Риторика стала заметно мягче.', 'positive', NULL);
INSERT INTO public."News" (id, "scenarioId", "stepIndex", title, body, impact, sector) VALUES (195, '2022_feb', 41, 'ЦБ снизил ставку до 19%!', 'Первое снижение ставки с 2022 года. Рынок вырос на 4% за день. Цикл смягчения начался.', 'positive', NULL);
INSERT INTO public."News" (id, "scenarioId", "stepIndex", title, body, impact, sector) VALUES (196, '2022_feb', 41, 'Инфляция замедлилась', 'Инфляция упала ниже 10%. Аналитики ждут продолжения снижения ставки.', 'positive', NULL);
INSERT INTO public."News" (id, "scenarioId", "stepIndex", title, body, impact, sector) VALUES (197, '2022_feb', 46, 'ЦБ снизил ставку до 17%', 'Последовательное снижение: 21% → 19% → 17%. IMOEX достиг нового максимума.', 'positive', NULL);
INSERT INTO public."News" (id, "scenarioId", "stepIndex", title, body, impact, sector) VALUES (198, '2022_feb', 46, 'IMOEX 3500', 'Рынок восстановился к уровням начала 2024. Дивидендный сезон радует инвесторов.', 'positive', NULL);
INSERT INTO public."News" (id, "scenarioId", "stepIndex", title, body, impact, sector) VALUES (199, '2022_feb', 48, 'ЦБ снизил ставку до 16%', 'Ставка вернулась к уровням начала 2024. Рынок продолжает рост.', 'positive', NULL);
INSERT INTO public."News" (id, "scenarioId", "stepIndex", title, body, impact, sector) VALUES (200, '2022_feb', 48, 'Норникель: открытие в Арктике', 'ГМКН объявил о крупном месторождении. Акции +8% за день.', 'positive', 'Металлы');
INSERT INTO public."News" (id, "scenarioId", "stepIndex", title, body, impact, sector) VALUES (201, '2023_rate', 0, 'ЦБ повышает ставку', 'ЦБ поднял ставку с 7.5% до 8.5%. Инфляция ускоряется.', 'negative', NULL);
INSERT INTO public."News" (id, "scenarioId", "stepIndex", title, body, impact, sector) VALUES (202, '2023_rate', 0, 'MOEX восстанавливается', 'MOEX вырос на 40% с февральских минимумов 2022. Отечественные инвесторы активны.', 'positive', NULL);
INSERT INTO public."News" (id, "scenarioId", "stepIndex", title, body, impact, sector) VALUES (203, '2023_rate', 0, 'Мятеж Пригожина', 'Кратковременный мятеж ЧВК Вагнер. Рынок упал на 2% внутри дня, быстро восстановился.', 'negative', NULL);
INSERT INTO public."News" (id, "scenarioId", "stepIndex", title, body, impact, sector) VALUES (204, '2023_rate', 1, 'Ставка 8.5% → 12%', 'Экстренное заседание ЦБ: ставка поднята до 12% из-за обвала рубля.', 'negative', NULL);
INSERT INTO public."News" (id, "scenarioId", "stepIndex", title, body, impact, sector) VALUES (205, '2023_rate', 1, 'Рубль 100', 'Рубль впервые преодолел отметку 100 за доллар. ЦБ вынужден действовать.', 'negative', NULL);
INSERT INTO public."News" (id, "scenarioId", "stepIndex", title, body, impact, sector) VALUES (206, '2023_rate', 1, 'Лукойл отчитался', 'Лукойл показал рекордную прибыль. Дивидендные бумаги в фаворе.', 'positive', 'Нефть и газ');
INSERT INTO public."News" (id, "scenarioId", "stepIndex", title, body, impact, sector) VALUES (207, '2023_rate', 2, 'Ставка 12% → 13%', 'ЦБ продолжает цикл повышения. Перекладывайтесь из акций роста в дивидендные.', 'negative', NULL);
INSERT INTO public."News" (id, "scenarioId", "stepIndex", title, body, impact, sector) VALUES (208, '2023_rate', 2, 'Обязательная продажа', 'Правительство обязало экспортёров продавать 90% валютной выручки.', 'positive', NULL);
INSERT INTO public."News" (id, "scenarioId", "stepIndex", title, body, impact, sector) VALUES (209, '2023_rate', 2, 'IPO Астра', 'Группа Астра провела IPO на MOEX. Интерес к отечественным IT растёт.', 'positive', 'Технологии');
INSERT INTO public."News" (id, "scenarioId", "stepIndex", title, body, impact, sector) VALUES (210, '2023_rate', 3, 'Ставка 13% → 15%', 'ЦБ снова повышает: 15%. Вклады в банках — конкурент акциям.', 'negative', NULL);
INSERT INTO public."News" (id, "scenarioId", "stepIndex", title, body, impact, sector) VALUES (211, '2023_rate', 3, 'Рубль 90', 'Рубль стабилизировался у 90 после мер ЦБ.', 'positive', NULL);
INSERT INTO public."News" (id, "scenarioId", "stepIndex", title, body, impact, sector) VALUES (212, '2023_rate', 3, 'Нефть $95', 'Нефть поднялась до $95. Нефтяники показывают сильные результаты.', 'positive', 'Нефть и газ');
INSERT INTO public."News" (id, "scenarioId", "stepIndex", title, body, impact, sector) VALUES (213, '2023_rate', 4, 'Ставка 16%', 'ЦБ поднял ставку до 16%. Аналитики ждут пика цикла.', 'negative', NULL);
INSERT INTO public."News" (id, "scenarioId", "stepIndex", title, body, impact, sector) VALUES (214, '2023_rate', 4, 'Сбер: рекордная прибыль', 'Сбербанк заработал 1.3 трлн руб. за 9 месяцев. Рекорд.', 'positive', 'Банки');
INSERT INTO public."News" (id, "scenarioId", "stepIndex", title, body, impact, sector) VALUES (215, '2023_rate', 4, 'MOEX корректируется', 'Рост ставки давит на мультипликаторы. MOEX потерял 8% от максимумов.', 'negative', NULL);
INSERT INTO public."News" (id, "scenarioId", "stepIndex", title, body, impact, sector) VALUES (216, '2023_rate', 5, 'Пик ставки?', 'Аналитики ожидают паузу в цикле повышения. Рынок пытается восстановиться.', 'positive', NULL);
INSERT INTO public."News" (id, "scenarioId", "stepIndex", title, body, impact, sector) VALUES (217, '2023_rate', 5, 'Дивиденды ЛКОХ', 'Лукойл объявил промежуточные дивиденды. Доходность 8% за полгода.', 'positive', 'Нефть и газ');
INSERT INTO public."News" (id, "scenarioId", "stepIndex", title, body, impact, sector) VALUES (218, '2023_rate', 6, 'ЦБ держит ставку', 'ЦБ оставил ставку на 16%. Первые признаки паузы в цикле.', 'positive', NULL);
INSERT INTO public."News" (id, "scenarioId", "stepIndex", title, body, impact, sector) VALUES (219, '2023_rate', 6, 'Итоги 2023 года', 'MOEX вырос на 44% за год — лучший результат с 2009 года. Несмотря на ставку!', 'positive', NULL);
INSERT INTO public."News" (id, "scenarioId", "stepIndex", title, body, impact, sector) VALUES (220, '2023_rate', 6, 'Норникель дивиденды', 'Норникель сохранил дивиденды, несмотря на давление ставки.', 'positive', 'Металлы');
INSERT INTO public."News" (id, "scenarioId", "stepIndex", title, body, impact, sector) VALUES (221, '2023_rate', 7, 'Старт 2024 — сильный', 'MOEX вырос на 5% в январе. Инвесторы оптимистичны насчёт снижения ставки.', 'positive', NULL);
INSERT INTO public."News" (id, "scenarioId", "stepIndex", title, body, impact, sector) VALUES (222, '2023_rate', 7, 'Нефть $80', 'Нефть держится у $80. Дисконт Urals сократился до $12.', 'positive', 'Нефть и газ');
INSERT INTO public."News" (id, "scenarioId", "stepIndex", title, body, impact, sector) VALUES (223, '2023_rate', 7, 'Сбер: 1.5 трлн прибыли', 'Годовая прибыль Сбера — рекорд за всю историю. Дивиденды ожидаются высокие.', 'positive', 'Банки');
INSERT INTO public."News" (id, "scenarioId", "stepIndex", title, body, impact, sector) VALUES (224, '2023_rate', 8, 'Инфляция снижается', 'Инфляция замедлилась до 7.4%. Рынок закладывает первое снижение ставки в мае.', 'positive', NULL);
INSERT INTO public."News" (id, "scenarioId", "stepIndex", title, body, impact, sector) VALUES (225, '2023_rate', 8, 'ЦБ сохранил 16%', 'Февральское заседание: ставка осталась 16%. Но тон стал мягче.', 'positive', NULL);
INSERT INTO public."News" (id, "scenarioId", "stepIndex", title, body, impact, sector) VALUES (226, '2023_rate', 9, 'Выборы прошли', 'Президентские выборы прошли без потрясений. Рынок стабилен.', 'neutral', NULL);
INSERT INTO public."News" (id, "scenarioId", "stepIndex", title, body, impact, sector) VALUES (227, '2023_rate', 9, 'Ставка всё ещё 16%', 'ЦБ пока не снижает. Аналитики ждут снижения не раньше второго полугодия.', 'negative', NULL);
INSERT INTO public."News" (id, "scenarioId", "stepIndex", title, body, impact, sector) VALUES (228, '2023_rate', 9, 'Итоги сценария', '10 месяцев роста ставки: рынок устоял, дивидендные бумаги выиграли.', 'positive', NULL);
INSERT INTO public."News" (id, "scenarioId", "stepIndex", title, body, impact, sector) VALUES (229, '2023_rate', 10, 'ЦБ сохранил ставку 16%', 'Апрельское заседание без изменений. Рынок рассчитывал на снижение — ждёт июня.', 'negative', NULL);
INSERT INTO public."News" (id, "scenarioId", "stepIndex", title, body, impact, sector) VALUES (230, '2023_rate', 10, 'Нефть $90', 'Нефть дорожает на фоне напряжённости на Ближнем Востоке. Нефтяники в плюсе.', 'positive', 'Нефть и газ');
INSERT INTO public."News" (id, "scenarioId", "stepIndex", title, body, impact, sector) VALUES (231, '2023_rate', 13, 'ЦБ поднял ставку до 18%!', 'Инфляция не снижается. ЦБ поднял ставку до 18% — максимум с 2022 года. Акции роста под давлением.', 'negative', NULL);
INSERT INTO public."News" (id, "scenarioId", "stepIndex", title, body, impact, sector) VALUES (232, '2023_rate', 13, 'Рубль слабеет', 'Рубль ослаб на фоне бюджетных расходов и санкционного давления.', 'negative', NULL);
INSERT INTO public."News" (id, "scenarioId", "stepIndex", title, body, impact, sector) VALUES (233, '2023_rate', 16, 'ЦБ повысил до 21%!', 'Ключевая ставка 21% — исторический максимум. Рынок упал на 5%. Банки предлагают вклады под 20%+.', 'negative', NULL);
INSERT INTO public."News" (id, "scenarioId", "stepIndex", title, body, impact, sector) VALUES (234, '2023_rate', 20, 'Сигналы к переговорам', 'Первые контакты по урегулированию конфликта. MOEX отреагировал ростом на 3%.', 'positive', NULL);
INSERT INTO public."News" (id, "scenarioId", "stepIndex", title, body, impact, sector) VALUES (235, '2023_rate', 20, 'ЦБ: пауза в повышении', 'ЦБ оставил ставку на 21%. Риторика стала заметно мягче.', 'positive', NULL);
INSERT INTO public."News" (id, "scenarioId", "stepIndex", title, body, impact, sector) VALUES (236, '2023_rate', 24, 'ЦБ снизил ставку до 19%!', 'Первое снижение ставки с 2022 года. Рынок вырос на 4% за день. Цикл смягчения начался.', 'positive', NULL);
INSERT INTO public."News" (id, "scenarioId", "stepIndex", title, body, impact, sector) VALUES (237, '2023_rate', 24, 'Инфляция замедлилась', 'Инфляция упала ниже 10%. Аналитики ждут продолжения снижения ставки.', 'positive', NULL);
INSERT INTO public."News" (id, "scenarioId", "stepIndex", title, body, impact, sector) VALUES (238, '2023_rate', 29, 'ЦБ снизил ставку до 17%', 'Последовательное снижение: 21% → 19% → 17%. IMOEX достиг нового максимума.', 'positive', NULL);
INSERT INTO public."News" (id, "scenarioId", "stepIndex", title, body, impact, sector) VALUES (239, '2023_rate', 29, 'IMOEX 3500', 'Рынок восстановился к уровням начала 2024. Дивидендный сезон радует инвесторов.', 'positive', NULL);
INSERT INTO public."News" (id, "scenarioId", "stepIndex", title, body, impact, sector) VALUES (240, '2023_rate', 31, 'ЦБ снизил ставку до 16%', 'Ставка вернулась к уровням начала 2024. Рынок продолжает рост.', 'positive', NULL);
INSERT INTO public."News" (id, "scenarioId", "stepIndex", title, body, impact, sector) VALUES (241, '2023_rate', 31, 'Норникель: открытие в Арктике', 'ГМКН объявил о крупном месторождении. Акции +8% за день.', 'positive', 'Металлы');


--
-- Data for Name: Price; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO public."Price" (id, "stonkId", year, month, price) VALUES (34, 6, 2014, 12, 23.81);
INSERT INTO public."Price" (id, "stonkId", year, month, price) VALUES (133, 5, 2020, 1, 480.7);
INSERT INTO public."Price" (id, "stonkId", year, month, price) VALUES (134, 5, 2020, 2, 405.55);
INSERT INTO public."Price" (id, "stonkId", year, month, price) VALUES (141, 6, 2020, 3, 32.8);
INSERT INTO public."Price" (id, "stonkId", year, month, price) VALUES (136, 5, 2020, 4, 338.55);
INSERT INTO public."Price" (id, "stonkId", year, month, price) VALUES (9, 2, 2014, 11, 143.37);
INSERT INTO public."Price" (id, "stonkId", year, month, price) VALUES (3, 1, 2014, 11, 72.12);
INSERT INTO public."Price" (id, "stonkId", year, month, price) VALUES (4, 1, 2014, 12, 53.91);
INSERT INTO public."Price" (id, "stonkId", year, month, price) VALUES (5, 1, 2015, 1, 60.58);
INSERT INTO public."Price" (id, "stonkId", year, month, price) VALUES (6, 1, 2015, 2, 76);
INSERT INTO public."Price" (id, "stonkId", year, month, price) VALUES (109, 1, 2020, 1, 255.62);
INSERT INTO public."Price" (id, "stonkId", year, month, price) VALUES (110, 1, 2020, 2, 234.71);
INSERT INTO public."Price" (id, "stonkId", year, month, price) VALUES (117, 2, 2020, 3, 181.25);
INSERT INTO public."Price" (id, "stonkId", year, month, price) VALUES (112, 1, 2020, 4, 197.35);
INSERT INTO public."Price" (id, "stonkId", year, month, price) VALUES (113, 1, 2020, 5, 201.26);
INSERT INTO public."Price" (id, "stonkId", year, month, price) VALUES (120, 2, 2020, 6, 195.43);
INSERT INTO public."Price" (id, "stonkId", year, month, price) VALUES (7, 2, 2014, 9, 137.38);
INSERT INTO public."Price" (id, "stonkId", year, month, price) VALUES (14, 3, 2014, 10, 2091.3);
INSERT INTO public."Price" (id, "stonkId", year, month, price) VALUES (10, 2, 2014, 12, 131.48);
INSERT INTO public."Price" (id, "stonkId", year, month, price) VALUES (11, 2, 2015, 1, 143.28);
INSERT INTO public."Price" (id, "stonkId", year, month, price) VALUES (12, 2, 2015, 2, 151.43);
INSERT INTO public."Price" (id, "stonkId", year, month, price) VALUES (115, 2, 2020, 1, 229.74);
INSERT INTO public."Price" (id, "stonkId", year, month, price) VALUES (116, 2, 2020, 2, 205.8);
INSERT INTO public."Price" (id, "stonkId", year, month, price) VALUES (15, 3, 2014, 11, 2299.1);
INSERT INTO public."Price" (id, "stonkId", year, month, price) VALUES (119, 2, 2020, 5, 198.19);
INSERT INTO public."Price" (id, "stonkId", year, month, price) VALUES (17, 3, 2015, 1, 2819.5);
INSERT INTO public."Price" (id, "stonkId", year, month, price) VALUES (13, 3, 2014, 9, 2020.9);
INSERT INTO public."Price" (id, "stonkId", year, month, price) VALUES (18, 3, 2015, 2, 2964.9);
INSERT INTO public."Price" (id, "stonkId", year, month, price) VALUES (122, 3, 2020, 2, 5719);
INSERT INTO public."Price" (id, "stonkId", year, month, price) VALUES (16, 3, 2014, 12, 2217.5);
INSERT INTO public."Price" (id, "stonkId", year, month, price) VALUES (125, 3, 2020, 5, 5267.5);
INSERT INTO public."Price" (id, "stonkId", year, month, price) VALUES (126, 3, 2020, 6, 5318.5);
INSERT INTO public."Price" (id, "stonkId", year, month, price) VALUES (121, 3, 2020, 1, 6599);
INSERT INTO public."Price" (id, "stonkId", year, month, price) VALUES (19, 4, 2014, 9, 406.13);
INSERT INTO public."Price" (id, "stonkId", year, month, price) VALUES (123, 3, 2020, 3, 4630.5);
INSERT INTO public."Price" (id, "stonkId", year, month, price) VALUES (124, 3, 2020, 4, 4906.5);
INSERT INTO public."Price" (id, "stonkId", year, month, price) VALUES (20, 4, 2014, 10, 439.35);
INSERT INTO public."Price" (id, "stonkId", year, month, price) VALUES (21, 4, 2014, 11, 460.75);
INSERT INTO public."Price" (id, "stonkId", year, month, price) VALUES (23, 4, 2015, 1, 476.9);
INSERT INTO public."Price" (id, "stonkId", year, month, price) VALUES (24, 4, 2015, 2, 498.9);
INSERT INTO public."Price" (id, "stonkId", year, month, price) VALUES (128, 4, 2020, 2, 948.6);
INSERT INTO public."Price" (id, "stonkId", year, month, price) VALUES (131, 4, 2020, 5, 1042.2);
INSERT INTO public."Price" (id, "stonkId", year, month, price) VALUES (132, 4, 2020, 6, 1024.8);
INSERT INTO public."Price" (id, "stonkId", year, month, price) VALUES (127, 4, 2020, 1, 1172.6);
INSERT INTO public."Price" (id, "stonkId", year, month, price) VALUES (135, 5, 2020, 3, 313.85);
INSERT INTO public."Price" (id, "stonkId", year, month, price) VALUES (129, 4, 2020, 3, 907.4);
INSERT INTO public."Price" (id, "stonkId", year, month, price) VALUES (130, 4, 2020, 4, 1034.6);
INSERT INTO public."Price" (id, "stonkId", year, month, price) VALUES (138, 5, 2020, 6, 362.65);
INSERT INTO public."Price" (id, "stonkId", year, month, price) VALUES (137, 5, 2020, 5, 373.65);
INSERT INTO public."Price" (id, "stonkId", year, month, price) VALUES (25, 5, 2014, 9, 231.36);
INSERT INTO public."Price" (id, "stonkId", year, month, price) VALUES (26, 5, 2014, 10, 237.88);
INSERT INTO public."Price" (id, "stonkId", year, month, price) VALUES (27, 5, 2014, 11, 231.96);
INSERT INTO public."Price" (id, "stonkId", year, month, price) VALUES (28, 5, 2014, 12, 195.45);
INSERT INTO public."Price" (id, "stonkId", year, month, price) VALUES (30, 5, 2015, 2, 264.15);
INSERT INTO public."Price" (id, "stonkId", year, month, price) VALUES (144, 6, 2020, 6, 38.475);
INSERT INTO public."Price" (id, "stonkId", year, month, price) VALUES (31, 6, 2014, 9, 26.232);
INSERT INTO public."Price" (id, "stonkId", year, month, price) VALUES (32, 6, 2014, 10, 27.915);
INSERT INTO public."Price" (id, "stonkId", year, month, price) VALUES (33, 6, 2014, 11, 29.245);
INSERT INTO public."Price" (id, "stonkId", year, month, price) VALUES (38, 7, 2014, 10, 251.35);
INSERT INTO public."Price" (id, "stonkId", year, month, price) VALUES (35, 6, 2015, 1, 30.195);
INSERT INTO public."Price" (id, "stonkId", year, month, price) VALUES (36, 6, 2015, 2, 34.825);
INSERT INTO public."Price" (id, "stonkId", year, month, price) VALUES (139, 6, 2020, 1, 47.14);
INSERT INTO public."Price" (id, "stonkId", year, month, price) VALUES (140, 6, 2020, 2, 37.795);
INSERT INTO public."Price" (id, "stonkId", year, month, price) VALUES (40, 7, 2014, 12, 232.1);
INSERT INTO public."Price" (id, "stonkId", year, month, price) VALUES (142, 6, 2020, 4, 37.24);
INSERT INTO public."Price" (id, "stonkId", year, month, price) VALUES (41, 7, 2015, 1, 277.55);
INSERT INTO public."Price" (id, "stonkId", year, month, price) VALUES (37, 7, 2014, 9, 233.44);
INSERT INTO public."Price" (id, "stonkId", year, month, price) VALUES (146, 7, 2020, 2, 669);
INSERT INTO public."Price" (id, "stonkId", year, month, price) VALUES (39, 7, 2014, 11, 251.8);
INSERT INTO public."Price" (id, "stonkId", year, month, price) VALUES (149, 7, 2020, 5, 538.8);
INSERT INTO public."Price" (id, "stonkId", year, month, price) VALUES (44, 8, 2014, 10, 7894);
INSERT INTO public."Price" (id, "stonkId", year, month, price) VALUES (42, 7, 2015, 2, 321);
INSERT INTO public."Price" (id, "stonkId", year, month, price) VALUES (145, 7, 2020, 1, 770.4);
INSERT INTO public."Price" (id, "stonkId", year, month, price) VALUES (45, 8, 2014, 11, 8771);
INSERT INTO public."Price" (id, "stonkId", year, month, price) VALUES (147, 7, 2020, 3, 546.7);
INSERT INTO public."Price" (id, "stonkId", year, month, price) VALUES (148, 7, 2020, 4, 558);
INSERT INTO public."Price" (id, "stonkId", year, month, price) VALUES (47, 8, 2015, 1, 11560);
INSERT INTO public."Price" (id, "stonkId", year, month, price) VALUES (43, 8, 2014, 9, 7343);
INSERT INTO public."Price" (id, "stonkId", year, month, price) VALUES (48, 8, 2015, 2, 11077);
INSERT INTO public."Price" (id, "stonkId", year, month, price) VALUES (152, 8, 2020, 2, 20384);
INSERT INTO public."Price" (id, "stonkId", year, month, price) VALUES (46, 8, 2014, 12, 8162);
INSERT INTO public."Price" (id, "stonkId", year, month, price) VALUES (155, 8, 2020, 5, 22152);
INSERT INTO public."Price" (id, "stonkId", year, month, price) VALUES (156, 8, 2020, 6, 18870);
INSERT INTO public."Price" (id, "stonkId", year, month, price) VALUES (151, 8, 2020, 1, 20822);
INSERT INTO public."Price" (id, "stonkId", year, month, price) VALUES (55, 10, 2014, 9, 56.97);
INSERT INTO public."Price" (id, "stonkId", year, month, price) VALUES (153, 8, 2020, 3, 19492);
INSERT INTO public."Price" (id, "stonkId", year, month, price) VALUES (154, 8, 2020, 4, 20516);
INSERT INTO public."Price" (id, "stonkId", year, month, price) VALUES (57, 10, 2014, 11, 59.585);
INSERT INTO public."Price" (id, "stonkId", year, month, price) VALUES (58, 10, 2014, 12, 65.05);
INSERT INTO public."Price" (id, "stonkId", year, month, price) VALUES (50, 9, 2014, 10, 451);
INSERT INTO public."Price" (id, "stonkId", year, month, price) VALUES (51, 9, 2014, 11, 445.1);
INSERT INTO public."Price" (id, "stonkId", year, month, price) VALUES (52, 9, 2014, 12, 497.4);
INSERT INTO public."Price" (id, "stonkId", year, month, price) VALUES (53, 9, 2015, 1, 641.1);
INSERT INTO public."Price" (id, "stonkId", year, month, price) VALUES (54, 9, 2015, 2, 686.25);
INSERT INTO public."Price" (id, "stonkId", year, month, price) VALUES (157, 9, 2020, 1, 923.4);
INSERT INTO public."Price" (id, "stonkId", year, month, price) VALUES (63, 11, 2014, 11, 46.56);
INSERT INTO public."Price" (id, "stonkId", year, month, price) VALUES (56, 10, 2014, 10, 55.125);
INSERT INTO public."Price" (id, "stonkId", year, month, price) VALUES (68, 12, 2014, 10, 474);
INSERT INTO public."Price" (id, "stonkId", year, month, price) VALUES (69, 12, 2014, 11, 719);
INSERT INTO public."Price" (id, "stonkId", year, month, price) VALUES (59, 10, 2015, 1, 90.36);
INSERT INTO public."Price" (id, "stonkId", year, month, price) VALUES (60, 10, 2015, 2, 81.955);
INSERT INTO public."Price" (id, "stonkId", year, month, price) VALUES (62, 11, 2014, 10, 38.59);
INSERT INTO public."Price" (id, "stonkId", year, month, price) VALUES (71, 12, 2015, 1, 1051.5);
INSERT INTO public."Price" (id, "stonkId", year, month, price) VALUES (64, 11, 2014, 12, 62.19);
INSERT INTO public."Price" (id, "stonkId", year, month, price) VALUES (65, 11, 2015, 1, 78.1);
INSERT INTO public."Price" (id, "stonkId", year, month, price) VALUES (66, 11, 2015, 2, 68.37);
INSERT INTO public."Price" (id, "stonkId", year, month, price) VALUES (67, 12, 2014, 9, 494);
INSERT INTO public."Price" (id, "stonkId", year, month, price) VALUES (72, 12, 2015, 2, 1116);
INSERT INTO public."Price" (id, "stonkId", year, month, price) VALUES (75, 13, 2014, 11, 11714.8);
INSERT INTO public."Price" (id, "stonkId", year, month, price) VALUES (70, 12, 2014, 12, 998);
INSERT INTO public."Price" (id, "stonkId", year, month, price) VALUES (77, 13, 2015, 1, 10705);
INSERT INTO public."Price" (id, "stonkId", year, month, price) VALUES (78, 13, 2015, 2, 11319);
INSERT INTO public."Price" (id, "stonkId", year, month, price) VALUES (73, 13, 2014, 9, 9854.2);
INSERT INTO public."Price" (id, "stonkId", year, month, price) VALUES (80, 14, 2014, 10, 58.02);
INSERT INTO public."Price" (id, "stonkId", year, month, price) VALUES (76, 13, 2014, 12, 9854);
INSERT INTO public."Price" (id, "stonkId", year, month, price) VALUES (82, 14, 2014, 12, 60.76);
INSERT INTO public."Price" (id, "stonkId", year, month, price) VALUES (84, 14, 2015, 2, 76.88);
INSERT INTO public."Price" (id, "stonkId", year, month, price) VALUES (79, 14, 2014, 9, 58.24);
INSERT INTO public."Price" (id, "stonkId", year, month, price) VALUES (92, 16, 2014, 10, 38.29);
INSERT INTO public."Price" (id, "stonkId", year, month, price) VALUES (81, 14, 2014, 11, 59.73);
INSERT INTO public."Price" (id, "stonkId", year, month, price) VALUES (95, 16, 2015, 1, 37.49);
INSERT INTO public."Price" (id, "stonkId", year, month, price) VALUES (83, 14, 2015, 1, 69.97);
INSERT INTO public."Price" (id, "stonkId", year, month, price) VALUES (98, 17, 2014, 10, 253.92);
INSERT INTO public."Price" (id, "stonkId", year, month, price) VALUES (85, 15, 2014, 9, 0.0392);
INSERT INTO public."Price" (id, "stonkId", year, month, price) VALUES (86, 15, 2014, 10, 0.0395);
INSERT INTO public."Price" (id, "stonkId", year, month, price) VALUES (88, 15, 2014, 12, 0.06605);
INSERT INTO public."Price" (id, "stonkId", year, month, price) VALUES (89, 15, 2015, 1, 0.06753);
INSERT INTO public."Price" (id, "stonkId", year, month, price) VALUES (90, 15, 2015, 2, 0.06893);
INSERT INTO public."Price" (id, "stonkId", year, month, price) VALUES (91, 16, 2014, 9, 43.41);
INSERT INTO public."Price" (id, "stonkId", year, month, price) VALUES (102, 17, 2015, 2, 251.65);
INSERT INTO public."Price" (id, "stonkId", year, month, price) VALUES (93, 16, 2014, 11, 41.2);
INSERT INTO public."Price" (id, "stonkId", year, month, price) VALUES (94, 16, 2014, 12, 31.81);
INSERT INTO public."Price" (id, "stonkId", year, month, price) VALUES (96, 16, 2015, 2, 39.65);
INSERT INTO public."Price" (id, "stonkId", year, month, price) VALUES (97, 17, 2014, 9, 276.27);
INSERT INTO public."Price" (id, "stonkId", year, month, price) VALUES (111, 1, 2020, 3, 186.56);
INSERT INTO public."Price" (id, "stonkId", year, month, price) VALUES (99, 17, 2014, 11, 250.83);
INSERT INTO public."Price" (id, "stonkId", year, month, price) VALUES (101, 17, 2015, 1, 220.95);
INSERT INTO public."Price" (id, "stonkId", year, month, price) VALUES (114, 1, 2020, 6, 203.63);
INSERT INTO public."Price" (id, "stonkId", year, month, price) VALUES (239, 6, 2022, 3, 24.7);
INSERT INTO public."Price" (id, "stonkId", year, month, price) VALUES (233, 5, 2022, 1, 574.95);
INSERT INTO public."Price" (id, "stonkId", year, month, price) VALUES (234, 5, 2022, 2, 301.3);
INSERT INTO public."Price" (id, "stonkId", year, month, price) VALUES (243, 7, 2022, 3, 402.3);
INSERT INTO public."Price" (id, "stonkId", year, month, price) VALUES (292, 1, 2023, 9, 260.75);
INSERT INTO public."Price" (id, "stonkId", year, month, price) VALUES (295, 1, 2023, 12, 271.63);
INSERT INTO public."Price" (id, "stonkId", year, month, price) VALUES (220, 1, 2022, 4, 126.79);
INSERT INTO public."Price" (id, "stonkId", year, month, price) VALUES (223, 2, 2022, 3, 235.3);
INSERT INTO public."Price" (id, "stonkId", year, month, price) VALUES (290, 1, 2023, 7, 259.57);
INSERT INTO public."Price" (id, "stonkId", year, month, price) VALUES (291, 1, 2023, 8, 265.38);
INSERT INTO public."Price" (id, "stonkId", year, month, price) VALUES (299, 2, 2023, 6, 166.9);
INSERT INTO public."Price" (id, "stonkId", year, month, price) VALUES (293, 1, 2023, 10, 268.15);
INSERT INTO public."Price" (id, "stonkId", year, month, price) VALUES (294, 1, 2023, 11, 275.45);
INSERT INTO public."Price" (id, "stonkId", year, month, price) VALUES (302, 2, 2023, 9, 168.27);
INSERT INTO public."Price" (id, "stonkId", year, month, price) VALUES (296, 1, 2024, 1, 275.69);
INSERT INTO public."Price" (id, "stonkId", year, month, price) VALUES (297, 1, 2024, 2, 292.48);
INSERT INTO public."Price" (id, "stonkId", year, month, price) VALUES (221, 2, 2022, 1, 333.35);
INSERT INTO public."Price" (id, "stonkId", year, month, price) VALUES (222, 2, 2022, 2, 221.39);
INSERT INTO public."Price" (id, "stonkId", year, month, price) VALUES (305, 2, 2023, 12, 160.05);
INSERT INTO public."Price" (id, "stonkId", year, month, price) VALUES (224, 2, 2022, 4, 242.06);
INSERT INTO public."Price" (id, "stonkId", year, month, price) VALUES (308, 2, 2024, 3, 157.18);
INSERT INTO public."Price" (id, "stonkId", year, month, price) VALUES (300, 2, 2023, 7, 173.54);
INSERT INTO public."Price" (id, "stonkId", year, month, price) VALUES (301, 2, 2023, 8, 178.06);
INSERT INTO public."Price" (id, "stonkId", year, month, price) VALUES (227, 3, 2022, 3, 5343.5);
INSERT INTO public."Price" (id, "stonkId", year, month, price) VALUES (303, 2, 2023, 10, 167.49);
INSERT INTO public."Price" (id, "stonkId", year, month, price) VALUES (304, 2, 2023, 11, 163.41);
INSERT INTO public."Price" (id, "stonkId", year, month, price) VALUES (228, 3, 2022, 4, 4569);
INSERT INTO public."Price" (id, "stonkId", year, month, price) VALUES (306, 2, 2024, 1, 164.89);
INSERT INTO public."Price" (id, "stonkId", year, month, price) VALUES (310, 3, 2023, 7, 5961.5);
INSERT INTO public."Price" (id, "stonkId", year, month, price) VALUES (225, 3, 2022, 1, 6830.5);
INSERT INTO public."Price" (id, "stonkId", year, month, price) VALUES (226, 3, 2022, 2, 5000.5);
INSERT INTO public."Price" (id, "stonkId", year, month, price) VALUES (311, 3, 2023, 8, 6827.5);
INSERT INTO public."Price" (id, "stonkId", year, month, price) VALUES (231, 4, 2022, 3, 1450.4);
INSERT INTO public."Price" (id, "stonkId", year, month, price) VALUES (309, 3, 2023, 6, 5099.5);
INSERT INTO public."Price" (id, "stonkId", year, month, price) VALUES (232, 4, 2022, 4, 1076);
INSERT INTO public."Price" (id, "stonkId", year, month, price) VALUES (235, 5, 2022, 3, 419.5);
INSERT INTO public."Price" (id, "stonkId", year, month, price) VALUES (312, 3, 2023, 9, 6657.5);
INSERT INTO public."Price" (id, "stonkId", year, month, price) VALUES (313, 3, 2023, 10, 7165.5);
INSERT INTO public."Price" (id, "stonkId", year, month, price) VALUES (314, 3, 2023, 11, 7242);
INSERT INTO public."Price" (id, "stonkId", year, month, price) VALUES (229, 4, 2022, 1, 1638.4);
INSERT INTO public."Price" (id, "stonkId", year, month, price) VALUES (236, 5, 2022, 4, 404.55);
INSERT INTO public."Price" (id, "stonkId", year, month, price) VALUES (244, 7, 2022, 4, 374.6);
INSERT INTO public."Price" (id, "stonkId", year, month, price) VALUES (237, 6, 2022, 1, 36.44);
INSERT INTO public."Price" (id, "stonkId", year, month, price) VALUES (238, 6, 2022, 2, 22.96);
INSERT INTO public."Price" (id, "stonkId", year, month, price) VALUES (248, 8, 2022, 4, 21424);
INSERT INTO public."Price" (id, "stonkId", year, month, price) VALUES (240, 6, 2022, 4, 23.58);
INSERT INTO public."Price" (id, "stonkId", year, month, price) VALUES (241, 7, 2022, 1, 501.2);
INSERT INTO public."Price" (id, "stonkId", year, month, price) VALUES (242, 7, 2022, 2, 359.6);
INSERT INTO public."Price" (id, "stonkId", year, month, price) VALUES (158, 9, 2020, 2, 826.2);
INSERT INTO public."Price" (id, "stonkId", year, month, price) VALUES (161, 9, 2020, 5, 930.2);
INSERT INTO public."Price" (id, "stonkId", year, month, price) VALUES (245, 8, 2022, 1, 21992);
INSERT INTO public."Price" (id, "stonkId", year, month, price) VALUES (246, 8, 2022, 2, 19498);
INSERT INTO public."Price" (id, "stonkId", year, month, price) VALUES (162, 9, 2020, 6, 862.6);
INSERT INTO public."Price" (id, "stonkId", year, month, price) VALUES (251, 9, 2022, 3, 1095.6);
INSERT INTO public."Price" (id, "stonkId", year, month, price) VALUES (159, 9, 2020, 3, 856.2);
INSERT INTO public."Price" (id, "stonkId", year, month, price) VALUES (160, 9, 2020, 4, 884.4);
INSERT INTO public."Price" (id, "stonkId", year, month, price) VALUES (252, 9, 2022, 4, 1077.6);
INSERT INTO public."Price" (id, "stonkId", year, month, price) VALUES (255, 10, 2022, 3, 172.38);
INSERT INTO public."Price" (id, "stonkId", year, month, price) VALUES (249, 9, 2022, 1, 1504.4);
INSERT INTO public."Price" (id, "stonkId", year, month, price) VALUES (250, 9, 2022, 2, 1334.4);
INSERT INTO public."Price" (id, "stonkId", year, month, price) VALUES (256, 10, 2022, 4, 158.64);
INSERT INTO public."Price" (id, "stonkId", year, month, price) VALUES (171, 11, 2020, 3, 61.91);
INSERT INTO public."Price" (id, "stonkId", year, month, price) VALUES (163, 10, 2020, 1, 140.32);
INSERT INTO public."Price" (id, "stonkId", year, month, price) VALUES (164, 10, 2020, 2, 125.94);
INSERT INTO public."Price" (id, "stonkId", year, month, price) VALUES (166, 10, 2020, 4, 127.46);
INSERT INTO public."Price" (id, "stonkId", year, month, price) VALUES (167, 10, 2020, 5, 136.86);
INSERT INTO public."Price" (id, "stonkId", year, month, price) VALUES (168, 10, 2020, 6, 140.52);
INSERT INTO public."Price" (id, "stonkId", year, month, price) VALUES (253, 10, 2022, 1, 213.56);
INSERT INTO public."Price" (id, "stonkId", year, month, price) VALUES (254, 10, 2022, 2, 177.94);
INSERT INTO public."Price" (id, "stonkId", year, month, price) VALUES (259, 11, 2022, 3, 92.99);
INSERT INTO public."Price" (id, "stonkId", year, month, price) VALUES (176, 12, 2020, 2, 8508.5);
INSERT INTO public."Price" (id, "stonkId", year, month, price) VALUES (169, 11, 2020, 1, 82.18);
INSERT INTO public."Price" (id, "stonkId", year, month, price) VALUES (170, 11, 2020, 2, 70.28);
INSERT INTO public."Price" (id, "stonkId", year, month, price) VALUES (179, 12, 2020, 5, 11587.5);
INSERT INTO public."Price" (id, "stonkId", year, month, price) VALUES (172, 11, 2020, 4, 62.56);
INSERT INTO public."Price" (id, "stonkId", year, month, price) VALUES (173, 11, 2020, 5, 66.1);
INSERT INTO public."Price" (id, "stonkId", year, month, price) VALUES (257, 11, 2022, 1, 114.56);
INSERT INTO public."Price" (id, "stonkId", year, month, price) VALUES (258, 11, 2022, 2, 78.53);
INSERT INTO public."Price" (id, "stonkId", year, month, price) VALUES (180, 12, 2020, 6, 11970.5);
INSERT INTO public."Price" (id, "stonkId", year, month, price) VALUES (260, 11, 2022, 4, 80.12);
INSERT INTO public."Price" (id, "stonkId", year, month, price) VALUES (175, 12, 2020, 1, 7788.5);
INSERT INTO public."Price" (id, "stonkId", year, month, price) VALUES (264, 12, 2022, 4, 13575);
INSERT INTO public."Price" (id, "stonkId", year, month, price) VALUES (177, 12, 2020, 3, 10980.5);
INSERT INTO public."Price" (id, "stonkId", year, month, price) VALUES (178, 12, 2020, 4, 12011);
INSERT INTO public."Price" (id, "stonkId", year, month, price) VALUES (182, 13, 2020, 2, 3153.5);
INSERT INTO public."Price" (id, "stonkId", year, month, price) VALUES (185, 13, 2020, 5, 3763);
INSERT INTO public."Price" (id, "stonkId", year, month, price) VALUES (261, 12, 2022, 1, 12032);
INSERT INTO public."Price" (id, "stonkId", year, month, price) VALUES (262, 12, 2022, 2, 11069.5);
INSERT INTO public."Price" (id, "stonkId", year, month, price) VALUES (186, 13, 2020, 6, 4083);
INSERT INTO public."Price" (id, "stonkId", year, month, price) VALUES (181, 13, 2020, 1, 3797.5);
INSERT INTO public."Price" (id, "stonkId", year, month, price) VALUES (267, 13, 2022, 3, 4134.5);
INSERT INTO public."Price" (id, "stonkId", year, month, price) VALUES (183, 13, 2020, 3, 3191);
INSERT INTO public."Price" (id, "stonkId", year, month, price) VALUES (184, 13, 2020, 4, 3587.5);
INSERT INTO public."Price" (id, "stonkId", year, month, price) VALUES (268, 13, 2022, 4, 4494.5);
INSERT INTO public."Price" (id, "stonkId", year, month, price) VALUES (189, 14, 2020, 3, 95.76);
INSERT INTO public."Price" (id, "stonkId", year, month, price) VALUES (265, 13, 2022, 1, 5020.5);
INSERT INTO public."Price" (id, "stonkId", year, month, price) VALUES (266, 13, 2022, 2, 3275);
INSERT INTO public."Price" (id, "stonkId", year, month, price) VALUES (192, 14, 2020, 6, 113.66);
INSERT INTO public."Price" (id, "stonkId", year, month, price) VALUES (271, 14, 2022, 3, 97.5);
INSERT INTO public."Price" (id, "stonkId", year, month, price) VALUES (187, 14, 2020, 1, 111.21);
INSERT INTO public."Price" (id, "stonkId", year, month, price) VALUES (195, 15, 2020, 3, 0.032275);
INSERT INTO public."Price" (id, "stonkId", year, month, price) VALUES (190, 14, 2020, 4, 119.45);
INSERT INTO public."Price" (id, "stonkId", year, month, price) VALUES (191, 14, 2020, 5, 114.26);
INSERT INTO public."Price" (id, "stonkId", year, month, price) VALUES (198, 15, 2020, 6, 0.035165);
INSERT INTO public."Price" (id, "stonkId", year, month, price) VALUES (269, 14, 2022, 1, 145.07);
INSERT INTO public."Price" (id, "stonkId", year, month, price) VALUES (270, 14, 2022, 2, 98.03);
INSERT INTO public."Price" (id, "stonkId", year, month, price) VALUES (275, 15, 2022, 3, 0.01884);
INSERT INTO public."Price" (id, "stonkId", year, month, price) VALUES (272, 14, 2022, 4, 93.9);
INSERT INTO public."Price" (id, "stonkId", year, month, price) VALUES (193, 15, 2020, 1, 0.04695);
INSERT INTO public."Price" (id, "stonkId", year, month, price) VALUES (194, 15, 2020, 2, 0.04326);
INSERT INTO public."Price" (id, "stonkId", year, month, price) VALUES (201, 16, 2020, 3, 68.06);
INSERT INTO public."Price" (id, "stonkId", year, month, price) VALUES (196, 15, 2020, 4, 0.035245);
INSERT INTO public."Price" (id, "stonkId", year, month, price) VALUES (202, 16, 2020, 4, 75.98);
INSERT INTO public."Price" (id, "stonkId", year, month, price) VALUES (273, 15, 2022, 1, 0.04365);
INSERT INTO public."Price" (id, "stonkId", year, month, price) VALUES (274, 15, 2022, 2, 0.0202);
INSERT INTO public."Price" (id, "stonkId", year, month, price) VALUES (204, 16, 2020, 6, 82.1);
INSERT INTO public."Price" (id, "stonkId", year, month, price) VALUES (276, 15, 2022, 4, 0.019935);
INSERT INTO public."Price" (id, "stonkId", year, month, price) VALUES (199, 16, 2020, 1, 107.78);
INSERT INTO public."Price" (id, "stonkId", year, month, price) VALUES (200, 16, 2020, 2, 94.32);
INSERT INTO public."Price" (id, "stonkId", year, month, price) VALUES (279, 16, 2022, 3, 37.22);
INSERT INTO public."Price" (id, "stonkId", year, month, price) VALUES (207, 17, 2020, 3, 297);
INSERT INTO public."Price" (id, "stonkId", year, month, price) VALUES (203, 16, 2020, 5, 78.12);
INSERT INTO public."Price" (id, "stonkId", year, month, price) VALUES (210, 17, 2020, 6, 329.85);
INSERT INTO public."Price" (id, "stonkId", year, month, price) VALUES (277, 16, 2022, 1, 56.84);
INSERT INTO public."Price" (id, "stonkId", year, month, price) VALUES (283, 17, 2022, 3, 232.25);
INSERT INTO public."Price" (id, "stonkId", year, month, price) VALUES (280, 16, 2022, 4, 30.92);
INSERT INTO public."Price" (id, "stonkId", year, month, price) VALUES (205, 17, 2020, 1, 329.95);
INSERT INTO public."Price" (id, "stonkId", year, month, price) VALUES (206, 17, 2020, 2, 322.05);
INSERT INTO public."Price" (id, "stonkId", year, month, price) VALUES (208, 17, 2020, 4, 319.9);
INSERT INTO public."Price" (id, "stonkId", year, month, price) VALUES (209, 17, 2020, 5, 320.75);
INSERT INTO public."Price" (id, "stonkId", year, month, price) VALUES (219, 1, 2022, 3, 140.83);
INSERT INTO public."Price" (id, "stonkId", year, month, price) VALUES (282, 17, 2022, 2, 223.1);
INSERT INTO public."Price" (id, "stonkId", year, month, price) VALUES (284, 17, 2022, 4, 207.05);
INSERT INTO public."Price" (id, "stonkId", year, month, price) VALUES (289, 1, 2023, 6, 239.52);
INSERT INTO public."Price" (id, "stonkId", year, month, price) VALUES (212, 18, 2020, 2, 5.3605);
INSERT INTO public."Price" (id, "stonkId", year, month, price) VALUES (213, 18, 2020, 3, 4.8585);
INSERT INTO public."Price" (id, "stonkId", year, month, price) VALUES (336, 5, 2024, 1, 574.65);
INSERT INTO public."Price" (id, "stonkId", year, month, price) VALUES (329, 5, 2023, 6, 482.4);
INSERT INTO public."Price" (id, "stonkId", year, month, price) VALUES (320, 4, 2023, 7, 1513);
INSERT INTO public."Price" (id, "stonkId", year, month, price) VALUES (471, 3, 2015, 12, 2352.5);
INSERT INTO public."Price" (id, "stonkId", year, month, price) VALUES (315, 3, 2023, 12, 6754.5);
INSERT INTO public."Price" (id, "stonkId", year, month, price) VALUES (321, 4, 2023, 8, 1686.2);
INSERT INTO public."Price" (id, "stonkId", year, month, price) VALUES (317, 3, 2024, 2, 7311.5);
INSERT INTO public."Price" (id, "stonkId", year, month, price) VALUES (326, 4, 2024, 1, 1437.8);
INSERT INTO public."Price" (id, "stonkId", year, month, price) VALUES (319, 4, 2023, 6, 1329.6);
INSERT INTO public."Price" (id, "stonkId", year, month, price) VALUES (328, 4, 2024, 3, 1320.6);
INSERT INTO public."Price" (id, "stonkId", year, month, price) VALUES (330, 5, 2023, 7, 506.35);
INSERT INTO public."Price" (id, "stonkId", year, month, price) VALUES (322, 4, 2023, 9, 1655.2);
INSERT INTO public."Price" (id, "stonkId", year, month, price) VALUES (323, 4, 2023, 10, 1669.6);
INSERT INTO public."Price" (id, "stonkId", year, month, price) VALUES (324, 4, 2023, 11, 1501.8);
INSERT INTO public."Price" (id, "stonkId", year, month, price) VALUES (331, 5, 2023, 8, 556.5);
INSERT INTO public."Price" (id, "stonkId", year, month, price) VALUES (327, 4, 2024, 2, 1348.4);
INSERT INTO public."Price" (id, "stonkId", year, month, price) VALUES (338, 5, 2024, 3, 566);
INSERT INTO public."Price" (id, "stonkId", year, month, price) VALUES (343, 6, 2023, 10, 32.7);
INSERT INTO public."Price" (id, "stonkId", year, month, price) VALUES (332, 5, 2023, 9, 536.1);
INSERT INTO public."Price" (id, "stonkId", year, month, price) VALUES (333, 5, 2023, 10, 578.3);
INSERT INTO public."Price" (id, "stonkId", year, month, price) VALUES (334, 5, 2023, 11, 587.35);
INSERT INTO public."Price" (id, "stonkId", year, month, price) VALUES (335, 5, 2023, 12, 592.55);
INSERT INTO public."Price" (id, "stonkId", year, month, price) VALUES (344, 6, 2023, 11, 31.665);
INSERT INTO public."Price" (id, "stonkId", year, month, price) VALUES (337, 5, 2024, 2, 576.1);
INSERT INTO public."Price" (id, "stonkId", year, month, price) VALUES (345, 6, 2023, 12, 26.84);
INSERT INTO public."Price" (id, "stonkId", year, month, price) VALUES (339, 6, 2023, 6, 28.5);
INSERT INTO public."Price" (id, "stonkId", year, month, price) VALUES (341, 6, 2023, 8, 31.43);
INSERT INTO public."Price" (id, "stonkId", year, month, price) VALUES (342, 6, 2023, 9, 31.1);
INSERT INTO public."Price" (id, "stonkId", year, month, price) VALUES (346, 6, 2024, 1, 29.145);
INSERT INTO public."Price" (id, "stonkId", year, month, price) VALUES (348, 6, 2024, 3, 29.3);
INSERT INTO public."Price" (id, "stonkId", year, month, price) VALUES (350, 7, 2023, 7, 521.4);
INSERT INTO public."Price" (id, "stonkId", year, month, price) VALUES (351, 7, 2023, 8, 591.3);
INSERT INTO public."Price" (id, "stonkId", year, month, price) VALUES (347, 6, 2024, 2, 29.25);
INSERT INTO public."Price" (id, "stonkId", year, month, price) VALUES (356, 7, 2024, 1, 701);
INSERT INTO public."Price" (id, "stonkId", year, month, price) VALUES (349, 7, 2023, 6, 506.1);
INSERT INTO public."Price" (id, "stonkId", year, month, price) VALUES (358, 7, 2024, 3, 693.5);
INSERT INTO public."Price" (id, "stonkId", year, month, price) VALUES (360, 8, 2023, 7, 16576);
INSERT INTO public."Price" (id, "stonkId", year, month, price) VALUES (352, 7, 2023, 9, 622);
INSERT INTO public."Price" (id, "stonkId", year, month, price) VALUES (354, 7, 2023, 11, 640.1);
INSERT INTO public."Price" (id, "stonkId", year, month, price) VALUES (355, 7, 2023, 12, 706.6);
INSERT INTO public."Price" (id, "stonkId", year, month, price) VALUES (361, 8, 2023, 8, 16820);
INSERT INTO public."Price" (id, "stonkId", year, month, price) VALUES (357, 7, 2024, 2, 714.8);
INSERT INTO public."Price" (id, "stonkId", year, month, price) VALUES (368, 8, 2024, 3, 15144);
INSERT INTO public."Price" (id, "stonkId", year, month, price) VALUES (359, 8, 2023, 6, 14734);
INSERT INTO public."Price" (id, "stonkId", year, month, price) VALUES (370, 9, 2023, 7, 1351);
INSERT INTO public."Price" (id, "stonkId", year, month, price) VALUES (371, 9, 2023, 8, 1407.2);
INSERT INTO public."Price" (id, "stonkId", year, month, price) VALUES (362, 8, 2023, 9, 16188);
INSERT INTO public."Price" (id, "stonkId", year, month, price) VALUES (363, 8, 2023, 10, 17500);
INSERT INTO public."Price" (id, "stonkId", year, month, price) VALUES (364, 8, 2023, 11, 16804);
INSERT INTO public."Price" (id, "stonkId", year, month, price) VALUES (365, 8, 2023, 12, 16194);
INSERT INTO public."Price" (id, "stonkId", year, month, price) VALUES (367, 8, 2024, 2, 14636);
INSERT INTO public."Price" (id, "stonkId", year, month, price) VALUES (376, 9, 2024, 1, 1663.4);
INSERT INTO public."Price" (id, "stonkId", year, month, price) VALUES (369, 9, 2023, 6, 1171.2);
INSERT INTO public."Price" (id, "stonkId", year, month, price) VALUES (378, 9, 2024, 3, 1865.4);
INSERT INTO public."Price" (id, "stonkId", year, month, price) VALUES (380, 10, 2023, 7, 208.56);
INSERT INTO public."Price" (id, "stonkId", year, month, price) VALUES (372, 9, 2023, 9, 1368.8);
INSERT INTO public."Price" (id, "stonkId", year, month, price) VALUES (373, 9, 2023, 10, 1357);
INSERT INTO public."Price" (id, "stonkId", year, month, price) VALUES (374, 9, 2023, 11, 1277.2);
INSERT INTO public."Price" (id, "stonkId", year, month, price) VALUES (375, 9, 2023, 12, 1399);
INSERT INTO public."Price" (id, "stonkId", year, month, price) VALUES (382, 10, 2023, 9, 209.52);
INSERT INTO public."Price" (id, "stonkId", year, month, price) VALUES (377, 9, 2024, 2, 1646);
INSERT INTO public."Price" (id, "stonkId", year, month, price) VALUES (383, 10, 2023, 10, 190.2);
INSERT INTO public."Price" (id, "stonkId", year, month, price) VALUES (385, 10, 2023, 12, 179.36);
INSERT INTO public."Price" (id, "stonkId", year, month, price) VALUES (381, 10, 2023, 8, 200.94);
INSERT INTO public."Price" (id, "stonkId", year, month, price) VALUES (386, 10, 2024, 1, 200.94);
INSERT INTO public."Price" (id, "stonkId", year, month, price) VALUES (387, 10, 2024, 2, 198.86);
INSERT INTO public."Price" (id, "stonkId", year, month, price) VALUES (384, 10, 2023, 11, 173.74);
INSERT INTO public."Price" (id, "stonkId", year, month, price) VALUES (388, 10, 2024, 3, 220.92);
INSERT INTO public."Price" (id, "stonkId", year, month, price) VALUES (395, 11, 2023, 12, 69.61);
INSERT INTO public."Price" (id, "stonkId", year, month, price) VALUES (398, 11, 2024, 3, 78.75);
INSERT INTO public."Price" (id, "stonkId", year, month, price) VALUES (400, 12, 2023, 7, 11809.5);
INSERT INTO public."Price" (id, "stonkId", year, month, price) VALUES (389, 11, 2023, 6, 70.09);
INSERT INTO public."Price" (id, "stonkId", year, month, price) VALUES (390, 11, 2023, 7, 84.83);
INSERT INTO public."Price" (id, "stonkId", year, month, price) VALUES (391, 11, 2023, 8, 81.65);
INSERT INTO public."Price" (id, "stonkId", year, month, price) VALUES (393, 11, 2023, 10, 70.03);
INSERT INTO public."Price" (id, "stonkId", year, month, price) VALUES (394, 11, 2023, 11, 65.59);
INSERT INTO public."Price" (id, "stonkId", year, month, price) VALUES (401, 12, 2023, 8, 11694);
INSERT INTO public."Price" (id, "stonkId", year, month, price) VALUES (396, 11, 2024, 1, 71.43);
INSERT INTO public."Price" (id, "stonkId", year, month, price) VALUES (397, 11, 2024, 2, 71.14);
INSERT INTO public."Price" (id, "stonkId", year, month, price) VALUES (406, 12, 2024, 1, 11286);
INSERT INTO public."Price" (id, "stonkId", year, month, price) VALUES (399, 12, 2023, 6, 10772.5);
INSERT INTO public."Price" (id, "stonkId", year, month, price) VALUES (408, 12, 2024, 3, 11938);
INSERT INTO public."Price" (id, "stonkId", year, month, price) VALUES (410, 13, 2023, 7, 5794.5);
INSERT INTO public."Price" (id, "stonkId", year, month, price) VALUES (402, 12, 2023, 9, 11474.5);
INSERT INTO public."Price" (id, "stonkId", year, month, price) VALUES (403, 12, 2023, 10, 11489.5);
INSERT INTO public."Price" (id, "stonkId", year, month, price) VALUES (404, 12, 2023, 11, 10886.5);
INSERT INTO public."Price" (id, "stonkId", year, month, price) VALUES (411, 13, 2023, 8, 6049);
INSERT INTO public."Price" (id, "stonkId", year, month, price) VALUES (407, 12, 2024, 2, 11062.5);
INSERT INTO public."Price" (id, "stonkId", year, month, price) VALUES (416, 13, 2024, 1, 7040.5);
INSERT INTO public."Price" (id, "stonkId", year, month, price) VALUES (409, 13, 2023, 6, 5140.5);
INSERT INTO public."Price" (id, "stonkId", year, month, price) VALUES (420, 14, 2023, 7, 132.66);
INSERT INTO public."Price" (id, "stonkId", year, month, price) VALUES (421, 14, 2023, 8, 171.8);
INSERT INTO public."Price" (id, "stonkId", year, month, price) VALUES (412, 13, 2023, 9, 5529);
INSERT INTO public."Price" (id, "stonkId", year, month, price) VALUES (413, 13, 2023, 10, 5855.5);
INSERT INTO public."Price" (id, "stonkId", year, month, price) VALUES (414, 13, 2023, 11, 6348.5);
INSERT INTO public."Price" (id, "stonkId", year, month, price) VALUES (415, 13, 2023, 12, 6983);
INSERT INTO public."Price" (id, "stonkId", year, month, price) VALUES (422, 14, 2023, 9, 178.09);
INSERT INTO public."Price" (id, "stonkId", year, month, price) VALUES (417, 13, 2024, 2, 7630.5);
INSERT INTO public."Price" (id, "stonkId", year, month, price) VALUES (419, 14, 2023, 6, 123.1);
INSERT INTO public."Price" (id, "stonkId", year, month, price) VALUES (423, 14, 2023, 10, 189.98);
INSERT INTO public."Price" (id, "stonkId", year, month, price) VALUES (424, 14, 2023, 11, 199.56);
INSERT INTO public."Price" (id, "stonkId", year, month, price) VALUES (429, 15, 2023, 6, 0.021735);
INSERT INTO public."Price" (id, "stonkId", year, month, price) VALUES (432, 15, 2023, 9, 0.025835);
INSERT INTO public."Price" (id, "stonkId", year, month, price) VALUES (435, 15, 2023, 12, 0.022845);
INSERT INTO public."Price" (id, "stonkId", year, month, price) VALUES (425, 14, 2023, 12, 189.36);
INSERT INTO public."Price" (id, "stonkId", year, month, price) VALUES (426, 14, 2024, 1, 202.47);
INSERT INTO public."Price" (id, "stonkId", year, month, price) VALUES (427, 14, 2024, 2, 199.57);
INSERT INTO public."Price" (id, "stonkId", year, month, price) VALUES (428, 14, 2024, 3, 221.06);
INSERT INTO public."Price" (id, "stonkId", year, month, price) VALUES (438, 15, 2024, 3, 0.02273);
INSERT INTO public."Price" (id, "stonkId", year, month, price) VALUES (430, 15, 2023, 7, 0.02571);
INSERT INTO public."Price" (id, "stonkId", year, month, price) VALUES (440, 16, 2023, 7, 45.36);
INSERT INTO public."Price" (id, "stonkId", year, month, price) VALUES (433, 15, 2023, 10, 0.02515);
INSERT INTO public."Price" (id, "stonkId", year, month, price) VALUES (434, 15, 2023, 11, 0.023715);
INSERT INTO public."Price" (id, "stonkId", year, month, price) VALUES (442, 16, 2023, 9, 41.39);
INSERT INTO public."Price" (id, "stonkId", year, month, price) VALUES (436, 15, 2024, 1, 0.02455);
INSERT INTO public."Price" (id, "stonkId", year, month, price) VALUES (437, 15, 2024, 2, 0.02338);
INSERT INTO public."Price" (id, "stonkId", year, month, price) VALUES (443, 16, 2023, 10, 39.24);
INSERT INTO public."Price" (id, "stonkId", year, month, price) VALUES (439, 16, 2023, 6, 42.6);
INSERT INTO public."Price" (id, "stonkId", year, month, price) VALUES (447, 16, 2024, 2, 38.41);
INSERT INTO public."Price" (id, "stonkId", year, month, price) VALUES (441, 16, 2023, 8, 44.03);
INSERT INTO public."Price" (id, "stonkId", year, month, price) VALUES (448, 16, 2024, 3, 44.71);
INSERT INTO public."Price" (id, "stonkId", year, month, price) VALUES (449, 17, 2023, 6, 298.9);
INSERT INTO public."Price" (id, "stonkId", year, month, price) VALUES (445, 16, 2023, 12, 35.06);
INSERT INTO public."Price" (id, "stonkId", year, month, price) VALUES (446, 16, 2024, 1, 38.94);
INSERT INTO public."Price" (id, "stonkId", year, month, price) VALUES (452, 17, 2023, 9, 275.75);
INSERT INTO public."Price" (id, "stonkId", year, month, price) VALUES (455, 17, 2023, 12, 248);
INSERT INTO public."Price" (id, "stonkId", year, month, price) VALUES (456, 17, 2024, 1, 273.65);
INSERT INTO public."Price" (id, "stonkId", year, month, price) VALUES (450, 17, 2023, 7, 290);
INSERT INTO public."Price" (id, "stonkId", year, month, price) VALUES (451, 17, 2023, 8, 284.45);
INSERT INTO public."Price" (id, "stonkId", year, month, price) VALUES (458, 17, 2024, 3, 296.9);
INSERT INTO public."Price" (id, "stonkId", year, month, price) VALUES (453, 17, 2023, 10, 272.4);
INSERT INTO public."Price" (id, "stonkId", year, month, price) VALUES (454, 17, 2023, 11, 254.45);
INSERT INTO public."Price" (id, "stonkId", year, month, price) VALUES (459, 18, 2023, 6, 4.04);
INSERT INTO public."Price" (id, "stonkId", year, month, price) VALUES (316, 3, 2024, 1, 7084);
INSERT INTO public."Price" (id, "stonkId", year, month, price) VALUES (318, 3, 2024, 3, 7529.5);
INSERT INTO public."Price" (id, "stonkId", year, month, price) VALUES (581, 5, 2021, 6, 566.9);
INSERT INTO public."Price" (id, "stonkId", year, month, price) VALUES (599, 5, 2021, 12, 597.65);
INSERT INTO public."Price" (id, "stonkId", year, month, price) VALUES (617, 5, 2022, 9, 257.7);
INSERT INTO public."Price" (id, "stonkId", year, month, price) VALUES (510, 6, 2017, 12, 27.735);
INSERT INTO public."Price" (id, "stonkId", year, month, price) VALUES (559, 1, 2020, 12, 271.99);
INSERT INTO public."Price" (id, "stonkId", year, month, price) VALUES (577, 1, 2021, 6, 305.04);
INSERT INTO public."Price" (id, "stonkId", year, month, price) VALUES (595, 1, 2021, 12, 293.27);
INSERT INTO public."Price" (id, "stonkId", year, month, price) VALUES (613, 1, 2022, 9, 109.08);
INSERT INTO public."Price" (id, "stonkId", year, month, price) VALUES (524, 2, 2018, 12, 153.3);
INSERT INTO public."Price" (id, "stonkId", year, month, price) VALUES (542, 2, 2019, 12, 256.63);
INSERT INTO public."Price" (id, "stonkId", year, month, price) VALUES (560, 2, 2020, 12, 212.26);
INSERT INTO public."Price" (id, "stonkId", year, month, price) VALUES (488, 2, 2016, 12, 153.55);
INSERT INTO public."Price" (id, "stonkId", year, month, price) VALUES (506, 2, 2017, 12, 129.87);
INSERT INTO public."Price" (id, "stonkId", year, month, price) VALUES (596, 2, 2021, 12, 341.21);
INSERT INTO public."Price" (id, "stonkId", year, month, price) VALUES (614, 2, 2022, 9, 221.68);
INSERT INTO public."Price" (id, "stonkId", year, month, price) VALUES (507, 3, 2017, 12, 3319);
INSERT INTO public."Price" (id, "stonkId", year, month, price) VALUES (561, 3, 2020, 12, 5182);
INSERT INTO public."Price" (id, "stonkId", year, month, price) VALUES (579, 3, 2021, 6, 6726.5);
INSERT INTO public."Price" (id, "stonkId", year, month, price) VALUES (489, 3, 2016, 12, 3428);
INSERT INTO public."Price" (id, "stonkId", year, month, price) VALUES (597, 3, 2021, 12, 6550.5);
INSERT INTO public."Price" (id, "stonkId", year, month, price) VALUES (525, 3, 2018, 12, 4986);
INSERT INTO public."Price" (id, "stonkId", year, month, price) VALUES (543, 3, 2019, 12, 6161.5);
INSERT INTO public."Price" (id, "stonkId", year, month, price) VALUES (615, 3, 2022, 9, 3892);
INSERT INTO public."Price" (id, "stonkId", year, month, price) VALUES (490, 4, 2016, 12, 783.5);
INSERT INTO public."Price" (id, "stonkId", year, month, price) VALUES (526, 4, 2018, 12, 1132.6);
INSERT INTO public."Price" (id, "stonkId", year, month, price) VALUES (562, 4, 2020, 12, 1256.2);
INSERT INTO public."Price" (id, "stonkId", year, month, price) VALUES (472, 4, 2015, 12, 595.4);
INSERT INTO public."Price" (id, "stonkId", year, month, price) VALUES (580, 4, 2021, 6, 1578.8);
INSERT INTO public."Price" (id, "stonkId", year, month, price) VALUES (598, 4, 2021, 12, 1728);
INSERT INTO public."Price" (id, "stonkId", year, month, price) VALUES (544, 4, 2019, 12, 1262.6);
INSERT INTO public."Price" (id, "stonkId", year, month, price) VALUES (616, 4, 2022, 9, 957.4);
INSERT INTO public."Price" (id, "stonkId", year, month, price) VALUES (527, 5, 2018, 12, 428.15);
INSERT INTO public."Price" (id, "stonkId", year, month, price) VALUES (545, 5, 2019, 12, 450.65);
INSERT INTO public."Price" (id, "stonkId", year, month, price) VALUES (563, 5, 2020, 12, 435.9);
INSERT INTO public."Price" (id, "stonkId", year, month, price) VALUES (473, 5, 2015, 12, 256.05);
INSERT INTO public."Price" (id, "stonkId", year, month, price) VALUES (491, 5, 2016, 12, 400.1);
INSERT INTO public."Price" (id, "stonkId", year, month, price) VALUES (509, 5, 2017, 12, 289.85);
INSERT INTO public."Price" (id, "stonkId", year, month, price) VALUES (528, 6, 2018, 12, 26.85);
INSERT INTO public."Price" (id, "stonkId", year, month, price) VALUES (564, 6, 2020, 12, 35.99);
INSERT INTO public."Price" (id, "stonkId", year, month, price) VALUES (474, 6, 2015, 12, 34.165);
INSERT INTO public."Price" (id, "stonkId", year, month, price) VALUES (582, 6, 2021, 6, 36.39);
INSERT INTO public."Price" (id, "stonkId", year, month, price) VALUES (600, 6, 2021, 12, 39.805);
INSERT INTO public."Price" (id, "stonkId", year, month, price) VALUES (546, 6, 2019, 12, 50.78);
INSERT INTO public."Price" (id, "stonkId", year, month, price) VALUES (618, 6, 2022, 9, 17.795);
INSERT INTO public."Price" (id, "stonkId", year, month, price) VALUES (475, 7, 2015, 12, 319.35);
INSERT INTO public."Price" (id, "stonkId", year, month, price) VALUES (511, 7, 2017, 12, 475.05);
INSERT INTO public."Price" (id, "stonkId", year, month, price) VALUES (583, 7, 2021, 6, 527);
INSERT INTO public."Price" (id, "stonkId", year, month, price) VALUES (601, 7, 2021, 12, 498.6);
INSERT INTO public."Price" (id, "stonkId", year, month, price) VALUES (493, 7, 2016, 12, 421.05);
INSERT INTO public."Price" (id, "stonkId", year, month, price) VALUES (619, 7, 2022, 9, 352.6);
INSERT INTO public."Price" (id, "stonkId", year, month, price) VALUES (529, 7, 2018, 12, 729.2);
INSERT INTO public."Price" (id, "stonkId", year, month, price) VALUES (547, 7, 2019, 12, 765.9);
INSERT INTO public."Price" (id, "stonkId", year, month, price) VALUES (512, 8, 2017, 12, 10747);
INSERT INTO public."Price" (id, "stonkId", year, month, price) VALUES (566, 8, 2020, 12, 23624);
INSERT INTO public."Price" (id, "stonkId", year, month, price) VALUES (584, 8, 2021, 6, 24770);
INSERT INTO public."Price" (id, "stonkId", year, month, price) VALUES (476, 8, 2015, 12, 9174);
INSERT INTO public."Price" (id, "stonkId", year, month, price) VALUES (494, 8, 2016, 12, 10042);
INSERT INTO public."Price" (id, "stonkId", year, month, price) VALUES (602, 8, 2021, 12, 22770);
INSERT INTO public."Price" (id, "stonkId", year, month, price) VALUES (530, 8, 2018, 12, 13009);
INSERT INTO public."Price" (id, "stonkId", year, month, price) VALUES (548, 8, 2019, 12, 19278);
INSERT INTO public."Price" (id, "stonkId", year, month, price) VALUES (620, 8, 2022, 9, 12282);
INSERT INTO public."Price" (id, "stonkId", year, month, price) VALUES (495, 9, 2016, 12, 928.9);
INSERT INTO public."Price" (id, "stonkId", year, month, price) VALUES (531, 9, 2018, 12, 942.3);
INSERT INTO public."Price" (id, "stonkId", year, month, price) VALUES (567, 9, 2020, 12, 1325.2);
INSERT INTO public."Price" (id, "stonkId", year, month, price) VALUES (585, 9, 2021, 6, 1564);
INSERT INTO public."Price" (id, "stonkId", year, month, price) VALUES (513, 9, 2017, 12, 893.2);
INSERT INTO public."Price" (id, "stonkId", year, month, price) VALUES (603, 9, 2021, 12, 1589.2);
INSERT INTO public."Price" (id, "stonkId", year, month, price) VALUES (549, 9, 2019, 12, 941.2);
INSERT INTO public."Price" (id, "stonkId", year, month, price) VALUES (621, 9, 2022, 9, 592.4);
INSERT INTO public."Price" (id, "stonkId", year, month, price) VALUES (478, 10, 2015, 12, 62.79);
INSERT INTO public."Price" (id, "stonkId", year, month, price) VALUES (568, 10, 2020, 12, 208.8);
INSERT INTO public."Price" (id, "stonkId", year, month, price) VALUES (586, 10, 2021, 6, 228.94);
INSERT INTO public."Price" (id, "stonkId", year, month, price) VALUES (604, 10, 2021, 12, 215.96);
INSERT INTO public."Price" (id, "stonkId", year, month, price) VALUES (496, 10, 2016, 12, 114.41);
INSERT INTO public."Price" (id, "stonkId", year, month, price) VALUES (514, 10, 2017, 12, 147.59);
INSERT INTO public."Price" (id, "stonkId", year, month, price) VALUES (532, 10, 2018, 12, 157.52);
INSERT INTO public."Price" (id, "stonkId", year, month, price) VALUES (622, 10, 2022, 9, 80.62);
INSERT INTO public."Price" (id, "stonkId", year, month, price) VALUES (497, 11, 2016, 12, 96.62);
INSERT INTO public."Price" (id, "stonkId", year, month, price) VALUES (551, 11, 2019, 12, 84.79);
INSERT INTO public."Price" (id, "stonkId", year, month, price) VALUES (569, 11, 2020, 12, 98.85);
INSERT INTO public."Price" (id, "stonkId", year, month, price) VALUES (479, 11, 2015, 12, 56.16);
INSERT INTO public."Price" (id, "stonkId", year, month, price) VALUES (587, 11, 2021, 6, 134.19);
INSERT INTO public."Price" (id, "stonkId", year, month, price) VALUES (515, 11, 2017, 12, 74.98);
INSERT INTO public."Price" (id, "stonkId", year, month, price) VALUES (533, 11, 2018, 12, 98.33);
INSERT INTO public."Price" (id, "stonkId", year, month, price) VALUES (605, 11, 2021, 12, 121.63);
INSERT INTO public."Price" (id, "stonkId", year, month, price) VALUES (516, 12, 2017, 12, 4523);
INSERT INTO public."Price" (id, "stonkId", year, month, price) VALUES (534, 12, 2018, 12, 5387);
INSERT INTO public."Price" (id, "stonkId", year, month, price) VALUES (570, 12, 2020, 12, 15256.5);
INSERT INTO public."Price" (id, "stonkId", year, month, price) VALUES (480, 12, 2015, 12, 2895);
INSERT INTO public."Price" (id, "stonkId", year, month, price) VALUES (498, 12, 2016, 12, 4444);
INSERT INTO public."Price" (id, "stonkId", year, month, price) VALUES (588, 12, 2021, 6, 13998.5);
INSERT INTO public."Price" (id, "stonkId", year, month, price) VALUES (606, 12, 2021, 12, 12949.5);
INSERT INTO public."Price" (id, "stonkId", year, month, price) VALUES (552, 12, 2019, 12, 7074.5);
INSERT INTO public."Price" (id, "stonkId", year, month, price) VALUES (624, 12, 2022, 9, 5028.5);
INSERT INTO public."Price" (id, "stonkId", year, month, price) VALUES (517, 13, 2017, 12, 6327);
INSERT INTO public."Price" (id, "stonkId", year, month, price) VALUES (571, 13, 2020, 12, 5675);
INSERT INTO public."Price" (id, "stonkId", year, month, price) VALUES (589, 13, 2021, 6, 5306);
INSERT INTO public."Price" (id, "stonkId", year, month, price) VALUES (481, 13, 2015, 12, 11126);
INSERT INTO public."Price" (id, "stonkId", year, month, price) VALUES (499, 13, 2016, 12, 10908);
INSERT INTO public."Price" (id, "stonkId", year, month, price) VALUES (607, 13, 2021, 12, 5440);
INSERT INTO public."Price" (id, "stonkId", year, month, price) VALUES (553, 13, 2019, 12, 3433);
INSERT INTO public."Price" (id, "stonkId", year, month, price) VALUES (625, 13, 2022, 9, 4533);
INSERT INTO public."Price" (id, "stonkId", year, month, price) VALUES (518, 14, 2017, 12, 109.23);
INSERT INTO public."Price" (id, "stonkId", year, month, price) VALUES (536, 14, 2018, 12, 80.94);
INSERT INTO public."Price" (id, "stonkId", year, month, price) VALUES (554, 14, 2019, 12, 107.86);
INSERT INTO public."Price" (id, "stonkId", year, month, price) VALUES (482, 14, 2015, 12, 92.68);
INSERT INTO public."Price" (id, "stonkId", year, month, price) VALUES (500, 14, 2016, 12, 124.28);
INSERT INTO public."Price" (id, "stonkId", year, month, price) VALUES (572, 14, 2020, 12, 159.47);
INSERT INTO public."Price" (id, "stonkId", year, month, price) VALUES (590, 14, 2021, 6, 170.22);
INSERT INTO public."Price" (id, "stonkId", year, month, price) VALUES (626, 14, 2022, 9, 75.37);
INSERT INTO public."Price" (id, "stonkId", year, month, price) VALUES (501, 15, 2016, 12, 0.0741);
INSERT INTO public."Price" (id, "stonkId", year, month, price) VALUES (519, 15, 2017, 12, 0.04711);
INSERT INTO public."Price" (id, "stonkId", year, month, price) VALUES (537, 15, 2018, 12, 0.034);
INSERT INTO public."Price" (id, "stonkId", year, month, price) VALUES (483, 15, 2015, 12, 0.07922);
INSERT INTO public."Price" (id, "stonkId", year, month, price) VALUES (555, 15, 2019, 12, 0.04603);
INSERT INTO public."Price" (id, "stonkId", year, month, price) VALUES (573, 15, 2020, 12, 0.037865);
INSERT INTO public."Price" (id, "stonkId", year, month, price) VALUES (591, 15, 2021, 6, 0.048155);
INSERT INTO public."Price" (id, "stonkId", year, month, price) VALUES (609, 15, 2021, 12, 0.04822);
INSERT INTO public."Price" (id, "stonkId", year, month, price) VALUES (627, 15, 2022, 9, 0.01474);
INSERT INTO public."Price" (id, "stonkId", year, month, price) VALUES (538, 16, 2018, 12, 101.08);
INSERT INTO public."Price" (id, "stonkId", year, month, price) VALUES (574, 16, 2020, 12, 71.42);
INSERT INTO public."Price" (id, "stonkId", year, month, price) VALUES (592, 16, 2021, 6, 67.92);
INSERT INTO public."Price" (id, "stonkId", year, month, price) VALUES (484, 16, 2015, 12, 56.1);
INSERT INTO public."Price" (id, "stonkId", year, month, price) VALUES (502, 16, 2016, 12, 152.96);
INSERT INTO public."Price" (id, "stonkId", year, month, price) VALUES (610, 16, 2021, 12, 58.96);
INSERT INTO public."Price" (id, "stonkId", year, month, price) VALUES (556, 16, 2019, 12, 103.88);
INSERT INTO public."Price" (id, "stonkId", year, month, price) VALUES (485, 17, 2015, 12, 210.9);
INSERT INTO public."Price" (id, "stonkId", year, month, price) VALUES (521, 17, 2017, 12, 276.2);
INSERT INTO public."Price" (id, "stonkId", year, month, price) VALUES (539, 17, 2018, 12, 237.85);
INSERT INTO public."Price" (id, "stonkId", year, month, price) VALUES (628, 16, 2022, 9, 22.6);
INSERT INTO public."Price" (id, "stonkId", year, month, price) VALUES (575, 17, 2020, 12, 329.75);
INSERT INTO public."Price" (id, "stonkId", year, month, price) VALUES (503, 17, 2016, 12, 257.2);
INSERT INTO public."Price" (id, "stonkId", year, month, price) VALUES (611, 17, 2021, 12, 297.4);
INSERT INTO public."Price" (id, "stonkId", year, month, price) VALUES (557, 17, 2019, 12, 321.35);
INSERT INTO public."Price" (id, "stonkId", year, month, price) VALUES (523, 1, 2018, 12, 186.05);
INSERT INTO public."Price" (id, "stonkId", year, month, price) VALUES (541, 1, 2019, 12, 253.96);
INSERT INTO public."Price" (id, "stonkId", year, month, price) VALUES (486, 18, 2015, 12, 1.0925);
INSERT INTO public."Price" (id, "stonkId", year, month, price) VALUES (707, 5, 2024, 12, 602.15);
INSERT INTO public."Price" (id, "stonkId", year, month, price) VALUES (761, 5, 2025, 9, 411.4);
INSERT INTO public."Price" (id, "stonkId", year, month, price) VALUES (779, 5, 2025, 12, 409);
INSERT INTO public."Price" (id, "stonkId", year, month, price) VALUES (703, 1, 2024, 12, 276.62);
INSERT INTO public."Price" (id, "stonkId", year, month, price) VALUES (721, 1, 2025, 3, 306.17);
INSERT INTO public."Price" (id, "stonkId", year, month, price) VALUES (739, 1, 2025, 6, 316.1);
INSERT INTO public."Price" (id, "stonkId", year, month, price) VALUES (757, 1, 2025, 9, 287.56);
INSERT INTO public."Price" (id, "stonkId", year, month, price) VALUES (775, 1, 2025, 12, 299.98);
INSERT INTO public."Price" (id, "stonkId", year, month, price) VALUES (632, 2, 2022, 12, 162.72);
INSERT INTO public."Price" (id, "stonkId", year, month, price) VALUES (650, 2, 2023, 3, 169.9);
INSERT INTO public."Price" (id, "stonkId", year, month, price) VALUES (668, 2, 2024, 6, 115.69);
INSERT INTO public."Price" (id, "stonkId", year, month, price) VALUES (686, 2, 2024, 9, 140.78);
INSERT INTO public."Price" (id, "stonkId", year, month, price) VALUES (722, 2, 2025, 3, 144.61);
INSERT INTO public."Price" (id, "stonkId", year, month, price) VALUES (740, 2, 2025, 6, 128.56);
INSERT INTO public."Price" (id, "stonkId", year, month, price) VALUES (776, 2, 2025, 12, 125.55);
INSERT INTO public."Price" (id, "stonkId", year, month, price) VALUES (633, 3, 2022, 12, 4058.5);
INSERT INTO public."Price" (id, "stonkId", year, month, price) VALUES (651, 3, 2023, 3, 4333);
INSERT INTO public."Price" (id, "stonkId", year, month, price) VALUES (705, 3, 2024, 12, 7176);
INSERT INTO public."Price" (id, "stonkId", year, month, price) VALUES (741, 3, 2025, 6, 6291);
INSERT INTO public."Price" (id, "stonkId", year, month, price) VALUES (759, 3, 2025, 9, 6057.5);
INSERT INTO public."Price" (id, "stonkId", year, month, price) VALUES (669, 3, 2024, 6, 7219);
INSERT INTO public."Price" (id, "stonkId", year, month, price) VALUES (687, 3, 2024, 9, 6930.5);
INSERT INTO public."Price" (id, "stonkId", year, month, price) VALUES (777, 3, 2025, 12, 5869);
INSERT INTO public."Price" (id, "stonkId", year, month, price) VALUES (723, 3, 2025, 3, 7009.5);
INSERT INTO public."Price" (id, "stonkId", year, month, price) VALUES (634, 4, 2022, 12, 1068.4);
INSERT INTO public."Price" (id, "stonkId", year, month, price) VALUES (652, 4, 2023, 3, 1146);
INSERT INTO public."Price" (id, "stonkId", year, month, price) VALUES (706, 4, 2024, 12, 980.8);
INSERT INTO public."Price" (id, "stonkId", year, month, price) VALUES (742, 4, 2025, 6, 1096.4);
INSERT INTO public."Price" (id, "stonkId", year, month, price) VALUES (760, 4, 2025, 9, 1098.8);
INSERT INTO public."Price" (id, "stonkId", year, month, price) VALUES (670, 4, 2024, 6, 1074.6);
INSERT INTO public."Price" (id, "stonkId", year, month, price) VALUES (688, 4, 2024, 9, 1027.2);
INSERT INTO public."Price" (id, "stonkId", year, month, price) VALUES (778, 4, 2025, 12, 1191);
INSERT INTO public."Price" (id, "stonkId", year, month, price) VALUES (724, 4, 2025, 3, 1221.4);
INSERT INTO public."Price" (id, "stonkId", year, month, price) VALUES (635, 5, 2022, 12, 362.6);
INSERT INTO public."Price" (id, "stonkId", year, month, price) VALUES (653, 5, 2023, 3, 380.05);
INSERT INTO public."Price" (id, "stonkId", year, month, price) VALUES (671, 5, 2024, 6, 562.25);
INSERT INTO public."Price" (id, "stonkId", year, month, price) VALUES (689, 5, 2024, 9, 510.6);
INSERT INTO public."Price" (id, "stonkId", year, month, price) VALUES (654, 6, 2023, 3, 23.515);
INSERT INTO public."Price" (id, "stonkId", year, month, price) VALUES (725, 5, 2025, 3, 490.35);
INSERT INTO public."Price" (id, "stonkId", year, month, price) VALUES (672, 6, 2024, 6, 28.96);
INSERT INTO public."Price" (id, "stonkId", year, month, price) VALUES (690, 6, 2024, 9, 25.065);
INSERT INTO public."Price" (id, "stonkId", year, month, price) VALUES (636, 6, 2022, 12, 21.67);
INSERT INTO public."Price" (id, "stonkId", year, month, price) VALUES (708, 6, 2024, 12, 24.7);
INSERT INTO public."Price" (id, "stonkId", year, month, price) VALUES (726, 6, 2025, 3, 25.2);
INSERT INTO public."Price" (id, "stonkId", year, month, price) VALUES (762, 6, 2025, 9, 21.215);
INSERT INTO public."Price" (id, "stonkId", year, month, price) VALUES (780, 6, 2025, 12, 21.81);
INSERT INTO public."Price" (id, "stonkId", year, month, price) VALUES (637, 7, 2022, 12, 348.3);
INSERT INTO public."Price" (id, "stonkId", year, month, price) VALUES (744, 6, 2025, 6, 22.64);
INSERT INTO public."Price" (id, "stonkId", year, month, price) VALUES (709, 7, 2024, 12, 682);
INSERT INTO public."Price" (id, "stonkId", year, month, price) VALUES (745, 7, 2025, 6, 668.2);
INSERT INTO public."Price" (id, "stonkId", year, month, price) VALUES (763, 7, 2025, 9, 628.2);
INSERT INTO public."Price" (id, "stonkId", year, month, price) VALUES (673, 7, 2024, 6, 701.4);
INSERT INTO public."Price" (id, "stonkId", year, month, price) VALUES (691, 7, 2024, 9, 645.3);
INSERT INTO public."Price" (id, "stonkId", year, month, price) VALUES (781, 7, 2025, 12, 576);
INSERT INTO public."Price" (id, "stonkId", year, month, price) VALUES (727, 7, 2025, 3, 679.8);
INSERT INTO public."Price" (id, "stonkId", year, month, price) VALUES (638, 8, 2022, 12, 15226);
INSERT INTO public."Price" (id, "stonkId", year, month, price) VALUES (656, 8, 2023, 3, 14974);
INSERT INTO public."Price" (id, "stonkId", year, month, price) VALUES (692, 8, 2024, 9, 115.22);
INSERT INTO public."Price" (id, "stonkId", year, month, price) VALUES (710, 8, 2024, 12, 115.26);
INSERT INTO public."Price" (id, "stonkId", year, month, price) VALUES (746, 8, 2025, 6, 111.6);
INSERT INTO public."Price" (id, "stonkId", year, month, price) VALUES (674, 8, 2024, 6, 130);
INSERT INTO public."Price" (id, "stonkId", year, month, price) VALUES (639, 9, 2022, 12, 900.2);
INSERT INTO public."Price" (id, "stonkId", year, month, price) VALUES (657, 9, 2023, 3, 1049.4);
INSERT INTO public."Price" (id, "stonkId", year, month, price) VALUES (711, 9, 2024, 12, 1293.6);
INSERT INTO public."Price" (id, "stonkId", year, month, price) VALUES (764, 8, 2025, 9, 123.9);
INSERT INTO public."Price" (id, "stonkId", year, month, price) VALUES (782, 8, 2025, 12, 149.04);
INSERT INTO public."Price" (id, "stonkId", year, month, price) VALUES (747, 9, 2025, 6, 1045.8);
INSERT INTO public."Price" (id, "stonkId", year, month, price) VALUES (765, 9, 2025, 9, 951.6);
INSERT INTO public."Price" (id, "stonkId", year, month, price) VALUES (675, 9, 2024, 6, 1547.2);
INSERT INTO public."Price" (id, "stonkId", year, month, price) VALUES (693, 9, 2024, 9, 1284.4);
INSERT INTO public."Price" (id, "stonkId", year, month, price) VALUES (783, 9, 2025, 12, 964.6);
INSERT INTO public."Price" (id, "stonkId", year, month, price) VALUES (729, 9, 2025, 3, 1157.6);
INSERT INTO public."Price" (id, "stonkId", year, month, price) VALUES (694, 10, 2024, 9, 144.28);
INSERT INTO public."Price" (id, "stonkId", year, month, price) VALUES (730, 10, 2025, 3, 142.58);
INSERT INTO public."Price" (id, "stonkId", year, month, price) VALUES (766, 10, 2025, 9, 104.64);
INSERT INTO public."Price" (id, "stonkId", year, month, price) VALUES (658, 10, 2023, 3, 129.64);
INSERT INTO public."Price" (id, "stonkId", year, month, price) VALUES (676, 10, 2024, 6, 177.78);
INSERT INTO public."Price" (id, "stonkId", year, month, price) VALUES (641, 11, 2022, 12, 58.79);
INSERT INTO public."Price" (id, "stonkId", year, month, price) VALUES (712, 10, 2024, 12, 144.34);
INSERT INTO public."Price" (id, "stonkId", year, month, price) VALUES (659, 11, 2023, 3, 65.66);
INSERT INTO public."Price" (id, "stonkId", year, month, price) VALUES (748, 10, 2025, 6, 111.72);
INSERT INTO public."Price" (id, "stonkId", year, month, price) VALUES (731, 11, 2025, 3, 54.38);
INSERT INTO public."Price" (id, "stonkId", year, month, price) VALUES (784, 10, 2025, 12, 106.36);
INSERT INTO public."Price" (id, "stonkId", year, month, price) VALUES (642, 12, 2022, 12, 7673.5);
INSERT INTO public."Price" (id, "stonkId", year, month, price) VALUES (660, 12, 2023, 3, 9425);
INSERT INTO public."Price" (id, "stonkId", year, month, price) VALUES (677, 11, 2024, 6, 70.93);
INSERT INTO public."Price" (id, "stonkId", year, month, price) VALUES (695, 11, 2024, 9, 55.22);
INSERT INTO public."Price" (id, "stonkId", year, month, price) VALUES (714, 12, 2024, 12, 13990);
INSERT INTO public."Price" (id, "stonkId", year, month, price) VALUES (749, 11, 2025, 6, 47.67);
INSERT INTO public."Price" (id, "stonkId", year, month, price) VALUES (767, 11, 2025, 9, 43.07);
INSERT INTO public."Price" (id, "stonkId", year, month, price) VALUES (785, 11, 2025, 12, 41.48);
INSERT INTO public."Price" (id, "stonkId", year, month, price) VALUES (732, 12, 2025, 3, 1878.6);
INSERT INTO public."Price" (id, "stonkId", year, month, price) VALUES (750, 12, 2025, 6, 1812.2);
INSERT INTO public."Price" (id, "stonkId", year, month, price) VALUES (678, 12, 2024, 6, 12158.5);
INSERT INTO public."Price" (id, "stonkId", year, month, price) VALUES (696, 12, 2024, 9, 13339);
INSERT INTO public."Price" (id, "stonkId", year, month, price) VALUES (768, 12, 2025, 9, 2383.2);
INSERT INTO public."Price" (id, "stonkId", year, month, price) VALUES (661, 13, 2023, 3, 4638.5);
INSERT INTO public."Price" (id, "stonkId", year, month, price) VALUES (715, 13, 2024, 12, 5092.5);
INSERT INTO public."Price" (id, "stonkId", year, month, price) VALUES (751, 13, 2025, 6, 3623);
INSERT INTO public."Price" (id, "stonkId", year, month, price) VALUES (769, 13, 2025, 9, 3171.5);
INSERT INTO public."Price" (id, "stonkId", year, month, price) VALUES (679, 13, 2024, 6, 6347.5);
INSERT INTO public."Price" (id, "stonkId", year, month, price) VALUES (697, 13, 2024, 9, 5723);
INSERT INTO public."Price" (id, "stonkId", year, month, price) VALUES (644, 14, 2022, 12, 94.69);
INSERT INTO public."Price" (id, "stonkId", year, month, price) VALUES (733, 13, 2025, 3, 4408.5);
INSERT INTO public."Price" (id, "stonkId", year, month, price) VALUES (662, 14, 2023, 3, 112.55);
INSERT INTO public."Price" (id, "stonkId", year, month, price) VALUES (680, 14, 2024, 6, 228.9);
INSERT INTO public."Price" (id, "stonkId", year, month, price) VALUES (698, 14, 2024, 9, 220.03);
INSERT INTO public."Price" (id, "stonkId", year, month, price) VALUES (716, 14, 2024, 12, 197.67);
INSERT INTO public."Price" (id, "stonkId", year, month, price) VALUES (752, 14, 2025, 6, 200.45);
INSERT INTO public."Price" (id, "stonkId", year, month, price) VALUES (770, 14, 2025, 9, 164.92);
INSERT INTO public."Price" (id, "stonkId", year, month, price) VALUES (645, 15, 2022, 12, 0.01654);
INSERT INTO public."Price" (id, "stonkId", year, month, price) VALUES (663, 15, 2023, 3, 0.018085);
INSERT INTO public."Price" (id, "stonkId", year, month, price) VALUES (681, 15, 2024, 6, 0.02136);
INSERT INTO public."Price" (id, "stonkId", year, month, price) VALUES (699, 15, 2024, 9, 90.32);
INSERT INTO public."Price" (id, "stonkId", year, month, price) VALUES (717, 15, 2024, 12, 79.49);
INSERT INTO public."Price" (id, "stonkId", year, month, price) VALUES (753, 15, 2025, 6, 106.39);
INSERT INTO public."Price" (id, "stonkId", year, month, price) VALUES (771, 15, 2025, 9, 68.21);
INSERT INTO public."Price" (id, "stonkId", year, month, price) VALUES (646, 16, 2022, 12, 24.56);
INSERT INTO public."Price" (id, "stonkId", year, month, price) VALUES (735, 15, 2025, 3, 81.73);
INSERT INTO public."Price" (id, "stonkId", year, month, price) VALUES (664, 16, 2023, 3, 31.51);
INSERT INTO public."Price" (id, "stonkId", year, month, price) VALUES (700, 16, 2024, 9, 55.04);
INSERT INTO public."Price" (id, "stonkId", year, month, price) VALUES (629, 17, 2022, 9, 184.9);
INSERT INTO public."Price" (id, "stonkId", year, month, price) VALUES (665, 17, 2023, 3, 256.85);
INSERT INTO public."Price" (id, "stonkId", year, month, price) VALUES (683, 17, 2024, 6, 290.6);
INSERT INTO public."Price" (id, "stonkId", year, month, price) VALUES (718, 16, 2024, 12, 59.01);
INSERT INTO public."Price" (id, "stonkId", year, month, price) VALUES (736, 16, 2025, 3, 68.61);
INSERT INTO public."Price" (id, "stonkId", year, month, price) VALUES (754, 16, 2025, 6, 66.47);
INSERT INTO public."Price" (id, "stonkId", year, month, price) VALUES (772, 16, 2025, 9, 54.51);
INSERT INTO public."Price" (id, "stonkId", year, month, price) VALUES (701, 17, 2024, 9, 207.1);
INSERT INTO public."Price" (id, "stonkId", year, month, price) VALUES (647, 17, 2022, 12, 234.95);
INSERT INTO public."Price" (id, "stonkId", year, month, price) VALUES (719, 17, 2024, 12, 208.6);
INSERT INTO public."Price" (id, "stonkId", year, month, price) VALUES (737, 17, 2025, 3, 224.5);
INSERT INTO public."Price" (id, "stonkId", year, month, price) VALUES (773, 17, 2025, 9, 205.55);
INSERT INTO public."Price" (id, "stonkId", year, month, price) VALUES (630, 18, 2022, 9, 2.5135);
INSERT INTO public."Price" (id, "stonkId", year, month, price) VALUES (667, 1, 2024, 6, 327.52);
INSERT INTO public."Price" (id, "stonkId", year, month, price) VALUES (685, 1, 2024, 9, 270.71);
INSERT INTO public."Price" (id, "stonkId", year, month, price) VALUES (1685, 1, 2016, 6, 132.97);
INSERT INTO public."Price" (id, "stonkId", year, month, price) VALUES (2232, 1, 2017, 7, 165.14);
INSERT INTO public."Price" (id, "stonkId", year, month, price) VALUES (2150, 1, 2017, 5, 157.35);
INSERT INTO public."Price" (id, "stonkId", year, month, price) VALUES (3838, 1, 2020, 9, 227.37);
INSERT INTO public."Price" (id, "stonkId", year, month, price) VALUES (6026, 1, 2025, 1, 282.55);
INSERT INTO public."Price" (id, "stonkId", year, month, price) VALUES (5040, 1, 2023, 2, 170.01);
INSERT INTO public."Price" (id, "stonkId", year, month, price) VALUES (298, 1, 2024, 3, 298.7);
INSERT INTO public."Price" (id, "stonkId", year, month, price) VALUES (2320, 1, 2017, 9, 192.23);
INSERT INTO public."Price" (id, "stonkId", year, month, price) VALUES (2066, 1, 2017, 3, 161.03);
INSERT INTO public."Price" (id, "stonkId", year, month, price) VALUES (1059, 1, 2015, 3, 62.53);
INSERT INTO public."Price" (id, "stonkId", year, month, price) VALUES (649, 1, 2023, 3, 214.32);
INSERT INTO public."Price" (id, "stonkId", year, month, price) VALUES (3379, 1, 2019, 10, 237.62);
INSERT INTO public."Price" (id, "stonkId", year, month, price) VALUES (2915, 1, 2018, 11, 192.75);
INSERT INTO public."Price" (id, "stonkId", year, month, price) VALUES (1399, 1, 2015, 11, 104.5);
INSERT INTO public."Price" (id, "stonkId", year, month, price) VALUES (1181, 1, 2015, 6, 71.44);
INSERT INTO public."Price" (id, "stonkId", year, month, price) VALUES (1605, 1, 2016, 4, 124.11);
INSERT INTO public."Price" (id, "stonkId", year, month, price) VALUES (1986, 1, 2017, 1, 173.16);
INSERT INTO public."Price" (id, "stonkId", year, month, price) VALUES (2406, 1, 2017, 11, 225.58);
INSERT INTO public."Price" (id, "stonkId", year, month, price) VALUES (1900, 1, 2016, 11, 158.84);
INSERT INTO public."Price" (id, "stonkId", year, month, price) VALUES (2490, 1, 2018, 1, 262.04);
INSERT INTO public."Price" (id, "stonkId", year, month, price) VALUES (4869, 1, 2022, 10, 126.81);
INSERT INTO public."Price" (id, "stonkId", year, month, price) VALUES (2568, 1, 2018, 3, 253.8);
INSERT INTO public."Price" (id, "stonkId", year, month, price) VALUES (1, 1, 2014, 9, 76.55);
INSERT INTO public."Price" (id, "stonkId", year, month, price) VALUES (1519, 1, 2016, 2, 106.32);
INSERT INTO public."Price" (id, "stonkId", year, month, price) VALUES (2782, 1, 2018, 8, 179.31);
INSERT INTO public."Price" (id, "stonkId", year, month, price) VALUES (1311, 1, 2015, 9, 75.87);
INSERT INTO public."Price" (id, "stonkId", year, month, price) VALUES (1814, 1, 2016, 9, 145.7);
INSERT INTO public."Price" (id, "stonkId", year, month, price) VALUES (3883, 1, 2020, 10, 202.69);
INSERT INTO public."Price" (id, "stonkId", year, month, price) VALUES (1727, 1, 2016, 7, 137.95);
INSERT INTO public."Price" (id, "stonkId", year, month, price) VALUES (5633, 1, 2024, 4, 308.43);
INSERT INTO public."Price" (id, "stonkId", year, month, price) VALUES (1101, 1, 2015, 4, 76.18);
INSERT INTO public."Price" (id, "stonkId", year, month, price) VALUES (4090, 1, 2021, 3, 291.99);
INSERT INTO public."Price" (id, "stonkId", year, month, price) VALUES (6066, 1, 2025, 2, 306.97);
INSERT INTO public."Price" (id, "stonkId", year, month, price) VALUES (5163, 1, 2023, 5, 244.05);
INSERT INTO public."Price" (id, "stonkId", year, month, price) VALUES (2654, 1, 2018, 5, 222.34);
INSERT INTO public."Price" (id, "stonkId", year, month, price) VALUES (3040, 1, 2019, 2, 206.31);
INSERT INTO public."Price" (id, "stonkId", year, month, price) VALUES (3165, 1, 2019, 5, 231.25);
INSERT INTO public."Price" (id, "stonkId", year, month, price) VALUES (1647, 1, 2016, 5, 134.46);
INSERT INTO public."Price" (id, "stonkId", year, month, price) VALUES (1223, 1, 2015, 7, 71.39);
INSERT INTO public."Price" (id, "stonkId", year, month, price) VALUES (469, 1, 2015, 12, 101.18);
INSERT INTO public."Price" (id, "stonkId", year, month, price) VALUES (2190, 1, 2017, 6, 145.55);
INSERT INTO public."Price" (id, "stonkId", year, month, price) VALUES (4352, 1, 2021, 9, 336.36);
INSERT INTO public."Price" (id, "stonkId", year, month, price) VALUES (2110, 1, 2017, 4, 165.15);
INSERT INTO public."Price" (id, "stonkId", year, month, price) VALUES (4736, 1, 2022, 7, 131.61);
INSERT INTO public."Price" (id, "stonkId", year, month, price) VALUES (2028, 1, 2017, 2, 157.77);
INSERT INTO public."Price" (id, "stonkId", year, month, price) VALUES (2, 1, 2014, 10, 76.03);
INSERT INTO public."Price" (id, "stonkId", year, month, price) VALUES (2274, 1, 2017, 8, 184.62);
INSERT INTO public."Price" (id, "stonkId", year, month, price) VALUES (2869, 1, 2018, 10, 186.9);
INSERT INTO public."Price" (id, "stonkId", year, month, price) VALUES (5679, 1, 2024, 5, 314.65);
INSERT INTO public."Price" (id, "stonkId", year, month, price) VALUES (1145, 1, 2015, 5, 74.99);
INSERT INTO public."Price" (id, "stonkId", year, month, price) VALUES (2362, 1, 2017, 10, 195.04);
INSERT INTO public."Price" (id, "stonkId", year, month, price) VALUES (1355, 1, 2015, 10, 89.81);
INSERT INTO public."Price" (id, "stonkId", year, month, price) VALUES (1561, 1, 2016, 3, 109.04);
INSERT INTO public."Price" (id, "stonkId", year, month, price) VALUES (487, 1, 2016, 12, 171.85);
INSERT INTO public."Price" (id, "stonkId", year, month, price) VALUES (2738, 1, 2018, 7, 213.12);
INSERT INTO public."Price" (id, "stonkId", year, month, price) VALUES (3796, 1, 2020, 8, 226.92);
INSERT INTO public."Price" (id, "stonkId", year, month, price) VALUES (1858, 1, 2016, 10, 147.92);
INSERT INTO public."Price" (id, "stonkId", year, month, price) VALUES (505, 1, 2017, 12, 225.08);
INSERT INTO public."Price" (id, "stonkId", year, month, price) VALUES (4179, 1, 2021, 5, 310.71);
INSERT INTO public."Price" (id, "stonkId", year, month, price) VALUES (2530, 1, 2018, 2, 274.55);
INSERT INTO public."Price" (id, "stonkId", year, month, price) VALUES (1483, 1, 2016, 1, 97.06);
INSERT INTO public."Price" (id, "stonkId", year, month, price) VALUES (3080, 1, 2019, 3, 216.21);
INSERT INTO public."Price" (id, "stonkId", year, month, price) VALUES (1269, 1, 2015, 8, 73.84);
INSERT INTO public."Price" (id, "stonkId", year, month, price) VALUES (3292, 1, 2019, 8, 223.85);
INSERT INTO public."Price" (id, "stonkId", year, month, price) VALUES (4264, 1, 2021, 7, 304.78);
INSERT INTO public."Price" (id, "stonkId", year, month, price) VALUES (4135, 1, 2021, 4, 296.81);
INSERT INTO public."Price" (id, "stonkId", year, month, price) VALUES (3121, 1, 2019, 4, 225.94);
INSERT INTO public."Price" (id, "stonkId", year, month, price) VALUES (3000, 1, 2019, 1, 216.91);
INSERT INTO public."Price" (id, "stonkId", year, month, price) VALUES (2610, 1, 2018, 4, 225.26);
INSERT INTO public."Price" (id, "stonkId", year, month, price) VALUES (4693, 1, 2022, 6, 128.56);
INSERT INTO public."Price" (id, "stonkId", year, month, price) VALUES (3207, 1, 2019, 6, 239.56);
INSERT INTO public."Price" (id, "stonkId", year, month, price) VALUES (3752, 1, 2020, 7, 220.17);
INSERT INTO public."Price" (id, "stonkId", year, month, price) VALUES (4050, 1, 2021, 2, 269.8);
INSERT INTO public."Price" (id, "stonkId", year, month, price) VALUES (3246, 1, 2019, 7, 235.47);
INSERT INTO public."Price" (id, "stonkId", year, month, price) VALUES (2696, 1, 2018, 6, 215.29);
INSERT INTO public."Price" (id, "stonkId", year, month, price) VALUES (5123, 1, 2023, 4, 239.85);
INSERT INTO public."Price" (id, "stonkId", year, month, price) VALUES (4308, 1, 2021, 8, 328.82);
INSERT INTO public."Price" (id, "stonkId", year, month, price) VALUES (4911, 1, 2022, 11, 135.91);
INSERT INTO public."Price" (id, "stonkId", year, month, price) VALUES (3425, 1, 2019, 11, 233.41);
INSERT INTO public."Price" (id, "stonkId", year, month, price) VALUES (4012, 1, 2021, 1, 260.42);
INSERT INTO public."Price" (id, "stonkId", year, month, price) VALUES (3336, 1, 2019, 9, 227.43);
INSERT INTO public."Price" (id, "stonkId", year, month, price) VALUES (5939, 1, 2024, 11, 233.1);
INSERT INTO public."Price" (id, "stonkId", year, month, price) VALUES (631, 1, 2022, 12, 140.87);
INSERT INTO public."Price" (id, "stonkId", year, month, price) VALUES (4998, 1, 2023, 1, 155.69);
INSERT INTO public."Price" (id, "stonkId", year, month, price) VALUES (4397, 1, 2021, 10, 357.76);
INSERT INTO public."Price" (id, "stonkId", year, month, price) VALUES (6430, 1, 2026, 1, 305.92);
INSERT INTO public."Price" (id, "stonkId", year, month, price) VALUES (4778, 1, 2022, 8, 134.45);
INSERT INTO public."Price" (id, "stonkId", year, month, price) VALUES (3927, 1, 2020, 11, 249.03);
INSERT INTO public."Price" (id, "stonkId", year, month, price) VALUES (4439, 1, 2021, 11, 315.9);
INSERT INTO public."Price" (id, "stonkId", year, month, price) VALUES (218, 1, 2022, 2, 130.63);
INSERT INTO public."Price" (id, "stonkId", year, month, price) VALUES (217, 1, 2022, 1, 265.34);
INSERT INTO public."Price" (id, "stonkId", year, month, price) VALUES (4657, 1, 2022, 5, 118.65);
INSERT INTO public."Price" (id, "stonkId", year, month, price) VALUES (6193, 1, 2025, 5, 308.42);
INSERT INTO public."Price" (id, "stonkId", year, month, price) VALUES (5760, 1, 2024, 7, 289.7);
INSERT INTO public."Price" (id, "stonkId", year, month, price) VALUES (6320, 1, 2025, 8, 310.39);
INSERT INTO public."Price" (id, "stonkId", year, month, price) VALUES (5893, 1, 2024, 10, 239.86);
INSERT INTO public."Price" (id, "stonkId", year, month, price) VALUES (795, 3, 2026, 4, 5523.5);
INSERT INTO public."Price" (id, "stonkId", year, month, price) VALUES (796, 4, 2026, 4, 1268.8);
INSERT INTO public."Price" (id, "stonkId", year, month, price) VALUES (793, 1, 2026, 4, 316.49);
INSERT INTO public."Price" (id, "stonkId", year, month, price) VALUES (6149, 1, 2025, 4, 306.47);
INSERT INTO public."Price" (id, "stonkId", year, month, price) VALUES (6364, 1, 2025, 10, 293.67);
INSERT INTO public."Price" (id, "stonkId", year, month, price) VALUES (5806, 1, 2024, 8, 256.43);
INSERT INTO public."Price" (id, "stonkId", year, month, price) VALUES (6387, 1, 2025, 11, 302.28);
INSERT INTO public."Price" (id, "stonkId", year, month, price) VALUES (6274, 1, 2025, 7, 304.38);
INSERT INTO public."Price" (id, "stonkId", year, month, price) VALUES (6449, 1, 2026, 2, 314.63);
INSERT INTO public."Price" (id, "stonkId", year, month, price) VALUES (6468, 1, 2026, 3, 314.17);
INSERT INTO public."Price" (id, "stonkId", year, month, price) VALUES (6741, 2, 2015, 3, 138.2);
INSERT INTO public."Price" (id, "stonkId", year, month, price) VALUES (6783, 2, 2015, 4, 152.83);
INSERT INTO public."Price" (id, "stonkId", year, month, price) VALUES (8, 2, 2014, 10, 140.52);
INSERT INTO public."Price" (id, "stonkId", year, month, price) VALUES (6827, 2, 2015, 5, 144.56);
INSERT INTO public."Price" (id, "stonkId", year, month, price) VALUES (6863, 2, 2015, 6, 144.26);
INSERT INTO public."Price" (id, "stonkId", year, month, price) VALUES (6905, 2, 2015, 7, 140.09);
INSERT INTO public."Price" (id, "stonkId", year, month, price) VALUES (6951, 2, 2015, 8, 146.53);
INSERT INTO public."Price" (id, "stonkId", year, month, price) VALUES (6993, 2, 2015, 9, 134.72);
INSERT INTO public."Price" (id, "stonkId", year, month, price) VALUES (7037, 2, 2015, 10, 135.88);
INSERT INTO public."Price" (id, "stonkId", year, month, price) VALUES (7081, 2, 2015, 11, 140.26);
INSERT INTO public."Price" (id, "stonkId", year, month, price) VALUES (7165, 2, 2016, 1, 135.6);
INSERT INTO public."Price" (id, "stonkId", year, month, price) VALUES (470, 2, 2015, 12, 136.25);
INSERT INTO public."Price" (id, "stonkId", year, month, price) VALUES (7201, 2, 2016, 2, 140.08);
INSERT INTO public."Price" (id, "stonkId", year, month, price) VALUES (7243, 2, 2016, 3, 147.03);
INSERT INTO public."Price" (id, "stonkId", year, month, price) VALUES (7287, 2, 2016, 4, 166.87);
INSERT INTO public."Price" (id, "stonkId", year, month, price) VALUES (7329, 2, 2016, 5, 147.61);
INSERT INTO public."Price" (id, "stonkId", year, month, price) VALUES (797, 5, 2026, 4, 471.3);
INSERT INTO public."Price" (id, "stonkId", year, month, price) VALUES (794, 2, 2026, 4, 134.05);
INSERT INTO public."Price" (id, "stonkId", year, month, price) VALUES (799, 7, 2026, 4, 652.5);
INSERT INTO public."Price" (id, "stonkId", year, month, price) VALUES (801, 9, 2026, 4, 847.6);
INSERT INTO public."Price" (id, "stonkId", year, month, price) VALUES (803, 11, 2026, 4, 34.18);
INSERT INTO public."Price" (id, "stonkId", year, month, price) VALUES (798, 6, 2026, 4, 21.245);
INSERT INTO public."Price" (id, "stonkId", year, month, price) VALUES (786, 12, 2025, 12, 2392.2);
INSERT INTO public."Price" (id, "stonkId", year, month, price) VALUES (800, 8, 2026, 4, 140.14);
INSERT INTO public."Price" (id, "stonkId", year, month, price) VALUES (804, 12, 2026, 4, 2151.4);
INSERT INTO public."Price" (id, "stonkId", year, month, price) VALUES (787, 13, 2025, 12, 3015);
INSERT INTO public."Price" (id, "stonkId", year, month, price) VALUES (805, 13, 2026, 4, 3033);
INSERT INTO public."Price" (id, "stonkId", year, month, price) VALUES (788, 14, 2025, 12, 173.5);
INSERT INTO public."Price" (id, "stonkId", year, month, price) VALUES (789, 15, 2025, 12, 72.34);
INSERT INTO public."Price" (id, "stonkId", year, month, price) VALUES (807, 15, 2026, 4, 87.3);
INSERT INTO public."Price" (id, "stonkId", year, month, price) VALUES (790, 16, 2025, 12, 57.82);
INSERT INTO public."Price" (id, "stonkId", year, month, price) VALUES (806, 14, 2026, 4, 169.36);
INSERT INTO public."Price" (id, "stonkId", year, month, price) VALUES (792, 18, 2025, 12, 3.109);
INSERT INTO public."Price" (id, "stonkId", year, month, price) VALUES (1769, 1, 2016, 8, 143.2);
INSERT INTO public."Price" (id, "stonkId", year, month, price) VALUES (808, 16, 2026, 4, 47.87);
INSERT INTO public."Price" (id, "stonkId", year, month, price) VALUES (809, 17, 2026, 4, 226.05);
INSERT INTO public."Price" (id, "stonkId", year, month, price) VALUES (2828, 1, 2018, 9, 202.67);
INSERT INTO public."Price" (id, "stonkId", year, month, price) VALUES (12743, 3, 2016, 4, 2765.5);
INSERT INTO public."Price" (id, "stonkId", year, month, price) VALUES (12575, 3, 2015, 8, 2511);
INSERT INTO public."Price" (id, "stonkId", year, month, price) VALUES (8215, 2, 2018, 2, 143.61);
INSERT INTO public."Price" (id, "stonkId", year, month, price) VALUES (7917, 2, 2017, 7, 116.58);
INSERT INTO public."Price" (id, "stonkId", year, month, price) VALUES (8931, 2, 2019, 7, 237.16);
INSERT INTO public."Price" (id, "stonkId", year, month, price) VALUES (8047, 2, 2017, 10, 126.01);
INSERT INTO public."Price" (id, "stonkId", year, month, price) VALUES (7795, 2, 2017, 4, 136.3);
INSERT INTO public."Price" (id, "stonkId", year, month, price) VALUES (8725, 2, 2019, 2, 157.82);
INSERT INTO public."Price" (id, "stonkId", year, month, price) VALUES (10848, 2, 2023, 5, 162.36);
INSERT INTO public."Price" (id, "stonkId", year, month, price) VALUES (8339, 2, 2018, 5, 144.59);
INSERT INTO public."Price" (id, "stonkId", year, month, price) VALUES (10342, 2, 2022, 5, 297.82);
INSERT INTO public."Price" (id, "stonkId", year, month, price) VALUES (7671, 2, 2017, 1, 150.16);
INSERT INTO public."Price" (id, "stonkId", year, month, price) VALUES (10378, 2, 2022, 6, 226.72);
INSERT INTO public."Price" (id, "stonkId", year, month, price) VALUES (118, 2, 2020, 4, 192.5);
INSERT INTO public."Price" (id, "stonkId", year, month, price) VALUES (13268, 3, 2018, 5, 4211.5);
INSERT INTO public."Price" (id, "stonkId", year, month, price) VALUES (9993, 2, 2021, 8, 305.82);
INSERT INTO public."Price" (id, "stonkId", year, month, price) VALUES (7497, 2, 2016, 9, 135.32);
INSERT INTO public."Price" (id, "stonkId", year, month, price) VALUES (12618, 3, 2015, 10, 2339.9);
INSERT INTO public."Price" (id, "stonkId", year, month, price) VALUES (9820, 2, 2021, 4, 229.83);
INSERT INTO public."Price" (id, "stonkId", year, month, price) VALUES (9735, 2, 2021, 2, 219.16);
INSERT INTO public."Price" (id, "stonkId", year, month, price) VALUES (8467, 2, 2018, 8, 148.12);
INSERT INTO public."Price" (id, "stonkId", year, month, price) VALUES (7367, 2, 2016, 6, 140.41);
INSERT INTO public."Price" (id, "stonkId", year, month, price) VALUES (8850, 2, 2019, 5, 212.77);
INSERT INTO public."Price" (id, "stonkId", year, month, price) VALUES (10082, 2, 2021, 10, 349.2);
INSERT INTO public."Price" (id, "stonkId", year, month, price) VALUES (12092, 2, 2025, 10, 116.39);
INSERT INTO public."Price" (id, "stonkId", year, month, price) VALUES (10421, 2, 2022, 7, 195.12);
INSERT INTO public."Price" (id, "stonkId", year, month, price) VALUES (13122, 3, 2017, 10, 3111);
INSERT INTO public."Price" (id, "stonkId", year, month, price) VALUES (12491, 3, 2015, 4, 2633.3);
INSERT INTO public."Price" (id, "stonkId", year, month, price) VALUES (8600, 2, 2018, 11, 161.47);
INSERT INTO public."Price" (id, "stonkId", year, month, price) VALUES (7835, 2, 2017, 5, 120.4);
INSERT INTO public."Price" (id, "stonkId", year, month, price) VALUES (8253, 2, 2018, 3, 142.63);
INSERT INTO public."Price" (id, "stonkId", year, month, price) VALUES (7959, 2, 2017, 8, 118.33);
INSERT INTO public."Price" (id, "stonkId", year, month, price) VALUES (8091, 2, 2017, 11, 133);
INSERT INTO public."Price" (id, "stonkId", year, month, price) VALUES (7713, 2, 2017, 2, 133.72);
INSERT INTO public."Price" (id, "stonkId", year, month, price) VALUES (9064, 2, 2019, 10, 262.22);
INSERT INTO public."Price" (id, "stonkId", year, month, price) VALUES (11491, 2, 2024, 8, 126.35);
INSERT INTO public."Price" (id, "stonkId", year, month, price) VALUES (9612, 2, 2020, 11, 182.64);
INSERT INTO public."Price" (id, "stonkId", year, month, price) VALUES (11318, 2, 2024, 4, 163.79);
INSERT INTO public."Price" (id, "stonkId", year, month, price) VALUES (8381, 2, 2018, 6, 140.24);
INSERT INTO public."Price" (id, "stonkId", year, month, price) VALUES (7541, 2, 2016, 10, 137.97);
INSERT INTO public."Price" (id, "stonkId", year, month, price) VALUES (9021, 2, 2019, 9, 226.87);
INSERT INTO public."Price" (id, "stonkId", year, month, price) VALUES (7409, 2, 2016, 7, 138.28);
INSERT INTO public."Price" (id, "stonkId", year, month, price) VALUES (12721, 3, 2016, 3, 2598);
INSERT INTO public."Price" (id, "stonkId", year, month, price) VALUES (10554, 2, 2022, 10, 170.14);
INSERT INTO public."Price" (id, "stonkId", year, month, price) VALUES (8977, 2, 2019, 8, 232.5);
INSERT INTO public."Price" (id, "stonkId", year, month, price) VALUES (12299, 2, 2026, 3, 134.16);
INSERT INTO public."Price" (id, "stonkId", year, month, price) VALUES (578, 2, 2021, 6, 279.88);
INSERT INTO public."Price" (id, "stonkId", year, month, price) VALUES (13036, 3, 2017, 6, 2886.5);
INSERT INTO public."Price" (id, "stonkId", year, month, price) VALUES (12470, 3, 2015, 3, 2674.5);
INSERT INTO public."Price" (id, "stonkId", year, month, price) VALUES (8892, 2, 2019, 6, 233.64);
INSERT INTO public."Price" (id, "stonkId", year, month, price) VALUES (11834, 2, 2025, 4, 150.56);
INSERT INTO public."Price" (id, "stonkId", year, month, price) VALUES (10683, 2, 2023, 1, 158.67);
INSERT INTO public."Price" (id, "stonkId", year, month, price) VALUES (12531, 3, 2015, 6, 2448.8);
INSERT INTO public."Price" (id, "stonkId", year, month, price) VALUES (7875, 2, 2017, 6, 119.33);
INSERT INTO public."Price" (id, "stonkId", year, month, price) VALUES (9523, 2, 2020, 9, 170.87);
INSERT INTO public."Price" (id, "stonkId", year, month, price) VALUES (9437, 2, 2020, 7, 182.9);
INSERT INTO public."Price" (id, "stonkId", year, month, price) VALUES (8005, 2, 2017, 9, 121.81);
INSERT INTO public."Price" (id, "stonkId", year, month, price) VALUES (7751, 2, 2017, 3, 128.4);
INSERT INTO public."Price" (id, "stonkId", year, month, price) VALUES (8175, 2, 2018, 1, 142.95);
INSERT INTO public."Price" (id, "stonkId", year, month, price) VALUES (13442, 3, 2019, 1, 5271.5);
INSERT INTO public."Price" (id, "stonkId", year, month, price) VALUES (10808, 2, 2023, 4, 182.29);
INSERT INTO public."Price" (id, "stonkId", year, month, price) VALUES (8295, 2, 2018, 4, 145.63);
INSERT INTO public."Price" (id, "stonkId", year, month, price) VALUES (7585, 2, 2016, 11, 149.43);
INSERT INTO public."Price" (id, "stonkId", year, month, price) VALUES (8685, 2, 2019, 1, 164.3);
INSERT INTO public."Price" (id, "stonkId", year, month, price) VALUES (12891, 3, 2016, 11, 3164);
INSERT INTO public."Price" (id, "stonkId", year, month, price) VALUES (7451, 2, 2016, 8, 134.93);
INSERT INTO public."Price" (id, "stonkId", year, month, price) VALUES (12261, 2, 2026, 2, 127.04);
INSERT INTO public."Price" (id, "stonkId", year, month, price) VALUES (9864, 2, 2021, 5, 260.46);
INSERT INTO public."Price" (id, "stonkId", year, month, price) VALUES (9949, 2, 2021, 7, 284.84);
INSERT INTO public."Price" (id, "stonkId", year, month, price) VALUES (12804, 3, 2016, 7, 2873);
INSERT INTO public."Price" (id, "stonkId", year, month, price) VALUES (8423, 2, 2018, 7, 141.36);
INSERT INTO public."Price" (id, "stonkId", year, month, price) VALUES (9110, 2, 2019, 11, 255.07);
INSERT INTO public."Price" (id, "stonkId", year, month, price) VALUES (10037, 2, 2021, 9, 362.12);
INSERT INTO public."Price" (id, "stonkId", year, month, price) VALUES (758, 2, 2025, 9, 117.33);
INSERT INTO public."Price" (id, "stonkId", year, month, price) VALUES (8806, 2, 2019, 4, 164.28);
INSERT INTO public."Price" (id, "stonkId", year, month, price) VALUES (704, 2, 2024, 12, 131.97);
INSERT INTO public."Price" (id, "stonkId", year, month, price) VALUES (9697, 2, 2021, 1, 214.32);
INSERT INTO public."Price" (id, "stonkId", year, month, price) VALUES (10124, 2, 2021, 11, 336.66);
INSERT INTO public."Price" (id, "stonkId", year, month, price) VALUES (9775, 2, 2021, 3, 226.16);
INSERT INTO public."Price" (id, "stonkId", year, month, price) VALUES (11445, 2, 2024, 7, 133.28);
INSERT INTO public."Price" (id, "stonkId", year, month, price) VALUES (8554, 2, 2018, 10, 154.11);
INSERT INTO public."Price" (id, "stonkId", year, month, price) VALUES (307, 2, 2024, 2, 161.17);
INSERT INTO public."Price" (id, "stonkId", year, month, price) VALUES (12005, 2, 2025, 8, 134.55);
INSERT INTO public."Price" (id, "stonkId", year, month, price) VALUES (13399, 3, 2018, 11, 4867);
INSERT INTO public."Price" (id, "stonkId", year, month, price) VALUES (11624, 2, 2024, 11, 123.1);
INSERT INTO public."Price" (id, "stonkId", year, month, price) VALUES (9568, 2, 2020, 10, 155.19);
INSERT INTO public."Price" (id, "stonkId", year, month, price) VALUES (11751, 2, 2025, 2, 167.42);
INSERT INTO public."Price" (id, "stonkId", year, month, price) VALUES (10463, 2, 2022, 8, 255.28);
INSERT INTO public."Price" (id, "stonkId", year, month, price) VALUES (9481, 2, 2020, 8, 181.72);
INSERT INTO public."Price" (id, "stonkId", year, month, price) VALUES (13225, 3, 2018, 3, 3980.5);
INSERT INTO public."Price" (id, "stonkId", year, month, price) VALUES (12955, 3, 2017, 2, 3104);
INSERT INTO public."Price" (id, "stonkId", year, month, price) VALUES (12700, 3, 2016, 2, 2636);
INSERT INTO public."Price" (id, "stonkId", year, month, price) VALUES (12513, 3, 2015, 5, 2547);
INSERT INTO public."Price" (id, "stonkId", year, month, price) VALUES (10596, 2, 2022, 11, 167.97);
INSERT INTO public."Price" (id, "stonkId", year, month, price) VALUES (12223, 2, 2026, 1, 127.8);
INSERT INTO public."Price" (id, "stonkId", year, month, price) VALUES (12596, 3, 2015, 9, 2260.7);
INSERT INTO public."Price" (id, "stonkId", year, month, price) VALUES (11364, 2, 2024, 5, 125.97);
INSERT INTO public."Price" (id, "stonkId", year, month, price) VALUES (10725, 2, 2023, 2, 156.83);
INSERT INTO public."Price" (id, "stonkId", year, month, price) VALUES (11959, 2, 2025, 7, 121.86);
INSERT INTO public."Price" (id, "stonkId", year, month, price) VALUES (12640, 3, 2015, 11, 2547.1);
INSERT INTO public."Price" (id, "stonkId", year, month, price) VALUES (12552, 3, 2015, 7, 2485.7);
INSERT INTO public."Price" (id, "stonkId", year, month, price) VALUES (11578, 2, 2024, 10, 123.48);
INSERT INTO public."Price" (id, "stonkId", year, month, price) VALUES (11711, 2, 2025, 1, 141.95);
INSERT INTO public."Price" (id, "stonkId", year, month, price) VALUES (12764, 3, 2016, 5, 2600);
INSERT INTO public."Price" (id, "stonkId", year, month, price) VALUES (12138, 2, 2025, 11, 126.09);
INSERT INTO public."Price" (id, "stonkId", year, month, price) VALUES (12870, 3, 2016, 10, 3095.5);
INSERT INTO public."Price" (id, "stonkId", year, month, price) VALUES (11878, 2, 2025, 5, 131.04);
INSERT INTO public."Price" (id, "stonkId", year, month, price) VALUES (13078, 3, 2017, 8, 2927.5);
INSERT INTO public."Price" (id, "stonkId", year, month, price) VALUES (13016, 3, 2017, 5, 2769);
INSERT INTO public."Price" (id, "stonkId", year, month, price) VALUES (12783, 3, 2016, 6, 2680);
INSERT INTO public."Price" (id, "stonkId", year, month, price) VALUES (12996, 3, 2017, 4, 2847.5);
INSERT INTO public."Price" (id, "stonkId", year, month, price) VALUES (12934, 3, 2017, 1, 3384);
INSERT INTO public."Price" (id, "stonkId", year, month, price) VALUES (13101, 3, 2017, 9, 3061.5);
INSERT INTO public."Price" (id, "stonkId", year, month, price) VALUES (12825, 3, 2016, 8, 2943);
INSERT INTO public."Price" (id, "stonkId", year, month, price) VALUES (12682, 3, 2016, 1, 2516.8);
INSERT INTO public."Price" (id, "stonkId", year, month, price) VALUES (12974, 3, 2017, 3, 2991);
INSERT INTO public."Price" (id, "stonkId", year, month, price) VALUES (13310, 3, 2018, 7, 4445);
INSERT INTO public."Price" (id, "stonkId", year, month, price) VALUES (12848, 3, 2016, 9, 3081.5);
INSERT INTO public."Price" (id, "stonkId", year, month, price) VALUES (13057, 3, 2017, 7, 2793.5);
INSERT INTO public."Price" (id, "stonkId", year, month, price) VALUES (13246, 3, 2018, 4, 4200);
INSERT INTO public."Price" (id, "stonkId", year, month, price) VALUES (13144, 3, 2017, 11, 3300.5);
INSERT INTO public."Price" (id, "stonkId", year, month, price) VALUES (13289, 3, 2018, 6, 4307.5);
INSERT INTO public."Price" (id, "stonkId", year, month, price) VALUES (13186, 3, 2018, 1, 3721.5);
INSERT INTO public."Price" (id, "stonkId", year, month, price) VALUES (13206, 3, 2018, 2, 3789);
INSERT INTO public."Price" (id, "stonkId", year, month, price) VALUES (13332, 3, 2018, 8, 4697);
INSERT INTO public."Price" (id, "stonkId", year, month, price) VALUES (13503, 3, 2019, 4, 5500);
INSERT INTO public."Price" (id, "stonkId", year, month, price) VALUES (13355, 3, 2018, 9, 4988.5);
INSERT INTO public."Price" (id, "stonkId", year, month, price) VALUES (13376, 3, 2018, 10, 4903);
INSERT INTO public."Price" (id, "stonkId", year, month, price) VALUES (13482, 3, 2019, 3, 5872.5);
INSERT INTO public."Price" (id, "stonkId", year, month, price) VALUES (13525, 3, 2019, 5, 5241);
INSERT INTO public."Price" (id, "stonkId", year, month, price) VALUES (13566, 3, 2019, 7, 5211);
INSERT INTO public."Price" (id, "stonkId", year, month, price) VALUES (13462, 3, 2019, 2, 5520);
INSERT INTO public."Price" (id, "stonkId", year, month, price) VALUES (13546, 3, 2019, 6, 5340);
INSERT INTO public."Price" (id, "stonkId", year, month, price) VALUES (13633, 3, 2019, 10, 5928.5);
INSERT INTO public."Price" (id, "stonkId", year, month, price) VALUES (13589, 3, 2019, 8, 5365.5);
INSERT INTO public."Price" (id, "stonkId", year, month, price) VALUES (13843, 3, 2020, 8, 5021);
INSERT INTO public."Price" (id, "stonkId", year, month, price) VALUES (13611, 3, 2019, 9, 5406.5);
INSERT INTO public."Price" (id, "stonkId", year, month, price) VALUES (13656, 3, 2019, 11, 6124.5);
INSERT INTO public."Price" (id, "stonkId", year, month, price) VALUES (13864, 3, 2020, 9, 4484);
INSERT INTO public."Price" (id, "stonkId", year, month, price) VALUES (13821, 3, 2020, 7, 5085.5);
INSERT INTO public."Price" (id, "stonkId", year, month, price) VALUES (13887, 3, 2020, 10, 4039);
INSERT INTO public."Price" (id, "stonkId", year, month, price) VALUES (8513, 2, 2018, 9, 162.13);
INSERT INTO public."Price" (id, "stonkId", year, month, price) VALUES (13909, 3, 2020, 11, 5073);
INSERT INTO public."Price" (id, "stonkId", year, month, price) VALUES (8765, 2, 2019, 3, 150.07);
INSERT INTO public."Price" (id, "stonkId", year, month, price) VALUES (18891, 4, 2025, 4, 1191.8);
INSERT INTO public."Price" (id, "stonkId", year, month, price) VALUES (18200, 4, 2022, 8, 1135.2);
INSERT INTO public."Price" (id, "stonkId", year, month, price) VALUES (17941, 4, 2021, 7, 1629);
INSERT INTO public."Price" (id, "stonkId", year, month, price) VALUES (14101, 3, 2021, 8, 6295.5);
INSERT INTO public."Price" (id, "stonkId", year, month, price) VALUES (17232, 4, 2019, 3, 1068);
INSERT INTO public."Price" (id, "stonkId", year, month, price) VALUES (18008, 4, 2021, 10, 1792.8);
INSERT INTO public."Price" (id, "stonkId", year, month, price) VALUES (15092, 3, 2025, 7, 5915.5);
INSERT INTO public."Price" (id, "stonkId", year, month, price) VALUES (15804, 4, 2015, 11, 621.6);
INSERT INTO public."Price" (id, "stonkId", year, month, price) VALUES (15505, 4, 2015, 3, 428.4);
INSERT INTO public."Price" (id, "stonkId", year, month, price) VALUES (14123, 3, 2021, 9, 6935.5);
INSERT INTO public."Price" (id, "stonkId", year, month, price) VALUES (22, 4, 2014, 12, 436);
INSERT INTO public."Price" (id, "stonkId", year, month, price) VALUES (14792, 3, 2024, 5, 7452.5);
INSERT INTO public."Price" (id, "stonkId", year, month, price) VALUES (14405, 3, 2022, 11, 4596);
INSERT INTO public."Price" (id, "stonkId", year, month, price) VALUES (18762, 4, 2024, 10, 851.6);
INSERT INTO public."Price" (id, "stonkId", year, month, price) VALUES (16360, 4, 2017, 3, 708.1);
INSERT INTO public."Price" (id, "stonkId", year, month, price) VALUES (15159, 3, 2025, 10, 5461);
INSERT INTO public."Price" (id, "stonkId", year, month, price) VALUES (14167, 3, 2021, 11, 6567.5);
INSERT INTO public."Price" (id, "stonkId", year, month, price) VALUES (18654, 4, 2024, 5, 1089.4);
INSERT INTO public."Price" (id, "stonkId", year, month, price) VALUES (17683, 4, 2020, 7, 1085.4);
INSERT INTO public."Price" (id, "stonkId", year, month, price) VALUES (15617, 4, 2015, 6, 557.7);
INSERT INTO public."Price" (id, "stonkId", year, month, price) VALUES (13971, 3, 2021, 2, 5642);
INSERT INTO public."Price" (id, "stonkId", year, month, price) VALUES (16747, 4, 2018, 2, 725.8);
INSERT INTO public."Price" (id, "stonkId", year, month, price) VALUES (15115, 3, 2025, 8, 6461);
INSERT INTO public."Price" (id, "stonkId", year, month, price) VALUES (16607, 4, 2017, 10, 651.7);
INSERT INTO public."Price" (id, "stonkId", year, month, price) VALUES (15937, 4, 2016, 3, 600.2);
INSERT INTO public."Price" (id, "stonkId", year, month, price) VALUES (16534, 4, 2017, 8, 605);
INSERT INTO public."Price" (id, "stonkId", year, month, price) VALUES (14449, 3, 2023, 1, 3951);
INSERT INTO public."Price" (id, "stonkId", year, month, price) VALUES (14833, 3, 2024, 7, 6777.5);
INSERT INTO public."Price" (id, "stonkId", year, month, price) VALUES (14317, 3, 2022, 7, 3851);
INSERT INTO public."Price" (id, "stonkId", year, month, price) VALUES (16923, 4, 2018, 7, 923.2);
INSERT INTO public."Price" (id, "stonkId", year, month, price) VALUES (16295, 4, 2017, 1, 764.8);
INSERT INTO public."Price" (id, "stonkId", year, month, price) VALUES (508, 4, 2017, 12, 674.6);
INSERT INTO public."Price" (id, "stonkId", year, month, price) VALUES (14146, 3, 2021, 10, 7207.5);
INSERT INTO public."Price" (id, "stonkId", year, month, price) VALUES (15653, 4, 2015, 7, 579.4);
INSERT INTO public."Price" (id, "stonkId", year, month, price) VALUES (15225, 3, 2026, 1, 5326);
INSERT INTO public."Price" (id, "stonkId", year, month, price) VALUES (17726, 4, 2020, 9, 1066.6);
INSERT INTO public."Price" (id, "stonkId", year, month, price) VALUES (14967, 3, 2025, 1, 7174.5);
INSERT INTO public."Price" (id, "stonkId", year, month, price) VALUES (15904, 4, 2016, 2, 634.8);
INSERT INTO public."Price" (id, "stonkId", year, month, price) VALUES (16777, 4, 2018, 3, 742.7);
INSERT INTO public."Price" (id, "stonkId", year, month, price) VALUES (14470, 3, 2023, 2, 3972.5);
INSERT INTO public."Price" (id, "stonkId", year, month, price) VALUES (14338, 3, 2022, 8, 4237);
INSERT INTO public."Price" (id, "stonkId", year, month, price) VALUES (16399, 4, 2017, 4, 694.6);
INSERT INTO public."Price" (id, "stonkId", year, month, price) VALUES (14900, 3, 2024, 10, 6807);
INSERT INTO public."Price" (id, "stonkId", year, month, price) VALUES (14014, 3, 2021, 4, 5827.5);
INSERT INTO public."Price" (id, "stonkId", year, month, price) VALUES (17431, 4, 2019, 8, 1290.2);
INSERT INTO public."Price" (id, "stonkId", year, month, price) VALUES (16328, 4, 2017, 2, 749.5);
INSERT INTO public."Price" (id, "stonkId", year, month, price) VALUES (15874, 4, 2016, 1, 627.3);
INSERT INTO public."Price" (id, "stonkId", year, month, price) VALUES (16044, 4, 2016, 6, 645.2);
INSERT INTO public."Price" (id, "stonkId", year, month, price) VALUES (15545, 4, 2015, 4, 495.7);
INSERT INTO public."Price" (id, "stonkId", year, month, price) VALUES (17042, 4, 2018, 10, 1056.6);
INSERT INTO public."Price" (id, "stonkId", year, month, price) VALUES (14277, 3, 2022, 5, 4092);
INSERT INTO public."Price" (id, "stonkId", year, month, price) VALUES (14987, 3, 2025, 2, 7462);
INSERT INTO public."Price" (id, "stonkId", year, month, price) VALUES (14532, 3, 2023, 5, 5556);
INSERT INTO public."Price" (id, "stonkId", year, month, price) VALUES (14036, 3, 2021, 5, 5992);
INSERT INTO public."Price" (id, "stonkId", year, month, price) VALUES (15244, 3, 2026, 2, 5191.5);
INSERT INTO public."Price" (id, "stonkId", year, month, price) VALUES (17192, 4, 2019, 2, 1084.2);
INSERT INTO public."Price" (id, "stonkId", year, month, price) VALUES (14923, 3, 2024, 11, 6858.5);
INSERT INTO public."Price" (id, "stonkId", year, month, price) VALUES (18246, 4, 2022, 10, 1110.8);
INSERT INTO public."Price" (id, "stonkId", year, month, price) VALUES (17389, 4, 2019, 7, 1319.2);
INSERT INTO public."Price" (id, "stonkId", year, month, price) VALUES (15765, 4, 2015, 10, 584.5);
INSERT INTO public."Price" (id, "stonkId", year, month, price) VALUES (16814, 4, 2018, 4, 767.1);
INSERT INTO public."Price" (id, "stonkId", year, month, price) VALUES (16224, 4, 2016, 11, 728);
INSERT INTO public."Price" (id, "stonkId", year, month, price) VALUES (14295, 3, 2022, 6, 3960.5);
INSERT INTO public."Price" (id, "stonkId", year, month, price) VALUES (14079, 3, 2021, 7, 6305);
INSERT INTO public."Price" (id, "stonkId", year, month, price) VALUES (14769, 3, 2024, 4, 8112.5);
INSERT INTO public."Price" (id, "stonkId", year, month, price) VALUES (17853, 4, 2021, 3, 1493);
INSERT INTO public."Price" (id, "stonkId", year, month, price) VALUES (15728, 4, 2015, 9, 598.8);
INSERT INTO public."Price" (id, "stonkId", year, month, price) VALUES (15029, 3, 2025, 4, 6659.5);
INSERT INTO public."Price" (id, "stonkId", year, month, price) VALUES (15182, 3, 2025, 11, 5469);
INSERT INTO public."Price" (id, "stonkId", year, month, price) VALUES (15975, 4, 2016, 4, 627.2);
INSERT INTO public."Price" (id, "stonkId", year, month, price) VALUES (14856, 3, 2024, 8, 6225);
INSERT INTO public."Price" (id, "stonkId", year, month, price) VALUES (18179, 4, 2022, 7, 1042.4);
INSERT INTO public."Price" (id, "stonkId", year, month, price) VALUES (17705, 4, 2020, 8, 1106.4);
INSERT INTO public."Price" (id, "stonkId", year, month, price) VALUES (14384, 3, 2022, 10, 4708.5);
INSERT INTO public."Price" (id, "stonkId", year, month, price) VALUES (16887, 4, 2018, 6, 858.6);
INSERT INTO public."Price" (id, "stonkId", year, month, price) VALUES (14512, 3, 2023, 4, 4675);
INSERT INTO public."Price" (id, "stonkId", year, month, price) VALUES (17771, 4, 2020, 11, 1207.4);
INSERT INTO public."Price" (id, "stonkId", year, month, price) VALUES (16013, 4, 2016, 5, 658.4);
INSERT INTO public."Price" (id, "stonkId", year, month, price) VALUES (15583, 4, 2015, 5, 534.1);
INSERT INTO public."Price" (id, "stonkId", year, month, price) VALUES (17354, 4, 2019, 6, 1339.4);
INSERT INTO public."Price" (id, "stonkId", year, month, price) VALUES (16153, 4, 2016, 9, 678.5);
INSERT INTO public."Price" (id, "stonkId", year, month, price) VALUES (16114, 4, 2016, 8, 687.8);
INSERT INTO public."Price" (id, "stonkId", year, month, price) VALUES (15051, 3, 2025, 5, 6724.5);
INSERT INTO public."Price" (id, "stonkId", year, month, price) VALUES (15263, 3, 2026, 3, 5611);
INSERT INTO public."Price" (id, "stonkId", year, month, price) VALUES (16716, 4, 2018, 1, 717.6);
INSERT INTO public."Price" (id, "stonkId", year, month, price) VALUES (17156, 4, 2019, 1, 1146.7);
INSERT INTO public."Price" (id, "stonkId", year, month, price) VALUES (16080, 4, 2016, 7, 652.1);
INSERT INTO public."Price" (id, "stonkId", year, month, price) VALUES (16641, 4, 2017, 11, 658.7);
INSERT INTO public."Price" (id, "stonkId", year, month, price) VALUES (16503, 4, 2017, 7, 605.9);
INSERT INTO public."Price" (id, "stonkId", year, month, price) VALUES (15692, 4, 2015, 8, 617.5);
INSERT INTO public."Price" (id, "stonkId", year, month, price) VALUES (16854, 4, 2018, 5, 837.9);
INSERT INTO public."Price" (id, "stonkId", year, month, price) VALUES (17898, 4, 2021, 5, 1452);
INSERT INTO public."Price" (id, "stonkId", year, month, price) VALUES (17005, 4, 2018, 9, 1150.7);
INSERT INTO public."Price" (id, "stonkId", year, month, price) VALUES (16466, 4, 2017, 6, 648.1);
INSERT INTO public."Price" (id, "stonkId", year, month, price) VALUES (16191, 4, 2016, 10, 658.4);
INSERT INTO public."Price" (id, "stonkId", year, month, price) VALUES (17833, 4, 2021, 2, 1280.8);
INSERT INTO public."Price" (id, "stonkId", year, month, price) VALUES (16433, 4, 2017, 5, 645.3);
INSERT INTO public."Price" (id, "stonkId", year, month, price) VALUES (17082, 4, 2018, 11, 1149.8);
INSERT INTO public."Price" (id, "stonkId", year, month, price) VALUES (18157, 4, 2022, 6, 1014.8);
INSERT INTO public."Price" (id, "stonkId", year, month, price) VALUES (18139, 4, 2022, 5, 921);
INSERT INTO public."Price" (id, "stonkId", year, month, price) VALUES (17312, 4, 2019, 5, 1312.4);
INSERT INTO public."Price" (id, "stonkId", year, month, price) VALUES (17518, 4, 2019, 11, 1271.4);
INSERT INTO public."Price" (id, "stonkId", year, month, price) VALUES (17473, 4, 2019, 9, 1327.4);
INSERT INTO public."Price" (id, "stonkId", year, month, price) VALUES (16963, 4, 2018, 8, 1088.3);
INSERT INTO public."Price" (id, "stonkId", year, month, price) VALUES (17495, 4, 2019, 10, 1358);
INSERT INTO public."Price" (id, "stonkId", year, month, price) VALUES (17270, 4, 2019, 4, 1198.2);
INSERT INTO public."Price" (id, "stonkId", year, month, price) VALUES (18267, 4, 2022, 11, 1033.8);
INSERT INTO public."Price" (id, "stonkId", year, month, price) VALUES (17814, 4, 2021, 1, 1284.2);
INSERT INTO public."Price" (id, "stonkId", year, month, price) VALUES (17749, 4, 2020, 10, 961.4);
INSERT INTO public."Price" (id, "stonkId", year, month, price) VALUES (18029, 4, 2021, 11, 1632.6);
INSERT INTO public."Price" (id, "stonkId", year, month, price) VALUES (18311, 4, 2023, 1, 1027.2);
INSERT INTO public."Price" (id, "stonkId", year, month, price) VALUES (17876, 4, 2021, 4, 1371);
INSERT INTO public."Price" (id, "stonkId", year, month, price) VALUES (17985, 4, 2021, 9, 1909.6);
INSERT INTO public."Price" (id, "stonkId", year, month, price) VALUES (17963, 4, 2021, 8, 1728.6);
INSERT INTO public."Price" (id, "stonkId", year, month, price) VALUES (230, 4, 2022, 2, 1178);
INSERT INTO public."Price" (id, "stonkId", year, month, price) VALUES (18332, 4, 2023, 2, 1063.6);
INSERT INTO public."Price" (id, "stonkId", year, month, price) VALUES (18695, 4, 2024, 7, 1043.8);
INSERT INTO public."Price" (id, "stonkId", year, month, price) VALUES (18394, 4, 2023, 5, 1300.6);
INSERT INTO public."Price" (id, "stonkId", year, month, price) VALUES (18631, 4, 2024, 4, 1235.6);
INSERT INTO public."Price" (id, "stonkId", year, month, price) VALUES (19044, 4, 2025, 11, 1147.2);
INSERT INTO public."Price" (id, "stonkId", year, month, price) VALUES (18374, 4, 2023, 4, 1327);
INSERT INTO public."Price" (id, "stonkId", year, month, price) VALUES (325, 4, 2023, 12, 1465);
INSERT INTO public."Price" (id, "stonkId", year, month, price) VALUES (18785, 4, 2024, 11, 826.8);
INSERT INTO public."Price" (id, "stonkId", year, month, price) VALUES (18718, 4, 2024, 8, 979.8);
INSERT INTO public."Price" (id, "stonkId", year, month, price) VALUES (18977, 4, 2025, 8, 1232.4);
INSERT INTO public."Price" (id, "stonkId", year, month, price) VALUES (18954, 4, 2025, 7, 1016);
INSERT INTO public."Price" (id, "stonkId", year, month, price) VALUES (18829, 4, 2025, 1, 1088);
INSERT INTO public."Price" (id, "stonkId", year, month, price) VALUES (18849, 4, 2025, 2, 1253.8);
INSERT INTO public."Price" (id, "stonkId", year, month, price) VALUES (18913, 4, 2025, 5, 1094.8);
INSERT INTO public."Price" (id, "stonkId", year, month, price) VALUES (19021, 4, 2025, 10, 1052.2);
INSERT INTO public."Price" (id, "stonkId", year, month, price) VALUES (19087, 4, 2026, 1, 1177.2);
INSERT INTO public."Price" (id, "stonkId", year, month, price) VALUES (19106, 4, 2026, 2, 1193.5);
INSERT INTO public."Price" (id, "stonkId", year, month, price) VALUES (19125, 4, 2026, 3, 1289.9);
INSERT INTO public."Price" (id, "stonkId", year, month, price) VALUES (29, 5, 2015, 1, 228.8);
INSERT INTO public."Price" (id, "stonkId", year, month, price) VALUES (13952, 3, 2021, 1, 5452);
INSERT INTO public."Price" (id, "stonkId", year, month, price) VALUES (19397, 5, 2015, 3, 249.15);
INSERT INTO public."Price" (id, "stonkId", year, month, price) VALUES (19439, 5, 2015, 4, 255.3);
INSERT INTO public."Price" (id, "stonkId", year, month, price) VALUES (19483, 5, 2015, 5, 242.3);
INSERT INTO public."Price" (id, "stonkId", year, month, price) VALUES (19519, 5, 2015, 6, 230.2);
INSERT INTO public."Price" (id, "stonkId", year, month, price) VALUES (19561, 5, 2015, 7, 232.85);
INSERT INTO public."Price" (id, "stonkId", year, month, price) VALUES (19607, 5, 2015, 8, 243.85);
INSERT INTO public."Price" (id, "stonkId", year, month, price) VALUES (19649, 5, 2015, 9, 243.4);
INSERT INTO public."Price" (id, "stonkId", year, month, price) VALUES (13991, 3, 2021, 3, 6123.5);
INSERT INTO public."Price" (id, "stonkId", year, month, price) VALUES (20106, 5, 2016, 8, 344.35);
INSERT INTO public."Price" (id, "stonkId", year, month, price) VALUES (25648, 6, 2018, 6, 28.455);
INSERT INTO public."Price" (id, "stonkId", year, month, price) VALUES (23532, 5, 2025, 1, 531.1);
INSERT INTO public."Price" (id, "stonkId", year, month, price) VALUES (19984, 5, 2016, 5, 319.05);
INSERT INTO public."Price" (id, "stonkId", year, month, price) VALUES (22174, 5, 2020, 9, 385.25);
INSERT INTO public."Price" (id, "stonkId", year, month, price) VALUES (20658, 5, 2017, 9, 320.6);
INSERT INTO public."Price" (id, "stonkId", year, month, price) VALUES (24251, 6, 2015, 7, 33.635);
INSERT INTO public."Price" (id, "stonkId", year, month, price) VALUES (25116, 6, 2017, 4, 28.125);
INSERT INTO public."Price" (id, "stonkId", year, month, price) VALUES (23014, 5, 2023, 1, 340);
INSERT INTO public."Price" (id, "stonkId", year, month, price) VALUES (24425, 6, 2015, 11, 34.28);
INSERT INTO public."Price" (id, "stonkId", year, month, price) VALUES (19856, 5, 2016, 2, 285.05);
INSERT INTO public."Price" (id, "stonkId", year, month, price) VALUES (20828, 5, 2018, 1, 343.7);
INSERT INTO public."Price" (id, "stonkId", year, month, price) VALUES (23616, 5, 2025, 5, 428.15);
INSERT INTO public."Price" (id, "stonkId", year, month, price) VALUES (21583, 5, 2019, 7, 421.25);
INSERT INTO public."Price" (id, "stonkId", year, month, price) VALUES (21673, 5, 2019, 9, 420.7);
INSERT INTO public."Price" (id, "stonkId", year, month, price) VALUES (21417, 5, 2019, 3, 409.7);
INSERT INTO public."Price" (id, "stonkId", year, month, price) VALUES (22732, 5, 2021, 11, 565.25);
INSERT INTO public."Price" (id, "stonkId", year, month, price) VALUES (20948, 5, 2018, 4, 383.65);
INSERT INTO public."Price" (id, "stonkId", year, month, price) VALUES (23747, 5, 2025, 11, 403.5);
INSERT INTO public."Price" (id, "stonkId", year, month, price) VALUES (24506, 6, 2016, 1, 37.195);
INSERT INTO public."Price" (id, "stonkId", year, month, price) VALUES (22860, 5, 2022, 6, 366.6);
INSERT INTO public."Price" (id, "stonkId", year, month, price) VALUES (22386, 5, 2021, 2, 526.2);
INSERT INTO public."Price" (id, "stonkId", year, month, price) VALUES (20448, 5, 2017, 4, 319.3);
INSERT INTO public."Price" (id, "stonkId", year, month, price) VALUES (19693, 5, 2015, 10, 257.15);
INSERT INTO public."Price" (id, "stonkId", year, month, price) VALUES (20570, 5, 2017, 7, 308.75);
INSERT INTO public."Price" (id, "stonkId", year, month, price) VALUES (20324, 5, 2017, 1, 399.1);
INSERT INTO public."Price" (id, "stonkId", year, month, price) VALUES (20022, 5, 2016, 6, 329.1);
INSERT INTO public."Price" (id, "stonkId", year, month, price) VALUES (20152, 5, 2016, 9, 347);
INSERT INTO public."Price" (id, "stonkId", year, month, price) VALUES (23465, 5, 2024, 10, 434.35);
INSERT INTO public."Price" (id, "stonkId", year, month, price) VALUES (23077, 5, 2023, 4, 395.2);
INSERT INTO public."Price" (id, "stonkId", year, month, price) VALUES (22471, 5, 2021, 4, 525.65);
INSERT INTO public."Price" (id, "stonkId", year, month, price) VALUES (21076, 5, 2018, 7, 414.15);
INSERT INTO public."Price" (id, "stonkId", year, month, price) VALUES (22263, 5, 2020, 11, 449.55);
INSERT INTO public."Price" (id, "stonkId", year, month, price) VALUES (19898, 5, 2016, 3, 305.1);
INSERT INTO public."Price" (id, "stonkId", year, month, price) VALUES (21502, 5, 2019, 5, 431.9);
INSERT INTO public."Price" (id, "stonkId", year, month, price) VALUES (20700, 5, 2017, 10, 321.1);
INSERT INTO public."Price" (id, "stonkId", year, month, price) VALUES (21338, 5, 2019, 1, 414.55);
INSERT INTO public."Price" (id, "stonkId", year, month, price) VALUES (22600, 5, 2021, 7, 544.9);
INSERT INTO public."Price" (id, "stonkId", year, month, price) VALUES (20868, 5, 2018, 2, 332.3);
INSERT INTO public."Price" (id, "stonkId", year, month, price) VALUES (22688, 5, 2021, 9, 616.5);
INSERT INTO public."Price" (id, "stonkId", year, month, price) VALUES (24131, 6, 2015, 4, 37.515);
INSERT INTO public."Price" (id, "stonkId", year, month, price) VALUES (19737, 5, 2015, 11, 269.15);
INSERT INTO public."Price" (id, "stonkId", year, month, price) VALUES (23790, 5, 2026, 1, 407.5);
INSERT INTO public."Price" (id, "stonkId", year, month, price) VALUES (22089, 5, 2020, 7, 356);
INSERT INTO public."Price" (id, "stonkId", year, month, price) VALUES (24091, 6, 2015, 3, 35.985);
INSERT INTO public."Price" (id, "stonkId", year, month, price) VALUES (743, 5, 2025, 6, 440.15);
INSERT INTO public."Price" (id, "stonkId", year, month, price) VALUES (23035, 5, 2023, 2, 358.85);
INSERT INTO public."Price" (id, "stonkId", year, month, price) VALUES (22882, 5, 2022, 7, 350.05);
INSERT INTO public."Price" (id, "stonkId", year, month, price) VALUES (20488, 5, 2017, 5, 302.3);
INSERT INTO public."Price" (id, "stonkId", year, month, price) VALUES (20366, 5, 2017, 2, 330.55);
INSERT INTO public."Price" (id, "stonkId", year, month, price) VALUES (20064, 5, 2016, 7, 327.1);
INSERT INTO public."Price" (id, "stonkId", year, month, price) VALUES (20992, 5, 2018, 5, 384.7);
INSERT INTO public."Price" (id, "stonkId", year, month, price) VALUES (20196, 5, 2016, 10, 347.35);
INSERT INTO public."Price" (id, "stonkId", year, month, price) VALUES (21716, 5, 2019, 10, 430.55);
INSERT INTO public."Price" (id, "stonkId", year, month, price) VALUES (21207, 5, 2018, 10, 462.45);
INSERT INTO public."Price" (id, "stonkId", year, month, price) VALUES (19942, 5, 2016, 4, 348);
INSERT INTO public."Price" (id, "stonkId", year, month, price) VALUES (21458, 5, 2019, 4, 429.05);
INSERT INTO public."Price" (id, "stonkId", year, month, price) VALUES (20612, 5, 2017, 8, 307.25);
INSERT INTO public."Price" (id, "stonkId", year, month, price) VALUES (23552, 5, 2025, 2, 551.4);
INSERT INTO public."Price" (id, "stonkId", year, month, price) VALUES (21378, 5, 2019, 2, 397.5);
INSERT INTO public."Price" (id, "stonkId", year, month, price) VALUES (21629, 5, 2019, 8, 407.2);
INSERT INTO public."Price" (id, "stonkId", year, month, price) VALUES (22949, 5, 2022, 10, 335.7);
INSERT INTO public."Price" (id, "stonkId", year, month, price) VALUES (24874, 6, 2016, 10, 27.105);
INSERT INTO public."Price" (id, "stonkId", year, month, price) VALUES (20744, 5, 2017, 11, 291.15);
INSERT INTO public."Price" (id, "stonkId", year, month, price) VALUES (22133, 5, 2020, 8, 376.65);
INSERT INTO public."Price" (id, "stonkId", year, month, price) VALUES (24746, 6, 2016, 7, 31.58);
INSERT INTO public."Price" (id, "stonkId", year, month, price) VALUES (24210, 6, 2015, 6, 33.01);
INSERT INTO public."Price" (id, "stonkId", year, month, price) VALUES (21120, 5, 2018, 8, 434.7);
INSERT INTO public."Price" (id, "stonkId", year, month, price) VALUES (20906, 5, 2018, 3, 315.45);
INSERT INTO public."Price" (id, "stonkId", year, month, price) VALUES (21544, 5, 2019, 6, 413.8);
INSERT INTO public."Price" (id, "stonkId", year, month, price) VALUES (23680, 5, 2025, 8, 458.9);
INSERT INTO public."Price" (id, "stonkId", year, month, price) VALUES (23357, 5, 2024, 5, 564.2);
INSERT INTO public."Price" (id, "stonkId", year, month, price) VALUES (24337, 6, 2015, 9, 33.51);
INSERT INTO public."Price" (id, "stonkId", year, month, price) VALUES (20528, 5, 2017, 6, 327.7);
INSERT INTO public."Price" (id, "stonkId", year, month, price) VALUES (20404, 5, 2017, 3, 324.5);
INSERT INTO public."Price" (id, "stonkId", year, month, price) VALUES (20238, 5, 2016, 11, 341.1);
INSERT INTO public."Price" (id, "stonkId", year, month, price) VALUES (22903, 5, 2022, 8, 370.05);
INSERT INTO public."Price" (id, "stonkId", year, month, price) VALUES (23488, 5, 2024, 11, 478.95);
INSERT INTO public."Price" (id, "stonkId", year, month, price) VALUES (22348, 5, 2021, 1, 476.7);
INSERT INTO public."Price" (id, "stonkId", year, month, price) VALUES (21034, 5, 2018, 6, 393.75);
INSERT INTO public."Price" (id, "stonkId", year, month, price) VALUES (22711, 5, 2021, 10, 635.05);
INSERT INTO public."Price" (id, "stonkId", year, month, price) VALUES (23097, 5, 2023, 5, 443.65);
INSERT INTO public."Price" (id, "stonkId", year, month, price) VALUES (22515, 5, 2021, 5, 528.45);
INSERT INTO public."Price" (id, "stonkId", year, month, price) VALUES (23828, 5, 2026, 3, 485.35);
INSERT INTO public."Price" (id, "stonkId", year, month, price) VALUES (21253, 5, 2018, 11, 420.35);
INSERT INTO public."Price" (id, "stonkId", year, month, price) VALUES (22426, 5, 2021, 3, 570.75);
INSERT INTO public."Price" (id, "stonkId", year, month, price) VALUES (22219, 5, 2020, 10, 349.4);
INSERT INTO public."Price" (id, "stonkId", year, month, price) VALUES (21762, 5, 2019, 11, 441.6);
INSERT INTO public."Price" (id, "stonkId", year, month, price) VALUES (25189, 6, 2017, 6, 25.79);
INSERT INTO public."Price" (id, "stonkId", year, month, price) VALUES (25396, 6, 2017, 11, 27.6);
INSERT INTO public."Price" (id, "stonkId", year, month, price) VALUES (22970, 5, 2022, 11, 335.55);
INSERT INTO public."Price" (id, "stonkId", year, month, price) VALUES (22644, 5, 2021, 8, 535.2);
INSERT INTO public."Price" (id, "stonkId", year, month, price) VALUES (23657, 5, 2025, 7, 419.15);
INSERT INTO public."Price" (id, "stonkId", year, month, price) VALUES (24915, 6, 2016, 11, 29.82);
INSERT INTO public."Price" (id, "stonkId", year, month, price) VALUES (22842, 5, 2022, 5, 379.7);
INSERT INTO public."Price" (id, "stonkId", year, month, price) VALUES (24381, 6, 2015, 10, 35.405);
INSERT INTO public."Price" (id, "stonkId", year, month, price) VALUES (23594, 5, 2025, 4, 454.75);
INSERT INTO public."Price" (id, "stonkId", year, month, price) VALUES (24831, 6, 2016, 9, 30.69);
INSERT INTO public."Price" (id, "stonkId", year, month, price) VALUES (23809, 5, 2026, 2, 393.1);
INSERT INTO public."Price" (id, "stonkId", year, month, price) VALUES (23398, 5, 2024, 7, 513.7);
INSERT INTO public."Price" (id, "stonkId", year, month, price) VALUES (23334, 5, 2024, 4, 582.35);
INSERT INTO public."Price" (id, "stonkId", year, month, price) VALUES (24626, 6, 2016, 4, 34.67);
INSERT INTO public."Price" (id, "stonkId", year, month, price) VALUES (24583, 6, 2016, 3, 39.25);
INSERT INTO public."Price" (id, "stonkId", year, month, price) VALUES (23421, 5, 2024, 8, 482.4);
INSERT INTO public."Price" (id, "stonkId", year, month, price) VALUES (23724, 5, 2025, 10, 383.6);
INSERT INTO public."Price" (id, "stonkId", year, month, price) VALUES (25800, 6, 2018, 10, 26.48);
INSERT INTO public."Price" (id, "stonkId", year, month, price) VALUES (492, 6, 2016, 12, 30.93);
INSERT INTO public."Price" (id, "stonkId", year, month, price) VALUES (24175, 6, 2015, 5, 32.32);
INSERT INTO public."Price" (id, "stonkId", year, month, price) VALUES (25547, 6, 2018, 3, 28.585);
INSERT INTO public."Price" (id, "stonkId", year, month, price) VALUES (25615, 6, 2018, 5, 28.59);
INSERT INTO public."Price" (id, "stonkId", year, month, price) VALUES (24541, 6, 2016, 2, 39.32);
INSERT INTO public."Price" (id, "stonkId", year, month, price) VALUES (25073, 6, 2017, 3, 29.165);
INSERT INTO public."Price" (id, "stonkId", year, month, price) VALUES (25270, 6, 2017, 8, 26.69);
INSERT INTO public."Price" (id, "stonkId", year, month, price) VALUES (24787, 6, 2016, 8, 31);
INSERT INTO public."Price" (id, "stonkId", year, month, price) VALUES (24704, 6, 2016, 6, 33.09);
INSERT INTO public."Price" (id, "stonkId", year, month, price) VALUES (24296, 6, 2015, 8, 34.645);
INSERT INTO public."Price" (id, "stonkId", year, month, price) VALUES (24667, 6, 2016, 5, 33.97);
INSERT INTO public."Price" (id, "stonkId", year, month, price) VALUES (25355, 6, 2017, 10, 29.485);
INSERT INTO public."Price" (id, "stonkId", year, month, price) VALUES (25153, 6, 2017, 5, 30.39);
INSERT INTO public."Price" (id, "stonkId", year, month, price) VALUES (25037, 6, 2017, 2, 29.475);
INSERT INTO public."Price" (id, "stonkId", year, month, price) VALUES (25000, 6, 2017, 1, 32.385);
INSERT INTO public."Price" (id, "stonkId", year, month, price) VALUES (25314, 6, 2017, 9, 29.395);
INSERT INTO public."Price" (id, "stonkId", year, month, price) VALUES (25229, 6, 2017, 7, 26.34);
INSERT INTO public."Price" (id, "stonkId", year, month, price) VALUES (25511, 6, 2018, 2, 28.805);
INSERT INTO public."Price" (id, "stonkId", year, month, price) VALUES (25477, 6, 2018, 1, 29.345);
INSERT INTO public."Price" (id, "stonkId", year, month, price) VALUES (25690, 6, 2018, 7, 28.955);
INSERT INTO public."Price" (id, "stonkId", year, month, price) VALUES (25579, 6, 2018, 4, 29.705);
INSERT INTO public."Price" (id, "stonkId", year, month, price) VALUES (25727, 6, 2018, 8, 28.545);
INSERT INTO public."Price" (id, "stonkId", year, month, price) VALUES (25767, 6, 2018, 9, 27.695);
INSERT INTO public."Price" (id, "stonkId", year, month, price) VALUES (25996, 6, 2019, 3, 24.765);
INSERT INTO public."Price" (id, "stonkId", year, month, price) VALUES (25841, 6, 2018, 11, 27.275);
INSERT INTO public."Price" (id, "stonkId", year, month, price) VALUES (26037, 6, 2019, 4, 24.6);
INSERT INTO public."Price" (id, "stonkId", year, month, price) VALUES (25918, 6, 2019, 1, 27.435);
INSERT INTO public."Price" (id, "stonkId", year, month, price) VALUES (25956, 6, 2019, 2, 25.785);
INSERT INTO public."Price" (id, "stonkId", year, month, price) VALUES (26080, 6, 2019, 5, 24.86);
INSERT INTO public."Price" (id, "stonkId", year, month, price) VALUES (26204, 6, 2019, 8, 27.06);
INSERT INTO public."Price" (id, "stonkId", year, month, price) VALUES (26247, 6, 2019, 9, 35.22);
INSERT INTO public."Price" (id, "stonkId", year, month, price) VALUES (26120, 6, 2019, 6, 26.415);
INSERT INTO public."Price" (id, "stonkId", year, month, price) VALUES (26158, 6, 2019, 7, 26.94);
INSERT INTO public."Price" (id, "stonkId", year, month, price) VALUES (26290, 6, 2019, 10, 43.07);
INSERT INTO public."Price" (id, "stonkId", year, month, price) VALUES (26336, 6, 2019, 11, 43.63);
INSERT INTO public."Price" (id, "stonkId", year, month, price) VALUES (143, 6, 2020, 5, 39.605);
INSERT INTO public."Price" (id, "stonkId", year, month, price) VALUES (19821, 5, 2016, 1, 268.3);
INSERT INTO public."Price" (id, "stonkId", year, month, price) VALUES (21166, 5, 2018, 9, 488.2);
INSERT INTO public."Price" (id, "stonkId", year, month, price) VALUES (28704, 6, 2024, 8, 23.74);
INSERT INTO public."Price" (id, "stonkId", year, month, price) VALUES (27566, 6, 2022, 5, 22.19);
INSERT INTO public."Price" (id, "stonkId", year, month, price) VALUES (31096, 7, 2018, 1, 566.7);
INSERT INTO public."Price" (id, "stonkId", year, month, price) VALUES (29890, 7, 2015, 6, 294.7);
INSERT INTO public."Price" (id, "stonkId", year, month, price) VALUES (27088, 6, 2021, 5, 36.47);
INSERT INTO public."Price" (id, "stonkId", year, month, price) VALUES (30863, 7, 2017, 7, 387.75);
INSERT INTO public."Price" (id, "stonkId", year, month, price) VALUES (28069, 6, 2023, 5, 24.35);
INSERT INTO public."Price" (id, "stonkId", year, month, price) VALUES (26959, 6, 2021, 2, 32.805);
INSERT INTO public."Price" (id, "stonkId", year, month, price) VALUES (27687, 6, 2022, 8, 25.23);
INSERT INTO public."Price" (id, "stonkId", year, month, price) VALUES (30349, 7, 2016, 6, 328.2);
INSERT INTO public."Price" (id, "stonkId", year, month, price) VALUES (27906, 6, 2023, 1, 23.18);
INSERT INTO public."Price" (id, "stonkId", year, month, price) VALUES (31844, 7, 2019, 8, 736);
INSERT INTO public."Price" (id, "stonkId", year, month, price) VALUES (29216, 6, 2025, 8, 22.855);
INSERT INTO public."Price" (id, "stonkId", year, month, price) VALUES (31600, 7, 2019, 2, 780.6);
INSERT INTO public."Price" (id, "stonkId", year, month, price) VALUES (33199, 7, 2024, 11, 543);
INSERT INTO public."Price" (id, "stonkId", year, month, price) VALUES (30315, 7, 2016, 5, 305.7);
INSERT INTO public."Price" (id, "stonkId", year, month, price) VALUES (26792, 6, 2020, 10, 33.28);
INSERT INTO public."Price" (id, "stonkId", year, month, price) VALUES (31909, 7, 2019, 10, 752);
INSERT INTO public."Price" (id, "stonkId", year, month, price) VALUES (150, 7, 2020, 6, 558.9);
INSERT INTO public."Price" (id, "stonkId", year, month, price) VALUES (28923, 6, 2025, 1, 27.91);
INSERT INTO public."Price" (id, "stonkId", year, month, price) VALUES (28577, 6, 2024, 5, 29.205);
INSERT INTO public."Price" (id, "stonkId", year, month, price) VALUES (29929, 7, 2015, 7, 293.8);
INSERT INTO public."Price" (id, "stonkId", year, month, price) VALUES (26661, 6, 2020, 7, 37.195);
INSERT INTO public."Price" (id, "stonkId", year, month, price) VALUES (29498, 6, 2026, 3, 21.245);
INSERT INTO public."Price" (id, "stonkId", year, month, price) VALUES (29819, 7, 2015, 4, 294.7);
INSERT INTO public."Price" (id, "stonkId", year, month, price) VALUES (30390, 7, 2016, 7, 317.85);
INSERT INTO public."Price" (id, "stonkId", year, month, price) VALUES (31277, 7, 2018, 6, 668.7);
INSERT INTO public."Price" (id, "stonkId", year, month, price) VALUES (30549, 7, 2016, 11, 391.4);
INSERT INTO public."Price" (id, "stonkId", year, month, price) VALUES (30234, 7, 2016, 3, 359.3);
INSERT INTO public."Price" (id, "stonkId", year, month, price) VALUES (28791, 6, 2024, 10, 22.705);
INSERT INTO public."Price" (id, "stonkId", year, month, price) VALUES (27173, 6, 2021, 7, 32.655);
INSERT INTO public."Price" (id, "stonkId", year, month, price) VALUES (30162, 7, 2016, 1, 328.6);
INSERT INTO public."Price" (id, "stonkId", year, month, price) VALUES (27602, 6, 2022, 6, 24.485);
INSERT INTO public."Price" (id, "stonkId", year, month, price) VALUES (27306, 6, 2021, 10, 34.045);
INSERT INTO public."Price" (id, "stonkId", year, month, price) VALUES (30901, 7, 2017, 8, 384.55);
INSERT INTO public."Price" (id, "stonkId", year, month, price) VALUES (29858, 7, 2015, 5, 295.65);
INSERT INTO public."Price" (id, "stonkId", year, month, price) VALUES (29090, 6, 2025, 5, 21.96);
INSERT INTO public."Price" (id, "stonkId", year, month, price) VALUES (27778, 6, 2022, 10, 21.66);
INSERT INTO public."Price" (id, "stonkId", year, month, price) VALUES (27946, 6, 2023, 2, 22.77);
INSERT INTO public."Price" (id, "stonkId", year, month, price) VALUES (26836, 6, 2020, 11, 35.615);
INSERT INTO public."Price" (id, "stonkId", year, month, price) VALUES (29428, 6, 2026, 1, 22.16);
INSERT INTO public."Price" (id, "stonkId", year, month, price) VALUES (340, 6, 2023, 7, 29.585);
INSERT INTO public."Price" (id, "stonkId", year, month, price) VALUES (29348, 6, 2025, 11, 21.065);
INSERT INTO public."Price" (id, "stonkId", year, month, price) VALUES (26705, 6, 2020, 8, 36.855);
INSERT INTO public."Price" (id, "stonkId", year, month, price) VALUES (30670, 7, 2017, 2, 346.5);
INSERT INTO public."Price" (id, "stonkId", year, month, price) VALUES (32681, 7, 2022, 11, 365);
INSERT INTO public."Price" (id, "stonkId", year, month, price) VALUES (31484, 7, 2018, 11, 713.5);
INSERT INTO public."Price" (id, "stonkId", year, month, price) VALUES (31355, 7, 2018, 8, 783.8);
INSERT INTO public."Price" (id, "stonkId", year, month, price) VALUES (31722, 7, 2019, 5, 745.3);
INSERT INTO public."Price" (id, "stonkId", year, month, price) VALUES (30942, 7, 2017, 9, 407.95);
INSERT INTO public."Price" (id, "stonkId", year, month, price) VALUES (32808, 7, 2023, 5, 442.1);
INSERT INTO public."Price" (id, "stonkId", year, month, price) VALUES (28963, 6, 2025, 2, 27.585);
INSERT INTO public."Price" (id, "stonkId", year, month, price) VALUES (31440, 7, 2018, 10, 775.2);
INSERT INTO public."Price" (id, "stonkId", year, month, price) VALUES (28658, 6, 2024, 7, 27.86);
INSERT INTO public."Price" (id, "stonkId", year, month, price) VALUES (27645, 6, 2022, 7, 27.5);
INSERT INTO public."Price" (id, "stonkId", year, month, price) VALUES (27217, 6, 2021, 8, 33.795);
INSERT INTO public."Price" (id, "stonkId", year, month, price) VALUES (27044, 6, 2021, 4, 34.09);
INSERT INTO public."Price" (id, "stonkId", year, month, price) VALUES (30047, 7, 2015, 10, 332.15);
INSERT INTO public."Price" (id, "stonkId", year, month, price) VALUES (26921, 6, 2021, 1, 33.675);
INSERT INTO public."Price" (id, "stonkId", year, month, price) VALUES (27348, 6, 2021, 11, 37.145);
INSERT INTO public."Price" (id, "stonkId", year, month, price) VALUES (32119, 7, 2020, 8, 550.6);
INSERT INTO public."Price" (id, "stonkId", year, month, price) VALUES (29783, 7, 2015, 3, 280.2);
INSERT INTO public."Price" (id, "stonkId", year, month, price) VALUES (31680, 7, 2019, 4, 758.4);
INSERT INTO public."Price" (id, "stonkId", year, month, price) VALUES (31015, 7, 2017, 11, 462.9);
INSERT INTO public."Price" (id, "stonkId", year, month, price) VALUES (27820, 6, 2022, 11, 21.655);
INSERT INTO public."Price" (id, "stonkId", year, month, price) VALUES (30821, 7, 2017, 6, 377.55);
INSERT INTO public."Price" (id, "stonkId", year, month, price) VALUES (27261, 6, 2021, 9, 36.4);
INSERT INTO public."Price" (id, "stonkId", year, month, price) VALUES (28029, 6, 2023, 4, 25.21);
INSERT INTO public."Price" (id, "stonkId", year, month, price) VALUES (29302, 6, 2025, 10, 19.825);
INSERT INTO public."Price" (id, "stonkId", year, month, price) VALUES (30276, 7, 2016, 4, 343.5);
INSERT INTO public."Price" (id, "stonkId", year, month, price) VALUES (32140, 7, 2020, 9, 464.5);
INSERT INTO public."Price" (id, "stonkId", year, month, price) VALUES (31400, 7, 2018, 9, 829.7);
INSERT INTO public."Price" (id, "stonkId", year, month, price) VALUES (31243, 7, 2018, 5, 668.55);
INSERT INTO public."Price" (id, "stonkId", year, month, price) VALUES (29462, 6, 2026, 2, 22.04);
INSERT INTO public."Price" (id, "stonkId", year, month, price) VALUES (28531, 6, 2024, 4, 35.175);
INSERT INTO public."Price" (id, "stonkId", year, month, price) VALUES (28836, 6, 2024, 11, 23.9);
INSERT INTO public."Price" (id, "stonkId", year, month, price) VALUES (30473, 7, 2016, 9, 322.9);
INSERT INTO public."Price" (id, "stonkId", year, month, price) VALUES (29170, 6, 2025, 7, 21.95);
INSERT INTO public."Price" (id, "stonkId", year, month, price) VALUES (30008, 7, 2015, 9, 305.5);
INSERT INTO public."Price" (id, "stonkId", year, month, price) VALUES (31799, 7, 2019, 7, 738.5);
INSERT INTO public."Price" (id, "stonkId", year, month, price) VALUES (30432, 7, 2016, 8, 321.2);
INSERT INTO public."Price" (id, "stonkId", year, month, price) VALUES (30194, 7, 2016, 2, 319.75);
INSERT INTO public."Price" (id, "stonkId", year, month, price) VALUES (31132, 7, 2018, 2, 596.95);
INSERT INTO public."Price" (id, "stonkId", year, month, price) VALUES (30512, 7, 2016, 10, 348.05);
INSERT INTO public."Price" (id, "stonkId", year, month, price) VALUES (30746, 7, 2017, 4, 369.9);
INSERT INTO public."Price" (id, "stonkId", year, month, price) VALUES (29046, 6, 2025, 4, 23.42);
INSERT INTO public."Price" (id, "stonkId", year, month, price) VALUES (31166, 7, 2018, 3, 612.2);
INSERT INTO public."Price" (id, "stonkId", year, month, price) VALUES (32247, 7, 2021, 2, 525.6);
INSERT INTO public."Price" (id, "stonkId", year, month, price) VALUES (30087, 7, 2015, 11, 325.6);
INSERT INTO public."Price" (id, "stonkId", year, month, price) VALUES (29969, 7, 2015, 8, 316.3);
INSERT INTO public."Price" (id, "stonkId", year, month, price) VALUES (30630, 7, 2017, 1, 411.35);
INSERT INTO public."Price" (id, "stonkId", year, month, price) VALUES (32185, 7, 2020, 11, 494.8);
INSERT INTO public."Price" (id, "stonkId", year, month, price) VALUES (32553, 7, 2022, 5, 385.7);
INSERT INTO public."Price" (id, "stonkId", year, month, price) VALUES (30704, 7, 2017, 3, 351.3);
INSERT INTO public."Price" (id, "stonkId", year, month, price) VALUES (31762, 7, 2019, 6, 775.9);
INSERT INTO public."Price" (id, "stonkId", year, month, price) VALUES (565, 7, 2020, 12, 514.4);
INSERT INTO public."Price" (id, "stonkId", year, month, price) VALUES (31565, 7, 2019, 1, 808.2);
INSERT INTO public."Price" (id, "stonkId", year, month, price) VALUES (30981, 7, 2017, 10, 433.9);
INSERT INTO public."Price" (id, "stonkId", year, month, price) VALUES (30783, 7, 2017, 5, 388.95);
INSERT INTO public."Price" (id, "stonkId", year, month, price) VALUES (32593, 7, 2022, 7, 401.4);
INSERT INTO public."Price" (id, "stonkId", year, month, price) VALUES (32377, 7, 2021, 8, 486.4);
INSERT INTO public."Price" (id, "stonkId", year, month, price) VALUES (32355, 7, 2021, 7, 489.8);
INSERT INTO public."Price" (id, "stonkId", year, month, price) VALUES (31639, 7, 2019, 3, 757);
INSERT INTO public."Price" (id, "stonkId", year, month, price) VALUES (31205, 7, 2018, 4, 675.1);
INSERT INTO public."Price" (id, "stonkId", year, month, price) VALUES (31317, 7, 2018, 7, 718.55);
INSERT INTO public."Price" (id, "stonkId", year, month, price) VALUES (31887, 7, 2019, 9, 692.8);
INSERT INTO public."Price" (id, "stonkId", year, month, price) VALUES (32443, 7, 2021, 11, 473);
INSERT INTO public."Price" (id, "stonkId", year, month, price) VALUES (32399, 7, 2021, 9, 526.9);
INSERT INTO public."Price" (id, "stonkId", year, month, price) VALUES (31932, 7, 2019, 11, 741.8);
INSERT INTO public."Price" (id, "stonkId", year, month, price) VALUES (32312, 7, 2021, 5, 499.8);
INSERT INTO public."Price" (id, "stonkId", year, month, price) VALUES (32163, 7, 2020, 10, 408.9);
INSERT INTO public."Price" (id, "stonkId", year, month, price) VALUES (32097, 7, 2020, 7, 554.4);
INSERT INTO public."Price" (id, "stonkId", year, month, price) VALUES (32614, 7, 2022, 8, 454.9);
INSERT INTO public."Price" (id, "stonkId", year, month, price) VALUES (33045, 7, 2024, 4, 719.6);
INSERT INTO public."Price" (id, "stonkId", year, month, price) VALUES (32290, 7, 2021, 4, 505.8);
INSERT INTO public."Price" (id, "stonkId", year, month, price) VALUES (32267, 7, 2021, 3, 595.6);
INSERT INTO public."Price" (id, "stonkId", year, month, price) VALUES (32228, 7, 2021, 1, 492.7);
INSERT INTO public."Price" (id, "stonkId", year, month, price) VALUES (32571, 7, 2022, 6, 431.2);
INSERT INTO public."Price" (id, "stonkId", year, month, price) VALUES (32725, 7, 2023, 1, 328.3);
INSERT INTO public."Price" (id, "stonkId", year, month, price) VALUES (32422, 7, 2021, 10, 541.2);
INSERT INTO public."Price" (id, "stonkId", year, month, price) VALUES (655, 7, 2023, 3, 371.4);
INSERT INTO public."Price" (id, "stonkId", year, month, price) VALUES (32660, 7, 2022, 10, 386.4);
INSERT INTO public."Price" (id, "stonkId", year, month, price) VALUES (32788, 7, 2023, 4, 405.8);
INSERT INTO public."Price" (id, "stonkId", year, month, price) VALUES (33109, 7, 2024, 7, 636.8);
INSERT INTO public."Price" (id, "stonkId", year, month, price) VALUES (32746, 7, 2023, 2, 320.7);
INSERT INTO public."Price" (id, "stonkId", year, month, price) VALUES (353, 7, 2023, 10, 610.1);
INSERT INTO public."Price" (id, "stonkId", year, month, price) VALUES (33068, 7, 2024, 5, 697.6);
INSERT INTO public."Price" (id, "stonkId", year, month, price) VALUES (33176, 7, 2024, 10, 539);
INSERT INTO public."Price" (id, "stonkId", year, month, price) VALUES (33132, 7, 2024, 8, 594.4);
INSERT INTO public."Price" (id, "stonkId", year, month, price) VALUES (33368, 7, 2025, 7, 642.9);
INSERT INTO public."Price" (id, "stonkId", year, month, price) VALUES (33243, 7, 2025, 1, 686.8);
INSERT INTO public."Price" (id, "stonkId", year, month, price) VALUES (33391, 7, 2025, 8, 647.7);
INSERT INTO public."Price" (id, "stonkId", year, month, price) VALUES (33263, 7, 2025, 2, 723);
INSERT INTO public."Price" (id, "stonkId", year, month, price) VALUES (33305, 7, 2025, 4, 715);
INSERT INTO public."Price" (id, "stonkId", year, month, price) VALUES (33327, 7, 2025, 5, 700.7);
INSERT INTO public."Price" (id, "stonkId", year, month, price) VALUES (33458, 7, 2025, 11, 590.6);
INSERT INTO public."Price" (id, "stonkId", year, month, price) VALUES (33435, 7, 2025, 10, 539.3);
INSERT INTO public."Price" (id, "stonkId", year, month, price) VALUES (33501, 7, 2026, 1, 576);
INSERT INTO public."Price" (id, "stonkId", year, month, price) VALUES (33520, 7, 2026, 2, 543.4);
INSERT INTO public."Price" (id, "stonkId", year, month, price) VALUES (33708, 8, 2015, 4, 9660);
INSERT INTO public."Price" (id, "stonkId", year, month, price) VALUES (33539, 7, 2026, 3, 672);
INSERT INTO public."Price" (id, "stonkId", year, month, price) VALUES (33687, 8, 2015, 3, 10500);
INSERT INTO public."Price" (id, "stonkId", year, month, price) VALUES (26747, 6, 2020, 9, 34.945);
INSERT INTO public."Price" (id, "stonkId", year, month, price) VALUES (26999, 6, 2021, 3, 34.68);
INSERT INTO public."Price" (id, "stonkId", year, month, price) VALUES (36879, 8, 2026, 2, 164.32);
INSERT INTO public."Price" (id, "stonkId", year, month, price) VALUES (36596, 8, 2025, 7, 119.54);
INSERT INTO public."Price" (id, "stonkId", year, month, price) VALUES (35666, 8, 2023, 1, 15150);
INSERT INTO public."Price" (id, "stonkId", year, month, price) VALUES (33857, 8, 2015, 11, 9076);
INSERT INTO public."Price" (id, "stonkId", year, month, price) VALUES (35512, 8, 2022, 6, 17460);
INSERT INTO public."Price" (id, "stonkId", year, month, price) VALUES (34527, 8, 2018, 7, 10835);
INSERT INTO public."Price" (id, "stonkId", year, month, price) VALUES (34485, 8, 2018, 5, 11111);
INSERT INTO public."Price" (id, "stonkId", year, month, price) VALUES (34087, 8, 2016, 10, 9288);
INSERT INTO public."Price" (id, "stonkId", year, month, price) VALUES (33730, 8, 2015, 5, 9363);
INSERT INTO public."Price" (id, "stonkId", year, month, price) VALUES (34274, 8, 2017, 7, 8904);
INSERT INTO public."Price" (id, "stonkId", year, month, price) VALUES (36227, 8, 2024, 10, 98.4);
INSERT INTO public."Price" (id, "stonkId", year, month, price) VALUES (247, 8, 2022, 3, 20874);
INSERT INTO public."Price" (id, "stonkId", year, month, price) VALUES (33899, 8, 2016, 1, 8836);
INSERT INTO public."Price" (id, "stonkId", year, month, price) VALUES (35188, 8, 2021, 2, 23338);
INSERT INTO public."Price" (id, "stonkId", year, month, price) VALUES (34659, 8, 2019, 1, 13731);
INSERT INTO public."Price" (id, "stonkId", year, month, price) VALUES (34361, 8, 2017, 11, 9978);
INSERT INTO public."Price" (id, "stonkId", year, month, price) VALUES (35208, 8, 2021, 3, 23572);
INSERT INTO public."Price" (id, "stonkId", year, month, price) VALUES (35081, 8, 2020, 9, 18802);
INSERT INTO public."Price" (id, "stonkId", year, month, price) VALUES (33792, 8, 2015, 8, 10496);
INSERT INTO public."Price" (id, "stonkId", year, month, price) VALUES (34763, 8, 2019, 6, 14256);
INSERT INTO public."Price" (id, "stonkId", year, month, price) VALUES (37827, 9, 2016, 6, 693.7);
INSERT INTO public."Price" (id, "stonkId", year, month, price) VALUES (36841, 8, 2026, 1, 163.78);
INSERT INTO public."Price" (id, "stonkId", year, month, price) VALUES (34108, 8, 2016, 11, 10424);
INSERT INTO public."Price" (id, "stonkId", year, month, price) VALUES (34506, 8, 2018, 6, 11284);
INSERT INTO public."Price" (id, "stonkId", year, month, price) VALUES (33981, 8, 2016, 5, 9142);
INSERT INTO public."Price" (id, "stonkId", year, month, price) VALUES (34191, 8, 2017, 3, 8935);
INSERT INTO public."Price" (id, "stonkId", year, month, price) VALUES (37953, 9, 2016, 9, 765.9);
INSERT INTO public."Price" (id, "stonkId", year, month, price) VALUES (37372, 9, 2015, 7, 677.6);
INSERT INTO public."Price" (id, "stonkId", year, month, price) VALUES (34593, 8, 2018, 10, 10920);
INSERT INTO public."Price" (id, "stonkId", year, month, price) VALUES (35296, 8, 2021, 7, 25222);
INSERT INTO public."Price" (id, "stonkId", year, month, price) VALUES (34423, 8, 2018, 2, 11269);
INSERT INTO public."Price" (id, "stonkId", year, month, price) VALUES (33917, 8, 2016, 2, 9066);
INSERT INTO public."Price" (id, "stonkId", year, month, price) VALUES (34679, 8, 2019, 2, 14160);
INSERT INTO public."Price" (id, "stonkId", year, month, price) VALUES (728, 8, 2025, 3, 122.22);
INSERT INTO public."Price" (id, "stonkId", year, month, price) VALUES (38039, 9, 2016, 11, 968.2);
INSERT INTO public."Price" (id, "stonkId", year, month, price) VALUES (34065, 8, 2016, 9, 9885);
INSERT INTO public."Price" (id, "stonkId", year, month, price) VALUES (34000, 8, 2016, 6, 8488);
INSERT INTO public."Price" (id, "stonkId", year, month, price) VALUES (36022, 8, 2024, 5, 144.44);
INSERT INTO public."Price" (id, "stonkId", year, month, price) VALUES (34213, 8, 2017, 4, 8797);
INSERT INTO public."Price" (id, "stonkId", year, month, price) VALUES (35729, 8, 2023, 4, 14932);
INSERT INTO public."Price" (id, "stonkId", year, month, price) VALUES (35601, 8, 2022, 10, 13660);
INSERT INTO public."Price" (id, "stonkId", year, month, price) VALUES (33960, 8, 2016, 4, 9476);
INSERT INTO public."Price" (id, "stonkId", year, month, price) VALUES (34873, 8, 2019, 11, 17050);
INSERT INTO public."Price" (id, "stonkId", year, month, price) VALUES (34463, 8, 2018, 4, 10903);
INSERT INTO public."Price" (id, "stonkId", year, month, price) VALUES (35060, 8, 2020, 8, 19400);
INSERT INTO public."Price" (id, "stonkId", year, month, price) VALUES (34616, 8, 2018, 11, 12701);
INSERT INTO public."Price" (id, "stonkId", year, month, price) VALUES (34339, 8, 2017, 10, 10701);
INSERT INTO public."Price" (id, "stonkId", year, month, price) VALUES (34021, 8, 2016, 7, 9546);
INSERT INTO public."Price" (id, "stonkId", year, month, price) VALUES (35687, 8, 2023, 2, 14508);
INSERT INTO public."Price" (id, "stonkId", year, month, price) VALUES (34151, 8, 2017, 1, 9692);
INSERT INTO public."Price" (id, "stonkId", year, month, price) VALUES (35104, 8, 2020, 10, 18884);
INSERT INTO public."Price" (id, "stonkId", year, month, price) VALUES (34233, 8, 2017, 5, 7979);
INSERT INTO public."Price" (id, "stonkId", year, month, price) VALUES (33813, 8, 2015, 9, 9398);
INSERT INTO public."Price" (id, "stonkId", year, month, price) VALUES (35363, 8, 2021, 10, 22116);
INSERT INTO public."Price" (id, "stonkId", year, month, price) VALUES (34783, 8, 2019, 7, 14542);
INSERT INTO public."Price" (id, "stonkId", year, month, price) VALUES (35534, 8, 2022, 7, 15820);
INSERT INTO public."Price" (id, "stonkId", year, month, price) VALUES (37417, 9, 2015, 8, 717.5);
INSERT INTO public."Price" (id, "stonkId", year, month, price) VALUES (34042, 8, 2016, 8, 9590);
INSERT INTO public."Price" (id, "stonkId", year, month, price) VALUES (34549, 8, 2018, 8, 11237);
INSERT INTO public."Price" (id, "stonkId", year, month, price) VALUES (35555, 8, 2022, 8, 15988);
INSERT INTO public."Price" (id, "stonkId", year, month, price) VALUES (37749, 9, 2016, 4, 744.6);
INSERT INTO public."Price" (id, "stonkId", year, month, price) VALUES (34172, 8, 2017, 2, 9241);
INSERT INTO public."Price" (id, "stonkId", year, month, price) VALUES (34442, 8, 2018, 3, 10770);
INSERT INTO public."Price" (id, "stonkId", year, month, price) VALUES (33835, 8, 2015, 10, 9540);
INSERT INTO public."Price" (id, "stonkId", year, month, price) VALUES (35318, 8, 2021, 8, 24232);
INSERT INTO public."Price" (id, "stonkId", year, month, price) VALUES (34295, 8, 2017, 8, 9745);
INSERT INTO public."Price" (id, "stonkId", year, month, price) VALUES (37458, 9, 2015, 9, 697.4);
INSERT INTO public."Price" (id, "stonkId", year, month, price) VALUES (36917, 8, 2026, 3, 140.3);
INSERT INTO public."Price" (id, "stonkId", year, month, price) VALUES (34699, 8, 2019, 3, 13642);
INSERT INTO public."Price" (id, "stonkId", year, month, price) VALUES (35038, 8, 2020, 7, 19696);
INSERT INTO public."Price" (id, "stonkId", year, month, price) VALUES (34253, 8, 2017, 6, 8168);
INSERT INTO public."Price" (id, "stonkId", year, month, price) VALUES (34806, 8, 2019, 8, 15918);
INSERT INTO public."Price" (id, "stonkId", year, month, price) VALUES (36641, 8, 2025, 8, 124.82);
INSERT INTO public."Price" (id, "stonkId", year, month, price) VALUES (35126, 8, 2020, 11, 21570);
INSERT INTO public."Price" (id, "stonkId", year, month, price) VALUES (34720, 8, 2019, 4, 14346);
INSERT INTO public."Price" (id, "stonkId", year, month, price) VALUES (34318, 8, 2017, 9, 9831);
INSERT INTO public."Price" (id, "stonkId", year, month, price) VALUES (34572, 8, 2018, 9, 11296);
INSERT INTO public."Price" (id, "stonkId", year, month, price) VALUES (34403, 8, 2018, 1, 11582);
INSERT INTO public."Price" (id, "stonkId", year, month, price) VALUES (36395, 8, 2025, 2, 137.16);
INSERT INTO public."Price" (id, "stonkId", year, month, price) VALUES (34742, 8, 2019, 5, 13662);
INSERT INTO public."Price" (id, "stonkId", year, month, price) VALUES (35231, 8, 2021, 4, 25882);
INSERT INTO public."Price" (id, "stonkId", year, month, price) VALUES (49, 9, 2014, 9, 393.8);
INSERT INTO public."Price" (id, "stonkId", year, month, price) VALUES (36764, 8, 2025, 11, 129.72);
INSERT INTO public."Price" (id, "stonkId", year, month, price) VALUES (35986, 8, 2024, 4, 154.16);
INSERT INTO public."Price" (id, "stonkId", year, month, price) VALUES (34850, 8, 2019, 10, 18008);
INSERT INTO public."Price" (id, "stonkId", year, month, price) VALUES (36517, 8, 2025, 5, 105.68);
INSERT INTO public."Price" (id, "stonkId", year, month, price) VALUES (36100, 8, 2024, 7, 129.08);
INSERT INTO public."Price" (id, "stonkId", year, month, price) VALUES (35494, 8, 2022, 5, 20126);
INSERT INTO public."Price" (id, "stonkId", year, month, price) VALUES (35622, 8, 2022, 11, 14330);
INSERT INTO public."Price" (id, "stonkId", year, month, price) VALUES (34828, 8, 2019, 9, 16588);
INSERT INTO public."Price" (id, "stonkId", year, month, price) VALUES (35169, 8, 2021, 1, 24674);
INSERT INTO public."Price" (id, "stonkId", year, month, price) VALUES (35340, 8, 2021, 9, 21922);
INSERT INTO public."Price" (id, "stonkId", year, month, price) VALUES (35749, 8, 2023, 5, 14500);
INSERT INTO public."Price" (id, "stonkId", year, month, price) VALUES (35253, 8, 2021, 5, 26420);
INSERT INTO public."Price" (id, "stonkId", year, month, price) VALUES (35384, 8, 2021, 11, 21592);
INSERT INTO public."Price" (id, "stonkId", year, month, price) VALUES (38623, 9, 2018, 2, 923.6);
INSERT INTO public."Price" (id, "stonkId", year, month, price) VALUES (366, 8, 2024, 1, 16002);
INSERT INTO public."Price" (id, "stonkId", year, month, price) VALUES (36356, 8, 2025, 1, 122.22);
INSERT INTO public."Price" (id, "stonkId", year, month, price) VALUES (37705, 9, 2016, 3, 718.6);
INSERT INTO public."Price" (id, "stonkId", year, month, price) VALUES (477, 9, 2015, 12, 612.3);
INSERT INTO public."Price" (id, "stonkId", year, month, price) VALUES (36473, 8, 2025, 4, 113.04);
INSERT INTO public."Price" (id, "stonkId", year, month, price) VALUES (37212, 9, 2015, 3, 653.45);
INSERT INTO public."Price" (id, "stonkId", year, month, price) VALUES (36721, 8, 2025, 10, 125.12);
INSERT INTO public."Price" (id, "stonkId", year, month, price) VALUES (36270, 8, 2024, 11, 112.68);
INSERT INTO public."Price" (id, "stonkId", year, month, price) VALUES (36143, 8, 2024, 8, 107.58);
INSERT INTO public."Price" (id, "stonkId", year, month, price) VALUES (37254, 9, 2015, 4, 574.45);
INSERT INTO public."Price" (id, "stonkId", year, month, price) VALUES (37501, 9, 2015, 10, 745.6);
INSERT INTO public."Price" (id, "stonkId", year, month, price) VALUES (38281, 9, 2017, 5, 741.3);
INSERT INTO public."Price" (id, "stonkId", year, month, price) VALUES (37663, 9, 2016, 2, 626.2);
INSERT INTO public."Price" (id, "stonkId", year, month, price) VALUES (37545, 9, 2015, 11, 711.2);
INSERT INTO public."Price" (id, "stonkId", year, month, price) VALUES (37298, 9, 2015, 5, 623.8);
INSERT INTO public."Price" (id, "stonkId", year, month, price) VALUES (38123, 9, 2017, 1, 961.8);
INSERT INTO public."Price" (id, "stonkId", year, month, price) VALUES (37334, 9, 2015, 6, 589.5);
INSERT INTO public."Price" (id, "stonkId", year, month, price) VALUES (38202, 9, 2017, 3, 814.3);
INSERT INTO public."Price" (id, "stonkId", year, month, price) VALUES (38165, 9, 2017, 2, 830.2);
INSERT INTO public."Price" (id, "stonkId", year, month, price) VALUES (37910, 9, 2016, 8, 763.5);
INSERT INTO public."Price" (id, "stonkId", year, month, price) VALUES (37628, 9, 2016, 1, 616.7);
INSERT INTO public."Price" (id, "stonkId", year, month, price) VALUES (37869, 9, 2016, 7, 782.7);
INSERT INTO public."Price" (id, "stonkId", year, month, price) VALUES (37791, 9, 2016, 5, 686.3);
INSERT INTO public."Price" (id, "stonkId", year, month, price) VALUES (38504, 9, 2017, 11, 912.4);
INSERT INTO public."Price" (id, "stonkId", year, month, price) VALUES (37997, 9, 2016, 10, 880.7);
INSERT INTO public."Price" (id, "stonkId", year, month, price) VALUES (38243, 9, 2017, 4, 777.7);
INSERT INTO public."Price" (id, "stonkId", year, month, price) VALUES (38352, 9, 2017, 7, 825.7);
INSERT INTO public."Price" (id, "stonkId", year, month, price) VALUES (38585, 9, 2018, 1, 925);
INSERT INTO public."Price" (id, "stonkId", year, month, price) VALUES (38391, 9, 2017, 8, 912);
INSERT INTO public."Price" (id, "stonkId", year, month, price) VALUES (38660, 9, 2018, 3, 873.1);
INSERT INTO public."Price" (id, "stonkId", year, month, price) VALUES (38312, 9, 2017, 6, 771.2);
INSERT INTO public."Price" (id, "stonkId", year, month, price) VALUES (38432, 9, 2017, 9, 868.6);
INSERT INTO public."Price" (id, "stonkId", year, month, price) VALUES (38470, 9, 2017, 10, 901);
INSERT INTO public."Price" (id, "stonkId", year, month, price) VALUES (38739, 9, 2018, 5, 1003.6);
INSERT INTO public."Price" (id, "stonkId", year, month, price) VALUES (38699, 9, 2018, 4, 1004.9);
INSERT INTO public."Price" (id, "stonkId", year, month, price) VALUES (38862, 9, 2018, 8, 1081.7);
INSERT INTO public."Price" (id, "stonkId", year, month, price) VALUES (38905, 9, 2018, 9, 1087.6);
INSERT INTO public."Price" (id, "stonkId", year, month, price) VALUES (38778, 9, 2018, 6, 925.3);
INSERT INTO public."Price" (id, "stonkId", year, month, price) VALUES (38820, 9, 2018, 7, 1013);
INSERT INTO public."Price" (id, "stonkId", year, month, price) VALUES (39075, 9, 2019, 1, 995.8);
INSERT INTO public."Price" (id, "stonkId", year, month, price) VALUES (38944, 9, 2018, 10, 1016.6);
INSERT INTO public."Price" (id, "stonkId", year, month, price) VALUES (39154, 9, 2019, 3, 1029);
INSERT INTO public."Price" (id, "stonkId", year, month, price) VALUES (38990, 9, 2018, 11, 999.2);
INSERT INTO public."Price" (id, "stonkId", year, month, price) VALUES (39114, 9, 2019, 2, 1026.4);
INSERT INTO public."Price" (id, "stonkId", year, month, price) VALUES (33748, 8, 2015, 6, 9473);
INSERT INTO public."Price" (id, "stonkId", year, month, price) VALUES (39195, 9, 2019, 4, 1052.8);
INSERT INTO public."Price" (id, "stonkId", year, month, price) VALUES (33769, 8, 2015, 7, 9361);
INSERT INTO public."Price" (id, "stonkId", year, month, price) VALUES (40889, 9, 2025, 7, 998.8);
INSERT INTO public."Price" (id, "stonkId", year, month, price) VALUES (44559, 10, 2022, 5, 143.2);
INSERT INTO public."Price" (id, "stonkId", year, month, price) VALUES (40848, 9, 2025, 5, 1000.6);
INSERT INTO public."Price" (id, "stonkId", year, month, price) VALUES (40246, 9, 2023, 1, 922.6);
INSERT INTO public."Price" (id, "stonkId", year, month, price) VALUES (43204, 10, 2019, 8, 147.64);
INSERT INTO public."Price" (id, "stonkId", year, month, price) VALUES (42925, 10, 2019, 1, 153.06);
INSERT INTO public."Price" (id, "stonkId", year, month, price) VALUES (42579, 10, 2018, 4, 161.92);
INSERT INTO public."Price" (id, "stonkId", year, month, price) VALUES (42382, 10, 2017, 10, 134.2);
INSERT INTO public."Price" (id, "stonkId", year, month, price) VALUES (39811, 9, 2021, 4, 1777.4);
INSERT INTO public."Price" (id, "stonkId", year, month, price) VALUES (41060, 9, 2026, 3, 847.4);
INSERT INTO public."Price" (id, "stonkId", year, month, price) VALUES (39788, 9, 2021, 3, 1523.8);
INSERT INTO public."Price" (id, "stonkId", year, month, price) VALUES (40135, 9, 2022, 8, 751.4);
INSERT INTO public."Price" (id, "stonkId", year, month, price) VALUES (44255, 10, 2021, 9, 216.64);
INSERT INTO public."Price" (id, "stonkId", year, month, price) VALUES (39364, 9, 2019, 8, 994.2);
INSERT INTO public."Price" (id, "stonkId", year, month, price) VALUES (40630, 9, 2024, 7, 1420.2);
INSERT INTO public."Price" (id, "stonkId", year, month, price) VALUES (550, 10, 2019, 12, 143.3);
INSERT INTO public."Price" (id, "stonkId", year, month, price) VALUES (41404, 10, 2015, 6, 74.89);
INSERT INTO public."Price" (id, "stonkId", year, month, price) VALUES (40912, 9, 2025, 8, 1067.2);
INSERT INTO public."Price" (id, "stonkId", year, month, price) VALUES (40267, 9, 2023, 2, 1060.2);
INSERT INTO public."Price" (id, "stonkId", year, month, price) VALUES (42345, 10, 2017, 9, 131.72);
INSERT INTO public."Price" (id, "stonkId", year, month, price) VALUES (39640, 9, 2020, 8, 936.8);
INSERT INTO public."Price" (id, "stonkId", year, month, price) VALUES (39833, 9, 2021, 5, 1681);
INSERT INTO public."Price" (id, "stonkId", year, month, price) VALUES (41575, 10, 2015, 11, 70.26);
INSERT INTO public."Price" (id, "stonkId", year, month, price) VALUES (39684, 9, 2020, 10, 1070.8);
INSERT INTO public."Price" (id, "stonkId", year, month, price) VALUES (40074, 9, 2022, 5, 980.2);
INSERT INTO public."Price" (id, "stonkId", year, month, price) VALUES (39408, 9, 2019, 9, 939.4);
INSERT INTO public."Price" (id, "stonkId", year, month, price) VALUES (40956, 9, 2025, 10, 858.4);
INSERT INTO public."Price" (id, "stonkId", year, month, price) VALUES (43993, 10, 2021, 3, 240.18);
INSERT INTO public."Price" (id, "stonkId", year, month, price) VALUES (42685, 10, 2018, 7, 161.68);
INSERT INTO public."Price" (id, "stonkId", year, month, price) VALUES (41832, 10, 2016, 7, 94.63);
INSERT INTO public."Price" (id, "stonkId", year, month, price) VALUES (40697, 9, 2024, 10, 1097.8);
INSERT INTO public."Price" (id, "stonkId", year, month, price) VALUES (41872, 10, 2016, 8, 90.76);
INSERT INTO public."Price" (id, "stonkId", year, month, price) VALUES (41371, 10, 2015, 5, 74.93);
INSERT INTO public."Price" (id, "stonkId", year, month, price) VALUES (40329, 9, 2023, 5, 1025.4);
INSERT INTO public."Price" (id, "stonkId", year, month, price) VALUES (39876, 9, 2021, 7, 1794.8);
INSERT INTO public."Price" (id, "stonkId", year, month, price) VALUES (39706, 9, 2020, 11, 1128.8);
INSERT INTO public."Price" (id, "stonkId", year, month, price) VALUES (39661, 9, 2020, 9, 994.2);
INSERT INTO public."Price" (id, "stonkId", year, month, price) VALUES (41911, 10, 2016, 9, 83.37);
INSERT INTO public."Price" (id, "stonkId", year, month, price) VALUES (40764, 9, 2025, 1, 1234);
INSERT INTO public."Price" (id, "stonkId", year, month, price) VALUES (39280, 9, 2019, 6, 1070.4);
INSERT INTO public."Price" (id, "stonkId", year, month, price) VALUES (40092, 9, 2022, 6, 826.6);
INSERT INTO public."Price" (id, "stonkId", year, month, price) VALUES (42162, 10, 2017, 4, 108.28);
INSERT INTO public."Price" (id, "stonkId", year, month, price) VALUES (42613, 10, 2018, 5, 164.29);
INSERT INTO public."Price" (id, "stonkId", year, month, price) VALUES (41640, 10, 2016, 1, 64.47);
INSERT INTO public."Price" (id, "stonkId", year, month, price) VALUES (41333, 10, 2015, 4, 68.125);
INSERT INTO public."Price" (id, "stonkId", year, month, price) VALUES (41022, 9, 2026, 1, 1002);
INSERT INTO public."Price" (id, "stonkId", year, month, price) VALUES (39920, 9, 2021, 9, 1523.6);
INSERT INTO public."Price" (id, "stonkId", year, month, price) VALUES (39453, 9, 2019, 11, 906);
INSERT INTO public."Price" (id, "stonkId", year, month, price) VALUES (43656, 10, 2020, 7, 144.3);
INSERT INTO public."Price" (id, "stonkId", year, month, price) VALUES (39898, 9, 2021, 8, 1728);
INSERT INTO public."Price" (id, "stonkId", year, month, price) VALUES (40566, 9, 2024, 4, 1926.4);
INSERT INTO public."Price" (id, "stonkId", year, month, price) VALUES (42195, 10, 2017, 5, 111.91);
INSERT INTO public."Price" (id, "stonkId", year, month, price) VALUES (40720, 9, 2024, 11, 1115.4);
INSERT INTO public."Price" (id, "stonkId", year, month, price) VALUES (41772, 10, 2016, 5, 85.07);
INSERT INTO public."Price" (id, "stonkId", year, month, price) VALUES (40181, 9, 2022, 10, 797.8);
INSERT INTO public."Price" (id, "stonkId", year, month, price) VALUES (45055, 10, 2023, 5, 145.54);
INSERT INTO public."Price" (id, "stonkId", year, month, price) VALUES (40784, 9, 2025, 2, 1337.2);
INSERT INTO public."Price" (id, "stonkId", year, month, price) VALUES (39768, 9, 2021, 2, 1353);
INSERT INTO public."Price" (id, "stonkId", year, month, price) VALUES (44897, 10, 2023, 1, 116.16);
INSERT INTO public."Price" (id, "stonkId", year, month, price) VALUES (39618, 9, 2020, 7, 911.2);
INSERT INTO public."Price" (id, "stonkId", year, month, price) VALUES (44811, 10, 2022, 11, 105.98);
INSERT INTO public."Price" (id, "stonkId", year, month, price) VALUES (44038, 10, 2021, 4, 266.48);
INSERT INTO public."Price" (id, "stonkId", year, month, price) VALUES (41474, 10, 2015, 8, 80.26);
INSERT INTO public."Price" (id, "stonkId", year, month, price) VALUES (39318, 9, 2019, 7, 1025.6);
INSERT INTO public."Price" (id, "stonkId", year, month, price) VALUES (42648, 10, 2018, 6, 151.6);
INSERT INTO public."Price" (id, "stonkId", year, month, price) VALUES (41700, 10, 2016, 3, 83.68);
INSERT INTO public."Price" (id, "stonkId", year, month, price) VALUES (39964, 9, 2021, 11, 1583.4);
INSERT INTO public."Price" (id, "stonkId", year, month, price) VALUES (40309, 9, 2023, 4, 999);
INSERT INTO public."Price" (id, "stonkId", year, month, price) VALUES (42226, 10, 2017, 6, 114.7);
INSERT INTO public."Price" (id, "stonkId", year, month, price) VALUES (41436, 10, 2015, 7, 79.38);
INSERT INTO public."Price" (id, "stonkId", year, month, price) VALUES (41041, 9, 2026, 2, 966.2);
INSERT INTO public."Price" (id, "stonkId", year, month, price) VALUES (40653, 9, 2024, 8, 1245.8);
INSERT INTO public."Price" (id, "stonkId", year, month, price) VALUES (40202, 9, 2022, 11, 788.2);
INSERT INTO public."Price" (id, "stonkId", year, month, price) VALUES (39749, 9, 2021, 1, 1262.8);
INSERT INTO public."Price" (id, "stonkId", year, month, price) VALUES (39943, 9, 2021, 10, 1615);
INSERT INTO public."Price" (id, "stonkId", year, month, price) VALUES (43248, 10, 2019, 9, 141.48);
INSERT INTO public."Price" (id, "stonkId", year, month, price) VALUES (44211, 10, 2021, 8, 248.58);
INSERT INTO public."Price" (id, "stonkId", year, month, price) VALUES (43121, 10, 2019, 6, 160.6);
INSERT INTO public."Price" (id, "stonkId", year, month, price) VALUES (40826, 9, 2025, 4, 1045.4);
INSERT INTO public."Price" (id, "stonkId", year, month, price) VALUES (40114, 9, 2022, 7, 723.2);
INSERT INTO public."Price" (id, "stonkId", year, month, price) VALUES (42302, 10, 2017, 8, 137.23);
INSERT INTO public."Price" (id, "stonkId", year, month, price) VALUES (42485, 10, 2018, 1, 148.72);
INSERT INTO public."Price" (id, "stonkId", year, month, price) VALUES (40589, 9, 2024, 5, 1799.2);
INSERT INTO public."Price" (id, "stonkId", year, month, price) VALUES (42842, 10, 2018, 11, 158.78);
INSERT INTO public."Price" (id, "stonkId", year, month, price) VALUES (41945, 10, 2016, 10, 99.47);
INSERT INTO public."Price" (id, "stonkId", year, month, price) VALUES (41505, 10, 2015, 9, 74.07);
INSERT INTO public."Price" (id, "stonkId", year, month, price) VALUES (43037, 10, 2019, 4, 171.12);
INSERT INTO public."Price" (id, "stonkId", year, month, price) VALUES (40979, 9, 2025, 11, 929.8);
INSERT INTO public."Price" (id, "stonkId", year, month, price) VALUES (43699, 10, 2020, 8, 155.26);
INSERT INTO public."Price" (id, "stonkId", year, month, price) VALUES (41667, 10, 2016, 2, 72.58);
INSERT INTO public."Price" (id, "stonkId", year, month, price) VALUES (42087, 10, 2017, 2, 110.77);
INSERT INTO public."Price" (id, "stonkId", year, month, price) VALUES (43079, 10, 2019, 5, 171.34);
INSERT INTO public."Price" (id, "stonkId", year, month, price) VALUES (41978, 10, 2016, 11, 120.07);
INSERT INTO public."Price" (id, "stonkId", year, month, price) VALUES (42548, 10, 2018, 3, 144.39);
INSERT INTO public."Price" (id, "stonkId", year, month, price) VALUES (41297, 10, 2015, 3, 77.74);
INSERT INTO public."Price" (id, "stonkId", year, month, price) VALUES (42053, 10, 2017, 1, 118);
INSERT INTO public."Price" (id, "stonkId", year, month, price) VALUES (41801, 10, 2016, 6, 83.06);
INSERT INTO public."Price" (id, "stonkId", year, month, price) VALUES (41540, 10, 2015, 10, 77.59);
INSERT INTO public."Price" (id, "stonkId", year, month, price) VALUES (41737, 10, 2016, 4, 87.06);
INSERT INTO public."Price" (id, "stonkId", year, month, price) VALUES (165, 10, 2020, 3, 123.02);
INSERT INTO public."Price" (id, "stonkId", year, month, price) VALUES (43158, 10, 2019, 7, 150.5);
INSERT INTO public."Price" (id, "stonkId", year, month, price) VALUES (42721, 10, 2018, 8, 165.42);
INSERT INTO public."Price" (id, "stonkId", year, month, price) VALUES (42518, 10, 2018, 2, 146);
INSERT INTO public."Price" (id, "stonkId", year, month, price) VALUES (42124, 10, 2017, 3, 112.36);
INSERT INTO public."Price" (id, "stonkId", year, month, price) VALUES (42414, 10, 2017, 11, 130.74);
INSERT INTO public."Price" (id, "stonkId", year, month, price) VALUES (42263, 10, 2017, 7, 125.49);
INSERT INTO public."Price" (id, "stonkId", year, month, price) VALUES (43741, 10, 2020, 9, 172.88);
INSERT INTO public."Price" (id, "stonkId", year, month, price) VALUES (42998, 10, 2019, 3, 170.48);
INSERT INTO public."Price" (id, "stonkId", year, month, price) VALUES (44082, 10, 2021, 5, 262.26);
INSERT INTO public."Price" (id, "stonkId", year, month, price) VALUES (43830, 10, 2020, 11, 193.16);
INSERT INTO public."Price" (id, "stonkId", year, month, price) VALUES (42798, 10, 2018, 10, 160.06);
INSERT INTO public."Price" (id, "stonkId", year, month, price) VALUES (42760, 10, 2018, 9, 177.26);
INSERT INTO public."Price" (id, "stonkId", year, month, price) VALUES (43289, 10, 2019, 10, 126.3);
INSERT INTO public."Price" (id, "stonkId", year, month, price) VALUES (43335, 10, 2019, 11, 128.82);
INSERT INTO public."Price" (id, "stonkId", year, month, price) VALUES (640, 10, 2022, 12, 116.88);
INSERT INTO public."Price" (id, "stonkId", year, month, price) VALUES (44637, 10, 2022, 7, 127.26);
INSERT INTO public."Price" (id, "stonkId", year, month, price) VALUES (43953, 10, 2021, 2, 223.18);
INSERT INTO public."Price" (id, "stonkId", year, month, price) VALUES (43786, 10, 2020, 10, 183.62);
INSERT INTO public."Price" (id, "stonkId", year, month, price) VALUES (44678, 10, 2022, 8, 120.28);
INSERT INTO public."Price" (id, "stonkId", year, month, price) VALUES (44167, 10, 2021, 7, 258.12);
INSERT INTO public."Price" (id, "stonkId", year, month, price) VALUES (44300, 10, 2021, 10, 222.98);
INSERT INTO public."Price" (id, "stonkId", year, month, price) VALUES (44594, 10, 2022, 6, 136.92);
INSERT INTO public."Price" (id, "stonkId", year, month, price) VALUES (44342, 10, 2021, 11, 217.32);
INSERT INTO public."Price" (id, "stonkId", year, month, price) VALUES (44769, 10, 2022, 10, 103.3);
INSERT INTO public."Price" (id, "stonkId", year, month, price) VALUES (45016, 10, 2023, 4, 137.48);
INSERT INTO public."Price" (id, "stonkId", year, month, price) VALUES (44936, 10, 2023, 2, 124.94);
INSERT INTO public."Price" (id, "stonkId", year, month, price) VALUES (46275, 10, 2025, 10, 98.1);
INSERT INTO public."Price" (id, "stonkId", year, month, price) VALUES (379, 10, 2023, 6, 171.3);
INSERT INTO public."Price" (id, "stonkId", year, month, price) VALUES (45512, 10, 2024, 4, 240.94);
INSERT INTO public."Price" (id, "stonkId", year, month, price) VALUES (45558, 10, 2024, 5, 197.96);
INSERT INTO public."Price" (id, "stonkId", year, month, price) VALUES (45638, 10, 2024, 7, 165.38);
INSERT INTO public."Price" (id, "stonkId", year, month, price) VALUES (45684, 10, 2024, 8, 135.56);
INSERT INTO public."Price" (id, "stonkId", year, month, price) VALUES (45771, 10, 2024, 10, 118.48);
INSERT INTO public."Price" (id, "stonkId", year, month, price) VALUES (45817, 10, 2024, 11, 124.96);
INSERT INTO public."Price" (id, "stonkId", year, month, price) VALUES (45903, 10, 2025, 1, 146.98);
INSERT INTO public."Price" (id, "stonkId", year, month, price) VALUES (45943, 10, 2025, 2, 155.5);
INSERT INTO public."Price" (id, "stonkId", year, month, price) VALUES (46026, 10, 2025, 4, 129.56);
INSERT INTO public."Price" (id, "stonkId", year, month, price) VALUES (46070, 10, 2025, 5, 117.16);
INSERT INTO public."Price" (id, "stonkId", year, month, price) VALUES (46146, 10, 2025, 7, 109.92);
INSERT INTO public."Price" (id, "stonkId", year, month, price) VALUES (46192, 10, 2025, 8, 118.82);
INSERT INTO public."Price" (id, "stonkId", year, month, price) VALUES (39239, 9, 2019, 5, 1034);
INSERT INTO public."Price" (id, "stonkId", year, month, price) VALUES (39430, 9, 2019, 10, 892.2);
INSERT INTO public."Price" (id, "stonkId", year, month, price) VALUES (49445, 11, 2020, 8, 66.58);
INSERT INTO public."Price" (id, "stonkId", year, month, price) VALUES (48392, 11, 2018, 7, 96.81);
INSERT INTO public."Price" (id, "stonkId", year, month, price) VALUES (52461, 12, 2015, 6, 1698);
INSERT INTO public."Price" (id, "stonkId", year, month, price) VALUES (46781, 11, 2015, 4, 68.03);
INSERT INTO public."Price" (id, "stonkId", year, month, price) VALUES (52158, 11, 2026, 1, 41.75);
INSERT INTO public."Price" (id, "stonkId", year, month, price) VALUES (49956, 11, 2021, 8, 144.09);
INSERT INTO public."Price" (id, "stonkId", year, month, price) VALUES (47848, 11, 2017, 6, 87.12);
INSERT INTO public."Price" (id, "stonkId", year, month, price) VALUES (47348, 11, 2016, 6, 69.45);
INSERT INTO public."Price" (id, "stonkId", year, month, price) VALUES (47227, 11, 2016, 3, 69.91);
INSERT INTO public."Price" (id, "stonkId", year, month, price) VALUES (51526, 11, 2024, 10, 46.92);
INSERT INTO public."Price" (id, "stonkId", year, month, price) VALUES (47069, 11, 2015, 11, 52);
INSERT INTO public."Price" (id, "stonkId", year, month, price) VALUES (47432, 11, 2016, 8, 76.01);
INSERT INTO public."Price" (id, "stonkId", year, month, price) VALUES (48482, 11, 2018, 9, 106.26);
INSERT INTO public."Price" (id, "stonkId", year, month, price) VALUES (46822, 11, 2015, 5, 66.64);
INSERT INTO public."Price" (id, "stonkId", year, month, price) VALUES (49783, 11, 2021, 4, 108.21);
INSERT INTO public."Price" (id, "stonkId", year, month, price) VALUES (48308, 11, 2018, 5, 88.82);
INSERT INTO public."Price" (id, "stonkId", year, month, price) VALUES (47561, 11, 2016, 11, 91.87);
INSERT INTO public."Price" (id, "stonkId", year, month, price) VALUES (50087, 11, 2021, 11, 127.67);
INSERT INTO public."Price" (id, "stonkId", year, month, price) VALUES (46320, 10, 2025, 11, 104.84);
INSERT INTO public."Price" (id, "stonkId", year, month, price) VALUES (50384, 11, 2022, 7, 64.33);
INSERT INTO public."Price" (id, "stonkId", year, month, price) VALUES (49532, 11, 2020, 10, 70.93);
INSERT INTO public."Price" (id, "stonkId", year, month, price) VALUES (52034, 11, 2025, 10, 39.34);
INSERT INTO public."Price" (id, "stonkId", year, month, price) VALUES (47645, 11, 2017, 1, 105.71);
INSERT INTO public."Price" (id, "stonkId", year, month, price) VALUES (52505, 12, 2015, 8, 2385);
INSERT INTO public."Price" (id, "stonkId", year, month, price) VALUES (61, 11, 2014, 9, 35.232);
INSERT INTO public."Price" (id, "stonkId", year, month, price) VALUES (48897, 11, 2019, 7, 81.46);
INSERT INTO public."Price" (id, "stonkId", year, month, price) VALUES (47976, 11, 2017, 9, 81.86);
INSERT INTO public."Price" (id, "stonkId", year, month, price) VALUES (48222, 11, 2018, 3, 91.6);
INSERT INTO public."Price" (id, "stonkId", year, month, price) VALUES (48817, 11, 2019, 5, 88.3);
INSERT INTO public."Price" (id, "stonkId", year, month, price) VALUES (47769, 11, 2017, 4, 97.57);
INSERT INTO public."Price" (id, "stonkId", year, month, price) VALUES (49075, 11, 2019, 11, 77.49);
INSERT INTO public."Price" (id, "stonkId", year, month, price) VALUES (47149, 11, 2016, 1, 60.39);
INSERT INTO public."Price" (id, "stonkId", year, month, price) VALUES (50558, 11, 2022, 11, 64.89);
INSERT INTO public."Price" (id, "stonkId", year, month, price) VALUES (47477, 11, 2016, 9, 85.53);
INSERT INTO public."Price" (id, "stonkId", year, month, price) VALUES (46400, 10, 2026, 1, 113.3);
INSERT INTO public."Price" (id, "stonkId", year, month, price) VALUES (46854, 11, 2015, 6, 63.22);
INSERT INTO public."Price" (id, "stonkId", year, month, price) VALUES (49661, 11, 2021, 1, 99.74);
INSERT INTO public."Price" (id, "stonkId", year, month, price) VALUES (46981, 11, 2015, 9, 56.78);
INSERT INTO public."Price" (id, "stonkId", year, month, price) VALUES (47390, 11, 2016, 7, 71.98);
INSERT INTO public."Price" (id, "stonkId", year, month, price) VALUES (48987, 11, 2019, 9, 74.14);
INSERT INTO public."Price" (id, "stonkId", year, month, price) VALUES (48653, 11, 2019, 1, 98.17);
INSERT INTO public."Price" (id, "stonkId", year, month, price) VALUES (51315, 11, 2024, 5, 75.67);
INSERT INTO public."Price" (id, "stonkId", year, month, price) VALUES (47890, 11, 2017, 7, 83.68);
INSERT INTO public."Price" (id, "stonkId", year, month, price) VALUES (52548, 12, 2015, 10, 2850);
INSERT INTO public."Price" (id, "stonkId", year, month, price) VALUES (49487, 11, 2020, 9, 73.24);
INSERT INTO public."Price" (id, "stonkId", year, month, price) VALUES (46940, 11, 2015, 8, 65.17);
INSERT INTO public."Price" (id, "stonkId", year, month, price) VALUES (47809, 11, 2017, 5, 88.52);
INSERT INTO public."Price" (id, "stonkId", year, month, price) VALUES (48145, 11, 2018, 1, 81.66);
INSERT INTO public."Price" (id, "stonkId", year, month, price) VALUES (48523, 11, 2018, 10, 98.56);
INSERT INTO public."Price" (id, "stonkId", year, month, price) VALUES (51823, 11, 2025, 5, 46.07);
INSERT INTO public."Price" (id, "stonkId", year, month, price) VALUES (47687, 11, 2017, 2, 92.61);
INSERT INTO public."Price" (id, "stonkId", year, month, price) VALUES (46432, 10, 2026, 2, 112.48);
INSERT INTO public."Price" (id, "stonkId", year, month, price) VALUES (49912, 11, 2021, 7, 131.43);
INSERT INTO public."Price" (id, "stonkId", year, month, price) VALUES (48436, 11, 2018, 8, 100.63);
INSERT INTO public."Price" (id, "stonkId", year, month, price) VALUES (52193, 11, 2026, 2, 40.13);
INSERT INTO public."Price" (id, "stonkId", year, month, price) VALUES (49401, 11, 2020, 7, 67.59);
INSERT INTO public."Price" (id, "stonkId", year, month, price) VALUES (48350, 11, 2018, 6, 99.78);
INSERT INTO public."Price" (id, "stonkId", year, month, price) VALUES (47310, 11, 2016, 5, 72.14);
INSERT INTO public."Price" (id, "stonkId", year, month, price) VALUES (47185, 11, 2016, 2, 70.05);
INSERT INTO public."Price" (id, "stonkId", year, month, price) VALUES (52570, 12, 2015, 11, 2685);
INSERT INTO public."Price" (id, "stonkId", year, month, price) VALUES (46894, 11, 2015, 7, 69.53);
INSERT INTO public."Price" (id, "stonkId", year, month, price) VALUES (48185, 11, 2018, 2, 87.5);
INSERT INTO public."Price" (id, "stonkId", year, month, price) VALUES (47025, 11, 2015, 10, 52.22);
INSERT INTO public."Price" (id, "stonkId", year, month, price) VALUES (50045, 11, 2021, 10, 126.22);
INSERT INTO public."Price" (id, "stonkId", year, month, price) VALUES (50341, 11, 2022, 6, 68.98);
INSERT INTO public."Price" (id, "stonkId", year, month, price) VALUES (48018, 11, 2017, 10, 75.49);
INSERT INTO public."Price" (id, "stonkId", year, month, price) VALUES (47269, 11, 2016, 4, 72.79);
INSERT INTO public."Price" (id, "stonkId", year, month, price) VALUES (47520, 11, 2016, 10, 88.33);
INSERT INTO public."Price" (id, "stonkId", year, month, price) VALUES (50517, 11, 2022, 10, 66.33);
INSERT INTO public."Price" (id, "stonkId", year, month, price) VALUES (50767, 11, 2023, 4, 68.13);
INSERT INTO public."Price" (id, "stonkId", year, month, price) VALUES (48264, 11, 2018, 4, 90.2);
INSERT INTO public."Price" (id, "stonkId", year, month, price) VALUES (50805, 11, 2023, 5, 65.36);
INSERT INTO public."Price" (id, "stonkId", year, month, price) VALUES (49738, 11, 2021, 3, 107.03);
INSERT INTO public."Price" (id, "stonkId", year, month, price) VALUES (48062, 11, 2017, 11, 77.23);
INSERT INTO public."Price" (id, "stonkId", year, month, price) VALUES (52443, 12, 2015, 5, 1584.5);
INSERT INTO public."Price" (id, "stonkId", year, month, price) VALUES (48859, 11, 2019, 6, 86.74);
INSERT INTO public."Price" (id, "stonkId", year, month, price) VALUES (52230, 11, 2026, 3, 34.33);
INSERT INTO public."Price" (id, "stonkId", year, month, price) VALUES (47932, 11, 2017, 8, 81.58);
INSERT INTO public."Price" (id, "stonkId", year, month, price) VALUES (48733, 11, 2019, 3, 92.77);
INSERT INTO public."Price" (id, "stonkId", year, month, price) VALUES (174, 11, 2020, 6, 64.48);
INSERT INTO public."Price" (id, "stonkId", year, month, price) VALUES (47725, 11, 2017, 3, 91.9);
INSERT INTO public."Price" (id, "stonkId", year, month, price) VALUES (48693, 11, 2019, 2, 95.49);
INSERT INTO public."Price" (id, "stonkId", year, month, price) VALUES (52079, 11, 2025, 11, 39.51);
INSERT INTO public."Price" (id, "stonkId", year, month, price) VALUES (52966, 12, 2017, 6, 3948.59);
INSERT INTO public."Price" (id, "stonkId", year, month, price) VALUES (48943, 11, 2019, 8, 73.46);
INSERT INTO public."Price" (id, "stonkId", year, month, price) VALUES (49827, 11, 2021, 5, 116.25);
INSERT INTO public."Price" (id, "stonkId", year, month, price) VALUES (49576, 11, 2020, 11, 88.88);
INSERT INTO public."Price" (id, "stonkId", year, month, price) VALUES (48569, 11, 2018, 11, 100.14);
INSERT INTO public."Price" (id, "stonkId", year, month, price) VALUES (48774, 11, 2019, 4, 94.79);
INSERT INTO public."Price" (id, "stonkId", year, month, price) VALUES (52778, 12, 2016, 9, 4493);
INSERT INTO public."Price" (id, "stonkId", year, month, price) VALUES (52694, 12, 2016, 5, 4689);
INSERT INTO public."Price" (id, "stonkId", year, month, price) VALUES (50305, 11, 2022, 5, 73.2);
INSERT INTO public."Price" (id, "stonkId", year, month, price) VALUES (49029, 11, 2019, 10, 74.57);
INSERT INTO public."Price" (id, "stonkId", year, month, price) VALUES (49699, 11, 2021, 2, 99.68);
INSERT INTO public."Price" (id, "stonkId", year, month, price) VALUES (623, 11, 2022, 9, 59.08);
INSERT INTO public."Price" (id, "stonkId", year, month, price) VALUES (50000, 11, 2021, 9, 133.58);
INSERT INTO public."Price" (id, "stonkId", year, month, price) VALUES (50686, 11, 2023, 2, 60.43);
INSERT INTO public."Price" (id, "stonkId", year, month, price) VALUES (50645, 11, 2023, 1, 62.01);
INSERT INTO public."Price" (id, "stonkId", year, month, price) VALUES (52400, 12, 2015, 3, 1026.5);
INSERT INTO public."Price" (id, "stonkId", year, month, price) VALUES (52734, 12, 2016, 7, 4660);
INSERT INTO public."Price" (id, "stonkId", year, month, price) VALUES (51948, 11, 2025, 8, 47.46);
INSERT INTO public."Price" (id, "stonkId", year, month, price) VALUES (52421, 12, 2015, 4, 1543.5);
INSERT INTO public."Price" (id, "stonkId", year, month, price) VALUES (50426, 11, 2022, 8, 72.05);
INSERT INTO public."Price" (id, "stonkId", year, month, price) VALUES (52904, 12, 2017, 3, 4436);
INSERT INTO public."Price" (id, "stonkId", year, month, price) VALUES (51903, 11, 2025, 7, 45.97);
INSERT INTO public."Price" (id, "stonkId", year, month, price) VALUES (51440, 11, 2024, 8, 50.7);
INSERT INTO public."Price" (id, "stonkId", year, month, price) VALUES (713, 11, 2024, 12, 57.37);
INSERT INTO public."Price" (id, "stonkId", year, month, price) VALUES (392, 11, 2023, 9, 73.28);
INSERT INTO public."Price" (id, "stonkId", year, month, price) VALUES (51394, 11, 2024, 7, 60.95);
INSERT INTO public."Price" (id, "stonkId", year, month, price) VALUES (51271, 11, 2024, 4, 76.91);
INSERT INTO public."Price" (id, "stonkId", year, month, price) VALUES (51571, 11, 2024, 11, 49.83);
INSERT INTO public."Price" (id, "stonkId", year, month, price) VALUES (51658, 11, 2025, 1, 57.49);
INSERT INTO public."Price" (id, "stonkId", year, month, price) VALUES (51780, 11, 2025, 4, 49.55);
INSERT INTO public."Price" (id, "stonkId", year, month, price) VALUES (52482, 12, 2015, 7, 1819);
INSERT INTO public."Price" (id, "stonkId", year, month, price) VALUES (51697, 11, 2025, 2, 60.17);
INSERT INTO public."Price" (id, "stonkId", year, month, price) VALUES (52651, 12, 2016, 3, 3833);
INSERT INTO public."Price" (id, "stonkId", year, month, price) VALUES (52800, 12, 2016, 10, 4390);
INSERT INTO public."Price" (id, "stonkId", year, month, price) VALUES (52885, 12, 2017, 2, 4400);
INSERT INTO public."Price" (id, "stonkId", year, month, price) VALUES (52673, 12, 2016, 4, 4715);
INSERT INTO public."Price" (id, "stonkId", year, month, price) VALUES (52630, 12, 2016, 2, 3942);
INSERT INTO public."Price" (id, "stonkId", year, month, price) VALUES (52755, 12, 2016, 8, 4605);
INSERT INTO public."Price" (id, "stonkId", year, month, price) VALUES (52526, 12, 2015, 9, 2985);
INSERT INTO public."Price" (id, "stonkId", year, month, price) VALUES (52713, 12, 2016, 6, 4683);
INSERT INTO public."Price" (id, "stonkId", year, month, price) VALUES (52612, 12, 2016, 1, 3155);
INSERT INTO public."Price" (id, "stonkId", year, month, price) VALUES (52821, 12, 2016, 11, 4431);
INSERT INTO public."Price" (id, "stonkId", year, month, price) VALUES (52864, 12, 2017, 1, 4622);
INSERT INTO public."Price" (id, "stonkId", year, month, price) VALUES (52946, 12, 2017, 5, 4435);
INSERT INTO public."Price" (id, "stonkId", year, month, price) VALUES (52987, 12, 2017, 7, 3896);
INSERT INTO public."Price" (id, "stonkId", year, month, price) VALUES (52926, 12, 2017, 4, 4402);
INSERT INTO public."Price" (id, "stonkId", year, month, price) VALUES (53052, 12, 2017, 10, 4769);
INSERT INTO public."Price" (id, "stonkId", year, month, price) VALUES (53008, 12, 2017, 8, 4589);
INSERT INTO public."Price" (id, "stonkId", year, month, price) VALUES (53031, 12, 2017, 9, 4455);
INSERT INTO public."Price" (id, "stonkId", year, month, price) VALUES (53074, 12, 2017, 11, 4991);
INSERT INTO public."Price" (id, "stonkId", year, month, price) VALUES (53136, 12, 2018, 2, 4589);
INSERT INTO public."Price" (id, "stonkId", year, month, price) VALUES (53116, 12, 2018, 1, 4562);
INSERT INTO public."Price" (id, "stonkId", year, month, price) VALUES (53155, 12, 2018, 3, 4503);
INSERT INTO public."Price" (id, "stonkId", year, month, price) VALUES (53176, 12, 2018, 4, 3984);
INSERT INTO public."Price" (id, "stonkId", year, month, price) VALUES (53198, 12, 2018, 5, 3771);
INSERT INTO public."Price" (id, "stonkId", year, month, price) VALUES (53219, 12, 2018, 6, 4120);
INSERT INTO public."Price" (id, "stonkId", year, month, price) VALUES (53240, 12, 2018, 7, 4406);
INSERT INTO public."Price" (id, "stonkId", year, month, price) VALUES (53262, 12, 2018, 8, 4278);
INSERT INTO public."Price" (id, "stonkId", year, month, price) VALUES (46742, 11, 2015, 3, 71.03);
INSERT INTO public."Price" (id, "stonkId", year, month, price) VALUES (46466, 10, 2026, 3, 96.34);
INSERT INTO public."Price" (id, "stonkId", year, month, price) VALUES (802, 10, 2026, 4, 97.18);
INSERT INTO public."Price" (id, "stonkId", year, month, price) VALUES (53430, 12, 2019, 4, 5060.5);
INSERT INTO public."Price" (id, "stonkId", year, month, price) VALUES (55648, 13, 2016, 6, 8903);
INSERT INTO public."Price" (id, "stonkId", year, month, price) VALUES (55168, 12, 2026, 2, 2496.4);
INSERT INTO public."Price" (id, "stonkId", year, month, price) VALUES (54953, 12, 2025, 4, 1735.2);
INSERT INTO public."Price" (id, "stonkId", year, month, price) VALUES (54006, 12, 2021, 7, 14007.5);
INSERT INTO public."Price" (id, "stonkId", year, month, price) VALUES (55378, 13, 2015, 5, 10775);
INSERT INTO public."Price" (id, "stonkId", year, month, price) VALUES (56817, 13, 2021, 1, 4971);
INSERT INTO public."Price" (id, "stonkId", year, month, price) VALUES (55547, 13, 2016, 1, 11609);
INSERT INTO public."Price" (id, "stonkId", year, month, price) VALUES (53285, 12, 2018, 9, 4084);
INSERT INTO public."Price" (id, "stonkId", year, month, price) VALUES (56498, 13, 2019, 10, 3216.5);
INSERT INTO public."Price" (id, "stonkId", year, month, price) VALUES (55016, 12, 2025, 7, 1960.4);
INSERT INTO public."Price" (id, "stonkId", year, month, price) VALUES (56241, 13, 2018, 10, 3633);
INSERT INTO public."Price" (id, "stonkId", year, month, price) VALUES (53583, 12, 2019, 11, 6874.5);
INSERT INTO public."Price" (id, "stonkId", year, month, price) VALUES (53560, 12, 2019, 10, 7504);
INSERT INTO public."Price" (id, "stonkId", year, month, price) VALUES (54050, 12, 2021, 9, 11835.5);
INSERT INTO public."Price" (id, "stonkId", year, month, price) VALUES (55799, 13, 2017, 1, 9657);
INSERT INTO public."Price" (id, "stonkId", year, month, price) VALUES (55966, 13, 2017, 9, 10113);
INSERT INTO public."Price" (id, "stonkId", year, month, price) VALUES (54459, 12, 2023, 5, 10579.5);
INSERT INTO public."Price" (id, "stonkId", year, month, price) VALUES (54222, 12, 2022, 6, 9023.5);
INSERT INTO public."Price" (id, "stonkId", year, month, price) VALUES (54028, 12, 2021, 8, 13272);
INSERT INTO public."Price" (id, "stonkId", year, month, price) VALUES (53452, 12, 2019, 5, 5134.5);
INSERT INTO public."Price" (id, "stonkId", year, month, price) VALUES (54760, 12, 2024, 7, 12779);
INSERT INTO public."Price" (id, "stonkId", year, month, price) VALUES (55922, 13, 2017, 7, 9560);
INSERT INTO public."Price" (id, "stonkId", year, month, price) VALUES (55461, 13, 2015, 9, 11741);
INSERT INTO public."Price" (id, "stonkId", year, month, price) VALUES (53473, 12, 2019, 6, 5829.5);
INSERT INTO public."Price" (id, "stonkId", year, month, price) VALUES (53748, 12, 2020, 7, 16737);
INSERT INTO public."Price" (id, "stonkId", year, month, price) VALUES (53898, 12, 2021, 2, 14047);
INSERT INTO public."Price" (id, "stonkId", year, month, price) VALUES (54975, 12, 2025, 5, 1683.2);
INSERT INTO public."Price" (id, "stonkId", year, month, price) VALUES (55396, 13, 2015, 6, 11352);
INSERT INTO public."Price" (id, "stonkId", year, month, price) VALUES (55106, 12, 2025, 11, 2135.2);
INSERT INTO public."Price" (id, "stonkId", year, month, price) VALUES (53493, 12, 2019, 7, 6485);
INSERT INTO public."Price" (id, "stonkId", year, month, price) VALUES (56901, 13, 2021, 5, 5451);
INSERT INTO public."Price" (id, "stonkId", year, month, price) VALUES (55039, 12, 2025, 8, 2134);
INSERT INTO public."Price" (id, "stonkId", year, month, price) VALUES (54696, 12, 2024, 4, 13319.5);
INSERT INTO public."Price" (id, "stonkId", year, month, price) VALUES (54311, 12, 2022, 10, 6091);
INSERT INTO public."Price" (id, "stonkId", year, month, price) VALUES (54094, 12, 2021, 11, 14356.5);
INSERT INTO public."Price" (id, "stonkId", year, month, price) VALUES (53770, 12, 2020, 8, 18080);
INSERT INTO public."Price" (id, "stonkId", year, month, price) VALUES (56307, 13, 2019, 1, 4145.5);
INSERT INTO public."Price" (id, "stonkId", year, month, price) VALUES (53879, 12, 2021, 1, 14414.5);
INSERT INTO public."Price" (id, "stonkId", year, month, price) VALUES (55440, 13, 2015, 8, 12203);
INSERT INTO public."Price" (id, "stonkId", year, month, price) VALUES (53370, 12, 2019, 1, 5550.5);
INSERT INTO public."Price" (id, "stonkId", year, month, price) VALUES (54827, 12, 2024, 10, 14807);
INSERT INTO public."Price" (id, "stonkId", year, month, price) VALUES (54073, 12, 2021, 10, 14049.5);
INSERT INTO public."Price" (id, "stonkId", year, month, price) VALUES (57160, 13, 2022, 6, 4251);
INSERT INTO public."Price" (id, "stonkId", year, month, price) VALUES (55669, 13, 2016, 7, 10247);
INSERT INTO public."Price" (id, "stonkId", year, month, price) VALUES (55881, 13, 2017, 5, 9144);
INSERT INTO public."Price" (id, "stonkId", year, month, price) VALUES (55629, 13, 2016, 5, 9382);
INSERT INTO public."Price" (id, "stonkId", year, month, price) VALUES (56154, 13, 2018, 6, 4600);
INSERT INTO public."Price" (id, "stonkId", year, month, price) VALUES (53516, 12, 2019, 8, 7551);
INSERT INTO public."Price" (id, "stonkId", year, month, price) VALUES (55756, 13, 2016, 11, 10293);
INSERT INTO public."Price" (id, "stonkId", year, month, price) VALUES (55187, 12, 2026, 3, 2100);
INSERT INTO public."Price" (id, "stonkId", year, month, price) VALUES (54439, 12, 2023, 4, 10443.5);
INSERT INTO public."Price" (id, "stonkId", year, month, price) VALUES (53390, 12, 2019, 2, 5399.5);
INSERT INTO public."Price" (id, "stonkId", year, month, price) VALUES (263, 12, 2022, 3, 12413);
INSERT INTO public."Price" (id, "stonkId", year, month, price) VALUES (53918, 12, 2021, 3, 13730);
INSERT INTO public."Price" (id, "stonkId", year, month, price) VALUES (54332, 12, 2022, 11, 7248.5);
INSERT INTO public."Price" (id, "stonkId", year, month, price) VALUES (55083, 12, 2025, 10, 2088.2);
INSERT INTO public."Price" (id, "stonkId", year, month, price) VALUES (53941, 12, 2021, 4, 13944);
INSERT INTO public."Price" (id, "stonkId", year, month, price) VALUES (54894, 12, 2025, 1, 17209);
INSERT INTO public."Price" (id, "stonkId", year, month, price) VALUES (56988, 13, 2021, 9, 6064);
INSERT INTO public."Price" (id, "stonkId", year, month, price) VALUES (53538, 12, 2019, 9, 7530.5);
INSERT INTO public."Price" (id, "stonkId", year, month, price) VALUES (53410, 12, 2019, 3, 5412.5);
INSERT INTO public."Price" (id, "stonkId", year, month, price) VALUES (55417, 13, 2015, 7, 12110);
INSERT INTO public."Price" (id, "stonkId", year, month, price) VALUES (54850, 12, 2024, 11, 14259.5);
INSERT INTO public."Price" (id, "stonkId", year, month, price) VALUES (56197, 13, 2018, 8, 4051);
INSERT INTO public."Price" (id, "stonkId", year, month, price) VALUES (56051, 13, 2018, 1, 5357);
INSERT INTO public."Price" (id, "stonkId", year, month, price) VALUES (55483, 13, 2015, 10, 11191);
INSERT INTO public."Price" (id, "stonkId", year, month, price) VALUES (53814, 12, 2020, 10, 15393.5);
INSERT INTO public."Price" (id, "stonkId", year, month, price) VALUES (55820, 13, 2017, 2, 9157);
INSERT INTO public."Price" (id, "stonkId", year, month, price) VALUES (54244, 12, 2022, 7, 8410);
INSERT INTO public."Price" (id, "stonkId", year, month, price) VALUES (53963, 12, 2021, 5, 15828.5);
INSERT INTO public."Price" (id, "stonkId", year, month, price) VALUES (54376, 12, 2023, 1, 9264.5);
INSERT INTO public."Price" (id, "stonkId", year, month, price) VALUES (54265, 12, 2022, 8, 8199);
INSERT INTO public."Price" (id, "stonkId", year, month, price) VALUES (54719, 12, 2024, 5, 12388);
INSERT INTO public."Price" (id, "stonkId", year, month, price) VALUES (53791, 12, 2020, 9, 16368.5);
INSERT INTO public."Price" (id, "stonkId", year, month, price) VALUES (55565, 13, 2016, 2, 10582);
INSERT INTO public."Price" (id, "stonkId", year, month, price) VALUES (56347, 13, 2019, 3, 3645.5);
INSERT INTO public."Price" (id, "stonkId", year, month, price) VALUES (53836, 12, 2020, 11, 14502.5);
INSERT INTO public."Price" (id, "stonkId", year, month, price) VALUES (74, 13, 2014, 10, 11716.3);
INSERT INTO public."Price" (id, "stonkId", year, month, price) VALUES (54914, 12, 2025, 2, 19108);
INSERT INTO public."Price" (id, "stonkId", year, month, price) VALUES (55149, 12, 2026, 1, 2589.8);
INSERT INTO public."Price" (id, "stonkId", year, month, price) VALUES (55987, 13, 2017, 10, 7822);
INSERT INTO public."Price" (id, "stonkId", year, month, price) VALUES (54783, 12, 2024, 8, 12225.5);
INSERT INTO public."Price" (id, "stonkId", year, month, price) VALUES (54204, 12, 2022, 5, 11425.5);
INSERT INTO public."Price" (id, "stonkId", year, month, price) VALUES (55839, 13, 2017, 3, 9378);
INSERT INTO public."Price" (id, "stonkId", year, month, price) VALUES (54397, 12, 2023, 2, 8795);
INSERT INTO public."Price" (id, "stonkId", year, month, price) VALUES (55690, 13, 2016, 8, 10305);
INSERT INTO public."Price" (id, "stonkId", year, month, price) VALUES (405, 12, 2023, 12, 10619);
INSERT INTO public."Price" (id, "stonkId", year, month, price) VALUES (55586, 13, 2016, 3, 10526);
INSERT INTO public."Price" (id, "stonkId", year, month, price) VALUES (55356, 13, 2015, 4, 11419);
INSERT INTO public."Price" (id, "stonkId", year, month, price) VALUES (56368, 13, 2019, 4, 3628.5);
INSERT INTO public."Price" (id, "stonkId", year, month, price) VALUES (56175, 13, 2018, 7, 4140);
INSERT INTO public."Price" (id, "stonkId", year, month, price) VALUES (56009, 13, 2017, 11, 6308);
INSERT INTO public."Price" (id, "stonkId", year, month, price) VALUES (55505, 13, 2015, 11, 12022);
INSERT INTO public."Price" (id, "stonkId", year, month, price) VALUES (55713, 13, 2016, 9, 10473);
INSERT INTO public."Price" (id, "stonkId", year, month, price) VALUES (55608, 13, 2016, 4, 9000);
INSERT INTO public."Price" (id, "stonkId", year, month, price) VALUES (55335, 13, 2015, 3, 11307);
INSERT INTO public."Price" (id, "stonkId", year, month, price) VALUES (56856, 13, 2021, 3, 5341.5);
INSERT INTO public."Price" (id, "stonkId", year, month, price) VALUES (55943, 13, 2017, 8, 10726);
INSERT INTO public."Price" (id, "stonkId", year, month, price) VALUES (55901, 13, 2017, 6, 9090);
INSERT INTO public."Price" (id, "stonkId", year, month, price) VALUES (57142, 13, 2022, 5, 4630.5);
INSERT INTO public."Price" (id, "stonkId", year, month, price) VALUES (535, 13, 2018, 12, 3512);
INSERT INTO public."Price" (id, "stonkId", year, month, price) VALUES (56264, 13, 2018, 11, 3490);
INSERT INTO public."Price" (id, "stonkId", year, month, price) VALUES (55735, 13, 2016, 10, 10515);
INSERT INTO public."Price" (id, "stonkId", year, month, price) VALUES (56431, 13, 2019, 7, 3782);
INSERT INTO public."Price" (id, "stonkId", year, month, price) VALUES (55861, 13, 2017, 4, 8837);
INSERT INTO public."Price" (id, "stonkId", year, month, price) VALUES (56133, 13, 2018, 5, 5128);
INSERT INTO public."Price" (id, "stonkId", year, month, price) VALUES (56111, 13, 2018, 4, 4884);
INSERT INTO public."Price" (id, "stonkId", year, month, price) VALUES (56090, 13, 2018, 3, 4666);
INSERT INTO public."Price" (id, "stonkId", year, month, price) VALUES (57032, 13, 2021, 11, 5834);
INSERT INTO public."Price" (id, "stonkId", year, month, price) VALUES (56071, 13, 2018, 2, 4833);
INSERT INTO public."Price" (id, "stonkId", year, month, price) VALUES (56220, 13, 2018, 9, 3820);
INSERT INTO public."Price" (id, "stonkId", year, month, price) VALUES (56944, 13, 2021, 7, 5369);
INSERT INTO public."Price" (id, "stonkId", year, month, price) VALUES (56476, 13, 2019, 9, 3547);
INSERT INTO public."Price" (id, "stonkId", year, month, price) VALUES (56454, 13, 2019, 8, 3648);
INSERT INTO public."Price" (id, "stonkId", year, month, price) VALUES (56327, 13, 2019, 2, 3790);
INSERT INTO public."Price" (id, "stonkId", year, month, price) VALUES (56390, 13, 2019, 5, 3702);
INSERT INTO public."Price" (id, "stonkId", year, month, price) VALUES (56708, 13, 2020, 8, 4501);
INSERT INTO public."Price" (id, "stonkId", year, month, price) VALUES (56411, 13, 2019, 6, 3762);
INSERT INTO public."Price" (id, "stonkId", year, month, price) VALUES (56521, 13, 2019, 11, 3260);
INSERT INTO public."Price" (id, "stonkId", year, month, price) VALUES (56729, 13, 2020, 9, 4939);
INSERT INTO public."Price" (id, "stonkId", year, month, price) VALUES (56752, 13, 2020, 10, 4654);
INSERT INTO public."Price" (id, "stonkId", year, month, price) VALUES (56686, 13, 2020, 7, 4602.5);
INSERT INTO public."Price" (id, "stonkId", year, month, price) VALUES (57011, 13, 2021, 10, 6501);
INSERT INTO public."Price" (id, "stonkId", year, month, price) VALUES (56836, 13, 2021, 2, 4925);
INSERT INTO public."Price" (id, "stonkId", year, month, price) VALUES (56774, 13, 2020, 11, 4995);
INSERT INTO public."Price" (id, "stonkId", year, month, price) VALUES (56879, 13, 2021, 4, 5109);
INSERT INTO public."Price" (id, "stonkId", year, month, price) VALUES (56966, 13, 2021, 8, 5580);
INSERT INTO public."Price" (id, "stonkId", year, month, price) VALUES (57182, 13, 2022, 7, 4827.5);
INSERT INTO public."Price" (id, "stonkId", year, month, price) VALUES (57203, 13, 2022, 8, 5429);
INSERT INTO public."Price" (id, "stonkId", year, month, price) VALUES (57377, 13, 2023, 4, 4724);
INSERT INTO public."Price" (id, "stonkId", year, month, price) VALUES (57249, 13, 2022, 10, 5256.5);
INSERT INTO public."Price" (id, "stonkId", year, month, price) VALUES (57270, 13, 2022, 11, 4804);
INSERT INTO public."Price" (id, "stonkId", year, month, price) VALUES (643, 13, 2022, 12, 4361);
INSERT INTO public."Price" (id, "stonkId", year, month, price) VALUES (57314, 13, 2023, 1, 4669);
INSERT INTO public."Price" (id, "stonkId", year, month, price) VALUES (57335, 13, 2023, 2, 4613);
INSERT INTO public."Price" (id, "stonkId", year, month, price) VALUES (57397, 13, 2023, 5, 4201);
INSERT INTO public."Price" (id, "stonkId", year, month, price) VALUES (418, 13, 2024, 3, 7872);
INSERT INTO public."Price" (id, "stonkId", year, month, price) VALUES (57721, 13, 2024, 8, 4828.5);
INSERT INTO public."Price" (id, "stonkId", year, month, price) VALUES (57634, 13, 2024, 4, 8387);
INSERT INTO public."Price" (id, "stonkId", year, month, price) VALUES (57657, 13, 2024, 5, 7234.5);
INSERT INTO public."Price" (id, "stonkId", year, month, price) VALUES (57698, 13, 2024, 7, 5769);
INSERT INTO public."Price" (id, "stonkId", year, month, price) VALUES (53305, 12, 2018, 10, 4128);
INSERT INTO public."Price" (id, "stonkId", year, month, price) VALUES (53328, 12, 2018, 11, 4798.5);
INSERT INTO public."Price" (id, "stonkId", year, month, price) VALUES (62337, 14, 2023, 5, 115.71);
INSERT INTO public."Price" (id, "stonkId", year, month, price) VALUES (60489, 14, 2019, 8, 94.77);
INSERT INTO public."Price" (id, "stonkId", year, month, price) VALUES (62297, 14, 2023, 4, 109.92);
INSERT INTO public."Price" (id, "stonkId", year, month, price) VALUES (58024, 13, 2025, 10, 2906);
INSERT INTO public."Price" (id, "stonkId", year, month, price) VALUES (59563, 14, 2017, 9, 115.35);
INSERT INTO public."Price" (id, "stonkId", year, month, price) VALUES (59331, 14, 2017, 3, 112.76);
INSERT INTO public."Price" (id, "stonkId", year, month, price) VALUES (61205, 14, 2021, 1, 158.03);
INSERT INTO public."Price" (id, "stonkId", year, month, price) VALUES (63684, 14, 2026, 1, 183.06);
INSERT INTO public."Price" (id, "stonkId", year, month, price) VALUES (62216, 14, 2023, 2, 115.34);
INSERT INTO public."Price" (id, "stonkId", year, month, price) VALUES (61850, 14, 2022, 5, 88.25);
INSERT INTO public."Price" (id, "stonkId", year, month, price) VALUES (61328, 14, 2021, 4, 178.7);
INSERT INTO public."Price" (id, "stonkId", year, month, price) VALUES (57957, 13, 2025, 7, 3536);
INSERT INTO public."Price" (id, "stonkId", year, month, price) VALUES (59488, 14, 2017, 7, 107.75);
INSERT INTO public."Price" (id, "stonkId", year, month, price) VALUES (61545, 14, 2021, 9, 173.68);
INSERT INTO public."Price" (id, "stonkId", year, month, price) VALUES (59946, 14, 2018, 7, 102.81);
INSERT INTO public."Price" (id, "stonkId", year, month, price) VALUES (58090, 13, 2026, 1, 3273);
INSERT INTO public."Price" (id, "stonkId", year, month, price) VALUES (58902, 14, 2016, 4, 103.43);
INSERT INTO public."Price" (id, "stonkId", year, month, price) VALUES (58671, 14, 2015, 10, 91.14);
INSERT INTO public."Price" (id, "stonkId", year, month, price) VALUES (60575, 14, 2019, 10, 95.13);
INSERT INTO public."Price" (id, "stonkId", year, month, price) VALUES (58791, 14, 2016, 1, 94.44);
INSERT INTO public."Price" (id, "stonkId", year, month, price) VALUES (59014, 14, 2016, 7, 113.33);
INSERT INTO public."Price" (id, "stonkId", year, month, price) VALUES (58501, 14, 2015, 6, 69.08);
INSERT INTO public."Price" (id, "stonkId", year, month, price) VALUES (57980, 13, 2025, 8, 3697.5);
INSERT INTO public."Price" (id, "stonkId", year, month, price) VALUES (58714, 14, 2015, 11, 95.29);
INSERT INTO public."Price" (id, "stonkId", year, month, price) VALUES (60198, 14, 2019, 1, 93.07);
INSERT INTO public."Price" (id, "stonkId", year, month, price) VALUES (59634, 14, 2017, 11, 124.16);
INSERT INTO public."Price" (id, "stonkId", year, month, price) VALUES (60067, 14, 2018, 10, 87.34);
INSERT INTO public."Price" (id, "stonkId", year, month, price) VALUES (59985, 14, 2018, 8, 96.85);
INSERT INTO public."Price" (id, "stonkId", year, month, price) VALUES (58109, 13, 2026, 2, 3357.5);
INSERT INTO public."Price" (id, "stonkId", year, month, price) VALUES (59298, 14, 2017, 2, 123.54);
INSERT INTO public."Price" (id, "stonkId", year, month, price) VALUES (60404, 14, 2019, 6, 89.91);
INSERT INTO public."Price" (id, "stonkId", year, month, price) VALUES (57832, 13, 2025, 1, 4723);
INSERT INTO public."Price" (id, "stonkId", year, month, price) VALUES (59906, 14, 2018, 6, 109.75);
INSERT INTO public."Price" (id, "stonkId", year, month, price) VALUES (59374, 14, 2017, 4, 114.95);
INSERT INTO public."Price" (id, "stonkId", year, month, price) VALUES (61926, 14, 2022, 7, 86.22);
INSERT INTO public."Price" (id, "stonkId", year, month, price) VALUES (59716, 14, 2018, 1, 115.71);
INSERT INTO public."Price" (id, "stonkId", year, month, price) VALUES (188, 14, 2020, 2, 100.63);
INSERT INTO public."Price" (id, "stonkId", year, month, price) VALUES (60621, 14, 2019, 11, 105.7);
INSERT INTO public."Price" (id, "stonkId", year, month, price) VALUES (58047, 13, 2025, 11, 2917.5);
INSERT INTO public."Price" (id, "stonkId", year, month, price) VALUES (62786, 14, 2024, 4, 234.72);
INSERT INTO public."Price" (id, "stonkId", year, month, price) VALUES (60278, 14, 2019, 3, 91.18);
INSERT INTO public."Price" (id, "stonkId", year, month, price) VALUES (58940, 14, 2016, 5, 108.9);
INSERT INTO public."Price" (id, "stonkId", year, month, price) VALUES (57852, 13, 2025, 2, 4904.5);
INSERT INTO public."Price" (id, "stonkId", year, month, price) VALUES (64702, 15, 2016, 6, 0.06814);
INSERT INTO public."Price" (id, "stonkId", year, month, price) VALUES (59099, 14, 2016, 9, 125.02);
INSERT INTO public."Price" (id, "stonkId", year, month, price) VALUES (58542, 14, 2015, 7, 71.11);
INSERT INTO public."Price" (id, "stonkId", year, month, price) VALUES (62830, 14, 2024, 5, 241.56);
INSERT INTO public."Price" (id, "stonkId", year, month, price) VALUES (58628, 14, 2015, 9, 80.09);
INSERT INTO public."Price" (id, "stonkId", year, month, price) VALUES (62174, 14, 2023, 1, 106.91);
INSERT INTO public."Price" (id, "stonkId", year, month, price) VALUES (58128, 13, 2026, 3, 2973.5);
INSERT INTO public."Price" (id, "stonkId", year, month, price) VALUES (59413, 14, 2017, 5, 101.18);
INSERT INTO public."Price" (id, "stonkId", year, month, price) VALUES (58827, 14, 2016, 2, 97.74);
INSERT INTO public."Price" (id, "stonkId", year, month, price) VALUES (57894, 13, 2025, 4, 4471.5);
INSERT INTO public."Price" (id, "stonkId", year, month, price) VALUES (61501, 14, 2021, 8, 184.6);
INSERT INTO public."Price" (id, "stonkId", year, month, price) VALUES (60443, 14, 2019, 7, 93.26);
INSERT INTO public."Price" (id, "stonkId", year, month, price) VALUES (59138, 14, 2016, 10, 116.43);
INSERT INTO public."Price" (id, "stonkId", year, month, price) VALUES (59753, 14, 2018, 2, 112.79);
INSERT INTO public."Price" (id, "stonkId", year, month, price) VALUES (64281, 15, 2015, 8, 0.06934);
INSERT INTO public."Price" (id, "stonkId", year, month, price) VALUES (62091, 14, 2022, 11, 87.07);
INSERT INTO public."Price" (id, "stonkId", year, month, price) VALUES (608, 14, 2021, 12, 152.8);
INSERT INTO public."Price" (id, "stonkId", year, month, price) VALUES (58385, 14, 2015, 3, 68.38);
INSERT INTO public."Price" (id, "stonkId", year, month, price) VALUES (59175, 14, 2016, 11, 117.19);
INSERT INTO public."Price" (id, "stonkId", year, month, price) VALUES (59523, 14, 2017, 8, 105.43);
INSERT INTO public."Price" (id, "stonkId", year, month, price) VALUES (58422, 14, 2015, 4, 76.24);
INSERT INTO public."Price" (id, "stonkId", year, month, price) VALUES (61120, 14, 2020, 11, 152.75);
INSERT INTO public."Price" (id, "stonkId", year, month, price) VALUES (60989, 14, 2020, 8, 137.83);
INSERT INTO public."Price" (id, "stonkId", year, month, price) VALUES (63339, 14, 2025, 5, 187.31);
INSERT INTO public."Price" (id, "stonkId", year, month, price) VALUES (60533, 14, 2019, 9, 94.74);
INSERT INTO public."Price" (id, "stonkId", year, month, price) VALUES (63212, 14, 2025, 2, 216.9);
INSERT INTO public."Price" (id, "stonkId", year, month, price) VALUES (59451, 14, 2017, 6, 105.03);
INSERT INTO public."Price" (id, "stonkId", year, month, price) VALUES (58465, 14, 2015, 5, 71.18);
INSERT INTO public."Price" (id, "stonkId", year, month, price) VALUES (734, 14, 2025, 3, 198.27);
INSERT INTO public."Price" (id, "stonkId", year, month, price) VALUES (58974, 14, 2016, 6, 113.14);
INSERT INTO public."Price" (id, "stonkId", year, month, price) VALUES (58864, 14, 2016, 3, 103.57);
INSERT INTO public."Price" (id, "stonkId", year, month, price) VALUES (58586, 14, 2015, 8, 73.83);
INSERT INTO public."Price" (id, "stonkId", year, month, price) VALUES (59056, 14, 2016, 8, 128.15);
INSERT INTO public."Price" (id, "stonkId", year, month, price) VALUES (60029, 14, 2018, 9, 97.5);
INSERT INTO public."Price" (id, "stonkId", year, month, price) VALUES (59259, 14, 2017, 1, 135.34);
INSERT INTO public."Price" (id, "stonkId", year, month, price) VALUES (61885, 14, 2022, 6, 85.73);
INSERT INTO public."Price" (id, "stonkId", year, month, price) VALUES (60363, 14, 2019, 5, 84.37);
INSERT INTO public."Price" (id, "stonkId", year, month, price) VALUES (59827, 14, 2018, 4, 120.25);
INSERT INTO public."Price" (id, "stonkId", year, month, price) VALUES (60238, 14, 2019, 2, 90.71);
INSERT INTO public."Price" (id, "stonkId", year, month, price) VALUES (60113, 14, 2018, 11, 89.82);
INSERT INTO public."Price" (id, "stonkId", year, month, price) VALUES (59603, 14, 2017, 10, 117.86);
INSERT INTO public."Price" (id, "stonkId", year, month, price) VALUES (59787, 14, 2018, 3, 117.31);
INSERT INTO public."Price" (id, "stonkId", year, month, price) VALUES (62911, 14, 2024, 7, 231.39);
INSERT INTO public."Price" (id, "stonkId", year, month, price) VALUES (59866, 14, 2018, 5, 112.39);
INSERT INTO public."Price" (id, "stonkId", year, month, price) VALUES (61457, 14, 2021, 7, 173.53);
INSERT INTO public."Price" (id, "stonkId", year, month, price) VALUES (60319, 14, 2019, 4, 90.57);
INSERT INTO public."Price" (id, "stonkId", year, month, price) VALUES (63466, 14, 2025, 8, 179.7);
INSERT INTO public."Price" (id, "stonkId", year, month, price) VALUES (61283, 14, 2021, 3, 173.08);
INSERT INTO public."Price" (id, "stonkId", year, month, price) VALUES (61031, 14, 2020, 9, 147.53);
INSERT INTO public."Price" (id, "stonkId", year, month, price) VALUES (60945, 14, 2020, 7, 132.4);
INSERT INTO public."Price" (id, "stonkId", year, month, price) VALUES (61243, 14, 2021, 2, 172.89);
INSERT INTO public."Price" (id, "stonkId", year, month, price) VALUES (61965, 14, 2022, 8, 91.56);
INSERT INTO public."Price" (id, "stonkId", year, month, price) VALUES (61632, 14, 2021, 11, 151.08);
INSERT INTO public."Price" (id, "stonkId", year, month, price) VALUES (61076, 14, 2020, 10, 136.16);
INSERT INTO public."Price" (id, "stonkId", year, month, price) VALUES (61372, 14, 2021, 5, 168.98);
INSERT INTO public."Price" (id, "stonkId", year, month, price) VALUES (64328, 15, 2015, 9, 0.06782);
INSERT INTO public."Price" (id, "stonkId", year, month, price) VALUES (63760, 14, 2026, 3, 169.23);
INSERT INTO public."Price" (id, "stonkId", year, month, price) VALUES (61590, 14, 2021, 10, 173.78);
INSERT INTO public."Price" (id, "stonkId", year, month, price) VALUES (64536, 15, 2016, 2, 0.07214);
INSERT INTO public."Price" (id, "stonkId", year, month, price) VALUES (62955, 14, 2024, 8, 206.27);
INSERT INTO public."Price" (id, "stonkId", year, month, price) VALUES (64141, 15, 2015, 5, 0.08049);
INSERT INTO public."Price" (id, "stonkId", year, month, price) VALUES (62052, 14, 2022, 10, 85.6);
INSERT INTO public."Price" (id, "stonkId", year, month, price) VALUES (87, 15, 2014, 11, 0.04607);
INSERT INTO public."Price" (id, "stonkId", year, month, price) VALUES (63599, 14, 2025, 11, 169.82);
INSERT INTO public."Price" (id, "stonkId", year, month, price) VALUES (63039, 14, 2024, 10, 189.35);
INSERT INTO public."Price" (id, "stonkId", year, month, price) VALUES (63085, 14, 2024, 11, 184.74);
INSERT INTO public."Price" (id, "stonkId", year, month, price) VALUES (64055, 15, 2015, 3, 0.05975);
INSERT INTO public."Price" (id, "stonkId", year, month, price) VALUES (64749, 15, 2016, 7, 0.06774);
INSERT INTO public."Price" (id, "stonkId", year, month, price) VALUES (63420, 14, 2025, 7, 174);
INSERT INTO public."Price" (id, "stonkId", year, month, price) VALUES (63172, 14, 2025, 1, 206.37);
INSERT INTO public."Price" (id, "stonkId", year, month, price) VALUES (63722, 14, 2026, 2, 183.94);
INSERT INTO public."Price" (id, "stonkId", year, month, price) VALUES (63295, 14, 2025, 4, 198.4);
INSERT INTO public."Price" (id, "stonkId", year, month, price) VALUES (64184, 15, 2015, 6, 0.07814);
INSERT INTO public."Price" (id, "stonkId", year, month, price) VALUES (63553, 14, 2025, 10, 162.68);
INSERT INTO public."Price" (id, "stonkId", year, month, price) VALUES (64500, 15, 2016, 1, 0.07258);
INSERT INTO public."Price" (id, "stonkId", year, month, price) VALUES (64097, 15, 2015, 4, 0.06456);
INSERT INTO public."Price" (id, "stonkId", year, month, price) VALUES (64372, 15, 2015, 10, 0.07217);
INSERT INTO public."Price" (id, "stonkId", year, month, price) VALUES (64235, 15, 2015, 7, 0.07209);
INSERT INTO public."Price" (id, "stonkId", year, month, price) VALUES (64622, 15, 2016, 4, 0.07049);
INSERT INTO public."Price" (id, "stonkId", year, month, price) VALUES (64929, 15, 2016, 11, 0.06887);
INSERT INTO public."Price" (id, "stonkId", year, month, price) VALUES (64416, 15, 2015, 11, 0.07211);
INSERT INTO public."Price" (id, "stonkId", year, month, price) VALUES (64664, 15, 2016, 5, 0.06917);
INSERT INTO public."Price" (id, "stonkId", year, month, price) VALUES (64791, 15, 2016, 8, 0.06822);
INSERT INTO public."Price" (id, "stonkId", year, month, price) VALUES (64837, 15, 2016, 9, 0.07215);
INSERT INTO public."Price" (id, "stonkId", year, month, price) VALUES (65097, 15, 2017, 3, 0.06638);
INSERT INTO public."Price" (id, "stonkId", year, month, price) VALUES (64887, 15, 2016, 10, 0.0679);
INSERT INTO public."Price" (id, "stonkId", year, month, price) VALUES (65017, 15, 2017, 1, 0.06894);
INSERT INTO public."Price" (id, "stonkId", year, month, price) VALUES (65059, 15, 2017, 2, 0.06612);
INSERT INTO public."Price" (id, "stonkId", year, month, price) VALUES (65142, 15, 2017, 4, 0.067);
INSERT INTO public."Price" (id, "stonkId", year, month, price) VALUES (57765, 13, 2024, 10, 4397.5);
INSERT INTO public."Price" (id, "stonkId", year, month, price) VALUES (65182, 15, 2017, 5, 0.06581);
INSERT INTO public."Price" (id, "stonkId", year, month, price) VALUES (65222, 15, 2017, 6, 0.06403);
INSERT INTO public."Price" (id, "stonkId", year, month, price) VALUES (65264, 15, 2017, 7, 0.05949);
INSERT INTO public."Price" (id, "stonkId", year, month, price) VALUES (65306, 15, 2017, 8, 0.06486);
INSERT INTO public."Price" (id, "stonkId", year, month, price) VALUES (65352, 15, 2017, 9, 0.06189);
INSERT INTO public."Price" (id, "stonkId", year, month, price) VALUES (65394, 15, 2017, 10, 0.06022);
INSERT INTO public."Price" (id, "stonkId", year, month, price) VALUES (65438, 15, 2017, 11, 0.05108);
INSERT INTO public."Price" (id, "stonkId", year, month, price) VALUES (65523, 15, 2018, 1, 0.04895);
INSERT INTO public."Price" (id, "stonkId", year, month, price) VALUES (57788, 13, 2024, 11, 4469.5);
INSERT INTO public."Price" (id, "stonkId", year, month, price) VALUES (71406, 16, 2019, 1, 108.12);
INSERT INTO public."Price" (id, "stonkId", year, month, price) VALUES (67726, 15, 2022, 6, 0.01818);
INSERT INTO public."Price" (id, "stonkId", year, month, price) VALUES (66369, 15, 2019, 9, 0.042395);
INSERT INTO public."Price" (id, "stonkId", year, month, price) VALUES (71486, 16, 2019, 3, 96.52);
INSERT INTO public."Price" (id, "stonkId", year, month, price) VALUES (69986, 16, 2016, 3, 73.87);
INSERT INTO public."Price" (id, "stonkId", year, month, price) VALUES (68793, 15, 2024, 7, 98.23);
INSERT INTO public."Price" (id, "stonkId", year, month, price) VALUES (67123, 15, 2021, 3, 0.041785);
INSERT INTO public."Price" (id, "stonkId", year, month, price) VALUES (67769, 15, 2022, 7, 0.018495);
INSERT INTO public."Price" (id, "stonkId", year, month, price) VALUES (65948, 15, 2018, 11, 0.037395);
INSERT INTO public."Price" (id, "stonkId", year, month, price) VALUES (197, 15, 2020, 5, 0.035735);
INSERT INTO public."Price" (id, "stonkId", year, month, price) VALUES (65815, 15, 2018, 8, 0.04125);
INSERT INTO public."Price" (id, "stonkId", year, month, price) VALUES (70411, 16, 2017, 1, 172.68);
INSERT INTO public."Price" (id, "stonkId", year, month, price) VALUES (65687, 15, 2018, 5, 0.05038);
INSERT INTO public."Price" (id, "stonkId", year, month, price) VALUES (69828, 16, 2015, 11, 57.59);
INSERT INTO public."Price" (id, "stonkId", year, month, price) VALUES (68666, 15, 2024, 4, 0.02343);
INSERT INTO public."Price" (id, "stonkId", year, month, price) VALUES (68196, 15, 2023, 5, 0.022225);
INSERT INTO public."Price" (id, "stonkId", year, month, price) VALUES (68950, 15, 2025, 2, 90.36);
INSERT INTO public."Price" (id, "stonkId", year, month, price) VALUES (68820, 15, 2024, 8, 93.29);
INSERT INTO public."Price" (id, "stonkId", year, month, price) VALUES (67385, 15, 2021, 9, 0.05164);
INSERT INTO public."Price" (id, "stonkId", year, month, price) VALUES (65563, 15, 2018, 2, 0.05337);
INSERT INTO public."Price" (id, "stonkId", year, month, price) VALUES (69614, 16, 2015, 6, 38.07);
INSERT INTO public."Price" (id, "stonkId", year, month, price) VALUES (67297, 15, 2021, 7, 0.04819);
INSERT INTO public."Price" (id, "stonkId", year, month, price) VALUES (67690, 15, 2022, 5, 0.018205);
INSERT INTO public."Price" (id, "stonkId", year, month, price) VALUES (69699, 16, 2015, 8, 39.82);
INSERT INTO public."Price" (id, "stonkId", year, month, price) VALUES (67045, 15, 2021, 1, 0.036745);
INSERT INTO public."Price" (id, "stonkId", year, month, price) VALUES (68073, 15, 2023, 2, 0.016465);
INSERT INTO public."Price" (id, "stonkId", year, month, price) VALUES (69188, 15, 2026, 1, 77.69);
INSERT INTO public."Price" (id, "stonkId", year, month, price) VALUES (71527, 16, 2019, 4, 96.66);
INSERT INTO public."Price" (id, "stonkId", year, month, price) VALUES (66154, 15, 2019, 4, 0.035365);
INSERT INTO public."Price" (id, "stonkId", year, month, price) VALUES (66279, 15, 2019, 7, 0.042645);
INSERT INTO public."Price" (id, "stonkId", year, month, price) VALUES (66033, 15, 2019, 1, 0.037645);
INSERT INTO public."Price" (id, "stonkId", year, month, price) VALUES (71234, 16, 2018, 9, 106.35);
INSERT INTO public."Price" (id, "stonkId", year, month, price) VALUES (66240, 15, 2019, 6, 0.04012);
INSERT INTO public."Price" (id, "stonkId", year, month, price) VALUES (69494, 16, 2015, 3, 33.99);
INSERT INTO public."Price" (id, "stonkId", year, month, price) VALUES (65729, 15, 2018, 6, 0.04838);
INSERT INTO public."Price" (id, "stonkId", year, month, price) VALUES (70110, 16, 2016, 6, 84.81);
INSERT INTO public."Price" (id, "stonkId", year, month, price) VALUES (69578, 16, 2015, 5, 40.83);
INSERT INTO public."Price" (id, "stonkId", year, month, price) VALUES (67944, 15, 2022, 11, 0.01688);
INSERT INTO public."Price" (id, "stonkId", year, month, price) VALUES (66412, 15, 2019, 10, 0.043275);
INSERT INTO public."Price" (id, "stonkId", year, month, price) VALUES (67168, 15, 2021, 4, 0.05061);
INSERT INTO public."Price" (id, "stonkId", year, month, price) VALUES (66785, 15, 2020, 7, 0.0387);
INSERT INTO public."Price" (id, "stonkId", year, month, price) VALUES (65601, 15, 2018, 3, 0.05147);
INSERT INTO public."Price" (id, "stonkId", year, month, price) VALUES (72751, 16, 2021, 9, 70.3);
INSERT INTO public."Price" (id, "stonkId", year, month, price) VALUES (67430, 15, 2021, 10, 0.052715);
INSERT INTO public."Price" (id, "stonkId", year, month, price) VALUES (68992, 15, 2025, 4, 96.82);
INSERT INTO public."Price" (id, "stonkId", year, month, price) VALUES (69055, 15, 2025, 7, 77.73);
INSERT INTO public."Price" (id, "stonkId", year, month, price) VALUES (70325, 16, 2016, 11, 137.84);
INSERT INTO public."Price" (id, "stonkId", year, month, price) VALUES (72579, 16, 2021, 5, 70.06);
INSERT INTO public."Price" (id, "stonkId", year, month, price) VALUES (70453, 16, 2017, 2, 163.6);
INSERT INTO public."Price" (id, "stonkId", year, month, price) VALUES (66916, 15, 2020, 10, 0.03277);
INSERT INTO public."Price" (id, "stonkId", year, month, price) VALUES (67811, 15, 2022, 8, 0.01923);
INSERT INTO public."Price" (id, "stonkId", year, month, price) VALUES (71829, 16, 2019, 11, 103.68);
INSERT INTO public."Price" (id, "stonkId", year, month, price) VALUES (67083, 15, 2021, 2, 0.037245);
INSERT INTO public."Price" (id, "stonkId", year, month, price) VALUES (66073, 15, 2019, 2, 0.03593);
INSERT INTO public."Price" (id, "stonkId", year, month, price) VALUES (66198, 15, 2019, 5, 0.036395);
INSERT INTO public."Price" (id, "stonkId", year, month, price) VALUES (71651, 16, 2019, 7, 107.34);
INSERT INTO public."Price" (id, "stonkId", year, month, price) VALUES (69207, 15, 2026, 2, 86.82);
INSERT INTO public."Price" (id, "stonkId", year, month, price) VALUES (67341, 15, 2021, 8, 0.052775);
INSERT INTO public."Price" (id, "stonkId", year, month, price) VALUES (65771, 15, 2018, 7, 0.04802);
INSERT INTO public."Price" (id, "stonkId", year, month, price) VALUES (65902, 15, 2018, 10, 0.03677);
INSERT INTO public."Price" (id, "stonkId", year, month, price) VALUES (66325, 15, 2019, 8, 0.038565);
INSERT INTO public."Price" (id, "stonkId", year, month, price) VALUES (70654, 16, 2017, 7, 200.45);
INSERT INTO public."Price" (id, "stonkId", year, month, price) VALUES (65643, 15, 2018, 4, 0.05315);
INSERT INTO public."Price" (id, "stonkId", year, month, price) VALUES (68712, 15, 2024, 5, 0.019965);
INSERT INTO public."Price" (id, "stonkId", year, month, price) VALUES (68863, 15, 2024, 10, 75.53);
INSERT INTO public."Price" (id, "stonkId", year, month, price) VALUES (431, 15, 2023, 8, 0.028805);
INSERT INTO public."Price" (id, "stonkId", year, month, price) VALUES (66458, 15, 2019, 11, 0.04532);
INSERT INTO public."Price" (id, "stonkId", year, month, price) VALUES (70946, 16, 2018, 2, 140.05);
INSERT INTO public."Price" (id, "stonkId", year, month, price) VALUES (70283, 16, 2016, 10, 129.54);
INSERT INTO public."Price" (id, "stonkId", year, month, price) VALUES (68156, 15, 2023, 4, 0.02226);
INSERT INTO public."Price" (id, "stonkId", year, month, price) VALUES (66829, 15, 2020, 8, 0.03561);
INSERT INTO public."Price" (id, "stonkId", year, month, price) VALUES (69655, 16, 2015, 7, 39.34);
INSERT INTO public."Price" (id, "stonkId", year, month, price) VALUES (67212, 15, 2021, 5, 0.04873);
INSERT INTO public."Price" (id, "stonkId", year, month, price) VALUES (69535, 16, 2015, 4, 38.74);
INSERT INTO public."Price" (id, "stonkId", year, month, price) VALUES (69078, 15, 2025, 8, 75.21);
INSERT INTO public."Price" (id, "stonkId", year, month, price) VALUES (69014, 15, 2025, 5, 94.54);
INSERT INTO public."Price" (id, "stonkId", year, month, price) VALUES (69784, 16, 2015, 10, 47.87);
INSERT INTO public."Price" (id, "stonkId", year, month, price) VALUES (70072, 16, 2016, 5, 81.9);
INSERT INTO public."Price" (id, "stonkId", year, month, price) VALUES (66960, 15, 2020, 11, 0.03738);
INSERT INTO public."Price" (id, "stonkId", year, month, price) VALUES (66871, 15, 2020, 9, 0.03447);
INSERT INTO public."Price" (id, "stonkId", year, month, price) VALUES (67472, 15, 2021, 11, 0.04724);
INSERT INTO public."Price" (id, "stonkId", year, month, price) VALUES (68031, 15, 2023, 1, 0.016895);
INSERT INTO public."Price" (id, "stonkId", year, month, price) VALUES (70694, 16, 2017, 8, 194.4);
INSERT INTO public."Price" (id, "stonkId", year, month, price) VALUES (70612, 16, 2017, 6, 194);
INSERT INTO public."Price" (id, "stonkId", year, month, price) VALUES (70574, 16, 2017, 5, 187.65);
INSERT INTO public."Price" (id, "stonkId", year, month, price) VALUES (69145, 15, 2025, 11, 72.28);
INSERT INTO public."Price" (id, "stonkId", year, month, price) VALUES (67902, 15, 2022, 10, 0.01692);
INSERT INTO public."Price" (id, "stonkId", year, month, price) VALUES (68886, 15, 2024, 11, 69.68);
INSERT INTO public."Price" (id, "stonkId", year, month, price) VALUES (69741, 16, 2015, 9, 35.28);
INSERT INTO public."Price" (id, "stonkId", year, month, price) VALUES (68930, 15, 2025, 1, 85.04);
INSERT INTO public."Price" (id, "stonkId", year, month, price) VALUES (70738, 16, 2017, 9, 181.85);
INSERT INTO public."Price" (id, "stonkId", year, month, price) VALUES (70240, 16, 2016, 9, 117.55);
INSERT INTO public."Price" (id, "stonkId", year, month, price) VALUES (69122, 15, 2025, 10, 68.38);
INSERT INTO public."Price" (id, "stonkId", year, month, price) VALUES (70983, 16, 2018, 3, 155.2);
INSERT INTO public."Price" (id, "stonkId", year, month, price) VALUES (69947, 16, 2016, 2, 56.8);
INSERT INTO public."Price" (id, "stonkId", year, month, price) VALUES (69912, 16, 2016, 1, 50.56);
INSERT INTO public."Price" (id, "stonkId", year, month, price) VALUES (71065, 16, 2018, 5, 140);
INSERT INTO public."Price" (id, "stonkId", year, month, price) VALUES (70534, 16, 2017, 4, 176.95);
INSERT INTO public."Price" (id, "stonkId", year, month, price) VALUES (69226, 15, 2026, 3, 84.765);
INSERT INTO public."Price" (id, "stonkId", year, month, price) VALUES (70030, 16, 2016, 4, 76.74);
INSERT INTO public."Price" (id, "stonkId", year, month, price) VALUES (71321, 16, 2018, 11, 115.26);
INSERT INTO public."Price" (id, "stonkId", year, month, price) VALUES (70194, 16, 2016, 8, 99.18);
INSERT INTO public."Price" (id, "stonkId", year, month, price) VALUES (70822, 16, 2017, 11, 152.55);
INSERT INTO public."Price" (id, "stonkId", year, month, price) VALUES (70490, 16, 2017, 3, 169.25);
INSERT INTO public."Price" (id, "stonkId", year, month, price) VALUES (70152, 16, 2016, 7, 85.32);
INSERT INTO public."Price" (id, "stonkId", year, month, price) VALUES (70779, 16, 2017, 10, 180.7);
INSERT INTO public."Price" (id, "stonkId", year, month, price) VALUES (520, 16, 2017, 12, 139.1);
INSERT INTO public."Price" (id, "stonkId", year, month, price) VALUES (71741, 16, 2019, 9, 103.4);
INSERT INTO public."Price" (id, "stonkId", year, month, price) VALUES (71783, 16, 2019, 10, 107.04);
INSERT INTO public."Price" (id, "stonkId", year, month, price) VALUES (70906, 16, 2018, 1, 134.55);
INSERT INTO public."Price" (id, "stonkId", year, month, price) VALUES (71188, 16, 2018, 8, 114.75);
INSERT INTO public."Price" (id, "stonkId", year, month, price) VALUES (71024, 16, 2018, 4, 144.25);
INSERT INTO public."Price" (id, "stonkId", year, month, price) VALUES (71107, 16, 2018, 6, 140.25);
INSERT INTO public."Price" (id, "stonkId", year, month, price) VALUES (71612, 16, 2019, 6, 101.64);
INSERT INTO public."Price" (id, "stonkId", year, month, price) VALUES (71147, 16, 2018, 7, 122.2);
INSERT INTO public."Price" (id, "stonkId", year, month, price) VALUES (72451, 16, 2021, 2, 69.62);
INSERT INTO public."Price" (id, "stonkId", year, month, price) VALUES (71275, 16, 2018, 10, 97.85);
INSERT INTO public."Price" (id, "stonkId", year, month, price) VALUES (71446, 16, 2019, 2, 96.62);
INSERT INTO public."Price" (id, "stonkId", year, month, price) VALUES (72198, 16, 2020, 8, 81.22);
INSERT INTO public."Price" (id, "stonkId", year, month, price) VALUES (71570, 16, 2019, 5, 93.22);
INSERT INTO public."Price" (id, "stonkId", year, month, price) VALUES (72490, 16, 2021, 3, 67.26);
INSERT INTO public."Price" (id, "stonkId", year, month, price) VALUES (72328, 16, 2020, 11, 71.76);
INSERT INTO public."Price" (id, "stonkId", year, month, price) VALUES (71697, 16, 2019, 8, 109.12);
INSERT INTO public."Price" (id, "stonkId", year, month, price) VALUES (72284, 16, 2020, 10, 56.98);
INSERT INTO public."Price" (id, "stonkId", year, month, price) VALUES (72154, 16, 2020, 7, 83.08);
INSERT INTO public."Price" (id, "stonkId", year, month, price) VALUES (72240, 16, 2020, 9, 74.2);
INSERT INTO public."Price" (id, "stonkId", year, month, price) VALUES (72663, 16, 2021, 7, 67.2);
INSERT INTO public."Price" (id, "stonkId", year, month, price) VALUES (72413, 16, 2021, 1, 70.32);
INSERT INTO public."Price" (id, "stonkId", year, month, price) VALUES (72535, 16, 2021, 4, 64.38);
INSERT INTO public."Price" (id, "stonkId", year, month, price) VALUES (72707, 16, 2021, 8, 69.46);
INSERT INTO public."Price" (id, "stonkId", year, month, price) VALUES (72796, 16, 2021, 10, 68.64);
INSERT INTO public."Price" (id, "stonkId", year, month, price) VALUES (65861, 15, 2018, 9, 0.04085);
INSERT INTO public."Price" (id, "stonkId", year, month, price) VALUES (72838, 16, 2021, 11, 60.12);
INSERT INTO public."Price" (id, "stonkId", year, month, price) VALUES (278, 16, 2022, 2, 36.84);
INSERT INTO public."Price" (id, "stonkId", year, month, price) VALUES (73056, 16, 2022, 5, 28.22);
INSERT INTO public."Price" (id, "stonkId", year, month, price) VALUES (73090, 16, 2022, 6, 26.86);
INSERT INTO public."Price" (id, "stonkId", year, month, price) VALUES (73132, 16, 2022, 7, 27.72);
INSERT INTO public."Price" (id, "stonkId", year, month, price) VALUES (73172, 16, 2022, 8, 28.78);
INSERT INTO public."Price" (id, "stonkId", year, month, price) VALUES (73254, 16, 2022, 10, 25.64);
INSERT INTO public."Price" (id, "stonkId", year, month, price) VALUES (73294, 16, 2022, 11, 24.86);
INSERT INTO public."Price" (id, "stonkId", year, month, price) VALUES (73373, 16, 2023, 1, 27.86);
INSERT INTO public."Price" (id, "stonkId", year, month, price) VALUES (73411, 16, 2023, 2, 28.26);
INSERT INTO public."Price" (id, "stonkId", year, month, price) VALUES (73486, 16, 2023, 4, 39.97);
INSERT INTO public."Price" (id, "stonkId", year, month, price) VALUES (66113, 15, 2019, 3, 0.036015);
INSERT INTO public."Price" (id, "stonkId", year, month, price) VALUES (457, 17, 2024, 2, 288.1);
INSERT INTO public."Price" (id, "stonkId", year, month, price) VALUES (74137, 16, 2024, 8, 47.74);
INSERT INTO public."Price" (id, "stonkId", year, month, price) VALUES (75466, 17, 2015, 10, 209.15);
INSERT INTO public."Price" (id, "stonkId", year, month, price) VALUES (77269, 17, 2019, 7, 266.1);
INSERT INTO public."Price" (id, "stonkId", year, month, price) VALUES (77192, 17, 2019, 5, 256.15);
INSERT INTO public."Price" (id, "stonkId", year, month, price) VALUES (76276, 17, 2017, 6, 235.2);
INSERT INTO public."Price" (id, "stonkId", year, month, price) VALUES (78195, 17, 2021, 5, 337.85);
INSERT INTO public."Price" (id, "stonkId", year, month, price) VALUES (75213, 17, 2015, 4, 262.8);
INSERT INTO public."Price" (id, "stonkId", year, month, price) VALUES (77071, 17, 2019, 2, 252.65);
INSERT INTO public."Price" (id, "stonkId", year, month, price) VALUES (74015, 16, 2024, 5, 55.09);
INSERT INTO public."Price" (id, "stonkId", year, month, price) VALUES (75710, 17, 2016, 4, 255.5);
INSERT INTO public."Price" (id, "stonkId", year, month, price) VALUES (76713, 17, 2018, 5, 284.55);
INSERT INTO public."Price" (id, "stonkId", year, month, price) VALUES (75335, 17, 2015, 7, 222.25);
INSERT INTO public."Price" (id, "stonkId", year, month, price) VALUES (74898, 16, 2026, 3, 47.56);
INSERT INTO public."Price" (id, "stonkId", year, month, price) VALUES (77401, 17, 2019, 10, 286.05);
INSERT INTO public."Price" (id, "stonkId", year, month, price) VALUES (74712, 16, 2025, 10, 50.61);
INSERT INTO public."Price" (id, "stonkId", year, month, price) VALUES (74220, 16, 2024, 10, 53.89);
INSERT INTO public."Price" (id, "stonkId", year, month, price) VALUES (80157, 17, 2025, 4, 215.1);
INSERT INTO public."Price" (id, "stonkId", year, month, price) VALUES (74629, 16, 2025, 8, 62.2);
INSERT INTO public."Price" (id, "stonkId", year, month, price) VALUES (77816, 17, 2020, 8, 340);
INSERT INTO public."Price" (id, "stonkId", year, month, price) VALUES (76160, 17, 2017, 3, 276.4);
INSERT INTO public."Price" (id, "stonkId", year, month, price) VALUES (80967, 18, 2015, 5, 1.2665);
INSERT INTO public."Price" (id, "stonkId", year, month, price) VALUES (76441, 17, 2017, 10, 283);
INSERT INTO public."Price" (id, "stonkId", year, month, price) VALUES (75827, 17, 2016, 7, 251.75);
INSERT INTO public."Price" (id, "stonkId", year, month, price) VALUES (80074, 17, 2025, 2, 244.55);
INSERT INTO public."Price" (id, "stonkId", year, month, price) VALUES (74584, 16, 2025, 7, 56.89);
INSERT INTO public."Price" (id, "stonkId", year, month, price) VALUES (75627, 17, 2016, 2, 233.15);
INSERT INTO public."Price" (id, "stonkId", year, month, price) VALUES (80546, 17, 2026, 1, 227.05);
INSERT INTO public."Price" (id, "stonkId", year, month, price) VALUES (77315, 17, 2019, 8, 266.45);
INSERT INTO public."Price" (id, "stonkId", year, month, price) VALUES (682, 16, 2024, 6, 62.79);
INSERT INTO public."Price" (id, "stonkId", year, month, price) VALUES (76563, 17, 2018, 1, 306.8);
INSERT INTO public."Price" (id, "stonkId", year, month, price) VALUES (100, 17, 2014, 12, 171.7);
INSERT INTO public."Price" (id, "stonkId", year, month, price) VALUES (75869, 17, 2016, 8, 241.05);
INSERT INTO public."Price" (id, "stonkId", year, month, price) VALUES (80328, 17, 2025, 8, 219);
INSERT INTO public."Price" (id, "stonkId", year, month, price) VALUES (75257, 17, 2015, 5, 246.7);
INSERT INTO public."Price" (id, "stonkId", year, month, price) VALUES (74839, 16, 2026, 1, 57.48);
INSERT INTO public."Price" (id, "stonkId", year, month, price) VALUES (78923, 17, 2022, 11, 235.8);
INSERT INTO public."Price" (id, "stonkId", year, month, price) VALUES (76081, 17, 2017, 1, 275.2);
INSERT INTO public."Price" (id, "stonkId", year, month, price) VALUES (74387, 16, 2025, 2, 72.63);
INSERT INTO public."Price" (id, "stonkId", year, month, price) VALUES (78793, 17, 2022, 8, 237.4);
INSERT INTO public."Price" (id, "stonkId", year, month, price) VALUES (78368, 17, 2021, 9, 329.3);
INSERT INTO public."Price" (id, "stonkId", year, month, price) VALUES (78152, 17, 2021, 4, 320.9);
INSERT INTO public."Price" (id, "stonkId", year, month, price) VALUES (74757, 16, 2025, 11, 56.34);
INSERT INTO public."Price" (id, "stonkId", year, month, price) VALUES (76356, 17, 2017, 8, 264.05);
INSERT INTO public."Price" (id, "stonkId", year, month, price) VALUES (77231, 17, 2019, 6, 286.75);
INSERT INTO public."Price" (id, "stonkId", year, month, price) VALUES (75752, 17, 2016, 5, 256.7);
INSERT INTO public."Price" (id, "stonkId", year, month, price) VALUES (74466, 16, 2025, 4, 70.39);
INSERT INTO public."Price" (id, "stonkId", year, month, price) VALUES (75381, 17, 2015, 8, 229);
INSERT INTO public."Price" (id, "stonkId", year, month, price) VALUES (77858, 17, 2020, 9, 339.5);
INSERT INTO public."Price" (id, "stonkId", year, month, price) VALUES (76906, 17, 2018, 10, 258.4);
INSERT INTO public."Price" (id, "stonkId", year, month, price) VALUES (74263, 16, 2024, 11, 53.47);
INSERT INTO public."Price" (id, "stonkId", year, month, price) VALUES (75953, 17, 2016, 10, 220.05);
INSERT INTO public."Price" (id, "stonkId", year, month, price) VALUES (76949, 17, 2018, 11, 249.6);
INSERT INTO public."Price" (id, "stonkId", year, month, price) VALUES (74095, 16, 2024, 7, 54.22);
INSERT INTO public."Price" (id, "stonkId", year, month, price) VALUES (76750, 17, 2018, 6, 277.6);
INSERT INTO public."Price" (id, "stonkId", year, month, price) VALUES (75423, 17, 2015, 9, 214);
INSERT INTO public."Price" (id, "stonkId", year, month, price) VALUES (78673, 17, 2022, 5, 253.4);
INSERT INTO public."Price" (id, "stonkId", year, month, price) VALUES (75788, 17, 2016, 6, 244.2);
INSERT INTO public."Price" (id, "stonkId", year, month, price) VALUES (77149, 17, 2019, 4, 255.05);
INSERT INTO public."Price" (id, "stonkId", year, month, price) VALUES (76204, 17, 2017, 4, 276.35);
INSERT INTO public."Price" (id, "stonkId", year, month, price) VALUES (75171, 17, 2015, 3, 247.15);
INSERT INTO public."Price" (id, "stonkId", year, month, price) VALUES (73971, 16, 2024, 4, 51.58);
INSERT INTO public."Price" (id, "stonkId", year, month, price) VALUES (76600, 17, 2018, 2, 312.95);
INSERT INTO public."Price" (id, "stonkId", year, month, price) VALUES (76123, 17, 2017, 2, 274.85);
INSERT INTO public."Price" (id, "stonkId", year, month, price) VALUES (75293, 17, 2015, 6, 242.7);
INSERT INTO public."Price" (id, "stonkId", year, month, price) VALUES (77772, 17, 2020, 7, 326.95);
INSERT INTO public."Price" (id, "stonkId", year, month, price) VALUES (74510, 16, 2025, 5, 67.96);
INSERT INTO public."Price" (id, "stonkId", year, month, price) VALUES (75668, 17, 2016, 3, 238.5);
INSERT INTO public."Price" (id, "stonkId", year, month, price) VALUES (74869, 16, 2026, 2, 55.85);
INSERT INTO public."Price" (id, "stonkId", year, month, price) VALUES (74349, 16, 2025, 1, 64.53);
INSERT INTO public."Price" (id, "stonkId", year, month, price) VALUES (79902, 17, 2024, 10, 183.8);
INSERT INTO public."Price" (id, "stonkId", year, month, price) VALUES (77033, 17, 2019, 1, 261.85);
INSERT INTO public."Price" (id, "stonkId", year, month, price) VALUES (79769, 17, 2024, 7, 227.95);
INSERT INTO public."Price" (id, "stonkId", year, month, price) VALUES (76317, 17, 2017, 7, 235.7);
INSERT INTO public."Price" (id, "stonkId", year, month, price) VALUES (78881, 17, 2022, 10, 226.55);
INSERT INTO public."Price" (id, "stonkId", year, month, price) VALUES (76672, 17, 2018, 4, 294.95);
INSERT INTO public."Price" (id, "stonkId", year, month, price) VALUES (593, 17, 2021, 6, 341.65);
INSERT INTO public."Price" (id, "stonkId", year, month, price) VALUES (75912, 17, 2016, 9, 228.2);
INSERT INTO public."Price" (id, "stonkId", year, month, price) VALUES (75509, 17, 2015, 11, 216.35);
INSERT INTO public."Price" (id, "stonkId", year, month, price) VALUES (77109, 17, 2019, 3, 253.8);
INSERT INTO public."Price" (id, "stonkId", year, month, price) VALUES (76399, 17, 2017, 9, 279.55);
INSERT INTO public."Price" (id, "stonkId", year, month, price) VALUES (78455, 17, 2021, 11, 293.6);
INSERT INTO public."Price" (id, "stonkId", year, month, price) VALUES (76481, 17, 2017, 11, 279.8);
INSERT INTO public."Price" (id, "stonkId", year, month, price) VALUES (75591, 17, 2016, 1, 225.45);
INSERT INTO public."Price" (id, "stonkId", year, month, price) VALUES (75995, 17, 2016, 11, 229.95);
INSERT INTO public."Price" (id, "stonkId", year, month, price) VALUES (78413, 17, 2021, 10, 312.35);
INSERT INTO public."Price" (id, "stonkId", year, month, price) VALUES (77903, 17, 2020, 10, 311.1);
INSERT INTO public."Price" (id, "stonkId", year, month, price) VALUES (77447, 17, 2019, 11, 304.45);
INSERT INTO public."Price" (id, "stonkId", year, month, price) VALUES (76242, 17, 2017, 5, 241.95);
INSERT INTO public."Price" (id, "stonkId", year, month, price) VALUES (77947, 17, 2020, 11, 320.55);
INSERT INTO public."Price" (id, "stonkId", year, month, price) VALUES (77358, 17, 2019, 9, 266.3);
INSERT INTO public."Price" (id, "stonkId", year, month, price) VALUES (755, 17, 2025, 6, 237.9);
INSERT INTO public."Price" (id, "stonkId", year, month, price) VALUES (78069, 17, 2021, 2, 314.6);
INSERT INTO public."Price" (id, "stonkId", year, month, price) VALUES (76829, 17, 2018, 8, 261.05);
INSERT INTO public."Price" (id, "stonkId", year, month, price) VALUES (76789, 17, 2018, 7, 262.15);
INSERT INTO public."Price" (id, "stonkId", year, month, price) VALUES (76636, 17, 2018, 3, 296);
INSERT INTO public."Price" (id, "stonkId", year, month, price) VALUES (76868, 17, 2018, 9, 271.7);
INSERT INTO public."Price" (id, "stonkId", year, month, price) VALUES (103, 18, 2014, 9, 0.008838);
INSERT INTO public."Price" (id, "stonkId", year, month, price) VALUES (78752, 17, 2022, 7, 243.4);
INSERT INTO public."Price" (id, "stonkId", year, month, price) VALUES (791, 17, 2025, 12, 213.75);
INSERT INTO public."Price" (id, "stonkId", year, month, price) VALUES (78324, 17, 2021, 8, 329.25);
INSERT INTO public."Price" (id, "stonkId", year, month, price) VALUES (79642, 17, 2024, 4, 311);
INSERT INTO public."Price" (id, "stonkId", year, month, price) VALUES (78107, 17, 2021, 3, 315.95);
INSERT INTO public."Price" (id, "stonkId", year, month, price) VALUES (79008, 17, 2023, 1, 247);
INSERT INTO public."Price" (id, "stonkId", year, month, price) VALUES (78280, 17, 2021, 7, 316);
INSERT INTO public."Price" (id, "stonkId", year, month, price) VALUES (79050, 17, 2023, 2, 257.6);
INSERT INTO public."Price" (id, "stonkId", year, month, price) VALUES (78031, 17, 2021, 1, 330.95);
INSERT INTO public."Price" (id, "stonkId", year, month, price) VALUES (78709, 17, 2022, 6, 272.15);
INSERT INTO public."Price" (id, "stonkId", year, month, price) VALUES (80034, 17, 2025, 1, 230.75);
INSERT INTO public."Price" (id, "stonkId", year, month, price) VALUES (79133, 17, 2023, 4, 272.1);
INSERT INTO public."Price" (id, "stonkId", year, month, price) VALUES (107, 18, 2015, 1, 0.7169);
INSERT INTO public."Price" (id, "stonkId", year, month, price) VALUES (81133, 18, 2015, 9, 1.065);
INSERT INTO public."Price" (id, "stonkId", year, month, price) VALUES (79688, 17, 2024, 5, 288.7);
INSERT INTO public."Price" (id, "stonkId", year, month, price) VALUES (79173, 17, 2023, 5, 315.8);
INSERT INTO public."Price" (id, "stonkId", year, month, price) VALUES (80622, 17, 2026, 3, 224.45);
INSERT INTO public."Price" (id, "stonkId", year, month, price) VALUES (79815, 17, 2024, 8, 192.6);
INSERT INTO public."Price" (id, "stonkId", year, month, price) VALUES (80415, 17, 2025, 10, 202.85);
INSERT INTO public."Price" (id, "stonkId", year, month, price) VALUES (80201, 17, 2025, 5, 216.15);
INSERT INTO public."Price" (id, "stonkId", year, month, price) VALUES (79947, 17, 2024, 11, 179.5);
INSERT INTO public."Price" (id, "stonkId", year, month, price) VALUES (108, 18, 2015, 2, 0.9215);
INSERT INTO public."Price" (id, "stonkId", year, month, price) VALUES (104, 18, 2014, 10, 0.009558);
INSERT INTO public."Price" (id, "stonkId", year, month, price) VALUES (80282, 17, 2025, 7, 208.3);
INSERT INTO public."Price" (id, "stonkId", year, month, price) VALUES (80584, 17, 2026, 2, 231.75);
INSERT INTO public."Price" (id, "stonkId", year, month, price) VALUES (80461, 17, 2025, 11, 210.7);
INSERT INTO public."Price" (id, "stonkId", year, month, price) VALUES (105, 18, 2014, 11, 0.009012);
INSERT INTO public."Price" (id, "stonkId", year, month, price) VALUES (80923, 18, 2015, 4, 1.1952);
INSERT INTO public."Price" (id, "stonkId", year, month, price) VALUES (80881, 18, 2015, 3, 1.0798);
INSERT INTO public."Price" (id, "stonkId", year, month, price) VALUES (106, 18, 2014, 12, 0.006951);
INSERT INTO public."Price" (id, "stonkId", year, month, price) VALUES (81045, 18, 2015, 7, 1.131);
INSERT INTO public."Price" (id, "stonkId", year, month, price) VALUES (81003, 18, 2015, 6, 1.2205);
INSERT INTO public."Price" (id, "stonkId", year, month, price) VALUES (81091, 18, 2015, 8, 1.1255);
INSERT INTO public."Price" (id, "stonkId", year, month, price) VALUES (81176, 18, 2015, 10, 1.2125);
INSERT INTO public."Price" (id, "stonkId", year, month, price) VALUES (73522, 16, 2023, 5, 39.82);
INSERT INTO public."Price" (id, "stonkId", year, month, price) VALUES (81220, 18, 2015, 11, 1.159);
INSERT INTO public."Price" (id, "stonkId", year, month, price) VALUES (81304, 18, 2016, 1, 1.345);
INSERT INTO public."Price" (id, "stonkId", year, month, price) VALUES (81340, 18, 2016, 2, 1.5825);
INSERT INTO public."Price" (id, "stonkId", year, month, price) VALUES (81382, 18, 2016, 3, 1.825);
INSERT INTO public."Price" (id, "stonkId", year, month, price) VALUES (81426, 18, 2016, 4, 1.821);
INSERT INTO public."Price" (id, "stonkId", year, month, price) VALUES (81468, 18, 2016, 5, 1.9485);
INSERT INTO public."Price" (id, "stonkId", year, month, price) VALUES (81506, 18, 2016, 6, 2.494);
INSERT INTO public."Price" (id, "stonkId", year, month, price) VALUES (81548, 18, 2016, 7, 2.612);
INSERT INTO public."Price" (id, "stonkId", year, month, price) VALUES (81590, 18, 2016, 8, 2.8175);
INSERT INTO public."Price" (id, "stonkId", year, month, price) VALUES (81636, 18, 2016, 9, 3.169);
INSERT INTO public."Price" (id, "stonkId", year, month, price) VALUES (444, 16, 2023, 11, 36.39);
INSERT INTO public."Price" (id, "stonkId", year, month, price) VALUES (540, 18, 2018, 12, 3.891);
INSERT INTO public."Price" (id, "stonkId", year, month, price) VALUES (612, 18, 2021, 12, 4.245);
INSERT INTO public."Price" (id, "stonkId", year, month, price) VALUES (82860, 18, 2019, 2, 3.908);
INSERT INTO public."Price" (id, "stonkId", year, month, price) VALUES (211, 18, 2020, 1, 5.912);
INSERT INTO public."Price" (id, "stonkId", year, month, price) VALUES (85616, 18, 2024, 8, 3.7175);
INSERT INTO public."Price" (id, "stonkId", year, month, price) VALUES (720, 18, 2024, 12, 3.7185);
INSERT INTO public."Price" (id, "stonkId", year, month, price) VALUES (84679, 18, 2022, 10, 3.071);
INSERT INTO public."Price" (id, "stonkId", year, month, price) VALUES (83611, 18, 2020, 8, 5.2135);
INSERT INTO public."Price" (id, "stonkId", year, month, price) VALUES (83741, 18, 2020, 11, 5.151);
INSERT INTO public."Price" (id, "stonkId", year, month, price) VALUES (84506, 18, 2022, 6, 3.4035);
INSERT INTO public."Price" (id, "stonkId", year, month, price) VALUES (84122, 18, 2021, 8, 4.6295);
INSERT INTO public."Price" (id, "stonkId", year, month, price) VALUES (288, 18, 2022, 4, 2.6645);
INSERT INTO public."Price" (id, "stonkId", year, month, price) VALUES (460, 18, 2023, 7, 4.1585);
INSERT INTO public."Price" (id, "stonkId", year, month, price) VALUES (82185, 18, 2017, 10, 3.5965);
INSERT INTO public."Price" (id, "stonkId", year, month, price) VALUES (81723, 18, 2016, 11, 3.809);
INSERT INTO public."Price" (id, "stonkId", year, month, price) VALUES (83064, 18, 2019, 7, 4.4985);
INSERT INTO public."Price" (id, "stonkId", year, month, price) VALUES (85876, 18, 2025, 2, 3.77);
INSERT INTO public."Price" (id, "stonkId", year, month, price) VALUES (84253, 18, 2021, 11, 4.306);
INSERT INTO public."Price" (id, "stonkId", year, month, price) VALUES (84808, 18, 2023, 1, 3.4805);
INSERT INTO public."Price" (id, "stonkId", year, month, price) VALUES (464, 18, 2023, 11, 4.1335);
INSERT INTO public."Price" (id, "stonkId", year, month, price) VALUES (215, 18, 2020, 5, 4.935);
INSERT INTO public."Price" (id, "stonkId", year, month, price) VALUES (16572, 4, 2017, 9, 658.7);
INSERT INTO public."Price" (id, "stonkId", year, month, price) VALUES (83026, 18, 2019, 6, 4.547);
INSERT INTO public."Price" (id, "stonkId", year, month, price) VALUES (85749, 18, 2024, 11, 3.8095);
INSERT INTO public."Price" (id, "stonkId", year, month, price) VALUES (86262, 18, 2025, 11, 2.8675);
INSERT INTO public."Price" (id, "stonkId", year, month, price) VALUES (85570, 18, 2024, 7, 3.8265);
INSERT INTO public."Price" (id, "stonkId", year, month, price) VALUES (83826, 18, 2021, 1, 5.3015);
INSERT INTO public."Price" (id, "stonkId", year, month, price) VALUES (82477, 18, 2018, 5, 4.027);
INSERT INTO public."Price" (id, "stonkId", year, month, price) VALUES (666, 18, 2023, 3, 3.7015);
INSERT INTO public."Price" (id, "stonkId", year, month, price) VALUES (81933, 18, 2017, 4, 4.0255);
INSERT INTO public."Price" (id, "stonkId", year, month, price) VALUES (83949, 18, 2021, 4, 4.94);
INSERT INTO public."Price" (id, "stonkId", year, month, price) VALUES (82940, 18, 2019, 4, 3.938);
INSERT INTO public."Price" (id, "stonkId", year, month, price) VALUES (85443, 18, 2024, 4, 4.2855);
INSERT INTO public."Price" (id, "stonkId", year, month, price) VALUES (84078, 18, 2021, 7, 4.3725);
INSERT INTO public."Price" (id, "stonkId", year, month, price) VALUES (463, 18, 2023, 10, 4.275);
INSERT INTO public."Price" (id, "stonkId", year, month, price) VALUES (84470, 18, 2022, 5, 3.1875);
INSERT INTO public."Price" (id, "stonkId", year, month, price) VALUES (84589, 18, 2022, 8, 3.18);
INSERT INTO public."Price" (id, "stonkId", year, month, price) VALUES (82736, 18, 2018, 11, 4.0365);
INSERT INTO public."Price" (id, "stonkId", year, month, price) VALUES (684, 18, 2024, 6, 3.9265);
INSERT INTO public."Price" (id, "stonkId", year, month, price) VALUES (84973, 18, 2023, 5, 4.074);
INSERT INTO public."Price" (id, "stonkId", year, month, price) VALUES (648, 18, 2022, 12, 3.394);
INSERT INTO public."Price" (id, "stonkId", year, month, price) VALUES (86084, 18, 2025, 7, 3.0875);
INSERT INTO public."Price" (id, "stonkId", year, month, price) VALUES (285, 18, 2022, 1, 3.886);
INSERT INTO public."Price" (id, "stonkId", year, month, price) VALUES (84211, 18, 2021, 10, 4.7735);
INSERT INTO public."Price" (id, "stonkId", year, month, price) VALUES (83196, 18, 2019, 10, 4.395);
INSERT INTO public."Price" (id, "stonkId", year, month, price) VALUES (83567, 18, 2020, 7, 5.8075);
INSERT INTO public."Price" (id, "stonkId", year, month, price) VALUES (82353, 18, 2018, 2, 3.705);
INSERT INTO public."Price" (id, "stonkId", year, month, price) VALUES (82605, 18, 2018, 8, 3.998);
INSERT INTO public."Price" (id, "stonkId", year, month, price) VALUES (466, 18, 2024, 1, 4.0905);
INSERT INTO public."Price" (id, "stonkId", year, month, price) VALUES (83904, 18, 2021, 3, 5.099);
INSERT INTO public."Price" (id, "stonkId", year, month, price) VALUES (83154, 18, 2019, 9, 4.468);
INSERT INTO public."Price" (id, "stonkId", year, month, price) VALUES (594, 18, 2021, 6, 4.7015);
INSERT INTO public."Price" (id, "stonkId", year, month, price) VALUES (85959, 18, 2025, 4, 3.536);
INSERT INTO public."Price" (id, "stonkId", year, month, price) VALUES (756, 18, 2025, 6, 3.239);
INSERT INTO public."Price" (id, "stonkId", year, month, price) VALUES (82820, 18, 2019, 1, 3.841);
INSERT INTO public."Price" (id, "stonkId", year, month, price) VALUES (83697, 18, 2020, 10, 5.0875);
INSERT INTO public."Price" (id, "stonkId", year, month, price) VALUES (287, 18, 2022, 3, 2.6015);
INSERT INTO public."Price" (id, "stonkId", year, month, price) VALUES (468, 18, 2024, 3, 4.0675);
INSERT INTO public."Price" (id, "stonkId", year, month, price) VALUES (558, 18, 2019, 12, 5.0325);
INSERT INTO public."Price" (id, "stonkId", year, month, price) VALUES (82013, 18, 2017, 6, 3.843);
INSERT INTO public."Price" (id, "stonkId", year, month, price) VALUES (84549, 18, 2022, 7, 3.2345);
INSERT INTO public."Price" (id, "stonkId", year, month, price) VALUES (85836, 18, 2025, 1, 3.712);
INSERT INTO public."Price" (id, "stonkId", year, month, price) VALUES (84850, 18, 2023, 2, 3.431);
INSERT INTO public."Price" (id, "stonkId", year, month, price) VALUES (462, 18, 2023, 9, 4.2935);
INSERT INTO public."Price" (id, "stonkId", year, month, price) VALUES (522, 18, 2017, 12, 3.3555);
INSERT INTO public."Price" (id, "stonkId", year, month, price) VALUES (82900, 18, 2019, 3, 3.7585);
INSERT INTO public."Price" (id, "stonkId", year, month, price) VALUES (83864, 18, 2021, 2, 5.1135);
INSERT INTO public."Price" (id, "stonkId", year, month, price) VALUES (85703, 18, 2024, 10, 3.792);
INSERT INTO public."Price" (id, "stonkId", year, month, price) VALUES (86347, 18, 2026, 1, 3.5255);
INSERT INTO public."Price" (id, "stonkId", year, month, price) VALUES (216, 18, 2020, 6, 4.8605);
INSERT INTO public."Price" (id, "stonkId", year, month, price) VALUES (702, 18, 2024, 9, 3.8165);
INSERT INTO public."Price" (id, "stonkId", year, month, price) VALUES (286, 18, 2022, 2, 2.3705);
INSERT INTO public."Price" (id, "stonkId", year, month, price) VALUES (84721, 18, 2022, 11, 3.285);
INSERT INTO public."Price" (id, "stonkId", year, month, price) VALUES (33938, 8, 2016, 3, 8789);
INSERT INTO public."Price" (id, "stonkId", year, month, price) VALUES (83993, 18, 2021, 5, 5.052);
INSERT INTO public."Price" (id, "stonkId", year, month, price) VALUES (42960, 10, 2019, 2, 158.02);
INSERT INTO public."Price" (id, "stonkId", year, month, price) VALUES (43915, 10, 2021, 1, 211.78);
INSERT INTO public."Price" (id, "stonkId", year, month, price) VALUES (86216, 18, 2025, 10, 2.745);
INSERT INTO public."Price" (id, "stonkId", year, month, price) VALUES (738, 18, 2025, 3, 3.622);
INSERT INTO public."Price" (id, "stonkId", year, month, price) VALUES (84933, 18, 2023, 4, 4.0495);
INSERT INTO public."Price" (id, "stonkId", year, month, price) VALUES (465, 18, 2023, 12, 3.9525);
INSERT INTO public."Price" (id, "stonkId", year, month, price) VALUES (774, 18, 2025, 9, 3.015);
INSERT INTO public."Price" (id, "stonkId", year, month, price) VALUES (82143, 18, 2017, 9, 3.725);
INSERT INTO public."Price" (id, "stonkId", year, month, price) VALUES (461, 18, 2023, 8, 4.1805);
INSERT INTO public."Price" (id, "stonkId", year, month, price) VALUES (86423, 18, 2026, 3, 3.188);
INSERT INTO public."Price" (id, "stonkId", year, month, price) VALUES (467, 18, 2024, 2, 4.053);
INSERT INTO public."Price" (id, "stonkId", year, month, price) VALUES (83653, 18, 2020, 9, 5.647);
INSERT INTO public."Price" (id, "stonkId", year, month, price) VALUES (82561, 18, 2018, 7, 4.1185);
INSERT INTO public."Price" (id, "stonkId", year, month, price) VALUES (81680, 18, 2016, 10, 3.3755);
INSERT INTO public."Price" (id, "stonkId", year, month, price) VALUES (81809, 18, 2017, 1, 4.0785);
INSERT INTO public."Price" (id, "stonkId", year, month, price) VALUES (810, 18, 2026, 4, 3.1865);
INSERT INTO public."Price" (id, "stonkId", year, month, price) VALUES (86003, 18, 2025, 5, 3.5415);
INSERT INTO public."Price" (id, "stonkId", year, month, price) VALUES (64578, 15, 2016, 3, 0.07604);
INSERT INTO public."Price" (id, "stonkId", year, month, price) VALUES (86385, 18, 2026, 2, 3.2755);
INSERT INTO public."Price" (id, "stonkId", year, month, price) VALUES (214, 18, 2020, 4, 5.03);
INSERT INTO public."Price" (id, "stonkId", year, month, price) VALUES (82433, 18, 2018, 4, 4.0015);
INSERT INTO public."Price" (id, "stonkId", year, month, price) VALUES (576, 18, 2020, 12, 5.3165);
INSERT INTO public."Price" (id, "stonkId", year, month, price) VALUES (82690, 18, 2018, 10, 3.9495);
INSERT INTO public."Price" (id, "stonkId", year, month, price) VALUES (83242, 18, 2019, 11, 4.4275);
INSERT INTO public."Price" (id, "stonkId", year, month, price) VALUES (86130, 18, 2025, 8, 3.162);
INSERT INTO public."Price" (id, "stonkId", year, month, price) VALUES (81889, 18, 2017, 3, 4.054);
INSERT INTO public."Price" (id, "stonkId", year, month, price) VALUES (82519, 18, 2018, 6, 4.0695);
INSERT INTO public."Price" (id, "stonkId", year, month, price) VALUES (81973, 18, 2017, 5, 3.952);
INSERT INTO public."Price" (id, "stonkId", year, month, price) VALUES (82097, 18, 2017, 8, 3.8885);
INSERT INTO public."Price" (id, "stonkId", year, month, price) VALUES (83110, 18, 2019, 8, 4.322);
INSERT INTO public."Price" (id, "stonkId", year, month, price) VALUES (281, 17, 2022, 1, 289.2);
INSERT INTO public."Price" (id, "stonkId", year, month, price) VALUES (82229, 18, 2017, 11, 3.66);
INSERT INTO public."Price" (id, "stonkId", year, month, price) VALUES (82391, 18, 2018, 3, 3.811);
INSERT INTO public."Price" (id, "stonkId", year, month, price) VALUES (57916, 13, 2025, 5, 3794);
INSERT INTO public."Price" (id, "stonkId", year, month, price) VALUES (81851, 18, 2017, 2, 3.728);
INSERT INTO public."Price" (id, "stonkId", year, month, price) VALUES (82055, 18, 2017, 7, 3.7675);
INSERT INTO public."Price" (id, "stonkId", year, month, price) VALUES (82984, 18, 2019, 5, 3.987);
INSERT INTO public."Price" (id, "stonkId", year, month, price) VALUES (82313, 18, 2018, 1, 3.798);
INSERT INTO public."Price" (id, "stonkId", year, month, price) VALUES (504, 18, 2016, 12, 3.799);
INSERT INTO public."Price" (id, "stonkId", year, month, price) VALUES (82650, 18, 2018, 9, 4.0825);
INSERT INTO public."Price" (id, "stonkId", year, month, price) VALUES (85489, 18, 2024, 5, 4.101);
INSERT INTO public."Price" (id, "stonkId", year, month, price) VALUES (84166, 18, 2021, 9, 4.6425);


--
-- Data for Name: Room; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO public."Room" (id, code, "scenarioId", status, "createdAt", "currentStepIndex", "hostUsername", "readyJson") VALUES (1, '4JPFRZ', '2022_feb', 'waiting', '2026-04-02 07:36:16.852', 0, '', '[]');
INSERT INTO public."Room" (id, code, "scenarioId", status, "createdAt", "currentStepIndex", "hostUsername", "readyJson") VALUES (2, 'AF293Y', '2020_covid', 'waiting', '2026-04-02 10:41:02.286', 0, '', '[]');
INSERT INTO public."Room" (id, code, "scenarioId", status, "createdAt", "currentStepIndex", "hostUsername", "readyJson") VALUES (3, 'ELCKR4', '2023_rate', 'waiting', '2026-04-02 10:52:34.356', 0, '', '[]');
INSERT INTO public."Room" (id, code, "scenarioId", status, "createdAt", "currentStepIndex", "hostUsername", "readyJson") VALUES (4, '5M9AFD', '2020_covid', 'active', '2026-04-02 11:43:43.316', 0, '', '[]');
INSERT INTO public."Room" (id, code, "scenarioId", status, "createdAt", "currentStepIndex", "hostUsername", "readyJson") VALUES (11, 'S7DTPA', '2020_covid', 'active', '2026-04-02 12:36:25.465', 12, '123', '[]');
INSERT INTO public."Room" (id, code, "scenarioId", status, "createdAt", "currentStepIndex", "hostUsername", "readyJson") VALUES (12, 'RA4SQ4', '2020_covid', 'waiting', '2026-04-02 12:38:10.286', 0, '123', '[]');
INSERT INTO public."Room" (id, code, "scenarioId", status, "createdAt", "currentStepIndex", "hostUsername", "readyJson") VALUES (13, 'M6ZN5Z', '2020_covid', 'waiting', '2026-04-02 12:38:31.563', 0, '123', '[]');
INSERT INTO public."Room" (id, code, "scenarioId", status, "createdAt", "currentStepIndex", "hostUsername", "readyJson") VALUES (5, 'PP729T', '2020_covid', 'active', '2026-04-02 12:00:22.864', 4, 'Wooler', '[]');
INSERT INTO public."Room" (id, code, "scenarioId", status, "createdAt", "currentStepIndex", "hostUsername", "readyJson") VALUES (6, 'DWNGZJ', '2020_covid', 'finished', '2026-04-02 12:09:46.239', 1, '321', '[]');
INSERT INTO public."Room" (id, code, "scenarioId", status, "createdAt", "currentStepIndex", "hostUsername", "readyJson") VALUES (7, 'LJ9P9P', '2020_covid', 'active', '2026-04-02 12:13:36.166', 2, '123', '[]');
INSERT INTO public."Room" (id, code, "scenarioId", status, "createdAt", "currentStepIndex", "hostUsername", "readyJson") VALUES (14, 'W5E4V8', '2023_rate', 'finished', '2026-04-02 12:56:57.391', 6, 'пр', '[]');
INSERT INTO public."Room" (id, code, "scenarioId", status, "createdAt", "currentStepIndex", "hostUsername", "readyJson") VALUES (15, 'VWT9JD', '2014_ruble', 'waiting', '2026-04-02 13:43:11.028', 0, 'ап', '[]');
INSERT INTO public."Room" (id, code, "scenarioId", status, "createdAt", "currentStepIndex", "hostUsername", "readyJson") VALUES (16, 'K5K4SY', '2020_covid', 'active', '2026-04-02 14:14:22.384', 0, '123', '[]');
INSERT INTO public."Room" (id, code, "scenarioId", status, "createdAt", "currentStepIndex", "hostUsername", "readyJson") VALUES (8, 'Y2GJ44', '2020_covid', 'finished', '2026-04-02 12:18:01.083', 5, '321', '[]');
INSERT INTO public."Room" (id, code, "scenarioId", status, "createdAt", "currentStepIndex", "hostUsername", "readyJson") VALUES (9, 'HWKYFR', '2020_covid', 'waiting', '2026-04-02 12:21:51.75', 0, '321', '[]');
INSERT INTO public."Room" (id, code, "scenarioId", status, "createdAt", "currentStepIndex", "hostUsername", "readyJson") VALUES (10, '7DC2K6', '2020_covid', 'waiting', '2026-04-02 12:32:24.251', 0, '123323', '[]');


--
-- Data for Name: Scenario; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO public."Scenario" (id, name, description, emoji, color, "parserKey", "periodLabel") VALUES ('2014_ruble', 'Крах рубля 2014', 'Рубль −50%, санкции, обвал нефти. Чёрный вторник 16 декабря.', '📉', '#ffc266', '2014_ruble', 'Сен 2014 — Фев 2015');
INSERT INTO public."Scenario" (id, name, description, emoji, color, "parserKey", "periodLabel") VALUES ('2020_covid', 'COVID-19 пандемия', 'IMOEX −35% за месяц, нефть в минус, V-образное восстановление.', '🦠', '#35d9ff', '2020_covid', 'Янв 2020 — Июн 2020');
INSERT INTO public."Scenario" (id, name, description, emoji, color, "parserKey", "periodLabel") VALUES ('2022_feb', 'Февраль 2022', 'IMOEX −45% за день. Биржа закрыта 28.02–24.03. Беспрецедентные санкции.', '⚔️', '#ff4fd8', '2022_feb', 'Янв 2022 — Апр 2022');
INSERT INTO public."Scenario" (id, name, description, emoji, color, "parserKey", "periodLabel") VALUES ('2023_rate', 'Рост ключевой ставки', 'ЦБ с 7.5% до 21%. Давление на акции роста, переток в облигации и депозиты.', '📊', '#31ff8c', '2023_rate', 'Июн 2023 — Мар 2024');


--
-- Data for Name: ScenarioStep; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO public."ScenarioStep" (id, "scenarioId", "stepIndex", year, month, label, "eventName", "eventDescription", "eventColor") VALUES (1, '2014_ruble', 0, 2014, 9, 'Сен 2014', NULL, NULL, NULL);
INSERT INTO public."ScenarioStep" (id, "scenarioId", "stepIndex", year, month, label, "eventName", "eventDescription", "eventColor") VALUES (2, '2014_ruble', 1, 2014, 10, 'Окт 2014', NULL, NULL, NULL);
INSERT INTO public."ScenarioStep" (id, "scenarioId", "stepIndex", year, month, label, "eventName", "eventDescription", "eventColor") VALUES (3, '2014_ruble', 2, 2014, 11, 'Ноя 2014', NULL, NULL, NULL);
INSERT INTO public."ScenarioStep" (id, "scenarioId", "stepIndex", year, month, label, "eventName", "eventDescription", "eventColor") VALUES (4, '2014_ruble', 3, 2014, 12, 'Дек 2014', '💥 ЧЁРНЫЙ ВТОРНИК', '16 декабря. Рубль рухнул до 80/$ за ночь. ЦБ экстренно поднял ставку до 17%. Паника на рынках.', '#ff7887');
INSERT INTO public."ScenarioStep" (id, "scenarioId", "stepIndex", year, month, label, "eventName", "eventDescription", "eventColor") VALUES (5, '2014_ruble', 4, 2015, 1, 'Янв 2015', NULL, NULL, NULL);
INSERT INTO public."ScenarioStep" (id, "scenarioId", "stepIndex", year, month, label, "eventName", "eventDescription", "eventColor") VALUES (6, '2014_ruble', 5, 2015, 2, 'Фев 2015', NULL, NULL, NULL);
INSERT INTO public."ScenarioStep" (id, "scenarioId", "stepIndex", year, month, label, "eventName", "eventDescription", "eventColor") VALUES (7, '2020_covid', 0, 2020, 1, 'Янв 2020', NULL, NULL, NULL);
INSERT INTO public."ScenarioStep" (id, "scenarioId", "stepIndex", year, month, label, "eventName", "eventDescription", "eventColor") VALUES (8, '2020_covid', 1, 2020, 2, 'Фев 2020', NULL, NULL, NULL);
INSERT INTO public."ScenarioStep" (id, "scenarioId", "stepIndex", year, month, label, "eventName", "eventDescription", "eventColor") VALUES (9, '2020_covid', 2, 2020, 3, 'Мар 2020', '🦠 ПАНДЕМИЯ И ЦЕНОВАЯ ВОЙНА', 'ВОЗ объявила пандемию. Россия и Саудовская Аравия разорвали сделку ОПЕК+. Нефть рухнула на 30% за день.', '#35d9ff');
INSERT INTO public."ScenarioStep" (id, "scenarioId", "stepIndex", year, month, label, "eventName", "eventDescription", "eventColor") VALUES (10, '2020_covid', 3, 2020, 4, 'Апр 2020', NULL, NULL, NULL);
INSERT INTO public."ScenarioStep" (id, "scenarioId", "stepIndex", year, month, label, "eventName", "eventDescription", "eventColor") VALUES (11, '2020_covid', 4, 2020, 5, 'Май 2020', NULL, NULL, NULL);
INSERT INTO public."ScenarioStep" (id, "scenarioId", "stepIndex", year, month, label, "eventName", "eventDescription", "eventColor") VALUES (12, '2020_covid', 5, 2020, 6, 'Июн 2020', NULL, NULL, NULL);
INSERT INTO public."ScenarioStep" (id, "scenarioId", "stepIndex", year, month, label, "eventName", "eventDescription", "eventColor") VALUES (13, '2022_feb', 0, 2022, 1, 'Янв 2022', NULL, NULL, NULL);
INSERT INTO public."ScenarioStep" (id, "scenarioId", "stepIndex", year, month, label, "eventName", "eventDescription", "eventColor") VALUES (14, '2022_feb', 1, 2022, 2, 'Фев 2022', '⚔️ 24 ФЕВРАЛЯ 2022', 'Россия начала СВО. MOEX рухнул на 45.3% — исторический антирекорд. SWIFT. ЦБ: ставка 20%.', '#ff4fd8');
INSERT INTO public."ScenarioStep" (id, "scenarioId", "stepIndex", year, month, label, "eventName", "eventDescription", "eventColor") VALUES (15, '2022_feb', 2, 2022, 3, 'Мар 2022', NULL, NULL, NULL);
INSERT INTO public."ScenarioStep" (id, "scenarioId", "stepIndex", year, month, label, "eventName", "eventDescription", "eventColor") VALUES (16, '2022_feb', 3, 2022, 4, 'Апр 2022', NULL, NULL, NULL);
INSERT INTO public."ScenarioStep" (id, "scenarioId", "stepIndex", year, month, label, "eventName", "eventDescription", "eventColor") VALUES (17, '2023_rate', 0, 2023, 6, 'Июн 2023', NULL, NULL, NULL);
INSERT INTO public."ScenarioStep" (id, "scenarioId", "stepIndex", year, month, label, "eventName", "eventDescription", "eventColor") VALUES (18, '2023_rate', 1, 2023, 7, 'Июл 2023', NULL, NULL, NULL);
INSERT INTO public."ScenarioStep" (id, "scenarioId", "stepIndex", year, month, label, "eventName", "eventDescription", "eventColor") VALUES (19, '2023_rate', 2, 2023, 8, 'Авг 2023', NULL, NULL, NULL);
INSERT INTO public."ScenarioStep" (id, "scenarioId", "stepIndex", year, month, label, "eventName", "eventDescription", "eventColor") VALUES (20, '2023_rate', 3, 2023, 9, 'Сен 2023', NULL, NULL, NULL);
INSERT INTO public."ScenarioStep" (id, "scenarioId", "stepIndex", year, month, label, "eventName", "eventDescription", "eventColor") VALUES (21, '2023_rate', 4, 2023, 10, 'Окт 2023', NULL, NULL, NULL);
INSERT INTO public."ScenarioStep" (id, "scenarioId", "stepIndex", year, month, label, "eventName", "eventDescription", "eventColor") VALUES (22, '2023_rate', 5, 2023, 11, 'Ноя 2023', NULL, NULL, NULL);
INSERT INTO public."ScenarioStep" (id, "scenarioId", "stepIndex", year, month, label, "eventName", "eventDescription", "eventColor") VALUES (23, '2023_rate', 6, 2023, 12, 'Дек 2023', NULL, NULL, NULL);
INSERT INTO public."ScenarioStep" (id, "scenarioId", "stepIndex", year, month, label, "eventName", "eventDescription", "eventColor") VALUES (24, '2023_rate', 7, 2024, 1, 'Янв 2024', NULL, NULL, NULL);
INSERT INTO public."ScenarioStep" (id, "scenarioId", "stepIndex", year, month, label, "eventName", "eventDescription", "eventColor") VALUES (25, '2023_rate', 8, 2024, 2, 'Фев 2024', NULL, NULL, NULL);
INSERT INTO public."ScenarioStep" (id, "scenarioId", "stepIndex", year, month, label, "eventName", "eventDescription", "eventColor") VALUES (26, '2023_rate', 9, 2024, 3, 'Мар 2024', NULL, NULL, NULL);
INSERT INTO public."ScenarioStep" (id, "scenarioId", "stepIndex", year, month, label, "eventName", "eventDescription", "eventColor") VALUES (27, '2014_ruble', 6, 2015, 3, 'Мар 2015', NULL, NULL, NULL);
INSERT INTO public."ScenarioStep" (id, "scenarioId", "stepIndex", year, month, label, "eventName", "eventDescription", "eventColor") VALUES (28, '2014_ruble', 7, 2015, 4, 'Апр 2015', NULL, NULL, NULL);
INSERT INTO public."ScenarioStep" (id, "scenarioId", "stepIndex", year, month, label, "eventName", "eventDescription", "eventColor") VALUES (29, '2014_ruble', 8, 2015, 5, 'Май 2015', NULL, NULL, NULL);
INSERT INTO public."ScenarioStep" (id, "scenarioId", "stepIndex", year, month, label, "eventName", "eventDescription", "eventColor") VALUES (30, '2014_ruble', 9, 2015, 6, 'Июн 2015', NULL, NULL, NULL);
INSERT INTO public."ScenarioStep" (id, "scenarioId", "stepIndex", year, month, label, "eventName", "eventDescription", "eventColor") VALUES (31, '2014_ruble', 10, 2015, 7, 'Июл 2015', NULL, NULL, NULL);
INSERT INTO public."ScenarioStep" (id, "scenarioId", "stepIndex", year, month, label, "eventName", "eventDescription", "eventColor") VALUES (32, '2014_ruble', 11, 2015, 8, 'Авг 2015', NULL, NULL, NULL);
INSERT INTO public."ScenarioStep" (id, "scenarioId", "stepIndex", year, month, label, "eventName", "eventDescription", "eventColor") VALUES (33, '2014_ruble', 12, 2015, 9, 'Сен 2015', NULL, NULL, NULL);
INSERT INTO public."ScenarioStep" (id, "scenarioId", "stepIndex", year, month, label, "eventName", "eventDescription", "eventColor") VALUES (34, '2014_ruble', 13, 2015, 10, 'Окт 2015', NULL, NULL, NULL);
INSERT INTO public."ScenarioStep" (id, "scenarioId", "stepIndex", year, month, label, "eventName", "eventDescription", "eventColor") VALUES (35, '2014_ruble', 14, 2015, 11, 'Ноя 2015', NULL, NULL, NULL);
INSERT INTO public."ScenarioStep" (id, "scenarioId", "stepIndex", year, month, label, "eventName", "eventDescription", "eventColor") VALUES (36, '2014_ruble', 15, 2015, 12, 'Дек 2015', NULL, NULL, NULL);
INSERT INTO public."ScenarioStep" (id, "scenarioId", "stepIndex", year, month, label, "eventName", "eventDescription", "eventColor") VALUES (37, '2014_ruble', 16, 2016, 1, 'Янв 2016', NULL, NULL, NULL);
INSERT INTO public."ScenarioStep" (id, "scenarioId", "stepIndex", year, month, label, "eventName", "eventDescription", "eventColor") VALUES (38, '2014_ruble', 17, 2016, 2, 'Фев 2016', NULL, NULL, NULL);
INSERT INTO public."ScenarioStep" (id, "scenarioId", "stepIndex", year, month, label, "eventName", "eventDescription", "eventColor") VALUES (39, '2014_ruble', 18, 2016, 3, 'Мар 2016', NULL, NULL, NULL);
INSERT INTO public."ScenarioStep" (id, "scenarioId", "stepIndex", year, month, label, "eventName", "eventDescription", "eventColor") VALUES (40, '2014_ruble', 19, 2016, 4, 'Апр 2016', NULL, NULL, NULL);
INSERT INTO public."ScenarioStep" (id, "scenarioId", "stepIndex", year, month, label, "eventName", "eventDescription", "eventColor") VALUES (41, '2014_ruble', 20, 2016, 5, 'Май 2016', NULL, NULL, NULL);
INSERT INTO public."ScenarioStep" (id, "scenarioId", "stepIndex", year, month, label, "eventName", "eventDescription", "eventColor") VALUES (42, '2014_ruble', 21, 2016, 6, 'Июн 2016', NULL, NULL, NULL);
INSERT INTO public."ScenarioStep" (id, "scenarioId", "stepIndex", year, month, label, "eventName", "eventDescription", "eventColor") VALUES (43, '2014_ruble', 22, 2016, 7, 'Июл 2016', NULL, NULL, NULL);
INSERT INTO public."ScenarioStep" (id, "scenarioId", "stepIndex", year, month, label, "eventName", "eventDescription", "eventColor") VALUES (44, '2014_ruble', 23, 2016, 8, 'Авг 2016', NULL, NULL, NULL);
INSERT INTO public."ScenarioStep" (id, "scenarioId", "stepIndex", year, month, label, "eventName", "eventDescription", "eventColor") VALUES (45, '2014_ruble', 24, 2016, 9, 'Сен 2016', NULL, NULL, NULL);
INSERT INTO public."ScenarioStep" (id, "scenarioId", "stepIndex", year, month, label, "eventName", "eventDescription", "eventColor") VALUES (46, '2014_ruble', 25, 2016, 10, 'Окт 2016', NULL, NULL, NULL);
INSERT INTO public."ScenarioStep" (id, "scenarioId", "stepIndex", year, month, label, "eventName", "eventDescription", "eventColor") VALUES (47, '2014_ruble', 26, 2016, 11, 'Ноя 2016', NULL, NULL, NULL);
INSERT INTO public."ScenarioStep" (id, "scenarioId", "stepIndex", year, month, label, "eventName", "eventDescription", "eventColor") VALUES (48, '2014_ruble', 27, 2016, 12, 'Дек 2016', NULL, NULL, NULL);
INSERT INTO public."ScenarioStep" (id, "scenarioId", "stepIndex", year, month, label, "eventName", "eventDescription", "eventColor") VALUES (49, '2014_ruble', 28, 2017, 1, 'Янв 2017', NULL, NULL, NULL);
INSERT INTO public."ScenarioStep" (id, "scenarioId", "stepIndex", year, month, label, "eventName", "eventDescription", "eventColor") VALUES (50, '2014_ruble', 29, 2017, 2, 'Фев 2017', NULL, NULL, NULL);
INSERT INTO public."ScenarioStep" (id, "scenarioId", "stepIndex", year, month, label, "eventName", "eventDescription", "eventColor") VALUES (51, '2014_ruble', 30, 2017, 3, 'Мар 2017', NULL, NULL, NULL);
INSERT INTO public."ScenarioStep" (id, "scenarioId", "stepIndex", year, month, label, "eventName", "eventDescription", "eventColor") VALUES (52, '2014_ruble', 31, 2017, 4, 'Апр 2017', NULL, NULL, NULL);
INSERT INTO public."ScenarioStep" (id, "scenarioId", "stepIndex", year, month, label, "eventName", "eventDescription", "eventColor") VALUES (53, '2014_ruble', 32, 2017, 5, 'Май 2017', NULL, NULL, NULL);
INSERT INTO public."ScenarioStep" (id, "scenarioId", "stepIndex", year, month, label, "eventName", "eventDescription", "eventColor") VALUES (54, '2014_ruble', 33, 2017, 6, 'Июн 2017', NULL, NULL, NULL);
INSERT INTO public."ScenarioStep" (id, "scenarioId", "stepIndex", year, month, label, "eventName", "eventDescription", "eventColor") VALUES (55, '2014_ruble', 34, 2017, 7, 'Июл 2017', NULL, NULL, NULL);
INSERT INTO public."ScenarioStep" (id, "scenarioId", "stepIndex", year, month, label, "eventName", "eventDescription", "eventColor") VALUES (56, '2014_ruble', 35, 2017, 8, 'Авг 2017', NULL, NULL, NULL);
INSERT INTO public."ScenarioStep" (id, "scenarioId", "stepIndex", year, month, label, "eventName", "eventDescription", "eventColor") VALUES (57, '2014_ruble', 36, 2017, 9, 'Сен 2017', NULL, NULL, NULL);
INSERT INTO public."ScenarioStep" (id, "scenarioId", "stepIndex", year, month, label, "eventName", "eventDescription", "eventColor") VALUES (58, '2014_ruble', 37, 2017, 10, 'Окт 2017', NULL, NULL, NULL);
INSERT INTO public."ScenarioStep" (id, "scenarioId", "stepIndex", year, month, label, "eventName", "eventDescription", "eventColor") VALUES (59, '2014_ruble', 38, 2017, 11, 'Ноя 2017', NULL, NULL, NULL);
INSERT INTO public."ScenarioStep" (id, "scenarioId", "stepIndex", year, month, label, "eventName", "eventDescription", "eventColor") VALUES (60, '2014_ruble', 39, 2017, 12, 'Дек 2017', NULL, NULL, NULL);
INSERT INTO public."ScenarioStep" (id, "scenarioId", "stepIndex", year, month, label, "eventName", "eventDescription", "eventColor") VALUES (61, '2014_ruble', 40, 2018, 1, 'Янв 2018', NULL, NULL, NULL);
INSERT INTO public."ScenarioStep" (id, "scenarioId", "stepIndex", year, month, label, "eventName", "eventDescription", "eventColor") VALUES (62, '2014_ruble', 41, 2018, 2, 'Фев 2018', NULL, NULL, NULL);
INSERT INTO public."ScenarioStep" (id, "scenarioId", "stepIndex", year, month, label, "eventName", "eventDescription", "eventColor") VALUES (63, '2014_ruble', 42, 2018, 3, 'Мар 2018', NULL, NULL, NULL);
INSERT INTO public."ScenarioStep" (id, "scenarioId", "stepIndex", year, month, label, "eventName", "eventDescription", "eventColor") VALUES (64, '2014_ruble', 43, 2018, 4, 'Апр 2018', NULL, NULL, NULL);
INSERT INTO public."ScenarioStep" (id, "scenarioId", "stepIndex", year, month, label, "eventName", "eventDescription", "eventColor") VALUES (65, '2014_ruble', 44, 2018, 5, 'Май 2018', NULL, NULL, NULL);
INSERT INTO public."ScenarioStep" (id, "scenarioId", "stepIndex", year, month, label, "eventName", "eventDescription", "eventColor") VALUES (66, '2014_ruble', 45, 2018, 6, 'Июн 2018', NULL, NULL, NULL);
INSERT INTO public."ScenarioStep" (id, "scenarioId", "stepIndex", year, month, label, "eventName", "eventDescription", "eventColor") VALUES (67, '2014_ruble', 46, 2018, 7, 'Июл 2018', NULL, NULL, NULL);
INSERT INTO public."ScenarioStep" (id, "scenarioId", "stepIndex", year, month, label, "eventName", "eventDescription", "eventColor") VALUES (68, '2014_ruble', 47, 2018, 8, 'Авг 2018', NULL, NULL, NULL);
INSERT INTO public."ScenarioStep" (id, "scenarioId", "stepIndex", year, month, label, "eventName", "eventDescription", "eventColor") VALUES (69, '2014_ruble', 48, 2018, 9, 'Сен 2018', NULL, NULL, NULL);
INSERT INTO public."ScenarioStep" (id, "scenarioId", "stepIndex", year, month, label, "eventName", "eventDescription", "eventColor") VALUES (70, '2014_ruble', 49, 2018, 10, 'Окт 2018', NULL, NULL, NULL);
INSERT INTO public."ScenarioStep" (id, "scenarioId", "stepIndex", year, month, label, "eventName", "eventDescription", "eventColor") VALUES (71, '2014_ruble', 50, 2018, 11, 'Ноя 2018', NULL, NULL, NULL);
INSERT INTO public."ScenarioStep" (id, "scenarioId", "stepIndex", year, month, label, "eventName", "eventDescription", "eventColor") VALUES (72, '2014_ruble', 51, 2018, 12, 'Дек 2018', NULL, NULL, NULL);
INSERT INTO public."ScenarioStep" (id, "scenarioId", "stepIndex", year, month, label, "eventName", "eventDescription", "eventColor") VALUES (73, '2014_ruble', 52, 2019, 1, 'Янв 2019', NULL, NULL, NULL);
INSERT INTO public."ScenarioStep" (id, "scenarioId", "stepIndex", year, month, label, "eventName", "eventDescription", "eventColor") VALUES (74, '2014_ruble', 53, 2019, 2, 'Фев 2019', NULL, NULL, NULL);
INSERT INTO public."ScenarioStep" (id, "scenarioId", "stepIndex", year, month, label, "eventName", "eventDescription", "eventColor") VALUES (75, '2014_ruble', 54, 2019, 3, 'Мар 2019', NULL, NULL, NULL);
INSERT INTO public."ScenarioStep" (id, "scenarioId", "stepIndex", year, month, label, "eventName", "eventDescription", "eventColor") VALUES (76, '2014_ruble', 55, 2019, 4, 'Апр 2019', NULL, NULL, NULL);
INSERT INTO public."ScenarioStep" (id, "scenarioId", "stepIndex", year, month, label, "eventName", "eventDescription", "eventColor") VALUES (77, '2014_ruble', 56, 2019, 5, 'Май 2019', NULL, NULL, NULL);
INSERT INTO public."ScenarioStep" (id, "scenarioId", "stepIndex", year, month, label, "eventName", "eventDescription", "eventColor") VALUES (78, '2014_ruble', 57, 2019, 6, 'Июн 2019', NULL, NULL, NULL);
INSERT INTO public."ScenarioStep" (id, "scenarioId", "stepIndex", year, month, label, "eventName", "eventDescription", "eventColor") VALUES (79, '2014_ruble', 58, 2019, 7, 'Июл 2019', NULL, NULL, NULL);
INSERT INTO public."ScenarioStep" (id, "scenarioId", "stepIndex", year, month, label, "eventName", "eventDescription", "eventColor") VALUES (80, '2014_ruble', 59, 2019, 8, 'Авг 2019', NULL, NULL, NULL);
INSERT INTO public."ScenarioStep" (id, "scenarioId", "stepIndex", year, month, label, "eventName", "eventDescription", "eventColor") VALUES (81, '2014_ruble', 60, 2019, 9, 'Сен 2019', NULL, NULL, NULL);
INSERT INTO public."ScenarioStep" (id, "scenarioId", "stepIndex", year, month, label, "eventName", "eventDescription", "eventColor") VALUES (82, '2014_ruble', 61, 2019, 10, 'Окт 2019', NULL, NULL, NULL);
INSERT INTO public."ScenarioStep" (id, "scenarioId", "stepIndex", year, month, label, "eventName", "eventDescription", "eventColor") VALUES (83, '2014_ruble', 62, 2019, 11, 'Ноя 2019', NULL, NULL, NULL);
INSERT INTO public."ScenarioStep" (id, "scenarioId", "stepIndex", year, month, label, "eventName", "eventDescription", "eventColor") VALUES (84, '2014_ruble', 63, 2019, 12, 'Дек 2019', NULL, NULL, NULL);
INSERT INTO public."ScenarioStep" (id, "scenarioId", "stepIndex", year, month, label, "eventName", "eventDescription", "eventColor") VALUES (85, '2014_ruble', 64, 2020, 1, 'Янв 2020', NULL, NULL, NULL);
INSERT INTO public."ScenarioStep" (id, "scenarioId", "stepIndex", year, month, label, "eventName", "eventDescription", "eventColor") VALUES (86, '2014_ruble', 65, 2020, 2, 'Фев 2020', NULL, NULL, NULL);
INSERT INTO public."ScenarioStep" (id, "scenarioId", "stepIndex", year, month, label, "eventName", "eventDescription", "eventColor") VALUES (87, '2014_ruble', 66, 2020, 3, 'Мар 2020', '🦠 COVID-19: ПАНДЕМИЯ', 'ВОЗ объявила пандемию COVID-19. Нефть рухнула −30% за день. IMOEX потерял 35% за март. Беспрецедентный кризис.', '#35d9ff');
INSERT INTO public."ScenarioStep" (id, "scenarioId", "stepIndex", year, month, label, "eventName", "eventDescription", "eventColor") VALUES (88, '2014_ruble', 67, 2020, 4, 'Апр 2020', NULL, NULL, NULL);
INSERT INTO public."ScenarioStep" (id, "scenarioId", "stepIndex", year, month, label, "eventName", "eventDescription", "eventColor") VALUES (89, '2014_ruble', 68, 2020, 5, 'Май 2020', NULL, NULL, NULL);
INSERT INTO public."ScenarioStep" (id, "scenarioId", "stepIndex", year, month, label, "eventName", "eventDescription", "eventColor") VALUES (90, '2014_ruble', 69, 2020, 6, 'Июн 2020', NULL, NULL, NULL);
INSERT INTO public."ScenarioStep" (id, "scenarioId", "stepIndex", year, month, label, "eventName", "eventDescription", "eventColor") VALUES (91, '2014_ruble', 70, 2020, 7, 'Июл 2020', NULL, NULL, NULL);
INSERT INTO public."ScenarioStep" (id, "scenarioId", "stepIndex", year, month, label, "eventName", "eventDescription", "eventColor") VALUES (92, '2014_ruble', 71, 2020, 8, 'Авг 2020', NULL, NULL, NULL);
INSERT INTO public."ScenarioStep" (id, "scenarioId", "stepIndex", year, month, label, "eventName", "eventDescription", "eventColor") VALUES (93, '2014_ruble', 72, 2020, 9, 'Сен 2020', NULL, NULL, NULL);
INSERT INTO public."ScenarioStep" (id, "scenarioId", "stepIndex", year, month, label, "eventName", "eventDescription", "eventColor") VALUES (94, '2014_ruble', 73, 2020, 10, 'Окт 2020', NULL, NULL, NULL);
INSERT INTO public."ScenarioStep" (id, "scenarioId", "stepIndex", year, month, label, "eventName", "eventDescription", "eventColor") VALUES (95, '2014_ruble', 74, 2020, 11, 'Ноя 2020', NULL, NULL, NULL);
INSERT INTO public."ScenarioStep" (id, "scenarioId", "stepIndex", year, month, label, "eventName", "eventDescription", "eventColor") VALUES (96, '2014_ruble', 75, 2020, 12, 'Дек 2020', NULL, NULL, NULL);
INSERT INTO public."ScenarioStep" (id, "scenarioId", "stepIndex", year, month, label, "eventName", "eventDescription", "eventColor") VALUES (97, '2014_ruble', 76, 2021, 1, 'Янв 2021', NULL, NULL, NULL);
INSERT INTO public."ScenarioStep" (id, "scenarioId", "stepIndex", year, month, label, "eventName", "eventDescription", "eventColor") VALUES (98, '2014_ruble', 77, 2021, 2, 'Фев 2021', NULL, NULL, NULL);
INSERT INTO public."ScenarioStep" (id, "scenarioId", "stepIndex", year, month, label, "eventName", "eventDescription", "eventColor") VALUES (99, '2014_ruble', 78, 2021, 3, 'Мар 2021', NULL, NULL, NULL);
INSERT INTO public."ScenarioStep" (id, "scenarioId", "stepIndex", year, month, label, "eventName", "eventDescription", "eventColor") VALUES (100, '2014_ruble', 79, 2021, 4, 'Апр 2021', NULL, NULL, NULL);
INSERT INTO public."ScenarioStep" (id, "scenarioId", "stepIndex", year, month, label, "eventName", "eventDescription", "eventColor") VALUES (101, '2014_ruble', 80, 2021, 5, 'Май 2021', NULL, NULL, NULL);
INSERT INTO public."ScenarioStep" (id, "scenarioId", "stepIndex", year, month, label, "eventName", "eventDescription", "eventColor") VALUES (102, '2014_ruble', 81, 2021, 6, 'Июн 2021', NULL, NULL, NULL);
INSERT INTO public."ScenarioStep" (id, "scenarioId", "stepIndex", year, month, label, "eventName", "eventDescription", "eventColor") VALUES (103, '2014_ruble', 82, 2021, 7, 'Июл 2021', NULL, NULL, NULL);
INSERT INTO public."ScenarioStep" (id, "scenarioId", "stepIndex", year, month, label, "eventName", "eventDescription", "eventColor") VALUES (104, '2014_ruble', 83, 2021, 8, 'Авг 2021', NULL, NULL, NULL);
INSERT INTO public."ScenarioStep" (id, "scenarioId", "stepIndex", year, month, label, "eventName", "eventDescription", "eventColor") VALUES (105, '2014_ruble', 84, 2021, 9, 'Сен 2021', NULL, NULL, NULL);
INSERT INTO public."ScenarioStep" (id, "scenarioId", "stepIndex", year, month, label, "eventName", "eventDescription", "eventColor") VALUES (106, '2014_ruble', 85, 2021, 10, 'Окт 2021', NULL, NULL, NULL);
INSERT INTO public."ScenarioStep" (id, "scenarioId", "stepIndex", year, month, label, "eventName", "eventDescription", "eventColor") VALUES (107, '2014_ruble', 86, 2021, 11, 'Ноя 2021', NULL, NULL, NULL);
INSERT INTO public."ScenarioStep" (id, "scenarioId", "stepIndex", year, month, label, "eventName", "eventDescription", "eventColor") VALUES (108, '2014_ruble', 87, 2021, 12, 'Дек 2021', NULL, NULL, NULL);
INSERT INTO public."ScenarioStep" (id, "scenarioId", "stepIndex", year, month, label, "eventName", "eventDescription", "eventColor") VALUES (109, '2014_ruble', 88, 2022, 1, 'Янв 2022', NULL, NULL, NULL);
INSERT INTO public."ScenarioStep" (id, "scenarioId", "stepIndex", year, month, label, "eventName", "eventDescription", "eventColor") VALUES (110, '2014_ruble', 89, 2022, 2, 'Фев 2022', '⚔️ 24 ФЕВРАЛЯ 2022', 'Россия начала специальную военную операцию. MOEX рухнул на 45% — исторический антирекорд. Ставка 20%. Биржа закрыта.', '#ff4fd8');
INSERT INTO public."ScenarioStep" (id, "scenarioId", "stepIndex", year, month, label, "eventName", "eventDescription", "eventColor") VALUES (111, '2014_ruble', 90, 2022, 3, 'Мар 2022', NULL, NULL, NULL);
INSERT INTO public."ScenarioStep" (id, "scenarioId", "stepIndex", year, month, label, "eventName", "eventDescription", "eventColor") VALUES (112, '2014_ruble', 91, 2022, 4, 'Апр 2022', NULL, NULL, NULL);
INSERT INTO public."ScenarioStep" (id, "scenarioId", "stepIndex", year, month, label, "eventName", "eventDescription", "eventColor") VALUES (113, '2014_ruble', 92, 2022, 5, 'Май 2022', NULL, NULL, NULL);
INSERT INTO public."ScenarioStep" (id, "scenarioId", "stepIndex", year, month, label, "eventName", "eventDescription", "eventColor") VALUES (114, '2014_ruble', 93, 2022, 6, 'Июн 2022', NULL, NULL, NULL);
INSERT INTO public."ScenarioStep" (id, "scenarioId", "stepIndex", year, month, label, "eventName", "eventDescription", "eventColor") VALUES (115, '2014_ruble', 94, 2022, 7, 'Июл 2022', NULL, NULL, NULL);
INSERT INTO public."ScenarioStep" (id, "scenarioId", "stepIndex", year, month, label, "eventName", "eventDescription", "eventColor") VALUES (116, '2014_ruble', 95, 2022, 8, 'Авг 2022', NULL, NULL, NULL);
INSERT INTO public."ScenarioStep" (id, "scenarioId", "stepIndex", year, month, label, "eventName", "eventDescription", "eventColor") VALUES (117, '2014_ruble', 96, 2022, 9, 'Сен 2022', NULL, NULL, NULL);
INSERT INTO public."ScenarioStep" (id, "scenarioId", "stepIndex", year, month, label, "eventName", "eventDescription", "eventColor") VALUES (118, '2014_ruble', 97, 2022, 10, 'Окт 2022', NULL, NULL, NULL);
INSERT INTO public."ScenarioStep" (id, "scenarioId", "stepIndex", year, month, label, "eventName", "eventDescription", "eventColor") VALUES (119, '2014_ruble', 98, 2022, 11, 'Ноя 2022', NULL, NULL, NULL);
INSERT INTO public."ScenarioStep" (id, "scenarioId", "stepIndex", year, month, label, "eventName", "eventDescription", "eventColor") VALUES (120, '2014_ruble', 99, 2022, 12, 'Дек 2022', NULL, NULL, NULL);
INSERT INTO public."ScenarioStep" (id, "scenarioId", "stepIndex", year, month, label, "eventName", "eventDescription", "eventColor") VALUES (121, '2014_ruble', 100, 2023, 1, 'Янв 2023', NULL, NULL, NULL);
INSERT INTO public."ScenarioStep" (id, "scenarioId", "stepIndex", year, month, label, "eventName", "eventDescription", "eventColor") VALUES (122, '2014_ruble', 101, 2023, 2, 'Фев 2023', NULL, NULL, NULL);
INSERT INTO public."ScenarioStep" (id, "scenarioId", "stepIndex", year, month, label, "eventName", "eventDescription", "eventColor") VALUES (123, '2014_ruble', 102, 2023, 3, 'Мар 2023', NULL, NULL, NULL);
INSERT INTO public."ScenarioStep" (id, "scenarioId", "stepIndex", year, month, label, "eventName", "eventDescription", "eventColor") VALUES (124, '2014_ruble', 103, 2023, 4, 'Апр 2023', NULL, NULL, NULL);
INSERT INTO public."ScenarioStep" (id, "scenarioId", "stepIndex", year, month, label, "eventName", "eventDescription", "eventColor") VALUES (125, '2014_ruble', 104, 2023, 5, 'Май 2023', NULL, NULL, NULL);
INSERT INTO public."ScenarioStep" (id, "scenarioId", "stepIndex", year, month, label, "eventName", "eventDescription", "eventColor") VALUES (126, '2014_ruble', 105, 2023, 6, 'Июн 2023', NULL, NULL, NULL);
INSERT INTO public."ScenarioStep" (id, "scenarioId", "stepIndex", year, month, label, "eventName", "eventDescription", "eventColor") VALUES (127, '2014_ruble', 106, 2023, 7, 'Июл 2023', '📊 СТАВКА: 7.5% → 12%', 'Экстренное заседание ЦБ: ставка поднята до 12% из-за обвала рубля ниже 100 руб/$. Начало цикла резкого повышения.', '#31ff8c');
INSERT INTO public."ScenarioStep" (id, "scenarioId", "stepIndex", year, month, label, "eventName", "eventDescription", "eventColor") VALUES (128, '2014_ruble', 107, 2023, 8, 'Авг 2023', NULL, NULL, NULL);
INSERT INTO public."ScenarioStep" (id, "scenarioId", "stepIndex", year, month, label, "eventName", "eventDescription", "eventColor") VALUES (129, '2014_ruble', 108, 2023, 9, 'Сен 2023', NULL, NULL, NULL);
INSERT INTO public."ScenarioStep" (id, "scenarioId", "stepIndex", year, month, label, "eventName", "eventDescription", "eventColor") VALUES (130, '2014_ruble', 109, 2023, 10, 'Окт 2023', NULL, NULL, NULL);
INSERT INTO public."ScenarioStep" (id, "scenarioId", "stepIndex", year, month, label, "eventName", "eventDescription", "eventColor") VALUES (131, '2014_ruble', 110, 2023, 11, 'Ноя 2023', NULL, NULL, NULL);
INSERT INTO public."ScenarioStep" (id, "scenarioId", "stepIndex", year, month, label, "eventName", "eventDescription", "eventColor") VALUES (132, '2014_ruble', 111, 2023, 12, 'Дек 2023', NULL, NULL, NULL);
INSERT INTO public."ScenarioStep" (id, "scenarioId", "stepIndex", year, month, label, "eventName", "eventDescription", "eventColor") VALUES (133, '2014_ruble', 112, 2024, 1, 'Янв 2024', NULL, NULL, NULL);
INSERT INTO public."ScenarioStep" (id, "scenarioId", "stepIndex", year, month, label, "eventName", "eventDescription", "eventColor") VALUES (134, '2014_ruble', 113, 2024, 2, 'Фев 2024', NULL, NULL, NULL);
INSERT INTO public."ScenarioStep" (id, "scenarioId", "stepIndex", year, month, label, "eventName", "eventDescription", "eventColor") VALUES (135, '2014_ruble', 114, 2024, 3, 'Мар 2024', NULL, NULL, NULL);
INSERT INTO public."ScenarioStep" (id, "scenarioId", "stepIndex", year, month, label, "eventName", "eventDescription", "eventColor") VALUES (136, '2014_ruble', 115, 2024, 4, 'Апр 2024', NULL, NULL, NULL);
INSERT INTO public."ScenarioStep" (id, "scenarioId", "stepIndex", year, month, label, "eventName", "eventDescription", "eventColor") VALUES (137, '2014_ruble', 116, 2024, 5, 'Май 2024', NULL, NULL, NULL);
INSERT INTO public."ScenarioStep" (id, "scenarioId", "stepIndex", year, month, label, "eventName", "eventDescription", "eventColor") VALUES (138, '2014_ruble', 117, 2024, 6, 'Июн 2024', NULL, NULL, NULL);
INSERT INTO public."ScenarioStep" (id, "scenarioId", "stepIndex", year, month, label, "eventName", "eventDescription", "eventColor") VALUES (139, '2014_ruble', 118, 2024, 7, 'Июл 2024', NULL, NULL, NULL);
INSERT INTO public."ScenarioStep" (id, "scenarioId", "stepIndex", year, month, label, "eventName", "eventDescription", "eventColor") VALUES (140, '2014_ruble', 119, 2024, 8, 'Авг 2024', NULL, NULL, NULL);
INSERT INTO public."ScenarioStep" (id, "scenarioId", "stepIndex", year, month, label, "eventName", "eventDescription", "eventColor") VALUES (141, '2014_ruble', 120, 2024, 9, 'Сен 2024', NULL, NULL, NULL);
INSERT INTO public."ScenarioStep" (id, "scenarioId", "stepIndex", year, month, label, "eventName", "eventDescription", "eventColor") VALUES (142, '2014_ruble', 121, 2024, 10, 'Окт 2024', '📈 СТАВКА 21% — РЕКОРД', 'Ключевая ставка достигла 21% — исторический максимум. Рынок упал на 5%. Банки предлагают вклады под 20%+.', '#ffc266');
INSERT INTO public."ScenarioStep" (id, "scenarioId", "stepIndex", year, month, label, "eventName", "eventDescription", "eventColor") VALUES (143, '2014_ruble', 122, 2024, 11, 'Ноя 2024', NULL, NULL, NULL);
INSERT INTO public."ScenarioStep" (id, "scenarioId", "stepIndex", year, month, label, "eventName", "eventDescription", "eventColor") VALUES (144, '2014_ruble', 123, 2024, 12, 'Дек 2024', NULL, NULL, NULL);
INSERT INTO public."ScenarioStep" (id, "scenarioId", "stepIndex", year, month, label, "eventName", "eventDescription", "eventColor") VALUES (145, '2014_ruble', 124, 2025, 1, 'Янв 2025', NULL, NULL, NULL);
INSERT INTO public."ScenarioStep" (id, "scenarioId", "stepIndex", year, month, label, "eventName", "eventDescription", "eventColor") VALUES (146, '2014_ruble', 125, 2025, 2, 'Фев 2025', NULL, NULL, NULL);
INSERT INTO public."ScenarioStep" (id, "scenarioId", "stepIndex", year, month, label, "eventName", "eventDescription", "eventColor") VALUES (147, '2014_ruble', 126, 2025, 3, 'Мар 2025', NULL, NULL, NULL);
INSERT INTO public."ScenarioStep" (id, "scenarioId", "stepIndex", year, month, label, "eventName", "eventDescription", "eventColor") VALUES (148, '2014_ruble', 127, 2025, 4, 'Апр 2025', NULL, NULL, NULL);
INSERT INTO public."ScenarioStep" (id, "scenarioId", "stepIndex", year, month, label, "eventName", "eventDescription", "eventColor") VALUES (149, '2014_ruble', 128, 2025, 5, 'Май 2025', NULL, NULL, NULL);
INSERT INTO public."ScenarioStep" (id, "scenarioId", "stepIndex", year, month, label, "eventName", "eventDescription", "eventColor") VALUES (150, '2014_ruble', 129, 2025, 6, 'Июн 2025', NULL, NULL, NULL);
INSERT INTO public."ScenarioStep" (id, "scenarioId", "stepIndex", year, month, label, "eventName", "eventDescription", "eventColor") VALUES (151, '2014_ruble', 130, 2025, 7, 'Июл 2025', NULL, NULL, NULL);
INSERT INTO public."ScenarioStep" (id, "scenarioId", "stepIndex", year, month, label, "eventName", "eventDescription", "eventColor") VALUES (152, '2014_ruble', 131, 2025, 8, 'Авг 2025', NULL, NULL, NULL);
INSERT INTO public."ScenarioStep" (id, "scenarioId", "stepIndex", year, month, label, "eventName", "eventDescription", "eventColor") VALUES (153, '2014_ruble', 132, 2025, 9, 'Сен 2025', NULL, NULL, NULL);
INSERT INTO public."ScenarioStep" (id, "scenarioId", "stepIndex", year, month, label, "eventName", "eventDescription", "eventColor") VALUES (154, '2014_ruble', 133, 2025, 10, 'Окт 2025', NULL, NULL, NULL);
INSERT INTO public."ScenarioStep" (id, "scenarioId", "stepIndex", year, month, label, "eventName", "eventDescription", "eventColor") VALUES (155, '2014_ruble', 134, 2025, 11, 'Ноя 2025', NULL, NULL, NULL);
INSERT INTO public."ScenarioStep" (id, "scenarioId", "stepIndex", year, month, label, "eventName", "eventDescription", "eventColor") VALUES (156, '2014_ruble', 135, 2025, 12, 'Дек 2025', NULL, NULL, NULL);
INSERT INTO public."ScenarioStep" (id, "scenarioId", "stepIndex", year, month, label, "eventName", "eventDescription", "eventColor") VALUES (157, '2014_ruble', 136, 2026, 1, 'Янв 2026', NULL, NULL, NULL);
INSERT INTO public."ScenarioStep" (id, "scenarioId", "stepIndex", year, month, label, "eventName", "eventDescription", "eventColor") VALUES (158, '2014_ruble', 137, 2026, 2, 'Фев 2026', NULL, NULL, NULL);
INSERT INTO public."ScenarioStep" (id, "scenarioId", "stepIndex", year, month, label, "eventName", "eventDescription", "eventColor") VALUES (159, '2014_ruble', 138, 2026, 3, 'Мар 2026', NULL, NULL, NULL);
INSERT INTO public."ScenarioStep" (id, "scenarioId", "stepIndex", year, month, label, "eventName", "eventDescription", "eventColor") VALUES (160, '2014_ruble', 139, 2026, 4, 'Апр 2026', NULL, NULL, NULL);
INSERT INTO public."ScenarioStep" (id, "scenarioId", "stepIndex", year, month, label, "eventName", "eventDescription", "eventColor") VALUES (161, '2020_covid', 6, 2020, 7, 'Июл 2020', NULL, NULL, NULL);
INSERT INTO public."ScenarioStep" (id, "scenarioId", "stepIndex", year, month, label, "eventName", "eventDescription", "eventColor") VALUES (162, '2020_covid', 7, 2020, 8, 'Авг 2020', NULL, NULL, NULL);
INSERT INTO public."ScenarioStep" (id, "scenarioId", "stepIndex", year, month, label, "eventName", "eventDescription", "eventColor") VALUES (163, '2020_covid', 8, 2020, 9, 'Сен 2020', NULL, NULL, NULL);
INSERT INTO public."ScenarioStep" (id, "scenarioId", "stepIndex", year, month, label, "eventName", "eventDescription", "eventColor") VALUES (164, '2020_covid', 9, 2020, 10, 'Окт 2020', NULL, NULL, NULL);
INSERT INTO public."ScenarioStep" (id, "scenarioId", "stepIndex", year, month, label, "eventName", "eventDescription", "eventColor") VALUES (165, '2020_covid', 10, 2020, 11, 'Ноя 2020', NULL, NULL, NULL);
INSERT INTO public."ScenarioStep" (id, "scenarioId", "stepIndex", year, month, label, "eventName", "eventDescription", "eventColor") VALUES (166, '2020_covid', 11, 2020, 12, 'Дек 2020', NULL, NULL, NULL);
INSERT INTO public."ScenarioStep" (id, "scenarioId", "stepIndex", year, month, label, "eventName", "eventDescription", "eventColor") VALUES (167, '2020_covid', 12, 2021, 1, 'Янв 2021', NULL, NULL, NULL);
INSERT INTO public."ScenarioStep" (id, "scenarioId", "stepIndex", year, month, label, "eventName", "eventDescription", "eventColor") VALUES (168, '2020_covid', 13, 2021, 2, 'Фев 2021', NULL, NULL, NULL);
INSERT INTO public."ScenarioStep" (id, "scenarioId", "stepIndex", year, month, label, "eventName", "eventDescription", "eventColor") VALUES (169, '2020_covid', 14, 2021, 3, 'Мар 2021', NULL, NULL, NULL);
INSERT INTO public."ScenarioStep" (id, "scenarioId", "stepIndex", year, month, label, "eventName", "eventDescription", "eventColor") VALUES (170, '2020_covid', 15, 2021, 4, 'Апр 2021', NULL, NULL, NULL);
INSERT INTO public."ScenarioStep" (id, "scenarioId", "stepIndex", year, month, label, "eventName", "eventDescription", "eventColor") VALUES (171, '2020_covid', 16, 2021, 5, 'Май 2021', NULL, NULL, NULL);
INSERT INTO public."ScenarioStep" (id, "scenarioId", "stepIndex", year, month, label, "eventName", "eventDescription", "eventColor") VALUES (172, '2020_covid', 17, 2021, 6, 'Июн 2021', NULL, NULL, NULL);
INSERT INTO public."ScenarioStep" (id, "scenarioId", "stepIndex", year, month, label, "eventName", "eventDescription", "eventColor") VALUES (173, '2020_covid', 18, 2021, 7, 'Июл 2021', NULL, NULL, NULL);
INSERT INTO public."ScenarioStep" (id, "scenarioId", "stepIndex", year, month, label, "eventName", "eventDescription", "eventColor") VALUES (174, '2020_covid', 19, 2021, 8, 'Авг 2021', NULL, NULL, NULL);
INSERT INTO public."ScenarioStep" (id, "scenarioId", "stepIndex", year, month, label, "eventName", "eventDescription", "eventColor") VALUES (175, '2020_covid', 20, 2021, 9, 'Сен 2021', NULL, NULL, NULL);
INSERT INTO public."ScenarioStep" (id, "scenarioId", "stepIndex", year, month, label, "eventName", "eventDescription", "eventColor") VALUES (176, '2020_covid', 21, 2021, 10, 'Окт 2021', NULL, NULL, NULL);
INSERT INTO public."ScenarioStep" (id, "scenarioId", "stepIndex", year, month, label, "eventName", "eventDescription", "eventColor") VALUES (177, '2020_covid', 22, 2021, 11, 'Ноя 2021', NULL, NULL, NULL);
INSERT INTO public."ScenarioStep" (id, "scenarioId", "stepIndex", year, month, label, "eventName", "eventDescription", "eventColor") VALUES (178, '2020_covid', 23, 2021, 12, 'Дек 2021', NULL, NULL, NULL);
INSERT INTO public."ScenarioStep" (id, "scenarioId", "stepIndex", year, month, label, "eventName", "eventDescription", "eventColor") VALUES (179, '2020_covid', 24, 2022, 1, 'Янв 2022', NULL, NULL, NULL);
INSERT INTO public."ScenarioStep" (id, "scenarioId", "stepIndex", year, month, label, "eventName", "eventDescription", "eventColor") VALUES (180, '2020_covid', 25, 2022, 2, 'Фев 2022', '⚔️ 24 ФЕВРАЛЯ 2022', 'Россия начала специальную военную операцию. MOEX рухнул на 45% — исторический антирекорд. Ставка 20%. Биржа закрыта.', '#ff4fd8');
INSERT INTO public."ScenarioStep" (id, "scenarioId", "stepIndex", year, month, label, "eventName", "eventDescription", "eventColor") VALUES (181, '2020_covid', 26, 2022, 3, 'Мар 2022', NULL, NULL, NULL);
INSERT INTO public."ScenarioStep" (id, "scenarioId", "stepIndex", year, month, label, "eventName", "eventDescription", "eventColor") VALUES (182, '2020_covid', 27, 2022, 4, 'Апр 2022', NULL, NULL, NULL);
INSERT INTO public."ScenarioStep" (id, "scenarioId", "stepIndex", year, month, label, "eventName", "eventDescription", "eventColor") VALUES (183, '2020_covid', 28, 2022, 5, 'Май 2022', NULL, NULL, NULL);
INSERT INTO public."ScenarioStep" (id, "scenarioId", "stepIndex", year, month, label, "eventName", "eventDescription", "eventColor") VALUES (184, '2020_covid', 29, 2022, 6, 'Июн 2022', NULL, NULL, NULL);
INSERT INTO public."ScenarioStep" (id, "scenarioId", "stepIndex", year, month, label, "eventName", "eventDescription", "eventColor") VALUES (185, '2020_covid', 30, 2022, 7, 'Июл 2022', NULL, NULL, NULL);
INSERT INTO public."ScenarioStep" (id, "scenarioId", "stepIndex", year, month, label, "eventName", "eventDescription", "eventColor") VALUES (186, '2020_covid', 31, 2022, 8, 'Авг 2022', NULL, NULL, NULL);
INSERT INTO public."ScenarioStep" (id, "scenarioId", "stepIndex", year, month, label, "eventName", "eventDescription", "eventColor") VALUES (187, '2020_covid', 32, 2022, 9, 'Сен 2022', NULL, NULL, NULL);
INSERT INTO public."ScenarioStep" (id, "scenarioId", "stepIndex", year, month, label, "eventName", "eventDescription", "eventColor") VALUES (188, '2020_covid', 33, 2022, 10, 'Окт 2022', NULL, NULL, NULL);
INSERT INTO public."ScenarioStep" (id, "scenarioId", "stepIndex", year, month, label, "eventName", "eventDescription", "eventColor") VALUES (189, '2020_covid', 34, 2022, 11, 'Ноя 2022', NULL, NULL, NULL);
INSERT INTO public."ScenarioStep" (id, "scenarioId", "stepIndex", year, month, label, "eventName", "eventDescription", "eventColor") VALUES (190, '2020_covid', 35, 2022, 12, 'Дек 2022', NULL, NULL, NULL);
INSERT INTO public."ScenarioStep" (id, "scenarioId", "stepIndex", year, month, label, "eventName", "eventDescription", "eventColor") VALUES (191, '2020_covid', 36, 2023, 1, 'Янв 2023', NULL, NULL, NULL);
INSERT INTO public."ScenarioStep" (id, "scenarioId", "stepIndex", year, month, label, "eventName", "eventDescription", "eventColor") VALUES (192, '2020_covid', 37, 2023, 2, 'Фев 2023', NULL, NULL, NULL);
INSERT INTO public."ScenarioStep" (id, "scenarioId", "stepIndex", year, month, label, "eventName", "eventDescription", "eventColor") VALUES (193, '2020_covid', 38, 2023, 3, 'Мар 2023', NULL, NULL, NULL);
INSERT INTO public."ScenarioStep" (id, "scenarioId", "stepIndex", year, month, label, "eventName", "eventDescription", "eventColor") VALUES (194, '2020_covid', 39, 2023, 4, 'Апр 2023', NULL, NULL, NULL);
INSERT INTO public."ScenarioStep" (id, "scenarioId", "stepIndex", year, month, label, "eventName", "eventDescription", "eventColor") VALUES (195, '2020_covid', 40, 2023, 5, 'Май 2023', NULL, NULL, NULL);
INSERT INTO public."ScenarioStep" (id, "scenarioId", "stepIndex", year, month, label, "eventName", "eventDescription", "eventColor") VALUES (196, '2020_covid', 41, 2023, 6, 'Июн 2023', NULL, NULL, NULL);
INSERT INTO public."ScenarioStep" (id, "scenarioId", "stepIndex", year, month, label, "eventName", "eventDescription", "eventColor") VALUES (197, '2020_covid', 42, 2023, 7, 'Июл 2023', '📊 СТАВКА: 7.5% → 12%', 'Экстренное заседание ЦБ: ставка поднята до 12% из-за обвала рубля ниже 100 руб/$. Начало цикла резкого повышения.', '#31ff8c');
INSERT INTO public."ScenarioStep" (id, "scenarioId", "stepIndex", year, month, label, "eventName", "eventDescription", "eventColor") VALUES (198, '2020_covid', 43, 2023, 8, 'Авг 2023', NULL, NULL, NULL);
INSERT INTO public."ScenarioStep" (id, "scenarioId", "stepIndex", year, month, label, "eventName", "eventDescription", "eventColor") VALUES (199, '2020_covid', 44, 2023, 9, 'Сен 2023', NULL, NULL, NULL);
INSERT INTO public."ScenarioStep" (id, "scenarioId", "stepIndex", year, month, label, "eventName", "eventDescription", "eventColor") VALUES (200, '2020_covid', 45, 2023, 10, 'Окт 2023', NULL, NULL, NULL);
INSERT INTO public."ScenarioStep" (id, "scenarioId", "stepIndex", year, month, label, "eventName", "eventDescription", "eventColor") VALUES (201, '2020_covid', 46, 2023, 11, 'Ноя 2023', NULL, NULL, NULL);
INSERT INTO public."ScenarioStep" (id, "scenarioId", "stepIndex", year, month, label, "eventName", "eventDescription", "eventColor") VALUES (202, '2020_covid', 47, 2023, 12, 'Дек 2023', NULL, NULL, NULL);
INSERT INTO public."ScenarioStep" (id, "scenarioId", "stepIndex", year, month, label, "eventName", "eventDescription", "eventColor") VALUES (203, '2020_covid', 48, 2024, 1, 'Янв 2024', NULL, NULL, NULL);
INSERT INTO public."ScenarioStep" (id, "scenarioId", "stepIndex", year, month, label, "eventName", "eventDescription", "eventColor") VALUES (204, '2020_covid', 49, 2024, 2, 'Фев 2024', NULL, NULL, NULL);
INSERT INTO public."ScenarioStep" (id, "scenarioId", "stepIndex", year, month, label, "eventName", "eventDescription", "eventColor") VALUES (205, '2020_covid', 50, 2024, 3, 'Мар 2024', NULL, NULL, NULL);
INSERT INTO public."ScenarioStep" (id, "scenarioId", "stepIndex", year, month, label, "eventName", "eventDescription", "eventColor") VALUES (206, '2020_covid', 51, 2024, 4, 'Апр 2024', NULL, NULL, NULL);
INSERT INTO public."ScenarioStep" (id, "scenarioId", "stepIndex", year, month, label, "eventName", "eventDescription", "eventColor") VALUES (207, '2020_covid', 52, 2024, 5, 'Май 2024', NULL, NULL, NULL);
INSERT INTO public."ScenarioStep" (id, "scenarioId", "stepIndex", year, month, label, "eventName", "eventDescription", "eventColor") VALUES (208, '2020_covid', 53, 2024, 6, 'Июн 2024', NULL, NULL, NULL);
INSERT INTO public."ScenarioStep" (id, "scenarioId", "stepIndex", year, month, label, "eventName", "eventDescription", "eventColor") VALUES (209, '2020_covid', 54, 2024, 7, 'Июл 2024', NULL, NULL, NULL);
INSERT INTO public."ScenarioStep" (id, "scenarioId", "stepIndex", year, month, label, "eventName", "eventDescription", "eventColor") VALUES (210, '2020_covid', 55, 2024, 8, 'Авг 2024', NULL, NULL, NULL);
INSERT INTO public."ScenarioStep" (id, "scenarioId", "stepIndex", year, month, label, "eventName", "eventDescription", "eventColor") VALUES (211, '2020_covid', 56, 2024, 9, 'Сен 2024', NULL, NULL, NULL);
INSERT INTO public."ScenarioStep" (id, "scenarioId", "stepIndex", year, month, label, "eventName", "eventDescription", "eventColor") VALUES (212, '2020_covid', 57, 2024, 10, 'Окт 2024', '📈 СТАВКА 21% — РЕКОРД', 'Ключевая ставка достигла 21% — исторический максимум. Рынок упал на 5%. Банки предлагают вклады под 20%+.', '#ffc266');
INSERT INTO public."ScenarioStep" (id, "scenarioId", "stepIndex", year, month, label, "eventName", "eventDescription", "eventColor") VALUES (213, '2020_covid', 58, 2024, 11, 'Ноя 2024', NULL, NULL, NULL);
INSERT INTO public."ScenarioStep" (id, "scenarioId", "stepIndex", year, month, label, "eventName", "eventDescription", "eventColor") VALUES (214, '2020_covid', 59, 2024, 12, 'Дек 2024', NULL, NULL, NULL);
INSERT INTO public."ScenarioStep" (id, "scenarioId", "stepIndex", year, month, label, "eventName", "eventDescription", "eventColor") VALUES (215, '2020_covid', 60, 2025, 1, 'Янв 2025', NULL, NULL, NULL);
INSERT INTO public."ScenarioStep" (id, "scenarioId", "stepIndex", year, month, label, "eventName", "eventDescription", "eventColor") VALUES (216, '2020_covid', 61, 2025, 2, 'Фев 2025', NULL, NULL, NULL);
INSERT INTO public."ScenarioStep" (id, "scenarioId", "stepIndex", year, month, label, "eventName", "eventDescription", "eventColor") VALUES (217, '2020_covid', 62, 2025, 3, 'Мар 2025', NULL, NULL, NULL);
INSERT INTO public."ScenarioStep" (id, "scenarioId", "stepIndex", year, month, label, "eventName", "eventDescription", "eventColor") VALUES (218, '2020_covid', 63, 2025, 4, 'Апр 2025', NULL, NULL, NULL);
INSERT INTO public."ScenarioStep" (id, "scenarioId", "stepIndex", year, month, label, "eventName", "eventDescription", "eventColor") VALUES (219, '2020_covid', 64, 2025, 5, 'Май 2025', NULL, NULL, NULL);
INSERT INTO public."ScenarioStep" (id, "scenarioId", "stepIndex", year, month, label, "eventName", "eventDescription", "eventColor") VALUES (220, '2020_covid', 65, 2025, 6, 'Июн 2025', NULL, NULL, NULL);
INSERT INTO public."ScenarioStep" (id, "scenarioId", "stepIndex", year, month, label, "eventName", "eventDescription", "eventColor") VALUES (221, '2020_covid', 66, 2025, 7, 'Июл 2025', NULL, NULL, NULL);
INSERT INTO public."ScenarioStep" (id, "scenarioId", "stepIndex", year, month, label, "eventName", "eventDescription", "eventColor") VALUES (222, '2020_covid', 67, 2025, 8, 'Авг 2025', NULL, NULL, NULL);
INSERT INTO public."ScenarioStep" (id, "scenarioId", "stepIndex", year, month, label, "eventName", "eventDescription", "eventColor") VALUES (223, '2020_covid', 68, 2025, 9, 'Сен 2025', NULL, NULL, NULL);
INSERT INTO public."ScenarioStep" (id, "scenarioId", "stepIndex", year, month, label, "eventName", "eventDescription", "eventColor") VALUES (224, '2020_covid', 69, 2025, 10, 'Окт 2025', NULL, NULL, NULL);
INSERT INTO public."ScenarioStep" (id, "scenarioId", "stepIndex", year, month, label, "eventName", "eventDescription", "eventColor") VALUES (225, '2020_covid', 70, 2025, 11, 'Ноя 2025', NULL, NULL, NULL);
INSERT INTO public."ScenarioStep" (id, "scenarioId", "stepIndex", year, month, label, "eventName", "eventDescription", "eventColor") VALUES (226, '2020_covid', 71, 2025, 12, 'Дек 2025', NULL, NULL, NULL);
INSERT INTO public."ScenarioStep" (id, "scenarioId", "stepIndex", year, month, label, "eventName", "eventDescription", "eventColor") VALUES (227, '2020_covid', 72, 2026, 1, 'Янв 2026', NULL, NULL, NULL);
INSERT INTO public."ScenarioStep" (id, "scenarioId", "stepIndex", year, month, label, "eventName", "eventDescription", "eventColor") VALUES (228, '2020_covid', 73, 2026, 2, 'Фев 2026', NULL, NULL, NULL);
INSERT INTO public."ScenarioStep" (id, "scenarioId", "stepIndex", year, month, label, "eventName", "eventDescription", "eventColor") VALUES (229, '2020_covid', 74, 2026, 3, 'Мар 2026', NULL, NULL, NULL);
INSERT INTO public."ScenarioStep" (id, "scenarioId", "stepIndex", year, month, label, "eventName", "eventDescription", "eventColor") VALUES (230, '2020_covid', 75, 2026, 4, 'Апр 2026', NULL, NULL, NULL);
INSERT INTO public."ScenarioStep" (id, "scenarioId", "stepIndex", year, month, label, "eventName", "eventDescription", "eventColor") VALUES (231, '2022_feb', 4, 2022, 5, 'Май 2022', NULL, NULL, NULL);
INSERT INTO public."ScenarioStep" (id, "scenarioId", "stepIndex", year, month, label, "eventName", "eventDescription", "eventColor") VALUES (232, '2022_feb', 5, 2022, 6, 'Июн 2022', NULL, NULL, NULL);
INSERT INTO public."ScenarioStep" (id, "scenarioId", "stepIndex", year, month, label, "eventName", "eventDescription", "eventColor") VALUES (233, '2022_feb', 6, 2022, 7, 'Июл 2022', NULL, NULL, NULL);
INSERT INTO public."ScenarioStep" (id, "scenarioId", "stepIndex", year, month, label, "eventName", "eventDescription", "eventColor") VALUES (234, '2022_feb', 7, 2022, 8, 'Авг 2022', NULL, NULL, NULL);
INSERT INTO public."ScenarioStep" (id, "scenarioId", "stepIndex", year, month, label, "eventName", "eventDescription", "eventColor") VALUES (235, '2022_feb', 8, 2022, 9, 'Сен 2022', NULL, NULL, NULL);
INSERT INTO public."ScenarioStep" (id, "scenarioId", "stepIndex", year, month, label, "eventName", "eventDescription", "eventColor") VALUES (236, '2022_feb', 9, 2022, 10, 'Окт 2022', NULL, NULL, NULL);
INSERT INTO public."ScenarioStep" (id, "scenarioId", "stepIndex", year, month, label, "eventName", "eventDescription", "eventColor") VALUES (237, '2022_feb', 10, 2022, 11, 'Ноя 2022', NULL, NULL, NULL);
INSERT INTO public."ScenarioStep" (id, "scenarioId", "stepIndex", year, month, label, "eventName", "eventDescription", "eventColor") VALUES (238, '2022_feb', 11, 2022, 12, 'Дек 2022', NULL, NULL, NULL);
INSERT INTO public."ScenarioStep" (id, "scenarioId", "stepIndex", year, month, label, "eventName", "eventDescription", "eventColor") VALUES (239, '2022_feb', 12, 2023, 1, 'Янв 2023', NULL, NULL, NULL);
INSERT INTO public."ScenarioStep" (id, "scenarioId", "stepIndex", year, month, label, "eventName", "eventDescription", "eventColor") VALUES (240, '2022_feb', 13, 2023, 2, 'Фев 2023', NULL, NULL, NULL);
INSERT INTO public."ScenarioStep" (id, "scenarioId", "stepIndex", year, month, label, "eventName", "eventDescription", "eventColor") VALUES (241, '2022_feb', 14, 2023, 3, 'Мар 2023', NULL, NULL, NULL);
INSERT INTO public."ScenarioStep" (id, "scenarioId", "stepIndex", year, month, label, "eventName", "eventDescription", "eventColor") VALUES (242, '2022_feb', 15, 2023, 4, 'Апр 2023', NULL, NULL, NULL);
INSERT INTO public."ScenarioStep" (id, "scenarioId", "stepIndex", year, month, label, "eventName", "eventDescription", "eventColor") VALUES (243, '2022_feb', 16, 2023, 5, 'Май 2023', NULL, NULL, NULL);
INSERT INTO public."ScenarioStep" (id, "scenarioId", "stepIndex", year, month, label, "eventName", "eventDescription", "eventColor") VALUES (244, '2022_feb', 17, 2023, 6, 'Июн 2023', NULL, NULL, NULL);
INSERT INTO public."ScenarioStep" (id, "scenarioId", "stepIndex", year, month, label, "eventName", "eventDescription", "eventColor") VALUES (245, '2022_feb', 18, 2023, 7, 'Июл 2023', '📊 СТАВКА: 7.5% → 12%', 'Экстренное заседание ЦБ: ставка поднята до 12% из-за обвала рубля ниже 100 руб/$. Начало цикла резкого повышения.', '#31ff8c');
INSERT INTO public."ScenarioStep" (id, "scenarioId", "stepIndex", year, month, label, "eventName", "eventDescription", "eventColor") VALUES (246, '2022_feb', 19, 2023, 8, 'Авг 2023', NULL, NULL, NULL);
INSERT INTO public."ScenarioStep" (id, "scenarioId", "stepIndex", year, month, label, "eventName", "eventDescription", "eventColor") VALUES (247, '2022_feb', 20, 2023, 9, 'Сен 2023', NULL, NULL, NULL);
INSERT INTO public."ScenarioStep" (id, "scenarioId", "stepIndex", year, month, label, "eventName", "eventDescription", "eventColor") VALUES (248, '2022_feb', 21, 2023, 10, 'Окт 2023', NULL, NULL, NULL);
INSERT INTO public."ScenarioStep" (id, "scenarioId", "stepIndex", year, month, label, "eventName", "eventDescription", "eventColor") VALUES (249, '2022_feb', 22, 2023, 11, 'Ноя 2023', NULL, NULL, NULL);
INSERT INTO public."ScenarioStep" (id, "scenarioId", "stepIndex", year, month, label, "eventName", "eventDescription", "eventColor") VALUES (250, '2022_feb', 23, 2023, 12, 'Дек 2023', NULL, NULL, NULL);
INSERT INTO public."ScenarioStep" (id, "scenarioId", "stepIndex", year, month, label, "eventName", "eventDescription", "eventColor") VALUES (251, '2022_feb', 24, 2024, 1, 'Янв 2024', NULL, NULL, NULL);
INSERT INTO public."ScenarioStep" (id, "scenarioId", "stepIndex", year, month, label, "eventName", "eventDescription", "eventColor") VALUES (252, '2022_feb', 25, 2024, 2, 'Фев 2024', NULL, NULL, NULL);
INSERT INTO public."ScenarioStep" (id, "scenarioId", "stepIndex", year, month, label, "eventName", "eventDescription", "eventColor") VALUES (253, '2022_feb', 26, 2024, 3, 'Мар 2024', NULL, NULL, NULL);
INSERT INTO public."ScenarioStep" (id, "scenarioId", "stepIndex", year, month, label, "eventName", "eventDescription", "eventColor") VALUES (254, '2022_feb', 27, 2024, 4, 'Апр 2024', NULL, NULL, NULL);
INSERT INTO public."ScenarioStep" (id, "scenarioId", "stepIndex", year, month, label, "eventName", "eventDescription", "eventColor") VALUES (255, '2022_feb', 28, 2024, 5, 'Май 2024', NULL, NULL, NULL);
INSERT INTO public."ScenarioStep" (id, "scenarioId", "stepIndex", year, month, label, "eventName", "eventDescription", "eventColor") VALUES (256, '2022_feb', 29, 2024, 6, 'Июн 2024', NULL, NULL, NULL);
INSERT INTO public."ScenarioStep" (id, "scenarioId", "stepIndex", year, month, label, "eventName", "eventDescription", "eventColor") VALUES (257, '2022_feb', 30, 2024, 7, 'Июл 2024', NULL, NULL, NULL);
INSERT INTO public."ScenarioStep" (id, "scenarioId", "stepIndex", year, month, label, "eventName", "eventDescription", "eventColor") VALUES (258, '2022_feb', 31, 2024, 8, 'Авг 2024', NULL, NULL, NULL);
INSERT INTO public."ScenarioStep" (id, "scenarioId", "stepIndex", year, month, label, "eventName", "eventDescription", "eventColor") VALUES (259, '2022_feb', 32, 2024, 9, 'Сен 2024', NULL, NULL, NULL);
INSERT INTO public."ScenarioStep" (id, "scenarioId", "stepIndex", year, month, label, "eventName", "eventDescription", "eventColor") VALUES (260, '2022_feb', 33, 2024, 10, 'Окт 2024', '📈 СТАВКА 21% — РЕКОРД', 'Ключевая ставка достигла 21% — исторический максимум. Рынок упал на 5%. Банки предлагают вклады под 20%+.', '#ffc266');
INSERT INTO public."ScenarioStep" (id, "scenarioId", "stepIndex", year, month, label, "eventName", "eventDescription", "eventColor") VALUES (261, '2022_feb', 34, 2024, 11, 'Ноя 2024', NULL, NULL, NULL);
INSERT INTO public."ScenarioStep" (id, "scenarioId", "stepIndex", year, month, label, "eventName", "eventDescription", "eventColor") VALUES (262, '2022_feb', 35, 2024, 12, 'Дек 2024', NULL, NULL, NULL);
INSERT INTO public."ScenarioStep" (id, "scenarioId", "stepIndex", year, month, label, "eventName", "eventDescription", "eventColor") VALUES (263, '2022_feb', 36, 2025, 1, 'Янв 2025', NULL, NULL, NULL);
INSERT INTO public."ScenarioStep" (id, "scenarioId", "stepIndex", year, month, label, "eventName", "eventDescription", "eventColor") VALUES (264, '2022_feb', 37, 2025, 2, 'Фев 2025', NULL, NULL, NULL);
INSERT INTO public."ScenarioStep" (id, "scenarioId", "stepIndex", year, month, label, "eventName", "eventDescription", "eventColor") VALUES (265, '2022_feb', 38, 2025, 3, 'Мар 2025', NULL, NULL, NULL);
INSERT INTO public."ScenarioStep" (id, "scenarioId", "stepIndex", year, month, label, "eventName", "eventDescription", "eventColor") VALUES (266, '2022_feb', 39, 2025, 4, 'Апр 2025', NULL, NULL, NULL);
INSERT INTO public."ScenarioStep" (id, "scenarioId", "stepIndex", year, month, label, "eventName", "eventDescription", "eventColor") VALUES (267, '2022_feb', 40, 2025, 5, 'Май 2025', NULL, NULL, NULL);
INSERT INTO public."ScenarioStep" (id, "scenarioId", "stepIndex", year, month, label, "eventName", "eventDescription", "eventColor") VALUES (268, '2022_feb', 41, 2025, 6, 'Июн 2025', NULL, NULL, NULL);
INSERT INTO public."ScenarioStep" (id, "scenarioId", "stepIndex", year, month, label, "eventName", "eventDescription", "eventColor") VALUES (269, '2022_feb', 42, 2025, 7, 'Июл 2025', NULL, NULL, NULL);
INSERT INTO public."ScenarioStep" (id, "scenarioId", "stepIndex", year, month, label, "eventName", "eventDescription", "eventColor") VALUES (270, '2022_feb', 43, 2025, 8, 'Авг 2025', NULL, NULL, NULL);
INSERT INTO public."ScenarioStep" (id, "scenarioId", "stepIndex", year, month, label, "eventName", "eventDescription", "eventColor") VALUES (271, '2022_feb', 44, 2025, 9, 'Сен 2025', NULL, NULL, NULL);
INSERT INTO public."ScenarioStep" (id, "scenarioId", "stepIndex", year, month, label, "eventName", "eventDescription", "eventColor") VALUES (272, '2022_feb', 45, 2025, 10, 'Окт 2025', NULL, NULL, NULL);
INSERT INTO public."ScenarioStep" (id, "scenarioId", "stepIndex", year, month, label, "eventName", "eventDescription", "eventColor") VALUES (273, '2022_feb', 46, 2025, 11, 'Ноя 2025', NULL, NULL, NULL);
INSERT INTO public."ScenarioStep" (id, "scenarioId", "stepIndex", year, month, label, "eventName", "eventDescription", "eventColor") VALUES (274, '2022_feb', 47, 2025, 12, 'Дек 2025', NULL, NULL, NULL);
INSERT INTO public."ScenarioStep" (id, "scenarioId", "stepIndex", year, month, label, "eventName", "eventDescription", "eventColor") VALUES (275, '2022_feb', 48, 2026, 1, 'Янв 2026', NULL, NULL, NULL);
INSERT INTO public."ScenarioStep" (id, "scenarioId", "stepIndex", year, month, label, "eventName", "eventDescription", "eventColor") VALUES (276, '2022_feb', 49, 2026, 2, 'Фев 2026', NULL, NULL, NULL);
INSERT INTO public."ScenarioStep" (id, "scenarioId", "stepIndex", year, month, label, "eventName", "eventDescription", "eventColor") VALUES (277, '2022_feb', 50, 2026, 3, 'Мар 2026', NULL, NULL, NULL);
INSERT INTO public."ScenarioStep" (id, "scenarioId", "stepIndex", year, month, label, "eventName", "eventDescription", "eventColor") VALUES (278, '2022_feb', 51, 2026, 4, 'Апр 2026', NULL, NULL, NULL);
INSERT INTO public."ScenarioStep" (id, "scenarioId", "stepIndex", year, month, label, "eventName", "eventDescription", "eventColor") VALUES (279, '2023_rate', 10, 2024, 4, 'Апр 2024', NULL, NULL, NULL);
INSERT INTO public."ScenarioStep" (id, "scenarioId", "stepIndex", year, month, label, "eventName", "eventDescription", "eventColor") VALUES (280, '2023_rate', 11, 2024, 5, 'Май 2024', NULL, NULL, NULL);
INSERT INTO public."ScenarioStep" (id, "scenarioId", "stepIndex", year, month, label, "eventName", "eventDescription", "eventColor") VALUES (281, '2023_rate', 12, 2024, 6, 'Июн 2024', NULL, NULL, NULL);
INSERT INTO public."ScenarioStep" (id, "scenarioId", "stepIndex", year, month, label, "eventName", "eventDescription", "eventColor") VALUES (282, '2023_rate', 13, 2024, 7, 'Июл 2024', NULL, NULL, NULL);
INSERT INTO public."ScenarioStep" (id, "scenarioId", "stepIndex", year, month, label, "eventName", "eventDescription", "eventColor") VALUES (283, '2023_rate', 14, 2024, 8, 'Авг 2024', NULL, NULL, NULL);
INSERT INTO public."ScenarioStep" (id, "scenarioId", "stepIndex", year, month, label, "eventName", "eventDescription", "eventColor") VALUES (284, '2023_rate', 15, 2024, 9, 'Сен 2024', NULL, NULL, NULL);
INSERT INTO public."ScenarioStep" (id, "scenarioId", "stepIndex", year, month, label, "eventName", "eventDescription", "eventColor") VALUES (285, '2023_rate', 16, 2024, 10, 'Окт 2024', '📈 СТАВКА 21% — РЕКОРД', 'Ключевая ставка достигла 21% — исторический максимум. Рынок упал на 5%. Банки предлагают вклады под 20%+.', '#ffc266');
INSERT INTO public."ScenarioStep" (id, "scenarioId", "stepIndex", year, month, label, "eventName", "eventDescription", "eventColor") VALUES (286, '2023_rate', 17, 2024, 11, 'Ноя 2024', NULL, NULL, NULL);
INSERT INTO public."ScenarioStep" (id, "scenarioId", "stepIndex", year, month, label, "eventName", "eventDescription", "eventColor") VALUES (287, '2023_rate', 18, 2024, 12, 'Дек 2024', NULL, NULL, NULL);
INSERT INTO public."ScenarioStep" (id, "scenarioId", "stepIndex", year, month, label, "eventName", "eventDescription", "eventColor") VALUES (288, '2023_rate', 19, 2025, 1, 'Янв 2025', NULL, NULL, NULL);
INSERT INTO public."ScenarioStep" (id, "scenarioId", "stepIndex", year, month, label, "eventName", "eventDescription", "eventColor") VALUES (289, '2023_rate', 20, 2025, 2, 'Фев 2025', NULL, NULL, NULL);
INSERT INTO public."ScenarioStep" (id, "scenarioId", "stepIndex", year, month, label, "eventName", "eventDescription", "eventColor") VALUES (290, '2023_rate', 21, 2025, 3, 'Мар 2025', NULL, NULL, NULL);
INSERT INTO public."ScenarioStep" (id, "scenarioId", "stepIndex", year, month, label, "eventName", "eventDescription", "eventColor") VALUES (291, '2023_rate', 22, 2025, 4, 'Апр 2025', NULL, NULL, NULL);
INSERT INTO public."ScenarioStep" (id, "scenarioId", "stepIndex", year, month, label, "eventName", "eventDescription", "eventColor") VALUES (292, '2023_rate', 23, 2025, 5, 'Май 2025', NULL, NULL, NULL);
INSERT INTO public."ScenarioStep" (id, "scenarioId", "stepIndex", year, month, label, "eventName", "eventDescription", "eventColor") VALUES (293, '2023_rate', 24, 2025, 6, 'Июн 2025', NULL, NULL, NULL);
INSERT INTO public."ScenarioStep" (id, "scenarioId", "stepIndex", year, month, label, "eventName", "eventDescription", "eventColor") VALUES (294, '2023_rate', 25, 2025, 7, 'Июл 2025', NULL, NULL, NULL);
INSERT INTO public."ScenarioStep" (id, "scenarioId", "stepIndex", year, month, label, "eventName", "eventDescription", "eventColor") VALUES (295, '2023_rate', 26, 2025, 8, 'Авг 2025', NULL, NULL, NULL);
INSERT INTO public."ScenarioStep" (id, "scenarioId", "stepIndex", year, month, label, "eventName", "eventDescription", "eventColor") VALUES (296, '2023_rate', 27, 2025, 9, 'Сен 2025', NULL, NULL, NULL);
INSERT INTO public."ScenarioStep" (id, "scenarioId", "stepIndex", year, month, label, "eventName", "eventDescription", "eventColor") VALUES (297, '2023_rate', 28, 2025, 10, 'Окт 2025', NULL, NULL, NULL);
INSERT INTO public."ScenarioStep" (id, "scenarioId", "stepIndex", year, month, label, "eventName", "eventDescription", "eventColor") VALUES (298, '2023_rate', 29, 2025, 11, 'Ноя 2025', NULL, NULL, NULL);
INSERT INTO public."ScenarioStep" (id, "scenarioId", "stepIndex", year, month, label, "eventName", "eventDescription", "eventColor") VALUES (299, '2023_rate', 30, 2025, 12, 'Дек 2025', NULL, NULL, NULL);
INSERT INTO public."ScenarioStep" (id, "scenarioId", "stepIndex", year, month, label, "eventName", "eventDescription", "eventColor") VALUES (300, '2023_rate', 31, 2026, 1, 'Янв 2026', NULL, NULL, NULL);
INSERT INTO public."ScenarioStep" (id, "scenarioId", "stepIndex", year, month, label, "eventName", "eventDescription", "eventColor") VALUES (301, '2023_rate', 32, 2026, 2, 'Фев 2026', NULL, NULL, NULL);
INSERT INTO public."ScenarioStep" (id, "scenarioId", "stepIndex", year, month, label, "eventName", "eventDescription", "eventColor") VALUES (302, '2023_rate', 33, 2026, 3, 'Мар 2026', NULL, NULL, NULL);
INSERT INTO public."ScenarioStep" (id, "scenarioId", "stepIndex", year, month, label, "eventName", "eventDescription", "eventColor") VALUES (303, '2023_rate', 34, 2026, 4, 'Апр 2026', NULL, NULL, NULL);


--
-- Data for Name: Stonk; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO public."Stonk" (id, ticker, name, sector, color) VALUES (1, 'SBER', 'Сбербанк', 'Банки', '#21A038');
INSERT INTO public."Stonk" (id, ticker, name, sector, color) VALUES (2, 'GAZP', 'Газпром', 'Нефть и газ', '#00A3E0');
INSERT INTO public."Stonk" (id, ticker, name, sector, color) VALUES (3, 'LKOH', 'Лукойл', 'Нефть и газ', '#E3000F');
INSERT INTO public."Stonk" (id, ticker, name, sector, color) VALUES (4, 'NVTK', 'Новатэк', 'Нефть и газ', '#003087');
INSERT INTO public."Stonk" (id, ticker, name, sector, color) VALUES (5, 'ROSN', 'Роснефть', 'Нефть и газ', '#FF6200');
INSERT INTO public."Stonk" (id, ticker, name, sector, color) VALUES (6, 'SNGS', 'Сургутнефтегаз', 'Нефть и газ', '#005BAB');
INSERT INTO public."Stonk" (id, ticker, name, sector, color) VALUES (7, 'TATN', 'Татнефть', 'Нефть и газ', '#006BB6');
INSERT INTO public."Stonk" (id, ticker, name, sector, color) VALUES (8, 'GMKN', 'Норникель', 'Металлы', '#8B7355');
INSERT INTO public."Stonk" (id, ticker, name, sector, color) VALUES (9, 'CHMF', 'Северсталь', 'Металлы', '#4B6FA5');
INSERT INTO public."Stonk" (id, ticker, name, sector, color) VALUES (10, 'NLMK', 'НЛМК', 'Металлы', '#1B4F8A');
INSERT INTO public."Stonk" (id, ticker, name, sector, color) VALUES (11, 'ALRS', 'Алроса', 'Металлы', '#0055A5');
INSERT INTO public."Stonk" (id, ticker, name, sector, color) VALUES (12, 'PLZL', 'Полюс', 'Металлы', '#C8A951');
INSERT INTO public."Stonk" (id, ticker, name, sector, color) VALUES (13, 'MGNT', 'Магнит', 'Ритейл', '#C01213');
INSERT INTO public."Stonk" (id, ticker, name, sector, color) VALUES (14, 'MOEX', 'Мосбиржа', 'Финансы', '#009688');
INSERT INTO public."Stonk" (id, ticker, name, sector, color) VALUES (15, 'VTBR', 'ВТБ', 'Банки', '#009FDF');
INSERT INTO public."Stonk" (id, ticker, name, sector, color) VALUES (16, 'AFLT', 'Аэрофлот', 'Транспорт', '#1D3A6B');
INSERT INTO public."Stonk" (id, ticker, name, sector, color) VALUES (17, 'MTSS', 'МТС', 'Телеком', '#E30613');
INSERT INTO public."Stonk" (id, ticker, name, sector, color) VALUES (18, 'IRAO', 'Интер РАО', 'Энергетика', '#2E7D32');


--
-- Data for Name: StonkUser; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO public."StonkUser" (id, "userId", "roomId", budget, "portfolioJson", "finalNetWorth") VALUES (1, 2, 1, 1000000, '{}', NULL);
INSERT INTO public."StonkUser" (id, "userId", "roomId", budget, "portfolioJson", "finalNetWorth") VALUES (2, 1, 2, 1000000, '{}', NULL);
INSERT INTO public."StonkUser" (id, "userId", "roomId", budget, "portfolioJson", "finalNetWorth") VALUES (3, 11, 3, 1000000, '{}', NULL);
INSERT INTO public."StonkUser" (id, "userId", "roomId", budget, "portfolioJson", "finalNetWorth") VALUES (5, 12, 4, 1000000, '{}', NULL);
INSERT INTO public."StonkUser" (id, "userId", "roomId", budget, "portfolioJson", "finalNetWorth") VALUES (4, 1, 4, 450867.8866666667, '{"SBER":{"ticker":"SBER","shares":1918,"avgBuyPrice":234.71}}', NULL);
INSERT INTO public."StonkUser" (id, "userId", "roomId", budget, "portfolioJson", "finalNetWorth") VALUES (15, 7, 8, 26665.63333333334, '{"GMKN":{"ticker":"GMKN","shares":24,"avgBuyPrice":20822},"__bondsValue__":500000}', NULL);
INSERT INTO public."StonkUser" (id, "userId", "roomId", budget, "portfolioJson", "finalNetWorth") VALUES (16, 1, 8, 15628.63999999998, '{"SBER":{"ticker":"SBER","shares":978,"avgBuyPrice":255.62},"__bondsValue__":750000}', NULL);
INSERT INTO public."StonkUser" (id, "userId", "roomId", budget, "portfolioJson", "finalNetWorth") VALUES (17, 7, 9, 1000000, '{}', NULL);
INSERT INTO public."StonkUser" (id, "userId", "roomId", budget, "portfolioJson", "finalNetWorth") VALUES (18, 20, 10, 1000000, '{}', NULL);
INSERT INTO public."StonkUser" (id, "userId", "roomId", budget, "portfolioJson", "finalNetWorth") VALUES (19, 1, 11, 5413.224999999995, '{"__bondsValue__":1057808}', NULL);
INSERT INTO public."StonkUser" (id, "userId", "roomId", budget, "portfolioJson", "finalNetWorth") VALUES (20, 1, 12, 1000000, '{}', NULL);
INSERT INTO public."StonkUser" (id, "userId", "roomId", budget, "portfolioJson", "finalNetWorth") VALUES (21, 7, 12, 1000000, '{}', NULL);
INSERT INTO public."StonkUser" (id, "userId", "roomId", budget, "portfolioJson", "finalNetWorth") VALUES (22, 1, 13, 1000000, '{}', NULL);
INSERT INTO public."StonkUser" (id, "userId", "roomId", budget, "portfolioJson", "finalNetWorth") VALUES (6, 13, 5, 1000000, '{}', NULL);
INSERT INTO public."StonkUser" (id, "userId", "roomId", budget, "portfolioJson", "finalNetWorth") VALUES (7, 14, 5, 3.639999999984866, '{"SBER":{"ticker":"SBER","shares":978,"avgBuyPrice":255.62}}', NULL);
INSERT INTO public."StonkUser" (id, "userId", "roomId", budget, "portfolioJson", "finalNetWorth") VALUES (9, 16, 5, 129.9200000000419, '{"NLMK":{"ticker":"NLMK","shares":5344,"avgBuyPrice":140.32}}', NULL);
INSERT INTO public."StonkUser" (id, "userId", "roomId", budget, "portfolioJson", "finalNetWorth") VALUES (8, 15, 5, 72, '{"ROSN":{"ticker":"ROSN","shares":1040,"avgBuyPrice":480.7}}', NULL);
INSERT INTO public."StonkUser" (id, "userId", "roomId", budget, "portfolioJson", "finalNetWorth") VALUES (10, 7, 6, 14.55999999993946, '{"SBER":{"ticker":"SBER","shares":3912,"avgBuyPrice":255.62}}', NULL);
INSERT INTO public."StonkUser" (id, "userId", "roomId", budget, "portfolioJson", "finalNetWorth") VALUES (12, 18, 6, 1005208.333333333, '{}', NULL);
INSERT INTO public."StonkUser" (id, "userId", "roomId", budget, "portfolioJson", "finalNetWorth") VALUES (23, 24, 14, 4, '{"SBER":{"ticker":"SBER","shares":4175,"avgBuyPrice":239.52},"__bondsValue__":0}', NULL);
INSERT INTO public."StonkUser" (id, "userId", "roomId", budget, "portfolioJson", "finalNetWorth") VALUES (11, 17, 6, 1002604.166666667, '{}', NULL);
INSERT INTO public."StonkUser" (id, "userId", "roomId", budget, "portfolioJson", "finalNetWorth") VALUES (24, 11, 14, 3.159999999976717, '{"GAZP":{"ticker":"GAZP","shares":5991,"avgBuyPrice":166.9},"__bondsValue__":102}', NULL);
INSERT INTO public."StonkUser" (id, "userId", "roomId", budget, "portfolioJson", "finalNetWorth") VALUES (25, 11, 15, 1000000, '{}', NULL);
INSERT INTO public."StonkUser" (id, "userId", "roomId", budget, "portfolioJson", "finalNetWorth") VALUES (26, 1, 16, 1000000, '{"__bondsValue__":0}', NULL);
INSERT INTO public."StonkUser" (id, "userId", "roomId", budget, "portfolioJson", "finalNetWorth") VALUES (13, 1, 7, 1000000, '{}', NULL);
INSERT INTO public."StonkUser" (id, "userId", "roomId", budget, "portfolioJson", "finalNetWorth") VALUES (14, 7, 7, 1000000, '{}', NULL);


--
-- Data for Name: User; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO public."User" (id, username, "createdAt") VALUES (1, '123', '2026-04-02 07:31:05.836');
INSERT INTO public."User" (id, username, "createdAt") VALUES (2, '213', '2026-04-02 07:36:16.632');
INSERT INTO public."User" (id, username, "createdAt") VALUES (3, '312', '2026-04-02 07:52:44.875');
INSERT INTO public."User" (id, username, "createdAt") VALUES (4, '22', '2026-04-02 07:54:58.406');
INSERT INTO public."User" (id, username, "createdAt") VALUES (5, '3312', '2026-04-02 07:55:13.263');
INSERT INTO public."User" (id, username, "createdAt") VALUES (6, 'Трейдер', '2026-04-02 08:05:45.275');
INSERT INTO public."User" (id, username, "createdAt") VALUES (7, '321', '2026-04-02 08:21:46.347');
INSERT INTO public."User" (id, username, "createdAt") VALUES (8, 'fd', '2026-04-02 08:51:17.64');
INSERT INTO public."User" (id, username, "createdAt") VALUES (9, 'sad', '2026-04-02 10:39:43.985');
INSERT INTO public."User" (id, username, "createdAt") VALUES (10, 'апап', '2026-04-02 10:49:19.191');
INSERT INTO public."User" (id, username, "createdAt") VALUES (11, 'ап', '2026-04-02 10:52:34.279');
INSERT INTO public."User" (id, username, "createdAt") VALUES (12, 'Sdad', '2026-04-02 11:43:53.018');
INSERT INTO public."User" (id, username, "createdAt") VALUES (13, 'Wooler', '2026-04-02 12:00:22.782');
INSERT INTO public."User" (id, username, "createdAt") VALUES (14, 'hotzi', '2026-04-02 12:00:29.568');
INSERT INTO public."User" (id, username, "createdAt") VALUES (15, 'penis', '2026-04-02 12:00:37.331');
INSERT INTO public."User" (id, username, "createdAt") VALUES (16, 'chlenis', '2026-04-02 12:00:45.09');
INSERT INTO public."User" (id, username, "createdAt") VALUES (17, '312312', '2026-04-02 12:09:52.604');
INSERT INTO public."User" (id, username, "createdAt") VALUES (18, 'SAuidasf', '2026-04-02 12:10:00.941');
INSERT INTO public."User" (id, username, "createdAt") VALUES (19, 'п', '2026-04-02 12:31:52.935');
INSERT INTO public."User" (id, username, "createdAt") VALUES (20, '123323', '2026-04-02 12:32:24.219');
INSERT INTO public."User" (id, username, "createdAt") VALUES (21, '1123', '2026-04-02 12:39:01.013');
INSERT INTO public."User" (id, username, "createdAt") VALUES (22, 'лавп', '2026-04-02 12:51:49.152');
INSERT INTO public."User" (id, username, "createdAt") VALUES (23, 'мр', '2026-04-02 12:52:05.836');
INSERT INTO public."User" (id, username, "createdAt") VALUES (24, 'пр', '2026-04-02 12:52:18.918');
INSERT INTO public."User" (id, username, "createdAt") VALUES (25, 'прр', '2026-04-02 13:00:07.951');
INSERT INTO public."User" (id, username, "createdAt") VALUES (26, 'см', '2026-04-02 13:01:54.017');
INSERT INTO public."User" (id, username, "createdAt") VALUES (27, 'soldatka', '2026-04-02 13:13:21.422');
INSERT INTO public."User" (id, username, "createdAt") VALUES (28, 'Soldatka', '2026-04-02 13:14:05.35');
INSERT INTO public."User" (id, username, "createdAt") VALUES (29, 'ва', '2026-04-02 13:21:39.834');
INSERT INTO public."User" (id, username, "createdAt") VALUES (30, 'аав', '2026-04-02 13:42:03.39');
INSERT INTO public."User" (id, username, "createdAt") VALUES (31, '13', '2026-04-02 14:21:17.474');


--
-- Data for Name: dividend; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO public.dividend (id, ticker, year, month, currency, source, payment_date, per_share) VALUES (1, 'SBER', 2019, 6, 'RUB', 'moex', '2019-06-13 00:00:00', 16);
INSERT INTO public.dividend (id, ticker, year, month, currency, source, payment_date, per_share) VALUES (2, 'SBER', 2020, 10, 'RUB', 'moex', '2020-10-05 00:00:00', 18.7);
INSERT INTO public.dividend (id, ticker, year, month, currency, source, payment_date, per_share) VALUES (3, 'SBER', 2021, 5, 'RUB', 'moex', '2021-05-12 00:00:00', 18.7);
INSERT INTO public.dividend (id, ticker, year, month, currency, source, payment_date, per_share) VALUES (4, 'SBER', 2023, 5, 'RUB', 'moex', '2023-05-11 00:00:00', 25);
INSERT INTO public.dividend (id, ticker, year, month, currency, source, payment_date, per_share) VALUES (5, 'SBER', 2024, 7, 'RUB', 'moex', '2024-07-11 00:00:00', 33.3);
INSERT INTO public.dividend (id, ticker, year, month, currency, source, payment_date, per_share) VALUES (6, 'SBER', 2025, 7, 'RUB', 'moex', '2025-07-18 00:00:00', 34.84);
INSERT INTO public.dividend (id, ticker, year, month, currency, source, payment_date, per_share) VALUES (7, 'GAZP', 2014, 7, 'RUB', 'moex', '2014-07-17 00:00:00', 7.2);
INSERT INTO public.dividend (id, ticker, year, month, currency, source, payment_date, per_share) VALUES (8, 'GAZP', 2015, 7, 'RUB', 'moex', '2015-07-16 00:00:00', 7.2);
INSERT INTO public.dividend (id, ticker, year, month, currency, source, payment_date, per_share) VALUES (9, 'GAZP', 2016, 7, 'RUB', 'moex', '2016-07-20 00:00:00', 7.89);
INSERT INTO public.dividend (id, ticker, year, month, currency, source, payment_date, per_share) VALUES (10, 'GAZP', 2017, 7, 'RUB', 'moex', '2017-07-20 00:00:00', 8.04);
INSERT INTO public.dividend (id, ticker, year, month, currency, source, payment_date, per_share) VALUES (11, 'GAZP', 2018, 7, 'RUB', 'moex', '2018-07-19 00:00:00', 8.04);
INSERT INTO public.dividend (id, ticker, year, month, currency, source, payment_date, per_share) VALUES (12, 'GAZP', 2019, 7, 'RUB', 'moex', '2019-07-18 00:00:00', 16.61);
INSERT INTO public.dividend (id, ticker, year, month, currency, source, payment_date, per_share) VALUES (13, 'GAZP', 2020, 7, 'RUB', 'moex', '2020-07-16 00:00:00', 15.24);
INSERT INTO public.dividend (id, ticker, year, month, currency, source, payment_date, per_share) VALUES (14, 'GAZP', 2021, 7, 'RUB', 'moex', '2021-07-15 00:00:00', 12.55);
INSERT INTO public.dividend (id, ticker, year, month, currency, source, payment_date, per_share) VALUES (15, 'GAZP', 2022, 7, 'RUB', 'moex', '2022-07-20 00:00:00', 52.53);
INSERT INTO public.dividend (id, ticker, year, month, currency, source, payment_date, per_share) VALUES (16, 'GAZP', 2022, 10, 'RUB', 'moex', '2022-10-11 00:00:00', 51.03);
INSERT INTO public.dividend (id, ticker, year, month, currency, source, payment_date, per_share) VALUES (17, 'LKOH', 2013, 8, 'RUB', 'moex', '2013-08-15 00:00:00', 50);
INSERT INTO public.dividend (id, ticker, year, month, currency, source, payment_date, per_share) VALUES (18, 'LKOH', 2014, 7, 'RUB', 'moex', '2014-07-15 00:00:00', 60);
INSERT INTO public.dividend (id, ticker, year, month, currency, source, payment_date, per_share) VALUES (19, 'LKOH', 2014, 12, 'RUB', 'moex', '2014-12-26 00:00:00', 60);
INSERT INTO public.dividend (id, ticker, year, month, currency, source, payment_date, per_share) VALUES (20, 'LKOH', 2015, 4, 'RUB', 'moex', '2015-04-28 00:00:00', 94);
INSERT INTO public.dividend (id, ticker, year, month, currency, source, payment_date, per_share) VALUES (21, 'LKOH', 2015, 7, 'RUB', 'moex', '2015-07-14 00:00:00', 94);
INSERT INTO public.dividend (id, ticker, year, month, currency, source, payment_date, per_share) VALUES (22, 'LKOH', 2015, 7, 'RUB', 'moex', '2015-07-17 00:00:00', 94);
INSERT INTO public.dividend (id, ticker, year, month, currency, source, payment_date, per_share) VALUES (23, 'LKOH', 2015, 12, 'RUB', 'moex', '2015-12-24 00:00:00', 65);
INSERT INTO public.dividend (id, ticker, year, month, currency, source, payment_date, per_share) VALUES (24, 'LKOH', 2016, 7, 'RUB', 'moex', '2016-07-12 00:00:00', 112);
INSERT INTO public.dividend (id, ticker, year, month, currency, source, payment_date, per_share) VALUES (25, 'LKOH', 2016, 12, 'RUB', 'moex', '2016-12-23 00:00:00', 75);
INSERT INTO public.dividend (id, ticker, year, month, currency, source, payment_date, per_share) VALUES (26, 'LKOH', 2017, 7, 'RUB', 'moex', '2017-07-10 00:00:00', 120);
INSERT INTO public.dividend (id, ticker, year, month, currency, source, payment_date, per_share) VALUES (27, 'LKOH', 2017, 12, 'RUB', 'moex', '2017-12-22 00:00:00', 85);
INSERT INTO public.dividend (id, ticker, year, month, currency, source, payment_date, per_share) VALUES (28, 'LKOH', 2018, 7, 'RUB', 'moex', '2018-07-11 00:00:00', 130);
INSERT INTO public.dividend (id, ticker, year, month, currency, source, payment_date, per_share) VALUES (29, 'LKOH', 2018, 12, 'RUB', 'moex', '2018-12-21 00:00:00', 95);
INSERT INTO public.dividend (id, ticker, year, month, currency, source, payment_date, per_share) VALUES (30, 'LKOH', 2019, 7, 'RUB', 'moex', '2019-07-09 00:00:00', 155);
INSERT INTO public.dividend (id, ticker, year, month, currency, source, payment_date, per_share) VALUES (31, 'LKOH', 2019, 12, 'RUB', 'moex', '2019-12-20 00:00:00', 192);
INSERT INTO public.dividend (id, ticker, year, month, currency, source, payment_date, per_share) VALUES (32, 'LKOH', 2020, 7, 'RUB', 'moex', '2020-07-10 00:00:00', 350);
INSERT INTO public.dividend (id, ticker, year, month, currency, source, payment_date, per_share) VALUES (33, 'LKOH', 2020, 12, 'RUB', 'moex', '2020-12-18 00:00:00', 46);
INSERT INTO public.dividend (id, ticker, year, month, currency, source, payment_date, per_share) VALUES (34, 'LKOH', 2021, 7, 'RUB', 'moex', '2021-07-05 00:00:00', 213);
INSERT INTO public.dividend (id, ticker, year, month, currency, source, payment_date, per_share) VALUES (35, 'LKOH', 2021, 12, 'RUB', 'moex', '2021-12-21 00:00:00', 340);
INSERT INTO public.dividend (id, ticker, year, month, currency, source, payment_date, per_share) VALUES (36, 'LKOH', 2022, 12, 'RUB', 'moex', '2022-12-21 00:00:00', 537);
INSERT INTO public.dividend (id, ticker, year, month, currency, source, payment_date, per_share) VALUES (37, 'LKOH', 2023, 6, 'RUB', 'moex', '2023-06-05 00:00:00', 438);
INSERT INTO public.dividend (id, ticker, year, month, currency, source, payment_date, per_share) VALUES (38, 'LKOH', 2023, 12, 'RUB', 'moex', '2023-12-17 00:00:00', 447);
INSERT INTO public.dividend (id, ticker, year, month, currency, source, payment_date, per_share) VALUES (39, 'LKOH', 2024, 5, 'RUB', 'moex', '2024-05-07 00:00:00', 498);
INSERT INTO public.dividend (id, ticker, year, month, currency, source, payment_date, per_share) VALUES (40, 'LKOH', 2024, 12, 'RUB', 'moex', '2024-12-17 00:00:00', 514);
INSERT INTO public.dividend (id, ticker, year, month, currency, source, payment_date, per_share) VALUES (41, 'LKOH', 2025, 6, 'RUB', 'moex', '2025-06-03 00:00:00', 541);
INSERT INTO public.dividend (id, ticker, year, month, currency, source, payment_date, per_share) VALUES (42, 'NVTK', 2018, 10, 'RUB', 'moex', '2018-10-10 00:00:00', 9.25);
INSERT INTO public.dividend (id, ticker, year, month, currency, source, payment_date, per_share) VALUES (43, 'NVTK', 2019, 5, 'RUB', 'moex', '2019-05-06 00:00:00', 16.81);
INSERT INTO public.dividend (id, ticker, year, month, currency, source, payment_date, per_share) VALUES (44, 'NVTK', 2019, 10, 'RUB', 'moex', '2019-10-10 00:00:00', 14.23);
INSERT INTO public.dividend (id, ticker, year, month, currency, source, payment_date, per_share) VALUES (45, 'NVTK', 2020, 5, 'RUB', 'moex', '2020-05-08 00:00:00', 18.1);
INSERT INTO public.dividend (id, ticker, year, month, currency, source, payment_date, per_share) VALUES (46, 'NVTK', 2020, 10, 'RUB', 'moex', '2020-10-12 00:00:00', 11.82);
INSERT INTO public.dividend (id, ticker, year, month, currency, source, payment_date, per_share) VALUES (47, 'NVTK', 2021, 5, 'RUB', 'moex', '2021-05-07 00:00:00', 23.74);
INSERT INTO public.dividend (id, ticker, year, month, currency, source, payment_date, per_share) VALUES (48, 'NVTK', 2021, 10, 'RUB', 'moex', '2021-10-11 00:00:00', 27.67);
INSERT INTO public.dividend (id, ticker, year, month, currency, source, payment_date, per_share) VALUES (49, 'NVTK', 2022, 5, 'RUB', 'moex', '2022-05-05 00:00:00', 43.77);
INSERT INTO public.dividend (id, ticker, year, month, currency, source, payment_date, per_share) VALUES (50, 'NVTK', 2022, 10, 'RUB', 'moex', '2022-10-09 00:00:00', 45);
INSERT INTO public.dividend (id, ticker, year, month, currency, source, payment_date, per_share) VALUES (51, 'NVTK', 2023, 5, 'RUB', 'moex', '2023-05-03 00:00:00', 60.58);
INSERT INTO public.dividend (id, ticker, year, month, currency, source, payment_date, per_share) VALUES (52, 'NVTK', 2023, 10, 'RUB', 'moex', '2023-10-10 00:00:00', 34.5);
INSERT INTO public.dividend (id, ticker, year, month, currency, source, payment_date, per_share) VALUES (53, 'NVTK', 2024, 3, 'RUB', 'moex', '2024-03-26 00:00:00', 44.09);
INSERT INTO public.dividend (id, ticker, year, month, currency, source, payment_date, per_share) VALUES (54, 'NVTK', 2024, 10, 'RUB', 'moex', '2024-10-11 00:00:00', 35.5);
INSERT INTO public.dividend (id, ticker, year, month, currency, source, payment_date, per_share) VALUES (55, 'NVTK', 2025, 4, 'RUB', 'moex', '2025-04-28 00:00:00', 46.65);
INSERT INTO public.dividend (id, ticker, year, month, currency, source, payment_date, per_share) VALUES (56, 'ROSN', 2014, 7, 'RUB', 'moex', '2014-07-08 00:00:00', 12.85);
INSERT INTO public.dividend (id, ticker, year, month, currency, source, payment_date, per_share) VALUES (57, 'ROSN', 2015, 6, 'RUB', 'moex', '2015-06-29 00:00:00', 8.21);
INSERT INTO public.dividend (id, ticker, year, month, currency, source, payment_date, per_share) VALUES (58, 'ROSN', 2016, 6, 'RUB', 'moex', '2016-06-27 00:00:00', 11.75);
INSERT INTO public.dividend (id, ticker, year, month, currency, source, payment_date, per_share) VALUES (59, 'ROSN', 2017, 7, 'RUB', 'moex', '2017-07-03 00:00:00', 5.98);
INSERT INTO public.dividend (id, ticker, year, month, currency, source, payment_date, per_share) VALUES (60, 'ROSN', 2017, 10, 'RUB', 'moex', '2017-10-10 00:00:00', 3.83);
INSERT INTO public.dividend (id, ticker, year, month, currency, source, payment_date, per_share) VALUES (61, 'ROSN', 2018, 7, 'RUB', 'moex', '2018-07-02 00:00:00', 6.65);
INSERT INTO public.dividend (id, ticker, year, month, currency, source, payment_date, per_share) VALUES (62, 'ROSN', 2018, 10, 'RUB', 'moex', '2018-10-09 00:00:00', 14.58);
INSERT INTO public.dividend (id, ticker, year, month, currency, source, payment_date, per_share) VALUES (63, 'ROSN', 2019, 6, 'RUB', 'moex', '2019-06-17 00:00:00', 11.33);
INSERT INTO public.dividend (id, ticker, year, month, currency, source, payment_date, per_share) VALUES (64, 'ROSN', 2019, 10, 'RUB', 'moex', '2019-10-11 00:00:00', 15.34);
INSERT INTO public.dividend (id, ticker, year, month, currency, source, payment_date, per_share) VALUES (65, 'ROSN', 2020, 6, 'RUB', 'moex', '2020-06-15 00:00:00', 18.07);
INSERT INTO public.dividend (id, ticker, year, month, currency, source, payment_date, per_share) VALUES (66, 'ROSN', 2021, 6, 'RUB', 'moex', '2021-06-15 00:00:00', 6.94);
INSERT INTO public.dividend (id, ticker, year, month, currency, source, payment_date, per_share) VALUES (67, 'ROSN', 2021, 10, 'RUB', 'moex', '2021-10-11 00:00:00', 18.03);
INSERT INTO public.dividend (id, ticker, year, month, currency, source, payment_date, per_share) VALUES (68, 'ROSN', 2022, 7, 'RUB', 'moex', '2022-07-11 00:00:00', 23.63);
INSERT INTO public.dividend (id, ticker, year, month, currency, source, payment_date, per_share) VALUES (69, 'ROSN', 2023, 1, 'RUB', 'moex', '2023-01-12 00:00:00', 20.39);
INSERT INTO public.dividend (id, ticker, year, month, currency, source, payment_date, per_share) VALUES (70, 'ROSN', 2023, 7, 'RUB', 'moex', '2023-07-11 00:00:00', 17.97);
INSERT INTO public.dividend (id, ticker, year, month, currency, source, payment_date, per_share) VALUES (71, 'ROSN', 2024, 1, 'RUB', 'moex', '2024-01-11 00:00:00', 30.77);
INSERT INTO public.dividend (id, ticker, year, month, currency, source, payment_date, per_share) VALUES (72, 'ROSN', 2024, 7, 'RUB', 'moex', '2024-07-09 00:00:00', 29.01);
INSERT INTO public.dividend (id, ticker, year, month, currency, source, payment_date, per_share) VALUES (73, 'ROSN', 2025, 1, 'RUB', 'moex', '2025-01-10 00:00:00', 36.47);
INSERT INTO public.dividend (id, ticker, year, month, currency, source, payment_date, per_share) VALUES (74, 'ROSN', 2025, 7, 'RUB', 'moex', '2025-07-20 00:00:00', 14.68);
INSERT INTO public.dividend (id, ticker, year, month, currency, source, payment_date, per_share) VALUES (75, 'SNGS', 2014, 7, 'RUB', 'moex', '2014-07-16 00:00:00', 0.6);
INSERT INTO public.dividend (id, ticker, year, month, currency, source, payment_date, per_share) VALUES (76, 'SNGS', 2015, 7, 'RUB', 'moex', '2015-07-16 00:00:00', 0.65);
INSERT INTO public.dividend (id, ticker, year, month, currency, source, payment_date, per_share) VALUES (77, 'SNGS', 2016, 7, 'RUB', 'moex', '2016-07-18 00:00:00', 0.6);
INSERT INTO public.dividend (id, ticker, year, month, currency, source, payment_date, per_share) VALUES (78, 'SNGS', 2017, 7, 'RUB', 'moex', '2017-07-19 00:00:00', 0.6);
INSERT INTO public.dividend (id, ticker, year, month, currency, source, payment_date, per_share) VALUES (79, 'SNGS', 2018, 7, 'RUB', 'moex', '2018-07-19 00:00:00', 0.65);
INSERT INTO public.dividend (id, ticker, year, month, currency, source, payment_date, per_share) VALUES (80, 'SNGS', 2019, 7, 'RUB', 'moex', '2019-07-18 00:00:00', 0.65);
INSERT INTO public.dividend (id, ticker, year, month, currency, source, payment_date, per_share) VALUES (81, 'SNGS', 2020, 7, 'RUB', 'moex', '2020-07-20 00:00:00', 0.65);
INSERT INTO public.dividend (id, ticker, year, month, currency, source, payment_date, per_share) VALUES (82, 'SNGS', 2021, 7, 'RUB', 'moex', '2021-07-20 00:00:00', 0.7);
INSERT INTO public.dividend (id, ticker, year, month, currency, source, payment_date, per_share) VALUES (83, 'SNGS', 2022, 7, 'RUB', 'moex', '2022-07-20 00:00:00', 0.8);
INSERT INTO public.dividend (id, ticker, year, month, currency, source, payment_date, per_share) VALUES (84, 'SNGS', 2023, 7, 'RUB', 'moex', '2023-07-20 00:00:00', 0.8);
INSERT INTO public.dividend (id, ticker, year, month, currency, source, payment_date, per_share) VALUES (85, 'SNGS', 2024, 7, 'RUB', 'moex', '2024-07-18 00:00:00', 0.85);
INSERT INTO public.dividend (id, ticker, year, month, currency, source, payment_date, per_share) VALUES (86, 'SNGS', 2025, 7, 'RUB', 'moex', '2025-07-17 00:00:00', 0.9);
INSERT INTO public.dividend (id, ticker, year, month, currency, source, payment_date, per_share) VALUES (87, 'TATN', 2018, 7, 'RUB', 'moex', '2018-07-06 00:00:00', 12.16);
INSERT INTO public.dividend (id, ticker, year, month, currency, source, payment_date, per_share) VALUES (88, 'TATN', 2018, 10, 'RUB', 'moex', '2018-10-12 00:00:00', 30.27);
INSERT INTO public.dividend (id, ticker, year, month, currency, source, payment_date, per_share) VALUES (89, 'TATN', 2019, 1, 'RUB', 'moex', '2019-01-09 00:00:00', 22.26);
INSERT INTO public.dividend (id, ticker, year, month, currency, source, payment_date, per_share) VALUES (90, 'TATN', 2019, 7, 'RUB', 'moex', '2019-07-05 00:00:00', 32.38);
INSERT INTO public.dividend (id, ticker, year, month, currency, source, payment_date, per_share) VALUES (91, 'TATN', 2019, 9, 'RUB', 'moex', '2019-09-27 00:00:00', 40.11);
INSERT INTO public.dividend (id, ticker, year, month, currency, source, payment_date, per_share) VALUES (92, 'TATN', 2019, 12, 'RUB', 'moex', '2019-12-30 00:00:00', 24.36);
INSERT INTO public.dividend (id, ticker, year, month, currency, source, payment_date, per_share) VALUES (93, 'TATN', 2020, 10, 'RUB', 'moex', '2020-10-12 00:00:00', 9.94);
INSERT INTO public.dividend (id, ticker, year, month, currency, source, payment_date, per_share) VALUES (94, 'TATN', 2021, 7, 'RUB', 'moex', '2021-07-09 00:00:00', 12.3);
INSERT INTO public.dividend (id, ticker, year, month, currency, source, payment_date, per_share) VALUES (95, 'TATN', 2021, 10, 'RUB', 'moex', '2021-10-12 00:00:00', 16.52);
INSERT INTO public.dividend (id, ticker, year, month, currency, source, payment_date, per_share) VALUES (96, 'TATN', 2022, 1, 'RUB', 'moex', '2022-01-10 00:00:00', 9.98);
INSERT INTO public.dividend (id, ticker, year, month, currency, source, payment_date, per_share) VALUES (97, 'TATN', 2022, 7, 'RUB', 'moex', '2022-07-08 00:00:00', 16.14);
INSERT INTO public.dividend (id, ticker, year, month, currency, source, payment_date, per_share) VALUES (98, 'TATN', 2022, 10, 'RUB', 'moex', '2022-10-11 00:00:00', 32.71);
INSERT INTO public.dividend (id, ticker, year, month, currency, source, payment_date, per_share) VALUES (99, 'TATN', 2023, 1, 'RUB', 'moex', '2023-01-10 00:00:00', 6.86);
INSERT INTO public.dividend (id, ticker, year, month, currency, source, payment_date, per_share) VALUES (100, 'TATN', 2023, 7, 'RUB', 'moex', '2023-07-04 00:00:00', 27.71);
INSERT INTO public.dividend (id, ticker, year, month, currency, source, payment_date, per_share) VALUES (101, 'TATN', 2023, 7, 'RUB', 'moex', '2023-07-11 00:00:00', 27.71);
INSERT INTO public.dividend (id, ticker, year, month, currency, source, payment_date, per_share) VALUES (102, 'TATN', 2023, 10, 'RUB', 'moex', '2023-10-11 00:00:00', 27.54);
INSERT INTO public.dividend (id, ticker, year, month, currency, source, payment_date, per_share) VALUES (103, 'TATN', 2024, 1, 'RUB', 'moex', '2024-01-09 00:00:00', 35.17);
INSERT INTO public.dividend (id, ticker, year, month, currency, source, payment_date, per_share) VALUES (104, 'TATN', 2024, 7, 'RUB', 'moex', '2024-07-04 00:00:00', 25.17);
INSERT INTO public.dividend (id, ticker, year, month, currency, source, payment_date, per_share) VALUES (105, 'TATN', 2024, 7, 'RUB', 'moex', '2024-07-09 00:00:00', 25.17);
INSERT INTO public.dividend (id, ticker, year, month, currency, source, payment_date, per_share) VALUES (106, 'TATN', 2024, 10, 'RUB', 'moex', '2024-10-08 00:00:00', 38.2);
INSERT INTO public.dividend (id, ticker, year, month, currency, source, payment_date, per_share) VALUES (107, 'TATN', 2025, 1, 'RUB', 'moex', '2025-01-08 00:00:00', 17.39);
INSERT INTO public.dividend (id, ticker, year, month, currency, source, payment_date, per_share) VALUES (108, 'TATN', 2025, 6, 'RUB', 'moex', '2025-06-02 00:00:00', 43.11);
INSERT INTO public.dividend (id, ticker, year, month, currency, source, payment_date, per_share) VALUES (109, 'GMKN', 2013, 11, 'RUB', 'moex', '2013-11-01 00:00:00', 220.7);
INSERT INTO public.dividend (id, ticker, year, month, currency, source, payment_date, per_share) VALUES (110, 'GMKN', 2014, 6, 'RUB', 'moex', '2014-06-17 00:00:00', 248.48);
INSERT INTO public.dividend (id, ticker, year, month, currency, source, payment_date, per_share) VALUES (111, 'GMKN', 2014, 12, 'RUB', 'moex', '2014-12-22 00:00:00', 762.34);
INSERT INTO public.dividend (id, ticker, year, month, currency, source, payment_date, per_share) VALUES (112, 'GMKN', 2015, 5, 'RUB', 'moex', '2015-05-25 00:00:00', 670.04);
INSERT INTO public.dividend (id, ticker, year, month, currency, source, payment_date, per_share) VALUES (113, 'GMKN', 2015, 9, 'RUB', 'moex', '2015-09-25 00:00:00', 305.07);
INSERT INTO public.dividend (id, ticker, year, month, currency, source, payment_date, per_share) VALUES (114, 'GMKN', 2015, 12, 'RUB', 'moex', '2015-12-30 00:00:00', 321.95);
INSERT INTO public.dividend (id, ticker, year, month, currency, source, payment_date, per_share) VALUES (115, 'GMKN', 2016, 6, 'RUB', 'moex', '2016-06-21 00:00:00', 230.14);
INSERT INTO public.dividend (id, ticker, year, month, currency, source, payment_date, per_share) VALUES (116, 'GMKN', 2016, 12, 'RUB', 'moex', '2016-12-28 00:00:00', 444.25);
INSERT INTO public.dividend (id, ticker, year, month, currency, source, payment_date, per_share) VALUES (117, 'GMKN', 2017, 6, 'RUB', 'moex', '2017-06-23 00:00:00', 446.1);
INSERT INTO public.dividend (id, ticker, year, month, currency, source, payment_date, per_share) VALUES (118, 'GMKN', 2017, 10, 'RUB', 'moex', '2017-10-19 00:00:00', 224.2);
INSERT INTO public.dividend (id, ticker, year, month, currency, source, payment_date, per_share) VALUES (119, 'GMKN', 2018, 7, 'RUB', 'moex', '2018-07-17 00:00:00', 607.98);
INSERT INTO public.dividend (id, ticker, year, month, currency, source, payment_date, per_share) VALUES (120, 'GMKN', 2018, 10, 'RUB', 'moex', '2018-10-01 00:00:00', 776.02);
INSERT INTO public.dividend (id, ticker, year, month, currency, source, payment_date, per_share) VALUES (121, 'GMKN', 2019, 6, 'RUB', 'moex', '2019-06-21 00:00:00', 792.52);
INSERT INTO public.dividend (id, ticker, year, month, currency, source, payment_date, per_share) VALUES (122, 'GMKN', 2019, 10, 'RUB', 'moex', '2019-10-07 00:00:00', 883.93);
INSERT INTO public.dividend (id, ticker, year, month, currency, source, payment_date, per_share) VALUES (123, 'GMKN', 2019, 12, 'RUB', 'moex', '2019-12-27 00:00:00', 604.09);
INSERT INTO public.dividend (id, ticker, year, month, currency, source, payment_date, per_share) VALUES (124, 'GMKN', 2020, 5, 'RUB', 'moex', '2020-05-25 00:00:00', 557.2);
INSERT INTO public.dividend (id, ticker, year, month, currency, source, payment_date, per_share) VALUES (125, 'GMKN', 2020, 12, 'RUB', 'moex', '2020-12-24 00:00:00', 623.35);
INSERT INTO public.dividend (id, ticker, year, month, currency, source, payment_date, per_share) VALUES (126, 'GMKN', 2021, 6, 'RUB', 'moex', '2021-06-01 00:00:00', 1021.22);
INSERT INTO public.dividend (id, ticker, year, month, currency, source, payment_date, per_share) VALUES (127, 'GMKN', 2022, 1, 'RUB', 'moex', '2022-01-14 00:00:00', 1523.17);
INSERT INTO public.dividend (id, ticker, year, month, currency, source, payment_date, per_share) VALUES (128, 'GMKN', 2022, 6, 'RUB', 'moex', '2022-06-14 00:00:00', 1166.22);
INSERT INTO public.dividend (id, ticker, year, month, currency, source, payment_date, per_share) VALUES (129, 'GMKN', 2023, 12, 'RUB', 'moex', '2023-12-26 00:00:00', 915.33);
INSERT INTO public.dividend (id, ticker, year, month, currency, source, payment_date, per_share) VALUES (130, 'CHMF', 2013, 8, 'RUB', 'moex', '2013-08-12 00:00:00', 2.03);
INSERT INTO public.dividend (id, ticker, year, month, currency, source, payment_date, per_share) VALUES (131, 'CHMF', 2013, 10, 'RUB', 'moex', '2013-10-31 00:00:00', 2.01);
INSERT INTO public.dividend (id, ticker, year, month, currency, source, payment_date, per_share) VALUES (132, 'CHMF', 2014, 6, 'RUB', 'moex', '2014-06-23 00:00:00', 2.43);
INSERT INTO public.dividend (id, ticker, year, month, currency, source, payment_date, per_share) VALUES (133, 'CHMF', 2014, 9, 'RUB', 'moex', '2014-09-22 00:00:00', 2.14);
INSERT INTO public.dividend (id, ticker, year, month, currency, source, payment_date, per_share) VALUES (134, 'CHMF', 2014, 11, 'RUB', 'moex', '2014-11-25 00:00:00', 54.46);
INSERT INTO public.dividend (id, ticker, year, month, currency, source, payment_date, per_share) VALUES (135, 'CHMF', 2015, 6, 'RUB', 'moex', '2015-06-05 00:00:00', 12.81);
INSERT INTO public.dividend (id, ticker, year, month, currency, source, payment_date, per_share) VALUES (136, 'CHMF', 2015, 9, 'RUB', 'moex', '2015-09-28 00:00:00', 12.63);
INSERT INTO public.dividend (id, ticker, year, month, currency, source, payment_date, per_share) VALUES (137, 'CHMF', 2015, 12, 'RUB', 'moex', '2015-12-21 00:00:00', 13.17);
INSERT INTO public.dividend (id, ticker, year, month, currency, source, payment_date, per_share) VALUES (138, 'CHMF', 2016, 7, 'RUB', 'moex', '2016-07-05 00:00:00', 8.25);
INSERT INTO public.dividend (id, ticker, year, month, currency, source, payment_date, per_share) VALUES (139, 'CHMF', 2016, 9, 'RUB', 'moex', '2016-09-02 00:00:00', 19.66);
INSERT INTO public.dividend (id, ticker, year, month, currency, source, payment_date, per_share) VALUES (140, 'CHMF', 2016, 9, 'RUB', 'moex', '2016-09-16 00:00:00', 19.66);
INSERT INTO public.dividend (id, ticker, year, month, currency, source, payment_date, per_share) VALUES (141, 'CHMF', 2016, 12, 'RUB', 'moex', '2016-12-13 00:00:00', 24.96);
INSERT INTO public.dividend (id, ticker, year, month, currency, source, payment_date, per_share) VALUES (142, 'CHMF', 2017, 6, 'RUB', 'moex', '2017-06-20 00:00:00', 24.44);
INSERT INTO public.dividend (id, ticker, year, month, currency, source, payment_date, per_share) VALUES (143, 'CHMF', 2017, 9, 'RUB', 'moex', '2017-09-26 00:00:00', 22.28);
INSERT INTO public.dividend (id, ticker, year, month, currency, source, payment_date, per_share) VALUES (144, 'CHMF', 2017, 12, 'RUB', 'moex', '2017-12-05 00:00:00', 35.61);
INSERT INTO public.dividend (id, ticker, year, month, currency, source, payment_date, per_share) VALUES (145, 'CHMF', 2018, 6, 'RUB', 'moex', '2018-06-19 00:00:00', 38.32);
INSERT INTO public.dividend (id, ticker, year, month, currency, source, payment_date, per_share) VALUES (146, 'CHMF', 2018, 9, 'RUB', 'moex', '2018-09-25 00:00:00', 45.94);
INSERT INTO public.dividend (id, ticker, year, month, currency, source, payment_date, per_share) VALUES (147, 'CHMF', 2018, 12, 'RUB', 'moex', '2018-12-04 00:00:00', 44.39);
INSERT INTO public.dividend (id, ticker, year, month, currency, source, payment_date, per_share) VALUES (148, 'CHMF', 2019, 5, 'RUB', 'moex', '2019-05-07 00:00:00', 32.08);
INSERT INTO public.dividend (id, ticker, year, month, currency, source, payment_date, per_share) VALUES (149, 'CHMF', 2019, 6, 'RUB', 'moex', '2019-06-18 00:00:00', 35.43);
INSERT INTO public.dividend (id, ticker, year, month, currency, source, payment_date, per_share) VALUES (150, 'CHMF', 2019, 9, 'RUB', 'moex', '2019-09-17 00:00:00', 26.72);
INSERT INTO public.dividend (id, ticker, year, month, currency, source, payment_date, per_share) VALUES (151, 'CHMF', 2019, 12, 'RUB', 'moex', '2019-12-03 00:00:00', 27.47);
INSERT INTO public.dividend (id, ticker, year, month, currency, source, payment_date, per_share) VALUES (152, 'CHMF', 2020, 6, 'RUB', 'moex', '2020-06-16 00:00:00', 26.26);
INSERT INTO public.dividend (id, ticker, year, month, currency, source, payment_date, per_share) VALUES (153, 'CHMF', 2020, 9, 'RUB', 'moex', '2020-09-08 00:00:00', 15.44);
INSERT INTO public.dividend (id, ticker, year, month, currency, source, payment_date, per_share) VALUES (154, 'CHMF', 2020, 12, 'RUB', 'moex', '2020-12-08 00:00:00', 37.34);
INSERT INTO public.dividend (id, ticker, year, month, currency, source, payment_date, per_share) VALUES (155, 'CHMF', 2021, 6, 'RUB', 'moex', '2021-06-01 00:00:00', 36.27);
INSERT INTO public.dividend (id, ticker, year, month, currency, source, payment_date, per_share) VALUES (156, 'CHMF', 2021, 9, 'RUB', 'moex', '2021-09-02 00:00:00', 84.45);
INSERT INTO public.dividend (id, ticker, year, month, currency, source, payment_date, per_share) VALUES (157, 'CHMF', 2021, 12, 'RUB', 'moex', '2021-12-14 00:00:00', 85.93);
INSERT INTO public.dividend (id, ticker, year, month, currency, source, payment_date, per_share) VALUES (158, 'CHMF', 2022, 5, 'RUB', 'moex', '2022-05-31 00:00:00', 109.81);
INSERT INTO public.dividend (id, ticker, year, month, currency, source, payment_date, per_share) VALUES (159, 'CHMF', 2024, 6, 'RUB', 'moex', '2024-06-18 00:00:00', 191.51);
INSERT INTO public.dividend (id, ticker, year, month, currency, source, payment_date, per_share) VALUES (160, 'CHMF', 2024, 9, 'RUB', 'moex', '2024-09-10 00:00:00', 31.06);
INSERT INTO public.dividend (id, ticker, year, month, currency, source, payment_date, per_share) VALUES (161, 'CHMF', 2024, 12, 'RUB', 'moex', '2024-12-17 00:00:00', 49.06);
INSERT INTO public.dividend (id, ticker, year, month, currency, source, payment_date, per_share) VALUES (162, 'NLMK', 2014, 6, 'RUB', 'moex', '2014-06-17 00:00:00', 0.67);
INSERT INTO public.dividend (id, ticker, year, month, currency, source, payment_date, per_share) VALUES (163, 'NLMK', 2014, 10, 'RUB', 'moex', '2014-10-11 00:00:00', 0.88);
INSERT INTO public.dividend (id, ticker, year, month, currency, source, payment_date, per_share) VALUES (164, 'NLMK', 2015, 6, 'RUB', 'moex', '2015-06-16 00:00:00', 1.64);
INSERT INTO public.dividend (id, ticker, year, month, currency, source, payment_date, per_share) VALUES (165, 'NLMK', 2015, 10, 'RUB', 'moex', '2015-10-12 00:00:00', 0.93);
INSERT INTO public.dividend (id, ticker, year, month, currency, source, payment_date, per_share) VALUES (166, 'NLMK', 2016, 1, 'RUB', 'moex', '2016-01-08 00:00:00', 1.95);
INSERT INTO public.dividend (id, ticker, year, month, currency, source, payment_date, per_share) VALUES (167, 'NLMK', 2016, 6, 'RUB', 'moex', '2016-06-14 00:00:00', 1.13);
INSERT INTO public.dividend (id, ticker, year, month, currency, source, payment_date, per_share) VALUES (168, 'NLMK', 2016, 10, 'RUB', 'moex', '2016-10-12 00:00:00', 1.08);
INSERT INTO public.dividend (id, ticker, year, month, currency, source, payment_date, per_share) VALUES (169, 'NLMK', 2017, 1, 'RUB', 'moex', '2017-01-09 00:00:00', 3.63);
INSERT INTO public.dividend (id, ticker, year, month, currency, source, payment_date, per_share) VALUES (170, 'NLMK', 2017, 6, 'RUB', 'moex', '2017-06-14 00:00:00', 2.35);
INSERT INTO public.dividend (id, ticker, year, month, currency, source, payment_date, per_share) VALUES (171, 'NLMK', 2017, 10, 'RUB', 'moex', '2017-10-12 00:00:00', 3.2);
INSERT INTO public.dividend (id, ticker, year, month, currency, source, payment_date, per_share) VALUES (172, 'NLMK', 2018, 1, 'RUB', 'moex', '2018-01-09 00:00:00', 5.13);
INSERT INTO public.dividend (id, ticker, year, month, currency, source, payment_date, per_share) VALUES (173, 'NLMK', 2018, 6, 'RUB', 'moex', '2018-06-20 00:00:00', 5.73);
INSERT INTO public.dividend (id, ticker, year, month, currency, source, payment_date, per_share) VALUES (174, 'NLMK', 2018, 10, 'RUB', 'moex', '2018-10-12 00:00:00', 5.24);
INSERT INTO public.dividend (id, ticker, year, month, currency, source, payment_date, per_share) VALUES (175, 'NLMK', 2019, 1, 'RUB', 'moex', '2019-01-09 00:00:00', 6.04);
INSERT INTO public.dividend (id, ticker, year, month, currency, source, payment_date, per_share) VALUES (176, 'NLMK', 2019, 5, 'RUB', 'moex', '2019-05-06 00:00:00', 5.8);
INSERT INTO public.dividend (id, ticker, year, month, currency, source, payment_date, per_share) VALUES (177, 'NLMK', 2019, 6, 'RUB', 'moex', '2019-06-19 00:00:00', 7.34);
INSERT INTO public.dividend (id, ticker, year, month, currency, source, payment_date, per_share) VALUES (178, 'NLMK', 2019, 10, 'RUB', 'moex', '2019-10-10 00:00:00', 3.68);
INSERT INTO public.dividend (id, ticker, year, month, currency, source, payment_date, per_share) VALUES (179, 'NLMK', 2020, 1, 'RUB', 'moex', '2020-01-09 00:00:00', 3.22);
INSERT INTO public.dividend (id, ticker, year, month, currency, source, payment_date, per_share) VALUES (180, 'NLMK', 2020, 5, 'RUB', 'moex', '2020-05-06 00:00:00', 5.16);
INSERT INTO public.dividend (id, ticker, year, month, currency, source, payment_date, per_share) VALUES (181, 'NLMK', 2020, 6, 'RUB', 'moex', '2020-06-09 00:00:00', 3.12);
INSERT INTO public.dividend (id, ticker, year, month, currency, source, payment_date, per_share) VALUES (182, 'NLMK', 2020, 7, 'RUB', 'moex', '2020-07-13 00:00:00', 3.21);
INSERT INTO public.dividend (id, ticker, year, month, currency, source, payment_date, per_share) VALUES (183, 'NLMK', 2020, 10, 'RUB', 'moex', '2020-10-12 00:00:00', 4.75);
INSERT INTO public.dividend (id, ticker, year, month, currency, source, payment_date, per_share) VALUES (184, 'NLMK', 2020, 12, 'RUB', 'moex', '2020-12-29 00:00:00', 6.43);
INSERT INTO public.dividend (id, ticker, year, month, currency, source, payment_date, per_share) VALUES (185, 'NLMK', 2021, 5, 'RUB', 'moex', '2021-05-11 00:00:00', 7.25);
INSERT INTO public.dividend (id, ticker, year, month, currency, source, payment_date, per_share) VALUES (186, 'NLMK', 2021, 6, 'RUB', 'moex', '2021-06-23 00:00:00', 7.71);
INSERT INTO public.dividend (id, ticker, year, month, currency, source, payment_date, per_share) VALUES (187, 'NLMK', 2021, 9, 'RUB', 'moex', '2021-09-07 00:00:00', 13.62);
INSERT INTO public.dividend (id, ticker, year, month, currency, source, payment_date, per_share) VALUES (188, 'NLMK', 2021, 12, 'RUB', 'moex', '2021-12-07 00:00:00', 13.33);
INSERT INTO public.dividend (id, ticker, year, month, currency, source, payment_date, per_share) VALUES (189, 'NLMK', 2023, 1, 'RUB', 'moex', '2023-01-11 00:00:00', 2.6);
INSERT INTO public.dividend (id, ticker, year, month, currency, source, payment_date, per_share) VALUES (190, 'NLMK', 2024, 5, 'RUB', 'moex', '2024-05-27 00:00:00', 25.43);
INSERT INTO public.dividend (id, ticker, year, month, currency, source, payment_date, per_share) VALUES (191, 'ALRS', 2014, 7, 'RUB', 'moex', '2014-07-18 00:00:00', 1.47);
INSERT INTO public.dividend (id, ticker, year, month, currency, source, payment_date, per_share) VALUES (192, 'ALRS', 2015, 7, 'RUB', 'moex', '2015-07-15 00:00:00', 1.47);
INSERT INTO public.dividend (id, ticker, year, month, currency, source, payment_date, per_share) VALUES (193, 'ALRS', 2016, 7, 'RUB', 'moex', '2016-07-19 00:00:00', 2.09);
INSERT INTO public.dividend (id, ticker, year, month, currency, source, payment_date, per_share) VALUES (194, 'ALRS', 2017, 7, 'RUB', 'moex', '2017-07-20 00:00:00', 8.93);
INSERT INTO public.dividend (id, ticker, year, month, currency, source, payment_date, per_share) VALUES (195, 'ALRS', 2018, 7, 'RUB', 'moex', '2018-07-14 00:00:00', 5.24);
INSERT INTO public.dividend (id, ticker, year, month, currency, source, payment_date, per_share) VALUES (196, 'ALRS', 2018, 10, 'RUB', 'moex', '2018-10-15 00:00:00', 5.93);
INSERT INTO public.dividend (id, ticker, year, month, currency, source, payment_date, per_share) VALUES (197, 'ALRS', 2019, 7, 'RUB', 'moex', '2019-07-15 00:00:00', 4.11);
INSERT INTO public.dividend (id, ticker, year, month, currency, source, payment_date, per_share) VALUES (198, 'ALRS', 2019, 10, 'RUB', 'moex', '2019-10-14 00:00:00', 3.84);
INSERT INTO public.dividend (id, ticker, year, month, currency, source, payment_date, per_share) VALUES (199, 'ALRS', 2020, 7, 'RUB', 'moex', '2020-07-13 00:00:00', 2.63);
INSERT INTO public.dividend (id, ticker, year, month, currency, source, payment_date, per_share) VALUES (200, 'ALRS', 2021, 7, 'RUB', 'moex', '2021-07-04 00:00:00', 9.54);
INSERT INTO public.dividend (id, ticker, year, month, currency, source, payment_date, per_share) VALUES (201, 'ALRS', 2021, 10, 'RUB', 'moex', '2021-10-19 00:00:00', 8.79);
INSERT INTO public.dividend (id, ticker, year, month, currency, source, payment_date, per_share) VALUES (202, 'ALRS', 2023, 10, 'RUB', 'moex', '2023-10-18 00:00:00', 3.77);
INSERT INTO public.dividend (id, ticker, year, month, currency, source, payment_date, per_share) VALUES (203, 'ALRS', 2024, 5, 'RUB', 'moex', '2024-05-31 00:00:00', 2.02);
INSERT INTO public.dividend (id, ticker, year, month, currency, source, payment_date, per_share) VALUES (204, 'ALRS', 2024, 10, 'RUB', 'moex', '2024-10-19 00:00:00', 2.49);
INSERT INTO public.dividend (id, ticker, year, month, currency, source, payment_date, per_share) VALUES (205, 'PLZL', 2017, 7, 'RUB', 'moex', '2017-07-17 00:00:00', 152.41);
INSERT INTO public.dividend (id, ticker, year, month, currency, source, payment_date, per_share) VALUES (206, 'PLZL', 2017, 9, 'RUB', 'moex', '2017-09-25 00:00:00', 104.3);
INSERT INTO public.dividend (id, ticker, year, month, currency, source, payment_date, per_share) VALUES (207, 'PLZL', 2018, 6, 'RUB', 'moex', '2018-06-10 00:00:00', 147.12);
INSERT INTO public.dividend (id, ticker, year, month, currency, source, payment_date, per_share) VALUES (208, 'PLZL', 2018, 10, 'RUB', 'moex', '2018-10-18 00:00:00', 131.11);
INSERT INTO public.dividend (id, ticker, year, month, currency, source, payment_date, per_share) VALUES (209, 'PLZL', 2019, 5, 'RUB', 'moex', '2019-05-16 00:00:00', 143.62);
INSERT INTO public.dividend (id, ticker, year, month, currency, source, payment_date, per_share) VALUES (210, 'PLZL', 2019, 10, 'RUB', 'moex', '2019-10-10 00:00:00', 162.98);
INSERT INTO public.dividend (id, ticker, year, month, currency, source, payment_date, per_share) VALUES (211, 'PLZL', 2020, 8, 'RUB', 'moex', '2020-08-28 00:00:00', 244.75);
INSERT INTO public.dividend (id, ticker, year, month, currency, source, payment_date, per_share) VALUES (212, 'PLZL', 2020, 10, 'RUB', 'moex', '2020-10-20 00:00:00', 240.18);
INSERT INTO public.dividend (id, ticker, year, month, currency, source, payment_date, per_share) VALUES (213, 'PLZL', 2021, 6, 'RUB', 'moex', '2021-06-07 00:00:00', 387.15);
INSERT INTO public.dividend (id, ticker, year, month, currency, source, payment_date, per_share) VALUES (214, 'PLZL', 2021, 10, 'RUB', 'moex', '2021-10-11 00:00:00', 267.48);
INSERT INTO public.dividend (id, ticker, year, month, currency, source, payment_date, per_share) VALUES (215, 'PLZL', 2023, 6, 'RUB', 'moex', '2023-06-16 00:00:00', 436.79);
INSERT INTO public.dividend (id, ticker, year, month, currency, source, payment_date, per_share) VALUES (216, 'PLZL', 2024, 12, 'RUB', 'moex', '2024-12-13 00:00:00', 1301.75);
INSERT INTO public.dividend (id, ticker, year, month, currency, source, payment_date, per_share) VALUES (217, 'PLZL', 2025, 4, 'RUB', 'moex', '2025-04-25 00:00:00', 73);
INSERT INTO public.dividend (id, ticker, year, month, currency, source, payment_date, per_share) VALUES (218, 'MGNT', 2013, 8, 'RUB', 'moex', '2013-08-09 00:00:00', 46.06);
INSERT INTO public.dividend (id, ticker, year, month, currency, source, payment_date, per_share) VALUES (219, 'MGNT', 2014, 6, 'RUB', 'moex', '2014-06-13 00:00:00', 89.15);
INSERT INTO public.dividend (id, ticker, year, month, currency, source, payment_date, per_share) VALUES (220, 'MGNT', 2014, 10, 'RUB', 'moex', '2014-10-10 00:00:00', 78.3);
INSERT INTO public.dividend (id, ticker, year, month, currency, source, payment_date, per_share) VALUES (221, 'MGNT', 2014, 10, 'RUB', 'moex', '2014-10-29 00:00:00', 152.07);
INSERT INTO public.dividend (id, ticker, year, month, currency, source, payment_date, per_share) VALUES (222, 'MGNT', 2014, 12, 'RUB', 'moex', '2014-12-30 00:00:00', 152.07);
INSERT INTO public.dividend (id, ticker, year, month, currency, source, payment_date, per_share) VALUES (223, 'MGNT', 2015, 6, 'RUB', 'moex', '2015-06-19 00:00:00', 132.57);
INSERT INTO public.dividend (id, ticker, year, month, currency, source, payment_date, per_share) VALUES (224, 'MGNT', 2015, 10, 'RUB', 'moex', '2015-10-09 00:00:00', 88.4);
INSERT INTO public.dividend (id, ticker, year, month, currency, source, payment_date, per_share) VALUES (225, 'MGNT', 2016, 1, 'RUB', 'moex', '2016-01-08 00:00:00', 179.77);
INSERT INTO public.dividend (id, ticker, year, month, currency, source, payment_date, per_share) VALUES (226, 'MGNT', 2016, 6, 'RUB', 'moex', '2016-06-17 00:00:00', 42.3);
INSERT INTO public.dividend (id, ticker, year, month, currency, source, payment_date, per_share) VALUES (227, 'MGNT', 2016, 9, 'RUB', 'moex', '2016-09-23 00:00:00', 84.6);
INSERT INTO public.dividend (id, ticker, year, month, currency, source, payment_date, per_share) VALUES (228, 'MGNT', 2016, 12, 'RUB', 'moex', '2016-12-23 00:00:00', 126.12);
INSERT INTO public.dividend (id, ticker, year, month, currency, source, payment_date, per_share) VALUES (229, 'MGNT', 2017, 6, 'RUB', 'moex', '2017-06-23 00:00:00', 67.41);
INSERT INTO public.dividend (id, ticker, year, month, currency, source, payment_date, per_share) VALUES (230, 'MGNT', 2017, 9, 'RUB', 'moex', '2017-09-15 00:00:00', 115.51);
INSERT INTO public.dividend (id, ticker, year, month, currency, source, payment_date, per_share) VALUES (231, 'MGNT', 2018, 7, 'RUB', 'moex', '2018-07-06 00:00:00', 135.5);
INSERT INTO public.dividend (id, ticker, year, month, currency, source, payment_date, per_share) VALUES (232, 'MGNT', 2018, 12, 'RUB', 'moex', '2018-12-21 00:00:00', 137.38);
INSERT INTO public.dividend (id, ticker, year, month, currency, source, payment_date, per_share) VALUES (233, 'MGNT', 2019, 6, 'RUB', 'moex', '2019-06-14 00:00:00', 166.78);
INSERT INTO public.dividend (id, ticker, year, month, currency, source, payment_date, per_share) VALUES (234, 'MGNT', 2020, 1, 'RUB', 'moex', '2020-01-10 00:00:00', 147.19);
INSERT INTO public.dividend (id, ticker, year, month, currency, source, payment_date, per_share) VALUES (235, 'MGNT', 2020, 6, 'RUB', 'moex', '2020-06-19 00:00:00', 157);
INSERT INTO public.dividend (id, ticker, year, month, currency, source, payment_date, per_share) VALUES (236, 'MGNT', 2021, 1, 'RUB', 'moex', '2021-01-08 00:00:00', 245.31);
INSERT INTO public.dividend (id, ticker, year, month, currency, source, payment_date, per_share) VALUES (237, 'MGNT', 2021, 6, 'RUB', 'moex', '2021-06-25 00:00:00', 245.31);
INSERT INTO public.dividend (id, ticker, year, month, currency, source, payment_date, per_share) VALUES (238, 'MGNT', 2021, 12, 'RUB', 'moex', '2021-12-31 00:00:00', 294.37);
INSERT INTO public.dividend (id, ticker, year, month, currency, source, payment_date, per_share) VALUES (239, 'MGNT', 2024, 1, 'RUB', 'moex', '2024-01-11 00:00:00', 412.13);
INSERT INTO public.dividend (id, ticker, year, month, currency, source, payment_date, per_share) VALUES (240, 'MGNT', 2024, 7, 'RUB', 'moex', '2024-07-15 00:00:00', 412.13);
INSERT INTO public.dividend (id, ticker, year, month, currency, source, payment_date, per_share) VALUES (241, 'MGNT', 2025, 1, 'RUB', 'moex', '2025-01-09 00:00:00', 560);
INSERT INTO public.dividend (id, ticker, year, month, currency, source, payment_date, per_share) VALUES (242, 'MOEX', 2014, 7, 'RUB', 'moex', '2014-07-11 00:00:00', 2.38);
INSERT INTO public.dividend (id, ticker, year, month, currency, source, payment_date, per_share) VALUES (243, 'MOEX', 2015, 5, 'RUB', 'moex', '2015-05-12 00:00:00', 3.87);
INSERT INTO public.dividend (id, ticker, year, month, currency, source, payment_date, per_share) VALUES (244, 'MOEX', 2016, 5, 'RUB', 'moex', '2016-05-16 00:00:00', 7.11);
INSERT INTO public.dividend (id, ticker, year, month, currency, source, payment_date, per_share) VALUES (245, 'MOEX', 2017, 5, 'RUB', 'moex', '2017-05-16 00:00:00', 7.68);
INSERT INTO public.dividend (id, ticker, year, month, currency, source, payment_date, per_share) VALUES (246, 'MOEX', 2017, 9, 'RUB', 'moex', '2017-09-29 00:00:00', 2.49);
INSERT INTO public.dividend (id, ticker, year, month, currency, source, payment_date, per_share) VALUES (247, 'MOEX', 2018, 5, 'RUB', 'moex', '2018-05-15 00:00:00', 5.47);
INSERT INTO public.dividend (id, ticker, year, month, currency, source, payment_date, per_share) VALUES (248, 'MOEX', 2019, 5, 'RUB', 'moex', '2019-05-14 00:00:00', 7.7);
INSERT INTO public.dividend (id, ticker, year, month, currency, source, payment_date, per_share) VALUES (249, 'MOEX', 2020, 5, 'RUB', 'moex', '2020-05-15 00:00:00', 7.93);
INSERT INTO public.dividend (id, ticker, year, month, currency, source, payment_date, per_share) VALUES (250, 'MOEX', 2021, 5, 'RUB', 'moex', '2021-05-14 00:00:00', 9.45);
INSERT INTO public.dividend (id, ticker, year, month, currency, source, payment_date, per_share) VALUES (251, 'MOEX', 2023, 5, 'RUB', 'moex', '2023-05-12 00:00:00', 4.84);
INSERT INTO public.dividend (id, ticker, year, month, currency, source, payment_date, per_share) VALUES (252, 'MOEX', 2023, 6, 'RUB', 'moex', '2023-06-16 00:00:00', 4.84);
INSERT INTO public.dividend (id, ticker, year, month, currency, source, payment_date, per_share) VALUES (253, 'MOEX', 2024, 6, 'RUB', 'moex', '2024-06-14 00:00:00', 17.35);
INSERT INTO public.dividend (id, ticker, year, month, currency, source, payment_date, per_share) VALUES (254, 'MOEX', 2025, 7, 'RUB', 'moex', '2025-07-10 00:00:00', 26.11);
INSERT INTO public.dividend (id, ticker, year, month, currency, source, payment_date, per_share) VALUES (255, 'VTBR', 2016, 12, 'RUB', 'moex', '2016-12-26 00:00:00', 0.01);
INSERT INTO public.dividend (id, ticker, year, month, currency, source, payment_date, per_share) VALUES (256, 'VTBR', 2019, 6, 'RUB', 'moex', '2019-06-24 00:00:00', 0.00109867761463259);
INSERT INTO public.dividend (id, ticker, year, month, currency, source, payment_date, per_share) VALUES (257, 'VTBR', 2020, 10, 'RUB', 'moex', '2020-10-05 00:00:00', 0.00077345337561138);
INSERT INTO public.dividend (id, ticker, year, month, currency, source, payment_date, per_share) VALUES (258, 'VTBR', 2021, 6, 'RUB', 'moex', '2021-06-22 00:00:00', 1.73965919370917e-05);
INSERT INTO public.dividend (id, ticker, year, month, currency, source, payment_date, per_share) VALUES (259, 'VTBR', 2021, 7, 'RUB', 'moex', '2021-07-15 00:00:00', 1.73965919370917e-05);
INSERT INTO public.dividend (id, ticker, year, month, currency, source, payment_date, per_share) VALUES (260, 'VTBR', 2025, 7, 'RUB', 'moex', '2025-07-11 00:00:00', 25.58);
INSERT INTO public.dividend (id, ticker, year, month, currency, source, payment_date, per_share) VALUES (261, 'AFLT', 2014, 7, 'RUB', 'moex', '2014-07-08 00:00:00', 2.5);
INSERT INTO public.dividend (id, ticker, year, month, currency, source, payment_date, per_share) VALUES (262, 'AFLT', 2017, 7, 'RUB', 'moex', '2017-07-14 00:00:00', 17.48);
INSERT INTO public.dividend (id, ticker, year, month, currency, source, payment_date, per_share) VALUES (263, 'AFLT', 2018, 7, 'RUB', 'moex', '2018-07-06 00:00:00', 12.8053);
INSERT INTO public.dividend (id, ticker, year, month, currency, source, payment_date, per_share) VALUES (264, 'AFLT', 2019, 7, 'RUB', 'moex', '2019-07-05 00:00:00', 2.6877);
INSERT INTO public.dividend (id, ticker, year, month, currency, source, payment_date, per_share) VALUES (265, 'AFLT', 2025, 7, 'RUB', 'moex', '2025-07-18 00:00:00', 5.27);
INSERT INTO public.dividend (id, ticker, year, month, currency, source, payment_date, per_share) VALUES (266, 'MTSS', 2018, 7, 'RUB', 'moex', '2018-07-09 00:00:00', 23.4);
INSERT INTO public.dividend (id, ticker, year, month, currency, source, payment_date, per_share) VALUES (267, 'MTSS', 2018, 10, 'RUB', 'moex', '2018-10-09 00:00:00', 2.6);
INSERT INTO public.dividend (id, ticker, year, month, currency, source, payment_date, per_share) VALUES (268, 'MTSS', 2019, 7, 'RUB', 'moex', '2019-07-09 00:00:00', 19.98);
INSERT INTO public.dividend (id, ticker, year, month, currency, source, payment_date, per_share) VALUES (269, 'MTSS', 2019, 10, 'RUB', 'moex', '2019-10-14 00:00:00', 8.68);
INSERT INTO public.dividend (id, ticker, year, month, currency, source, payment_date, per_share) VALUES (270, 'MTSS', 2020, 1, 'RUB', 'moex', '2020-01-10 00:00:00', 13.25);
INSERT INTO public.dividend (id, ticker, year, month, currency, source, payment_date, per_share) VALUES (271, 'MTSS', 2020, 7, 'RUB', 'moex', '2020-07-09 00:00:00', 20.57);
INSERT INTO public.dividend (id, ticker, year, month, currency, source, payment_date, per_share) VALUES (272, 'MTSS', 2020, 10, 'RUB', 'moex', '2020-10-12 00:00:00', 8.93);
INSERT INTO public.dividend (id, ticker, year, month, currency, source, payment_date, per_share) VALUES (273, 'MTSS', 2021, 7, 'RUB', 'moex', '2021-07-08 00:00:00', 26.51);
INSERT INTO public.dividend (id, ticker, year, month, currency, source, payment_date, per_share) VALUES (274, 'MTSS', 2021, 10, 'RUB', 'moex', '2021-10-12 00:00:00', 10.55);
INSERT INTO public.dividend (id, ticker, year, month, currency, source, payment_date, per_share) VALUES (275, 'MTSS', 2022, 7, 'RUB', 'moex', '2022-07-12 00:00:00', 33.85);
INSERT INTO public.dividend (id, ticker, year, month, currency, source, payment_date, per_share) VALUES (276, 'MTSS', 2023, 6, 'RUB', 'moex', '2023-06-29 00:00:00', 34.29);
INSERT INTO public.dividend (id, ticker, year, month, currency, source, payment_date, per_share) VALUES (277, 'MTSS', 2024, 7, 'RUB', 'moex', '2024-07-16 00:00:00', 35);
INSERT INTO public.dividend (id, ticker, year, month, currency, source, payment_date, per_share) VALUES (278, 'MTSS', 2025, 7, 'RUB', 'moex', '2025-07-07 00:00:00', 35);
INSERT INTO public.dividend (id, ticker, year, month, currency, source, payment_date, per_share) VALUES (279, 'IRAO', 2016, 6, 'RUB', 'moex', '2016-06-21 00:00:00', 0.02);
INSERT INTO public.dividend (id, ticker, year, month, currency, source, payment_date, per_share) VALUES (280, 'IRAO', 2017, 6, 'RUB', 'moex', '2017-06-20 00:00:00', 0.15);
INSERT INTO public.dividend (id, ticker, year, month, currency, source, payment_date, per_share) VALUES (281, 'IRAO', 2018, 6, 'RUB', 'moex', '2018-06-01 00:00:00', 0.13);
INSERT INTO public.dividend (id, ticker, year, month, currency, source, payment_date, per_share) VALUES (282, 'IRAO', 2019, 5, 'RUB', 'moex', '2019-05-31 00:00:00', 0.171635536398468);
INSERT INTO public.dividend (id, ticker, year, month, currency, source, payment_date, per_share) VALUES (283, 'IRAO', 2020, 6, 'RUB', 'moex', '2020-06-01 00:00:00', 0.196192528735633);
INSERT INTO public.dividend (id, ticker, year, month, currency, source, payment_date, per_share) VALUES (284, 'IRAO', 2021, 6, 'RUB', 'moex', '2021-06-07 00:00:00', 0.180711206896552);
INSERT INTO public.dividend (id, ticker, year, month, currency, source, payment_date, per_share) VALUES (285, 'IRAO', 2022, 6, 'RUB', 'moex', '2022-06-10 00:00:00', 0.23658380041773);
INSERT INTO public.dividend (id, ticker, year, month, currency, source, payment_date, per_share) VALUES (286, 'IRAO', 2023, 5, 'RUB', 'moex', '2023-05-30 00:00:00', 0.28365531801897);
INSERT INTO public.dividend (id, ticker, year, month, currency, source, payment_date, per_share) VALUES (287, 'IRAO', 2024, 6, 'RUB', 'moex', '2024-06-03 00:00:00', 0.325999263608046);
INSERT INTO public.dividend (id, ticker, year, month, currency, source, payment_date, per_share) VALUES (288, 'IRAO', 2025, 6, 'RUB', 'moex', '2025-06-09 00:00:00', 0.353756516888506);


--
-- Data for Name: market_news; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO public.market_news (id, source, title, body, url, year, month, tickers, impact, category, published_at) VALUES (1, 'cbr', 'ЦБ РФ установил ключевую ставку 15.00%', 'Банк России принял решение снизить ключевую ставку до 15.00% годовых. Решение вступает в силу с 02.04.2026.', 'cbr://keyrate/2026-04-02', 2026, 4, '', 'neutral', 'rate', '2026-04-02 00:00:00');
INSERT INTO public.market_news (id, source, title, body, url, year, month, tickers, impact, category, published_at) VALUES (2, 'moex_sitenews', '30.09.2014 18-35 (мск) изменены значения верхних границ ценового коридора и диапазона оценки рыночных рисков ценной бумаги MTLRP (Мечел ОАО ап).', '30.09.2014 18-35 (мск) изменены значения верхних границ ценового коридора и диапазона оценки рыночных рисков ценной бумаги MTLRP (Мечел ОАО ап).', 'https://www.moex.com/n6365', 2014, 9, '', 'neutral', 'general', '2014-09-30 18:37:14');
INSERT INTO public.market_news (id, source, title, body, url, year, month, tickers, impact, category, published_at) VALUES (3, 'moex_sitenews', 'О проведении 1 октября 2014 года аукциона по размещению и торгов ОФЗ выпуска 26212RMFS', 'О проведении 1 октября 2014 года аукциона по размещению и торгов ОФЗ выпуска 26212RMFS', 'https://www.moex.com/n6364', 2014, 9, '', 'neutral', 'general', '2014-09-30 17:55:00');
INSERT INTO public.market_news (id, source, title, body, url, year, month, tickers, impact, category, published_at) VALUES (4, 'moex_sitenews', 'О внесении изменений в Список ценных бумаг, допущенных к торгам', 'О внесении изменений в Список ценных бумаг, допущенных к торгам', 'https://www.moex.com/n6361', 2014, 9, '', 'neutral', 'general', '2014-09-30 17:43:00');
INSERT INTO public.market_news (id, source, title, body, url, year, month, tickers, impact, category, published_at) VALUES (5, 'moex_sitenews', 'О допустимых кодах расчетов по облигациям "Татфондбанк" (ОАО)', 'О допустимых кодах расчетов по облигациям "Татфондбанк" (ОАО)', 'https://www.moex.com/n6360', 2014, 9, '', 'neutral', 'general', '2014-09-30 17:07:00');
INSERT INTO public.market_news (id, source, title, body, url, year, month, tickers, impact, category, published_at) VALUES (6, 'moex_sitenews', 'О начале торгов ценными бумагами 1 октября 2014 года', 'О начале торгов ценными бумагами 1 октября 2014 года', 'https://www.moex.com/n6351', 2014, 9, '', 'neutral', 'general', '2014-09-30 16:12:00');
INSERT INTO public.market_news (id, source, title, body, url, year, month, tickers, impact, category, published_at) VALUES (7, 'moex_sitenews', 'Итоги размещения депозитов Федерального Казначейства 30 сентября 2014 года', 'Итоги размещения депозитов Федерального Казначейства 30 сентября 2014 года', 'https://www.moex.com/n6346', 2014, 9, '', 'neutral', 'general', '2014-09-30 15:41:00');
INSERT INTO public.market_news (id, source, title, body, url, year, month, tickers, impact, category, published_at) VALUES (8, 'moex_sitenews', 'О включении биржевых облигаций ООО "РГС Недвижимость" и ЗАО АКБ "НОВИКОМБАНК" в Список ценных бумаг, допущенных к торгам, и о присвоении указанным биржевым облигациям идентификационных номеров', 'О включении биржевых облигаций ООО "РГС Недвижимость" и ЗАО АКБ "НОВИКОМБАНК" в Список ценных бумаг, допущенных к торгам, и о присвоении указанным биржевым облигациям идентификационных номеров', 'https://www.moex.com/n6345', 2014, 9, '', 'neutral', 'general', '2014-09-30 15:30:00');
INSERT INTO public.market_news (id, source, title, body, url, year, month, tickers, impact, category, published_at) VALUES (9, 'moex_sitenews', 'О проведении торгов на Московской Бирже в период новогодних праздников', 'О проведении торгов на Московской Бирже в период новогодних праздников', 'https://www.moex.com/n6344', 2014, 9, '', 'neutral', 'general', '2014-09-30 12:29:00');
INSERT INTO public.market_news (id, source, title, body, url, year, month, tickers, impact, category, published_at) VALUES (10, 'moex_sitenews', '30.09.2014 10-09 (мск) изменены значения верхних границ ценового коридора и диапазона оценки рыночных рисков ценной бумаги SU46005RMFS3 (Обл.федеральный аморт.займ).', '30.09.2014 10-09 (мск) изменены значения верхних границ ценового коридора и диапазона оценки рыночных рисков ценной бумаги SU46005RMFS3 (Обл.федеральный аморт.займ).', 'https://www.moex.com/n6343', 2014, 9, '', 'neutral', 'general', '2014-09-30 10:09:07');
INSERT INTO public.market_news (id, source, title, body, url, year, month, tickers, impact, category, published_at) VALUES (11, 'moex_sitenews', 'Условия проведения торгов в режимах "РЕПО с Банком России: Аукцион РЕПО" и "РЕПО с Банком России: фикс.ставка"', 'Условия проведения торгов в режимах "РЕПО с Банком России: Аукцион РЕПО" и "РЕПО с Банком России: фикс.ставка"', 'https://www.moex.com/n6342', 2014, 9, '', 'neutral', 'general', '2014-09-29 18:34:00');
INSERT INTO public.market_news (id, source, title, body, url, year, month, tickers, impact, category, published_at) VALUES (12, 'moex_sitenews', '29.09.2014 18-07 (мск) изменены значения нижних границ ценового коридора и диапазона оценки рыночных рисков ценной бумаги AFKS (АФК "Система" ОАО ао).', '29.09.2014 18-07 (мск) изменены значения нижних границ ценового коридора и диапазона оценки рыночных рисков ценной бумаги AFKS (АФК "Система" ОАО ао).', 'https://www.moex.com/n6341', 2014, 9, '', 'neutral', 'general', '2014-09-29 18:10:42');
INSERT INTO public.market_news (id, source, title, body, url, year, month, tickers, impact, category, published_at) VALUES (13, 'moex_sitenews', 'О возобновлении торгов обыкновенными акциями ОАО "Кузбассэнерго" с 30 сентября 2014 года', 'О возобновлении торгов обыкновенными акциями ОАО "Кузбассэнерго" с 30 сентября 2014 года', 'https://www.moex.com/n6340', 2014, 9, '', 'neutral', 'general', '2014-09-29 18:10:00');
INSERT INTO public.market_news (id, source, title, body, url, year, month, tickers, impact, category, published_at) VALUES (14, 'moex_sitenews', 'Итоги выпуска биржевых облигаций АКБ "ПЕРЕСВЕТ" (ЗАО)', 'Итоги выпуска биржевых облигаций АКБ "ПЕРЕСВЕТ" (ЗАО)', 'https://www.moex.com/n6339', 2014, 9, '', 'neutral', 'general', '2014-09-29 17:51:00');
INSERT INTO public.market_news (id, source, title, body, url, year, month, tickers, impact, category, published_at) VALUES (15, 'moex_sitenews', 'Итоги размещения депозитов Федерального Казначейства 29 сентября 2014 года', 'Итоги размещения депозитов Федерального Казначейства 29 сентября 2014 года', 'https://www.moex.com/n6338', 2014, 9, '', 'neutral', 'general', '2014-09-29 17:00:00');
INSERT INTO public.market_news (id, source, title, body, url, year, month, tickers, impact, category, published_at) VALUES (16, 'moex_sitenews', 'О начале торгов ценными бумагами 30 сентября 2014 года', 'О начале торгов ценными бумагами 30 сентября 2014 года', 'https://www.moex.com/n6337', 2014, 9, '', 'neutral', 'general', '2014-09-29 16:10:00');
INSERT INTO public.market_news (id, source, title, body, url, year, month, tickers, impact, category, published_at) VALUES (17, 'moex_sitenews', 'О присвоении идентификационного номера дополнительному выпуску биржевых облигаций ОАО КБ "Восточный"', 'О присвоении идентификационного номера дополнительному выпуску биржевых облигаций ОАО КБ "Восточный"', 'https://www.moex.com/n6336', 2014, 9, '', 'neutral', 'general', '2014-09-29 16:07:00');
INSERT INTO public.market_news (id, source, title, body, url, year, month, tickers, impact, category, published_at) VALUES (18, 'moex_sitenews', 'О внесении изменений в Список ценных бумаг, допущенных к торгам', 'О внесении изменений в Список ценных бумаг, допущенных к торгам', 'https://www.moex.com/n6335', 2014, 9, '', 'neutral', 'general', '2014-09-29 16:02:00');
INSERT INTO public.market_news (id, source, title, body, url, year, month, tickers, impact, category, published_at) VALUES (19, 'moex_sitenews', 'Завершено проведение дискретного аукциона по  обыкновенным акциям ОАО АФК "Система"', 'Завершено проведение дискретного аукциона по  обыкновенным акциям ОАО АФК "Система"', 'https://www.moex.com/n6334', 2014, 9, '', 'neutral', 'general', '2014-09-29 14:20:00');
INSERT INTO public.market_news (id, source, title, body, url, year, month, tickers, impact, category, published_at) VALUES (20, 'moex_sitenews', 'По обыкновенным акциям ОАО АФК "Система" проводится дискретный аукцион', 'По обыкновенным акциям ОАО АФК "Система" проводится дискретный аукцион', 'https://www.moex.com/n6333', 2014, 9, '', 'neutral', 'general', '2014-09-29 13:55:00');
INSERT INTO public.market_news (id, source, title, body, url, year, month, tickers, impact, category, published_at) VALUES (21, 'moex_sitenews', '29.09.2014 13-29 (мск) изменены значения нижних границ ценового коридора и диапазона оценки рыночных рисков ценной бумаги AFKS (АФК "Система" ОАО ао).', '29.09.2014 13-29 (мск) изменены значения нижних границ ценового коридора и диапазона оценки рыночных рисков ценной бумаги AFKS (АФК "Система" ОАО ао).', 'https://www.moex.com/n6332', 2014, 9, '', 'neutral', 'general', '2014-09-29 13:33:13');
INSERT INTO public.market_news (id, source, title, body, url, year, month, tickers, impact, category, published_at) VALUES (22, 'moex_sitenews', '20 сентября 2014 года состоится отбор заявок кредитных организаций на заключение договоров банковского депозита', '20 сентября 2014 года состоится отбор заявок кредитных организаций на заключение договоров банковского депозита', 'https://www.moex.com/n6331', 2014, 9, '', 'neutral', 'general', '2014-09-29 11:57:00');
INSERT INTO public.market_news (id, source, title, body, url, year, month, tickers, impact, category, published_at) VALUES (23, 'moex_sitenews', 'Порядок проведения торгов иностранной валютой на Московской Бирже на период с 29 сентября по 13 октября 2014 года', 'Порядок проведения торгов иностранной валютой на Московской Бирже на период с 29 сентября по 13 октября 2014 года', 'https://www.moex.com/n6329', 2014, 9, '', 'neutral', 'general', '2014-09-29 10:18:00');
INSERT INTO public.market_news (id, source, title, body, url, year, month, tickers, impact, category, published_at) VALUES (24, 'moex_sitenews', 'Итоги выпуска биржевых облигаций ЗАО "ТПГК-Финанс"', 'Итоги выпуска биржевых облигаций ЗАО "ТПГК-Финанс"', 'https://www.moex.com/n6328', 2014, 9, '', 'neutral', 'general', '2014-09-26 19:05:00');
INSERT INTO public.market_news (id, source, title, body, url, year, month, tickers, impact, category, published_at) VALUES (25, 'moex_sitenews', 'Банк России признал НРД и НКЦ системно значимыми инфраструктурными организациями финансового рынка', 'Банк России признал НРД и НКЦ системно значимыми инфраструктурными организациями финансового рынка', 'https://www.moex.com/n6327', 2014, 9, '', 'neutral', 'general', '2014-09-26 18:14:00');
INSERT INTO public.market_news (id, source, title, body, url, year, month, tickers, impact, category, published_at) VALUES (26, 'moex_sitenews', 'Об изменении параметров биржевых облигаций серии БО-28  ОАО "ТрансФин-М" с 29 сентября 2014 года', 'Об изменении параметров биржевых облигаций серии БО-28  ОАО "ТрансФин-М" с 29 сентября 2014 года', 'https://www.moex.com/n6326', 2014, 9, '', 'neutral', 'general', '2014-09-26 18:12:00');
INSERT INTO public.market_news (id, source, title, body, url, year, month, tickers, impact, category, published_at) VALUES (27, 'moex_sitenews', 'Итоги выпуска биржевых облигаций ОАО "ТрансФин-М"', 'Итоги выпуска биржевых облигаций ОАО "ТрансФин-М"', 'https://www.moex.com/n6325', 2014, 9, '', 'neutral', 'general', '2014-09-26 18:10:00');
INSERT INTO public.market_news (id, source, title, body, url, year, month, tickers, impact, category, published_at) VALUES (28, 'moex_sitenews', 'Итоги выпуска биржевых облигаций ГПБ (ОАО)', 'Итоги выпуска биржевых облигаций ГПБ (ОАО)', 'https://www.moex.com/n6324', 2014, 9, '', 'neutral', 'general', '2014-09-26 18:07:00');
INSERT INTO public.market_news (id, source, title, body, url, year, month, tickers, impact, category, published_at) VALUES (29, 'moex_sitenews', 'Об изменении уровня листинга ценных бумаг', 'Об изменении уровня листинга ценных бумаг', 'https://www.moex.com/n6323', 2014, 9, '', 'neutral', 'general', '2014-09-26 16:19:00');
INSERT INTO public.market_news (id, source, title, body, url, year, month, tickers, impact, category, published_at) VALUES (30, 'moex_sitenews', 'Об исключении ценных бумаг из Списка ценных бумаг, допущенных к торгам, и о прекращении торгов ценными бумагами', 'Об исключении ценных бумаг из Списка ценных бумаг, допущенных к торгам, и о прекращении торгов ценными бумагами', 'https://www.moex.com/n6322', 2014, 9, '', 'neutral', 'general', '2014-09-26 16:10:00');
INSERT INTO public.market_news (id, source, title, body, url, year, month, tickers, impact, category, published_at) VALUES (31, 'moex_sitenews', 'О начале торгов ценными бумагами 29 сентября 2014 года', 'О начале торгов ценными бумагами 29 сентября 2014 года', 'https://www.moex.com/n6321', 2014, 9, '', 'neutral', 'general', '2014-09-26 15:48:00');
INSERT INTO public.market_news (id, source, title, body, url, year, month, tickers, impact, category, published_at) VALUES (32, 'moex_sitenews', 'Московская Биржа запускает вторую линию системы распространения биржевой информации FAST', 'Московская Биржа запускает вторую линию системы распространения биржевой информации FAST', 'https://www.moex.com/n6319', 2014, 9, '', 'positive', 'general', '2014-09-26 14:49:00');
INSERT INTO public.market_news (id, source, title, body, url, year, month, tickers, impact, category, published_at) VALUES (33, 'moex_sitenews', 'Завершено проведение дискретного аукциона по обыкновенным акциям ОАО АФК "Система"', 'Завершено проведение дискретного аукциона по обыкновенным акциям ОАО АФК "Система"', 'https://www.moex.com/n6318', 2014, 9, '', 'neutral', 'general', '2014-09-26 14:36:00');
INSERT INTO public.market_news (id, source, title, body, url, year, month, tickers, impact, category, published_at) VALUES (34, 'moex_sitenews', 'По обыкновенным акциям ОАО АФК "Система" проводится дискретный аукцион', 'По обыкновенным акциям ОАО АФК "Система" проводится дискретный аукцион', 'https://www.moex.com/n6317', 2014, 9, '', 'neutral', 'general', '2014-09-26 14:04:00');
INSERT INTO public.market_news (id, source, title, body, url, year, month, tickers, impact, category, published_at) VALUES (35, 'moex_sitenews', '26.09.2014 13-07 (мск) изменены значения нижних границ ценового коридора и диапазона оценки рыночных рисков ценной бумаги AFKS (АФК "Система" ОАО ао).', '26.09.2014 13-07 (мск) изменены значения нижних границ ценового коридора и диапазона оценки рыночных рисков ценной бумаги AFKS (АФК "Система" ОАО ао).', 'https://www.moex.com/n6316', 2014, 9, '', 'neutral', 'general', '2014-09-26 13:10:41');
INSERT INTO public.market_news (id, source, title, body, url, year, month, tickers, impact, category, published_at) VALUES (36, 'moex_sitenews', '29 сентября 2014 года состоится отбор заявок кредитных организаций на заключение договоров банковского депозита', '29 сентября 2014 года состоится отбор заявок кредитных организаций на заключение договоров банковского депозита', 'https://www.moex.com/n6315', 2014, 9, '', 'neutral', 'general', '2014-09-26 12:10:00');
INSERT INTO public.market_news (id, source, title, body, url, year, month, tickers, impact, category, published_at) VALUES (37, 'moex_sitenews', '26.09.2014 10-54 (мск) изменены значения верхних границ ценового коридора и диапазона оценки рыночных рисков валютной пары GLD/RUB.', '26.09.2014 10-54 (мск) изменены значения верхних границ ценового коридора и диапазона оценки рыночных рисков валютной пары GLD/RUB.', 'https://www.moex.com/n6314', 2014, 9, '', 'neutral', 'general', '2014-09-26 10:56:51');
INSERT INTO public.market_news (id, source, title, body, url, year, month, tickers, impact, category, published_at) VALUES (38, 'moex_sitenews', 'Итоги выпуска биржевых облигаций ОАО "МОЭСК"', 'Итоги выпуска биржевых облигаций ОАО "МОЭСК"', 'https://www.moex.com/n6313', 2014, 9, '', 'neutral', 'general', '2014-09-25 17:28:00');
INSERT INTO public.market_news (id, source, title, body, url, year, month, tickers, impact, category, published_at) VALUES (39, 'moex_sitenews', 'Об итогах размещения депозитов Федерального Казначейства 25 сентября 2014 года', 'Об итогах размещения депозитов Федерального Казначейства 25 сентября 2014 года', 'https://www.moex.com/n6311', 2014, 9, '', 'neutral', 'general', '2014-09-25 16:39:00');
INSERT INTO public.market_news (id, source, title, body, url, year, month, tickers, impact, category, published_at) VALUES (40, 'moex_sitenews', 'О начале торгов ценными бумагами 26 сентября 2014 года', 'О начале торгов ценными бумагами 26 сентября 2014 года', 'https://www.moex.com/n6310', 2014, 9, '', 'neutral', 'general', '2014-09-25 16:15:00');
INSERT INTO public.market_news (id, source, title, body, url, year, month, tickers, impact, category, published_at) VALUES (41, 'moex_sitenews', 'О результатах промежуточной клиринговой сессии на Срочном рынке 25 сентября 2014', 'О результатах промежуточной клиринговой сессии на Срочном рынке 25 сентября 2014', 'https://www.moex.com/n6308', 2014, 9, '', 'neutral', 'general', '2014-09-25 15:52:00');
INSERT INTO public.market_news (id, source, title, body, url, year, month, tickers, impact, category, published_at) VALUES (42, 'moex_sitenews', 'О внесении изменений в Список ценных бумаг, допущенных к торгам', 'О внесении изменений в Список ценных бумаг, допущенных к торгам', 'https://www.moex.com/n6307', 2014, 9, '', 'neutral', 'general', '2014-09-25 15:26:00');
INSERT INTO public.market_news (id, source, title, body, url, year, month, tickers, impact, category, published_at) VALUES (43, 'moex_sitenews', 'Об изменениях в Программе поддержки ликвидности на рынке акций Московской Биржи', 'Об изменениях в Программе поддержки ликвидности на рынке акций Московской Биржи', 'https://www.moex.com/n6304', 2014, 9, '', 'neutral', 'general', '2014-09-25 10:31:00');
INSERT INTO public.market_news (id, source, title, body, url, year, month, tickers, impact, category, published_at) VALUES (44, 'moex_sitenews', 'Об оставлении ценных бумаг в Списке ценных бумаг, допущенных к торгам', 'Об оставлении ценных бумаг в Списке ценных бумаг, допущенных к торгам', 'https://www.moex.com/n6303', 2014, 9, '', 'neutral', 'general', '2014-09-24 18:01:00');
INSERT INTO public.market_news (id, source, title, body, url, year, month, tickers, impact, category, published_at) VALUES (45, 'moex_sitenews', 'Об ограничении кодов расчетов по акциям обыкновенным ОАО "Волжская ТГК" с 25.09.2014', 'Об ограничении кодов расчетов по акциям обыкновенным ОАО "Волжская ТГК" с 25.09.2014', 'https://www.moex.com/n6302', 2014, 9, '', 'neutral', 'general', '2014-09-24 17:54:00');
INSERT INTO public.market_news (id, source, title, body, url, year, month, tickers, impact, category, published_at) VALUES (46, 'moex_sitenews', 'О начале торгов ценными бумагами 25 сентября 2014 года', 'О начале торгов ценными бумагами 25 сентября 2014 года', 'https://www.moex.com/n6301', 2014, 9, '', 'neutral', 'general', '2014-09-24 17:43:00');
INSERT INTO public.market_news (id, source, title, body, url, year, month, tickers, impact, category, published_at) VALUES (47, 'moex_sitenews', 'О приостановке торгов акциями ряда энергосбытовых компаний с 25 сентября 2014 года', 'О приостановке торгов акциями ряда энергосбытовых компаний с 25 сентября 2014 года', 'https://www.moex.com/n6300', 2014, 9, '', 'neutral', 'general', '2014-09-24 17:25:00');
INSERT INTO public.market_news (id, source, title, body, url, year, month, tickers, impact, category, published_at) VALUES (48, 'moex_sitenews', 'Об итогах размещения депозитов Пенсионного Фонда РФ 24 сентября 2014 г.', 'Об итогах размещения депозитов Пенсионного Фонда РФ 24 сентября 2014 г.', 'https://www.moex.com/n6299', 2014, 9, '', 'neutral', 'general', '2014-09-24 16:39:00');
INSERT INTO public.market_news (id, source, title, body, url, year, month, tickers, impact, category, published_at) VALUES (49, 'moex_sitenews', 'О включении ценных бумаг в Сектор РИИ', 'О включении ценных бумаг в Сектор РИИ', 'https://www.moex.com/n6298', 2014, 9, '', 'neutral', 'general', '2014-09-24 16:26:00');
INSERT INTO public.market_news (id, source, title, body, url, year, month, tickers, impact, category, published_at) VALUES (50, 'moex_sitenews', 'О приостановке торгов обыкновенными акциями ОАО "МТС" с 25 сентября 2014 года', 'О приостановке торгов обыкновенными акциями ОАО "МТС" с 25 сентября 2014 года', 'https://www.moex.com/n6297', 2014, 9, '', 'neutral', 'general', '2014-09-24 16:19:00');
INSERT INTO public.market_news (id, source, title, body, url, year, month, tickers, impact, category, published_at) VALUES (51, 'moex_sitenews', 'О внесении изменений в Список ценных бумаг, допущенных к торгам', 'О внесении изменений в Список ценных бумаг, допущенных к торгам', 'https://www.moex.com/n6296', 2014, 9, '', 'neutral', 'general', '2014-09-24 15:53:00');
INSERT INTO public.market_news (id, source, title, body, url, year, month, tickers, impact, category, published_at) VALUES (52, 'moex_sitenews', 'Об изменении параметров инвестиционных паев c 25 сентября 2014 года', 'Об изменении параметров инвестиционных паев c 25 сентября 2014 года', 'https://www.moex.com/n6294', 2014, 9, '', 'neutral', 'general', '2014-09-24 13:18:00');
INSERT INTO public.market_news (id, source, title, body, url, year, month, tickers, impact, category, published_at) VALUES (53, 'moex_sitenews', '24.09.2014 13-08 (мск) изменены значения нижних границ ценового коридора и диапазона оценки рыночных рисков ценной бумаги SU48001RMFS0 (Обл.федеральный аморт.займ).', '24.09.2014 13-08 (мск) изменены значения нижних границ ценового коридора и диапазона оценки рыночных рисков ценной бумаги SU48001RMFS0 (Обл.федеральный аморт.займ).', 'https://www.moex.com/n6295', 2014, 9, '', 'neutral', 'general', '2014-09-24 13:12:09');
INSERT INTO public.market_news (id, source, title, body, url, year, month, tickers, impact, category, published_at) VALUES (54, 'moex_sitenews', '25 сентября 2014 года состоится отбор заявок кредитных организаций на заключение договоров банковского депозита', '25 сентября 2014 года состоится отбор заявок кредитных организаций на заключение договоров банковского депозита', 'https://www.moex.com/n6293', 2014, 9, '', 'neutral', 'general', '2014-09-24 11:10:00');
INSERT INTO public.market_news (id, source, title, body, url, year, month, tickers, impact, category, published_at) VALUES (55, 'moex_sitenews', 'Решения Наблюдательного Совета Московской Биржи', 'Решения Наблюдательного Совета Московской Биржи', 'https://www.moex.com/n6291', 2014, 9, '', 'neutral', 'general', '2014-09-23 19:06:00');
INSERT INTO public.market_news (id, source, title, body, url, year, month, tickers, impact, category, published_at) VALUES (56, 'moex_sitenews', 'О проведении 24 сентября 2014 года аукциона по размещению и торгов ОФЗ выпуска №26215RMFS', 'О проведении 24 сентября 2014 года аукциона по размещению и торгов ОФЗ выпуска №26215RMFS', 'https://www.moex.com/n6290', 2014, 9, '', 'neutral', 'general', '2014-09-23 18:14:00');
INSERT INTO public.market_news (id, source, title, body, url, year, month, tickers, impact, category, published_at) VALUES (57, 'moex_sitenews', 'О решениях комитета по валютному рынку Московской Биржи', 'О решениях комитета по валютному рынку Московской Биржи', 'https://www.moex.com/n6289', 2014, 9, '', 'neutral', 'general', '2014-09-23 17:57:00');
INSERT INTO public.market_news (id, source, title, body, url, year, month, tickers, impact, category, published_at) VALUES (58, 'moex_sitenews', 'Об увеличении размера минимального базового гарантийного обеспечения по фьючерсам на обыкновенные акции ОАО "МТС"', 'Об увеличении размера минимального базового гарантийного обеспечения по фьючерсам на обыкновенные акции ОАО "МТС"', 'https://www.moex.com/n6288', 2014, 9, '', 'neutral', 'general', '2014-09-23 17:12:00');
INSERT INTO public.market_news (id, source, title, body, url, year, month, tickers, impact, category, published_at) VALUES (59, 'moex_sitenews', 'Об итогах размещения депозитов Федерального Казначейства 23 сентября 2014 года', 'Об итогах размещения депозитов Федерального Казначейства 23 сентября 2014 года', 'https://www.moex.com/n6287', 2014, 9, '', 'neutral', 'general', '2014-09-23 16:51:00');
INSERT INTO public.market_news (id, source, title, body, url, year, month, tickers, impact, category, published_at) VALUES (60, 'moex_sitenews', 'Об исключении ценных бумаг из Списка ценных бумаг, допущенных к торгам, и о прекращении торгов ценными бумагами', 'Об исключении ценных бумаг из Списка ценных бумаг, допущенных к торгам, и о прекращении торгов ценными бумагами', 'https://www.moex.com/n6286', 2014, 9, '', 'neutral', 'general', '2014-09-23 16:25:00');
INSERT INTO public.market_news (id, source, title, body, url, year, month, tickers, impact, category, published_at) VALUES (61, 'moex_sitenews', '23.09.2014 14-25 (мск) изменены значения нижних границ ценового коридора и диапазона оценки рыночных рисков ценной бумаги MTLR (Мечел ОАО ао).', '23.09.2014 14-25 (мск) изменены значения нижних границ ценового коридора и диапазона оценки рыночных рисков ценной бумаги MTLR (Мечел ОАО ао).', 'https://www.moex.com/n6285', 2014, 9, '', 'neutral', 'general', '2014-09-23 14:28:34');
INSERT INTO public.market_news (id, source, title, body, url, year, month, tickers, impact, category, published_at) VALUES (62, 'moex_sitenews', '24 сентября состоится отбор заявок кредитных организаций на заключение договоров банковского депозита с Пенсионным фондом Российской Федерации', '24 сентября состоится отбор заявок кредитных организаций на заключение договоров банковского депозита с Пенсионным фондом Российской Федерации', 'https://www.moex.com/n6283', 2014, 9, '', 'neutral', 'general', '2014-09-23 11:30:00');
INSERT INTO public.market_news (id, source, title, body, url, year, month, tickers, impact, category, published_at) VALUES (63, 'moex_sitenews', 'О завершении дискретного аукциона по  обыкновенным акциям ОАО "Мечел"', 'О завершении дискретного аукциона по  обыкновенным акциям ОАО "Мечел"', 'https://www.moex.com/n6282', 2014, 9, '', 'neutral', 'general', '2014-09-23 11:24:00');
INSERT INTO public.market_news (id, source, title, body, url, year, month, tickers, impact, category, published_at) VALUES (64, 'moex_sitenews', 'По обыкновенным акциям ОАО "Мечел" проводится дискретный аукцион', 'По обыкновенным акциям ОАО "Мечел" проводится дискретный аукцион', 'https://www.moex.com/n6281', 2014, 9, '', 'neutral', 'general', '2014-09-23 11:10:00');
INSERT INTO public.market_news (id, source, title, body, url, year, month, tickers, impact, category, published_at) VALUES (65, 'moex_sitenews', 'Об аккредитации участников государственных закупочных интервенций на рынке зерна', 'Об аккредитации участников государственных закупочных интервенций на рынке зерна', 'https://www.moex.com/n6280', 2014, 9, '', 'neutral', 'general', '2014-09-23 09:51:00');
INSERT INTO public.market_news (id, source, title, body, url, year, month, tickers, impact, category, published_at) VALUES (66, 'moex_sitenews', 'Итоги выпуска биржевых облигаций ЗАО "Райффайзенбанк"', 'Итоги выпуска биржевых облигаций ЗАО "Райффайзенбанк"', 'https://www.moex.com/n6279', 2014, 9, '', 'neutral', 'general', '2014-09-22 19:04:00');
INSERT INTO public.market_news (id, source, title, body, url, year, month, tickers, impact, category, published_at) VALUES (67, 'moex_sitenews', 'Ограничение кодов расчетов по облигациям серии 01 и серии 02 ООО "СИБМЕТИНВЕСТ" с 23 сентября 2014 года', 'Ограничение кодов расчетов по облигациям серии 01 и серии 02 ООО "СИБМЕТИНВЕСТ" с 23 сентября 2014 года', 'https://www.moex.com/n6277', 2014, 9, '', 'neutral', 'general', '2014-09-22 17:12:00');
INSERT INTO public.market_news (id, source, title, body, url, year, month, tickers, impact, category, published_at) VALUES (68, 'moex_sitenews', 'О начале торгов ценными бумагами 23 сентября 2014 года', 'О начале торгов ценными бумагами 23 сентября 2014 года', 'https://www.moex.com/n6276', 2014, 9, '', 'neutral', 'general', '2014-09-22 16:48:00');
INSERT INTO public.market_news (id, source, title, body, url, year, month, tickers, impact, category, published_at) VALUES (69, 'moex_sitenews', 'О внесении изменений в Перечень ценных бумаг, принимаемых в качестве средств гарантийного обеспечения на срочном рынке Московской Биржи', 'О внесении изменений в Перечень ценных бумаг, принимаемых в качестве средств гарантийного обеспечения на срочном рынке Московской Биржи', 'https://www.moex.com/n6275', 2014, 9, '', 'neutral', 'general', '2014-09-22 16:40:00');
INSERT INTO public.market_news (id, source, title, body, url, year, month, tickers, impact, category, published_at) VALUES (70, 'moex_sitenews', 'Итоги размещения депозитов Федерального Казначейства 22/09/2014', 'Итоги размещения депозитов Федерального Казначейства 22/09/2014', 'https://www.moex.com/n6274', 2014, 9, '', 'neutral', 'general', '2014-09-22 16:35:00');
INSERT INTO public.market_news (id, source, title, body, url, year, month, tickers, impact, category, published_at) VALUES (71, 'moex_sitenews', 'О внесении изменений в Список ценных бумаг, допущенных к торгам', 'О внесении изменений в Список ценных бумаг, допущенных к торгам', 'https://www.moex.com/n6273', 2014, 9, '', 'neutral', 'general', '2014-09-22 15:18:00');
INSERT INTO public.market_news (id, source, title, body, url, year, month, tickers, impact, category, published_at) VALUES (72, 'moex_sitenews', '23 сентября 2014 года состоится отбор заявок кредитных организаций на заключение договоров банковского депозита', '23 сентября 2014 года состоится отбор заявок кредитных организаций на заключение договоров банковского депозита', 'https://www.moex.com/n6272', 2014, 9, '', 'neutral', 'general', '2014-09-22 11:25:00');
INSERT INTO public.market_news (id, source, title, body, url, year, month, tickers, impact, category, published_at) VALUES (73, 'moex_sitenews', '22.09.2014 10-05 (мск) изменены значения нижних границ ценового коридора и диапазона оценки рыночных рисков валютной пары SLV/RUB.', '22.09.2014 10-05 (мск) изменены значения нижних границ ценового коридора и диапазона оценки рыночных рисков валютной пары SLV/RUB.', 'https://www.moex.com/n6271', 2014, 9, '', 'neutral', 'general', '2014-09-22 10:08:21');
INSERT INTO public.market_news (id, source, title, body, url, year, month, tickers, impact, category, published_at) VALUES (74, 'moex_sitenews', 'Об условиях проведения торгов ценными бумагами ОАО "МТС"', 'Об условиях проведения торгов ценными бумагами ОАО "МТС"', 'https://www.moex.com/n6270', 2014, 9, '', 'neutral', 'general', '2014-09-19 18:56:00');
INSERT INTO public.market_news (id, source, title, body, url, year, month, tickers, impact, category, published_at) VALUES (75, 'moex_sitenews', 'Об ограничении кодов расчетов по акциям обыкновенным ОАО "Мобильные ТелеСистемы" с 22 сентября 2014 года', 'Об ограничении кодов расчетов по акциям обыкновенным ОАО "Мобильные ТелеСистемы" с 22 сентября 2014 года', 'https://www.moex.com/n6269', 2014, 9, '', 'neutral', 'general', '2014-09-19 16:38:00');
INSERT INTO public.market_news (id, source, title, body, url, year, month, tickers, impact, category, published_at) VALUES (76, 'moex_sitenews', 'О начале торгов ценными бумагами 22 сентября 2014 года', 'О начале торгов ценными бумагами 22 сентября 2014 года', 'https://www.moex.com/n6267', 2014, 9, '', 'neutral', 'general', '2014-09-19 15:24:00');
INSERT INTO public.market_news (id, source, title, body, url, year, month, tickers, impact, category, published_at) VALUES (77, 'moex_sitenews', 'О внесении изменений в Список ценных бумаг, допущенных к торгам', 'О внесении изменений в Список ценных бумаг, допущенных к торгам', 'https://www.moex.com/n6266', 2014, 9, '', 'neutral', 'general', '2014-09-19 15:21:00');
INSERT INTO public.market_news (id, source, title, body, url, year, month, tickers, impact, category, published_at) VALUES (78, 'moex_sitenews', 'О включении  биржевых облигаций ЗАО "ТПГК-Финанс" в Список ценных бумаг, допущенных к торгам, и о присвоении указанным биржевым облигациям идентификационных номеров', 'О включении  биржевых облигаций ЗАО "ТПГК-Финанс" в Список ценных бумаг, допущенных к торгам, и о присвоении указанным биржевым облигациям идентификационных номеров', 'https://www.moex.com/n6265', 2014, 9, '', 'neutral', 'general', '2014-09-19 15:18:00');
INSERT INTO public.market_news (id, source, title, body, url, year, month, tickers, impact, category, published_at) VALUES (79, 'moex_sitenews', 'О функционировании торгово-клиринговой системы срочного рынка Московской Биржи', 'О функционировании торгово-клиринговой системы срочного рынка Московской Биржи', 'https://www.moex.com/n6264', 2014, 9, '', 'neutral', 'general', '2014-09-19 13:48:00');
INSERT INTO public.market_news (id, source, title, body, url, year, month, tickers, impact, category, published_at) VALUES (80, 'moex_sitenews', 'Итоги выпуска биржевых облигаций ОАО "АЛЬФА-БАНК"', 'Итоги выпуска биржевых облигаций ОАО "АЛЬФА-БАНК"', 'https://www.moex.com/n6263', 2014, 9, '', 'neutral', 'general', '2014-09-19 10:58:00');
INSERT INTO public.market_news (id, source, title, body, url, year, month, tickers, impact, category, published_at) VALUES (81, 'moex_sitenews', '22 сентября 2014 года состоится отбор заявок кредитных организаций на заключение договоров банковского депозита', '22 сентября 2014 года состоится отбор заявок кредитных организаций на заключение договоров банковского депозита', 'https://www.moex.com/n6262', 2014, 9, '', 'neutral', 'general', '2014-09-19 10:55:00');
INSERT INTO public.market_news (id, source, title, body, url, year, month, tickers, impact, category, published_at) VALUES (82, 'moex_sitenews', '18.09.2014 18-13 (мск) изменены значения верхних границ ценового коридора и диапазона оценки рыночных рисков валютной пары CNY/RUB.', '18.09.2014 18-13 (мск) изменены значения верхних границ ценового коридора и диапазона оценки рыночных рисков валютной пары CNY/RUB.', 'https://www.moex.com/n6261', 2014, 9, '', 'neutral', 'general', '2014-09-18 18:16:02');
INSERT INTO public.market_news (id, source, title, body, url, year, month, tickers, impact, category, published_at) VALUES (83, 'moex_sitenews', 'Об итогах размещения депозитов Федерального Казначейства 18 сентября 2014 года', 'Об итогах размещения депозитов Федерального Казначейства 18 сентября 2014 года', 'https://www.moex.com/n6260', 2014, 9, '', 'neutral', 'general', '2014-09-18 15:39:00');
INSERT INTO public.market_news (id, source, title, body, url, year, month, tickers, impact, category, published_at) VALUES (84, 'moex_sitenews', 'Об итогах размещения депозитов Пенсионным фондом Российской Федерации 17 сентября 2014 года', 'Об итогах размещения депозитов Пенсионным фондом Российской Федерации 17 сентября 2014 года', 'https://www.moex.com/n6259', 2014, 9, '', 'neutral', 'general', '2014-09-18 14:38:00');
INSERT INTO public.market_news (id, source, title, body, url, year, month, tickers, impact, category, published_at) VALUES (85, 'moex_sitenews', 'О включении биржевых облигаций ОАО "Группа Компаний ПИК" в Список ценных бумаг, допущенных к торгам, и о присвоении указанным биржевым облигациям идентификационных номеров', 'О включении биржевых облигаций ОАО "Группа Компаний ПИК" в Список ценных бумаг, допущенных к торгам, и о присвоении указанным биржевым облигациям идентификационных номеров', 'https://www.moex.com/n6258', 2014, 9, '', 'neutral', 'general', '2014-09-18 14:24:00');
INSERT INTO public.market_news (id, source, title, body, url, year, month, tickers, impact, category, published_at) VALUES (86, 'moex_sitenews', 'Об утверждении изменений в решения о выпусках и проспект биржевых облигаций ОАО "МРСК Центра и Приволжья"', 'Об утверждении изменений в решения о выпусках и проспект биржевых облигаций ОАО "МРСК Центра и Приволжья"', 'https://www.moex.com/n6257', 2014, 9, '', 'neutral', 'general', '2014-09-18 14:23:00');
INSERT INTO public.market_news (id, source, title, body, url, year, month, tickers, impact, category, published_at) VALUES (87, 'moex_sitenews', '18.09.2014 09-26 (мск) изменены значения верхней и нижней границ ценового коридора и диапазона оценки рыночных рисков ценной бумаги AFKS (АФК "Система" ОАО ао).', '18.09.2014 09-26 (мск) изменены значения верхней и нижней границ ценового коридора и диапазона оценки рыночных рисков ценной бумаги AFKS (АФК "Система" ОАО ао).', 'https://www.moex.com/n6256', 2014, 9, '', 'neutral', 'general', '2014-09-18 09:38:23');
INSERT INTO public.market_news (id, source, title, body, url, year, month, tickers, impact, category, published_at) VALUES (88, 'moex_sitenews', 'На Московской Бирже состоялось заседание Совета Биржи', 'На Московской Бирже состоялось заседание Совета Биржи', 'https://www.moex.com/n6255', 2014, 9, '', 'neutral', 'general', '2014-09-17 17:59:00');
INSERT INTO public.market_news (id, source, title, body, url, year, month, tickers, impact, category, published_at) VALUES (89, 'moex_sitenews', 'Расписание нагрузочного тестирования 20 сентября 2014', 'Расписание нагрузочного тестирования 20 сентября 2014', 'https://www.moex.com/n6253', 2014, 9, '', 'neutral', 'general', '2014-09-17 16:33:00');
INSERT INTO public.market_news (id, source, title, body, url, year, month, tickers, impact, category, published_at) VALUES (90, 'moex_sitenews', 'О внесении изменений в Список ценных бумаг, допущенных к торгам', 'О внесении изменений в Список ценных бумаг, допущенных к торгам', 'https://www.moex.com/n6252', 2014, 9, '', 'neutral', 'general', '2014-09-17 16:28:00');
INSERT INTO public.market_news (id, source, title, body, url, year, month, tickers, impact, category, published_at) VALUES (91, 'moex_sitenews', 'О начале торгов ценными бумагами 18 сентября 2014 года', 'О начале торгов ценными бумагами 18 сентября 2014 года', 'https://www.moex.com/n6251', 2014, 9, '', 'neutral', 'general', '2014-09-17 16:10:00');
INSERT INTO public.market_news (id, source, title, body, url, year, month, tickers, impact, category, published_at) VALUES (92, 'moex_sitenews', 'Завершено проведение дискретного аукциона по  привилегированным акциям ОАО "АНК "Башнефть"', 'Завершено проведение дискретного аукциона по  привилегированным акциям ОАО "АНК "Башнефть"', 'https://www.moex.com/n6250', 2014, 9, '', 'neutral', 'general', '2014-09-17 13:03:00');
INSERT INTO public.market_news (id, source, title, body, url, year, month, tickers, impact, category, published_at) VALUES (93, 'moex_sitenews', 'Завершено проведение дискретного аукциона по обыкновенным акциям ОАО "АНК "Башнефть"', 'Завершено проведение дискретного аукциона по обыкновенным акциям ОАО "АНК "Башнефть"', 'https://www.moex.com/n6249', 2014, 9, '', 'neutral', 'general', '2014-09-17 12:52:00');
INSERT INTO public.market_news (id, source, title, body, url, year, month, tickers, impact, category, published_at) VALUES (94, 'moex_sitenews', 'По привилегированным акциям ОАО "АНК "Башнефть" проводится дискретный аукцион', 'По привилегированным акциям ОАО "АНК "Башнефть" проводится дискретный аукцион', 'https://www.moex.com/n6248', 2014, 9, '', 'neutral', 'general', '2014-09-17 12:25:00');
INSERT INTO public.market_news (id, source, title, body, url, year, month, tickers, impact, category, published_at) VALUES (95, 'moex_sitenews', 'По обыкновенным акциям ОАО "АНК "Башнефть" проводится дискретный аукцион', 'По обыкновенным акциям ОАО "АНК "Башнефть" проводится дискретный аукцион', 'https://www.moex.com/n6247', 2014, 9, '', 'neutral', 'general', '2014-09-17 12:15:00');
INSERT INTO public.market_news (id, source, title, body, url, year, month, tickers, impact, category, published_at) VALUES (96, 'moex_sitenews', 'Об изменении параметров инвестиционных паев с 18 сентября 2014 года', 'Об изменении параметров инвестиционных паев с 18 сентября 2014 года', 'https://www.moex.com/n6245', 2014, 9, '', 'neutral', 'general', '2014-09-17 12:05:00');
INSERT INTO public.market_news (id, source, title, body, url, year, month, tickers, impact, category, published_at) VALUES (97, 'moex_sitenews', '17.09.2014 12-03 (мск) изменены значения нижних границ ценового коридора и диапазона оценки рыночных рисков ценной бумаги BANE (Башнефть АНК ао).', '17.09.2014 12-03 (мск) изменены значения нижних границ ценового коридора и диапазона оценки рыночных рисков ценной бумаги BANE (Башнефть АНК ао).', 'https://www.moex.com/n6246', 2014, 9, '', 'neutral', 'general', '2014-09-17 12:03:17');
INSERT INTO public.market_news (id, source, title, body, url, year, month, tickers, impact, category, published_at) VALUES (98, 'moex_sitenews', '17.09.2014 11-50 (мск) изменены значения нижних границ ценового коридора и диапазона оценки рыночных рисков ценной бумаги AFKS (АФК "Система" ОАО ао).', '17.09.2014 11-50 (мск) изменены значения нижних границ ценового коридора и диапазона оценки рыночных рисков ценной бумаги AFKS (АФК "Система" ОАО ао).', 'https://www.moex.com/n6244', 2014, 9, '', 'neutral', 'general', '2014-09-17 11:50:30');
INSERT INTO public.market_news (id, source, title, body, url, year, month, tickers, impact, category, published_at) VALUES (99, 'moex_sitenews', '17.09.2014 11-30 (мск) изменены значения нижних границ ценового коридора и диапазона оценки рыночных рисков ценной бумаги BANE (Башнефть АНК ао).', '17.09.2014 11-30 (мск) изменены значения нижних границ ценового коридора и диапазона оценки рыночных рисков ценной бумаги BANE (Башнефть АНК ао).', 'https://www.moex.com/n6243', 2014, 9, '', 'neutral', 'general', '2014-09-17 11:30:22');
INSERT INTO public.market_news (id, source, title, body, url, year, month, tickers, impact, category, published_at) VALUES (100, 'moex_sitenews', '18 сентября 2014 года состоится отбор заявок кредитных организаций на заключение договоров банковского депозита', '18 сентября 2014 года состоится отбор заявок кредитных организаций на заключение договоров банковского депозита', 'https://www.moex.com/n6242', 2014, 9, '', 'neutral', 'general', '2014-09-17 11:30:00');
INSERT INTO public.market_news (id, source, title, body, url, year, month, tickers, impact, category, published_at) VALUES (101, 'moex_sitenews', '17.09.2014 11-24 (мск) изменены значения нижних границ ценового коридора и диапазона оценки рыночных рисков ценной бумаги BANEP (Башнефть АНК ап).', '17.09.2014 11-24 (мск) изменены значения нижних границ ценового коридора и диапазона оценки рыночных рисков ценной бумаги BANEP (Башнефть АНК ап).', 'https://www.moex.com/n6241', 2014, 9, '', 'neutral', 'general', '2014-09-17 11:24:31');
INSERT INTO public.market_news (id, source, title, body, url, year, month, tickers, impact, category, published_at) VALUES (102, 'moex_sitenews', 'Завершено проведение дискретного аукциона по обыкновенным акциям ОАО АФК "Система"', 'Завершено проведение дискретного аукциона по обыкновенным акциям ОАО АФК "Система"', 'https://www.moex.com/n6240', 2014, 9, '', 'neutral', 'general', '2014-09-17 11:03:00');
INSERT INTO public.market_news (id, source, title, body, url, year, month, tickers, impact, category, published_at) VALUES (103, 'moex_sitenews', '17.09.2014 10-37 (мск) изменены значения нижних границ ценового коридора и диапазона оценки рыночных рисков ценной бумаги MTSS (Мобильные ТелеСистемы (ОАО) ао).', '17.09.2014 10-37 (мск) изменены значения нижних границ ценового коридора и диапазона оценки рыночных рисков ценной бумаги MTSS (Мобильные ТелеСистемы (ОАО) ао).', 'https://www.moex.com/n6239', 2014, 9, 'MTSS', 'neutral', 'general', '2014-09-17 10:37:36');
INSERT INTO public.market_news (id, source, title, body, url, year, month, tickers, impact, category, published_at) VALUES (104, 'moex_sitenews', 'По обыкновенным акциям ОАО АФК "Система" проводится дискретный аукцион', 'По обыкновенным акциям ОАО АФК "Система" проводится дискретный аукцион', 'https://www.moex.com/n6238', 2014, 9, '', 'neutral', 'general', '2014-09-17 10:32:00');
INSERT INTO public.market_news (id, source, title, body, url, year, month, tickers, impact, category, published_at) VALUES (105, 'moex_sitenews', '17.09.2014 10-10 (мск) изменены значения нижних границ ценового коридора и диапазона оценки рыночных рисков ценной бумаги AFKS (АФК "Система" ОАО ао).', '17.09.2014 10-10 (мск) изменены значения нижних границ ценового коридора и диапазона оценки рыночных рисков ценной бумаги AFKS (АФК "Система" ОАО ао).', 'https://www.moex.com/n6237', 2014, 9, '', 'neutral', 'general', '2014-09-17 10:10:49');
INSERT INTO public.market_news (id, source, title, body, url, year, month, tickers, impact, category, published_at) VALUES (106, 'moex_sitenews', '17.09.2014 10-05 (мск) изменены значения нижних границ ценового коридора и диапазона оценки рыночных рисков ценной бумаги AFKS (АФК "Система" ОАО ао).', '17.09.2014 10-05 (мск) изменены значения нижних границ ценового коридора и диапазона оценки рыночных рисков ценной бумаги AFKS (АФК "Система" ОАО ао).', 'https://www.moex.com/n6236', 2014, 9, '', 'neutral', 'general', '2014-09-17 10:05:07');
INSERT INTO public.market_news (id, source, title, body, url, year, month, tickers, impact, category, published_at) VALUES (107, 'moex_sitenews', 'Определены цены исполнения фьючерсного контракта на нефть сорта Brent', 'Определены цены исполнения фьючерсного контракта на нефть сорта Brent', 'https://www.moex.com/n6235', 2014, 9, '', 'neutral', 'general', '2014-09-16 18:06:00');
INSERT INTO public.market_news (id, source, title, body, url, year, month, tickers, impact, category, published_at) VALUES (108, 'moex_sitenews', 'Итоги выпуска биржевых облигаций ООО "ОВК Финанс"', 'Итоги выпуска биржевых облигаций ООО "ОВК Финанс"', 'https://www.moex.com/n6234', 2014, 9, '', 'neutral', 'general', '2014-09-16 16:58:00');
INSERT INTO public.market_news (id, source, title, body, url, year, month, tickers, impact, category, published_at) VALUES (109, 'moex_sitenews', 'Об исключении ценных бумаг из Списка ценных бумаг, допущенных к торгам, и о прекращении торгов ценными бумагами', 'Об исключении ценных бумаг из Списка ценных бумаг, допущенных к торгам, и о прекращении торгов ценными бумагами', 'https://www.moex.com/n6233', 2014, 9, '', 'neutral', 'general', '2014-09-16 16:56:00');
INSERT INTO public.market_news (id, source, title, body, url, year, month, tickers, impact, category, published_at) VALUES (110, 'moex_sitenews', 'О приостановке торгов облигациями  АКБ "ИнтрастБанк" (ОАО) с 23 сентября 2014 года', 'О приостановке торгов облигациями  АКБ "ИнтрастБанк" (ОАО) с 23 сентября 2014 года', 'https://www.moex.com/n6232', 2014, 9, '', 'neutral', 'general', '2014-09-16 16:56:00');
INSERT INTO public.market_news (id, source, title, body, url, year, month, tickers, impact, category, published_at) VALUES (111, 'moex_sitenews', 'Об итогах размещения депозитов Федерального Казначейства 16 сентября 2014 года', 'Об итогах размещения депозитов Федерального Казначейства 16 сентября 2014 года', 'https://www.moex.com/n6231', 2014, 9, '', 'neutral', 'general', '2014-09-16 16:53:00');
INSERT INTO public.market_news (id, source, title, body, url, year, month, tickers, impact, category, published_at) VALUES (112, 'moex_sitenews', 'О приостановке торгов Облигациями класса "А" ЗАО "Ипотечный агент МБРР" с 22 сентября 2014 года', 'О приостановке торгов Облигациями класса "А" ЗАО "Ипотечный агент МБРР" с 22 сентября 2014 года', 'https://www.moex.com/n6230', 2014, 9, '', 'neutral', 'general', '2014-09-16 15:45:00');
INSERT INTO public.market_news (id, source, title, body, url, year, month, tickers, impact, category, published_at) VALUES (113, 'moex_sitenews', 'Об ограничении кодов расчетов по акциям обыкновенным ОАО "Территориальная генерирующая компания"', 'Об ограничении кодов расчетов по акциям обыкновенным ОАО "Территориальная генерирующая компания"', 'https://www.moex.com/n6229', 2014, 9, '', 'neutral', 'general', '2014-09-16 15:20:00');
INSERT INTO public.market_news (id, source, title, body, url, year, month, tickers, impact, category, published_at) VALUES (114, 'moex_sitenews', 'О внесении изменений в Список ценных бумаг, допущенных к торгам', 'О внесении изменений в Список ценных бумаг, допущенных к торгам', 'https://www.moex.com/n6228', 2014, 9, '', 'neutral', 'general', '2014-09-16 14:11:00');
INSERT INTO public.market_news (id, source, title, body, url, year, month, tickers, impact, category, published_at) VALUES (115, 'moex_sitenews', '17 сентября 2014 года состоится отбор заявок на заключение договоров банковского депозита с Пенсионным фондом России', '17 сентября 2014 года состоится отбор заявок на заключение договоров банковского депозита с Пенсионным фондом России', 'https://www.moex.com/n6227', 2014, 9, '', 'neutral', 'general', '2014-09-16 12:57:00');
INSERT INTO public.market_news (id, source, title, body, url, year, month, tickers, impact, category, published_at) VALUES (116, 'moex_sitenews', 'Об ограничении допустимых кодов расчетов и режимов торгов по облигациям Интрастбанка', 'Об ограничении допустимых кодов расчетов и режимов торгов по облигациям Интрастбанка', 'https://www.moex.com/n6226', 2014, 9, '', 'neutral', 'general', '2014-09-16 11:25:00');
INSERT INTO public.market_news (id, source, title, body, url, year, month, tickers, impact, category, published_at) VALUES (117, 'moex_sitenews', 'С 16 сентября обновлены Коэффициенты D (Делитель) и Z коэффициенты для индексов акций', 'С 16 сентября обновлены Коэффициенты D (Делитель) и Z коэффициенты для индексов акций', 'https://www.moex.com/n6225', 2014, 9, '', 'neutral', 'general', '2014-09-15 20:54:00');
INSERT INTO public.market_news (id, source, title, body, url, year, month, tickers, impact, category, published_at) VALUES (118, 'moex_sitenews', 'Определены цены исполнения фьючерсных контрактов на драгоценные металлы', 'Определены цены исполнения фьючерсных контрактов на драгоценные металлы', 'https://www.moex.com/n6223', 2014, 9, '', 'neutral', 'general', '2014-09-15 18:37:00');
INSERT INTO public.market_news (id, source, title, body, url, year, month, tickers, impact, category, published_at) VALUES (119, 'moex_sitenews', 'Определены цены исполнения сентябрьских фьючерсов на индексы РТС и ММВБ', 'Определены цены исполнения сентябрьских фьючерсов на индексы РТС и ММВБ', 'https://www.moex.com/n6222', 2014, 9, '', 'neutral', 'general', '2014-09-15 17:56:00');
INSERT INTO public.market_news (id, source, title, body, url, year, month, tickers, impact, category, published_at) VALUES (120, 'moex_sitenews', 'Определены цены исполнения фьючерсных контрактов на валютные пары и процентные ставки', 'Определены цены исполнения фьючерсных контрактов на валютные пары и процентные ставки', 'https://www.moex.com/n6221', 2014, 9, '', 'neutral', 'general', '2014-09-15 16:30:00');
INSERT INTO public.market_news (id, source, title, body, url, year, month, tickers, impact, category, published_at) VALUES (121, 'moex_sitenews', 'О начале торгов ценными бумагами 16 сентября 2014 года', 'О начале торгов ценными бумагами 16 сентября 2014 года', 'https://www.moex.com/n6220', 2014, 9, '', 'neutral', 'general', '2014-09-15 16:09:00');
INSERT INTO public.market_news (id, source, title, body, url, year, month, tickers, impact, category, published_at) VALUES (122, 'moex_sitenews', 'Об утверждении изменений в решения о выпусках и проспекты биржевых облигаций КБ "ЛОКО-Банк" (ЗАО), КБ "Ренессанс Кредит" (ООО) и ООО ИКБ "Совкомбанк"', 'Об утверждении изменений в решения о выпусках и проспекты биржевых облигаций КБ "ЛОКО-Банк" (ЗАО), КБ "Ренессанс Кредит" (ООО) и ООО ИКБ "Совкомбанк"', 'https://www.moex.com/n6219', 2014, 9, '', 'neutral', 'general', '2014-09-15 16:07:00');
INSERT INTO public.market_news (id, source, title, body, url, year, month, tickers, impact, category, published_at) VALUES (123, 'moex_sitenews', 'Об изменении параметров ценных бумаг с 16 сентября 2014 года', 'Об изменении параметров ценных бумаг с 16 сентября 2014 года', 'https://www.moex.com/n6218', 2014, 9, '', 'neutral', 'general', '2014-09-15 14:46:00');
INSERT INTO public.market_news (id, source, title, body, url, year, month, tickers, impact, category, published_at) VALUES (124, 'moex_sitenews', 'На Московской Бирже начинаются торги фьючерсами на еврооблигации РФ', 'На Московской Бирже начинаются торги фьючерсами на еврооблигации РФ', 'https://www.moex.com/n6217', 2014, 9, '', 'neutral', 'general', '2014-09-15 14:17:00');
INSERT INTO public.market_news (id, source, title, body, url, year, month, tickers, impact, category, published_at) VALUES (125, 'moex_sitenews', 'С 15 сентября утратила силу Методика расчета Индексов цен на нефтепродукты сопоставимых зарубежных рынков', 'С 15 сентября утратила силу Методика расчета Индексов цен на нефтепродукты сопоставимых зарубежных рынков', 'https://www.moex.com/n6216', 2014, 9, '', 'neutral', 'general', '2014-09-15 12:16:00');
INSERT INTO public.market_news (id, source, title, body, url, year, month, tickers, impact, category, published_at) VALUES (126, 'moex_sitenews', 'Об изменении параметров ценных бумаг', 'Об изменении параметров ценных бумаг', 'https://www.moex.com/n6215', 2014, 9, '', 'neutral', 'general', '2014-09-15 11:53:00');
INSERT INTO public.market_news (id, source, title, body, url, year, month, tickers, impact, category, published_at) VALUES (127, 'moex_sitenews', '16 сентября 2014 года состоится отбор заявок кредитных организаций на заключение договоров банковского депозита', '16 сентября 2014 года состоится отбор заявок кредитных организаций на заключение договоров банковского депозита', 'https://www.moex.com/n6214', 2014, 9, '', 'neutral', 'general', '2014-09-15 10:42:00');
INSERT INTO public.market_news (id, source, title, body, url, year, month, tickers, impact, category, published_at) VALUES (128, 'moex_sitenews', 'С 15 сентября вводится в действие новый состав базы расчета Кривой бескупонной доходности государственных ценных бумаг', 'С 15 сентября вводится в действие новый состав базы расчета Кривой бескупонной доходности государственных ценных бумаг', 'https://www.moex.com/n6213', 2014, 9, '', 'neutral', 'general', '2014-09-12 17:56:00');
INSERT INTO public.market_news (id, source, title, body, url, year, month, tickers, impact, category, published_at) VALUES (129, 'moex_sitenews', 'Итоги выпуска биржевых облигаций ООО "Обувьрус"', 'Итоги выпуска биржевых облигаций ООО "Обувьрус"', 'https://www.moex.com/n6212', 2014, 9, '', 'neutral', 'general', '2014-09-12 15:43:00');
INSERT INTO public.market_news (id, source, title, body, url, year, month, tickers, impact, category, published_at) VALUES (130, 'moex_sitenews', 'Об изменении уровня листинга ценных бумаг', 'Об изменении уровня листинга ценных бумаг', 'https://www.moex.com/n6211', 2014, 9, '', 'neutral', 'general', '2014-09-12 15:22:00');
INSERT INTO public.market_news (id, source, title, body, url, year, month, tickers, impact, category, published_at) VALUES (131, 'moex_sitenews', 'О начале торгов ценными бумагами 12 сентября 2014 года', 'О начале торгов ценными бумагами 12 сентября 2014 года', 'https://www.moex.com/n6210', 2014, 9, '', 'neutral', 'general', '2014-09-11 16:29:00');
INSERT INTO public.market_news (id, source, title, body, url, year, month, tickers, impact, category, published_at) VALUES (132, 'moex_sitenews', 'Об итогах размещения депозитов Федерального Казначейства 11 сентября 2014 года', 'Об итогах размещения депозитов Федерального Казначейства 11 сентября 2014 года', 'https://www.moex.com/n6209', 2014, 9, '', 'neutral', 'general', '2014-09-11 16:25:00');
INSERT INTO public.market_news (id, source, title, body, url, year, month, tickers, impact, category, published_at) VALUES (133, 'moex_sitenews', 'Об исключении ценных бумаг из Списка ценных бумаг, допущенных к торгам, и о прекращении торгов ценными бумагами', 'Об исключении ценных бумаг из Списка ценных бумаг, допущенных к торгам, и о прекращении торгов ценными бумагами', 'https://www.moex.com/n6208', 2014, 9, '', 'neutral', 'general', '2014-09-11 15:41:00');
INSERT INTO public.market_news (id, source, title, body, url, year, month, tickers, impact, category, published_at) VALUES (134, 'moex_sitenews', 'О внесении изменений в Список ценных бумаг, допущенных к торгам', 'О внесении изменений в Список ценных бумаг, допущенных к торгам', 'https://www.moex.com/n6207', 2014, 9, '', 'neutral', 'general', '2014-09-11 15:16:00');
INSERT INTO public.market_news (id, source, title, body, url, year, month, tickers, impact, category, published_at) VALUES (135, 'moex_sitenews', 'Об изменении фиксинга для определения цены исполнения фьючерсов на серебро', 'Об изменении фиксинга для определения цены исполнения фьючерсов на серебро', 'https://www.moex.com/n6206', 2014, 9, '', 'neutral', 'general', '2014-09-11 12:51:00');
INSERT INTO public.market_news (id, source, title, body, url, year, month, tickers, impact, category, published_at) VALUES (136, 'moex_sitenews', '11.09.2014 11-38 (мск) изменены значения нижних границ ценового коридора РЕПО и диапазона оценки процентных рисков ценной бумаги NVTK (ОАО "НОВАТЭК" ао).', '11.09.2014 11-38 (мск) изменены значения нижних границ ценового коридора РЕПО и диапазона оценки процентных рисков ценной бумаги NVTK (ОАО "НОВАТЭК" ао).', 'https://www.moex.com/n6202', 2014, 9, 'NVTK', 'neutral', 'general', '2014-09-11 11:40:29');
INSERT INTO public.market_news (id, source, title, body, url, year, month, tickers, impact, category, published_at) VALUES (137, 'moex_sitenews', '11.09.2014 11-38 (мск) изменены значения нижних границ ценового коридора РЕПО и диапазона оценки процентных рисков ценной бумаги NVTK (ОАО "НОВАТЭК" ао).', '11.09.2014 11-38 (мск) изменены значения нижних границ ценового коридора РЕПО и диапазона оценки процентных рисков ценной бумаги NVTK (ОАО "НОВАТЭК" ао).', 'https://www.moex.com/n6204', 2014, 9, 'NVTK', 'neutral', 'general', '2014-09-11 11:40:29');
INSERT INTO public.market_news (id, source, title, body, url, year, month, tickers, impact, category, published_at) VALUES (138, 'moex_sitenews', '11.09.2014 11-30 (мск) изменены значения нижних границ ценового коридора РЕПО и диапазона оценки процентных рисков ценной бумаги NVTK (ОАО "НОВАТЭК" ао).', '11.09.2014 11-30 (мск) изменены значения нижних границ ценового коридора РЕПО и диапазона оценки процентных рисков ценной бумаги NVTK (ОАО "НОВАТЭК" ао).', 'https://www.moex.com/n6203', 2014, 9, 'NVTK', 'neutral', 'general', '2014-09-11 11:32:33');
INSERT INTO public.market_news (id, source, title, body, url, year, month, tickers, impact, category, published_at) VALUES (139, 'moex_sitenews', '11.09.2014 11-30 (мск) изменены значения нижних границ ценового коридора РЕПО и диапазона оценки процентных рисков ценной бумаги NVTK (ОАО "НОВАТЭК" ао).', '11.09.2014 11-30 (мск) изменены значения нижних границ ценового коридора РЕПО и диапазона оценки процентных рисков ценной бумаги NVTK (ОАО "НОВАТЭК" ао).', 'https://www.moex.com/n6205', 2014, 9, 'NVTK', 'neutral', 'general', '2014-09-11 11:32:33');
INSERT INTO public.market_news (id, source, title, body, url, year, month, tickers, impact, category, published_at) VALUES (140, 'moex_sitenews', 'Итоги выпуска биржевых облигаций КИТ Финанс Капитал (ООО)', 'Итоги выпуска биржевых облигаций КИТ Финанс Капитал (ООО)', 'https://www.moex.com/n6201', 2014, 9, '', 'neutral', 'general', '2014-09-11 10:33:00');
INSERT INTO public.market_news (id, source, title, body, url, year, month, tickers, impact, category, published_at) VALUES (141, 'moex_sitenews', 'О планируемых изменениях в Клиринговом листе НКЦ', 'О планируемых изменениях в Клиринговом листе НКЦ', 'https://www.moex.com/n6199', 2014, 9, '', 'neutral', 'general', '2014-09-11 10:00:00');
INSERT INTO public.market_news (id, source, title, body, url, year, month, tickers, impact, category, published_at) VALUES (142, 'moex_sitenews', 'Об исключении ценных бумаг из Списка ценных бумаг, допущенных к торгам, и о прекращении торгов ценными бумагами', 'Об исключении ценных бумаг из Списка ценных бумаг, допущенных к торгам, и о прекращении торгов ценными бумагами', 'https://www.moex.com/n6197', 2014, 9, '', 'neutral', 'general', '2014-09-10 16:39:00');
INSERT INTO public.market_news (id, source, title, body, url, year, month, tickers, impact, category, published_at) VALUES (143, 'moex_sitenews', 'О допустимых кодах расчетов по ценным бумагам', 'О допустимых кодах расчетов по ценным бумагам', 'https://www.moex.com/n6196', 2014, 9, '', 'neutral', 'general', '2014-09-10 12:05:00');
INSERT INTO public.market_news (id, source, title, body, url, year, month, tickers, impact, category, published_at) VALUES (144, 'moex_sitenews', 'Порядок исполнения фьючерсов и опционов на срочном рынке в сентябре 2014 года', 'Порядок исполнения фьючерсов и опционов на срочном рынке в сентябре 2014 года', 'https://www.moex.com/n6195', 2014, 9, '', 'neutral', 'general', '2014-09-10 12:03:00');
INSERT INTO public.market_news (id, source, title, body, url, year, month, tickers, impact, category, published_at) VALUES (145, 'moex_sitenews', '11 сентября 2014 года состоится отбор заявок кредитных организаций на заключение договоров банковского депозита', '11 сентября 2014 года состоится отбор заявок кредитных организаций на заключение договоров банковского депозита', 'https://www.moex.com/n6194', 2014, 9, '', 'neutral', 'general', '2014-09-10 10:46:00');
INSERT INTO public.market_news (id, source, title, body, url, year, month, tickers, impact, category, published_at) VALUES (146, 'moex_sitenews', 'График проведение торгов иностранной валютой на Московской Бирже 3 ноября 2014 года', 'График проведение торгов иностранной валютой на Московской Бирже 3 ноября 2014 года', 'https://www.moex.com/n6193', 2014, 9, '', 'neutral', 'general', '2014-09-09 17:23:00');
INSERT INTO public.market_news (id, source, title, body, url, year, month, tickers, impact, category, published_at) VALUES (147, 'moex_sitenews', 'Об итогах размещения депозитов Федерального Казначейства 9 сентября 2014 года', 'Об итогах размещения депозитов Федерального Казначейства 9 сентября 2014 года', 'https://www.moex.com/n6192', 2014, 9, '', 'neutral', 'general', '2014-09-09 16:33:00');
INSERT INTO public.market_news (id, source, title, body, url, year, month, tickers, impact, category, published_at) VALUES (148, 'moex_sitenews', 'О начале торгов ценными бумагами 10 сентября 2014 года', 'О начале торгов ценными бумагами 10 сентября 2014 года', 'https://www.moex.com/n6191', 2014, 9, '', 'neutral', 'general', '2014-09-09 16:08:00');
INSERT INTO public.market_news (id, source, title, body, url, year, month, tickers, impact, category, published_at) VALUES (149, 'moex_sitenews', 'Об исключении ценных бумаг из Списка ценных бумаг, допущенных к торгам, и о прекращении торгов ценными бумагами', 'Об исключении ценных бумаг из Списка ценных бумаг, допущенных к торгам, и о прекращении торгов ценными бумагами', 'https://www.moex.com/n6190', 2014, 9, '', 'neutral', 'general', '2014-09-09 15:57:00');
INSERT INTO public.market_news (id, source, title, body, url, year, month, tickers, impact, category, published_at) VALUES (150, 'moex_sitenews', 'Об изменении шага цены на фондовом рынке Московской Биржи с 1 октября 2014 года', 'Об изменении шага цены на фондовом рынке Московской Биржи с 1 октября 2014 года', 'https://www.moex.com/n6189', 2014, 9, '', 'neutral', 'general', '2014-09-09 15:30:00');
INSERT INTO public.market_news (id, source, title, body, url, year, month, tickers, impact, category, published_at) VALUES (151, 'moex_sitenews', '9 сентября 2014 года состоится отбор заявок кредитных организаций на заключение договоров банковского депозита', '9 сентября 2014 года состоится отбор заявок кредитных организаций на заключение договоров банковского депозита', 'https://www.moex.com/n6188', 2014, 9, '', 'neutral', 'general', '2014-09-09 10:04:00');
INSERT INTO public.market_news (id, source, title, body, url, year, month, tickers, impact, category, published_at) VALUES (152, 'moex_sitenews', 'Об изменении параметров биржевых облигаций серии БО-11  Внешэкономбанка с 9 сентября 2014 года', 'Об изменении параметров биржевых облигаций серии БО-11  Внешэкономбанка с 9 сентября 2014 года', 'https://www.moex.com/n6187', 2014, 9, '', 'neutral', 'general', '2014-09-08 19:36:00');
INSERT INTO public.market_news (id, source, title, body, url, year, month, tickers, impact, category, published_at) VALUES (153, 'moex_sitenews', 'Итоги выпуска биржевых облигаций "Запсибкомбанк" ОАО и Внешэкономбанка', 'Итоги выпуска биржевых облигаций "Запсибкомбанк" ОАО и Внешэкономбанка', 'https://www.moex.com/n6185', 2014, 9, '', 'neutral', 'general', '2014-09-08 17:25:00');
INSERT INTO public.market_news (id, source, title, body, url, year, month, tickers, impact, category, published_at) VALUES (154, 'moex_sitenews', 'На Московской Бирже начинаются торги фьючерсом на волатильность RVI', 'На Московской Бирже начинаются торги фьючерсом на волатильность RVI', 'https://www.moex.com/n6184', 2014, 9, '', 'neutral', 'general', '2014-09-08 16:41:00');
INSERT INTO public.market_news (id, source, title, body, url, year, month, tickers, impact, category, published_at) VALUES (155, 'moex_sitenews', 'Об утверждении изменений в решения о выпусках и проспект биржевых облигаций ЗАО "Райффайзенбанк"', 'Об утверждении изменений в решения о выпусках и проспект биржевых облигаций ЗАО "Райффайзенбанк"', 'https://www.moex.com/n6182', 2014, 9, '', 'neutral', 'general', '2014-09-08 16:14:00');
INSERT INTO public.market_news (id, source, title, body, url, year, month, tickers, impact, category, published_at) VALUES (156, 'moex_sitenews', 'Московская Биржа объявляет о проведении конкурса "Лучший частный инвестор 2014"', 'Московская Биржа объявляет о проведении конкурса "Лучший частный инвестор 2014"', 'https://www.moex.com/n6181', 2014, 9, '', 'neutral', 'general', '2014-09-08 13:45:00');
INSERT INTO public.market_news (id, source, title, body, url, year, month, tickers, impact, category, published_at) VALUES (157, 'moex_sitenews', 'О вступлении в силу новой редакции правил листинга Московской Биржи', 'О вступлении в силу новой редакции правил листинга Московской Биржи', 'https://www.moex.com/n6180', 2014, 9, '', 'neutral', 'general', '2014-09-08 13:08:00');
INSERT INTO public.market_news (id, source, title, body, url, year, month, tickers, impact, category, published_at) VALUES (158, 'moex_sitenews', 'Об изменении значения нижних границ для инструментов TOM_3M СВОП USD/RUB и TOM_2M СВОП USD/RUB', 'Об изменении значения нижних границ для инструментов TOM_3M СВОП USD/RUB и TOM_2M СВОП USD/RUB', 'https://www.moex.com/n6179', 2014, 9, '', 'neutral', 'general', '2014-09-08 11:04:00');
INSERT INTO public.market_news (id, source, title, body, url, year, month, tickers, impact, category, published_at) VALUES (159, 'moex_sitenews', '20 сентября 2014 года состоится ежегодное нагрузочное тестирование торгово-клиринговых систем Московской Биржи', '20 сентября 2014 года состоится ежегодное нагрузочное тестирование торгово-клиринговых систем Московской Биржи', 'https://www.moex.com/n6178', 2014, 9, '', 'neutral', 'general', '2014-09-05 17:19:00');
INSERT INTO public.market_news (id, source, title, body, url, year, month, tickers, impact, category, published_at) VALUES (160, 'moex_sitenews', 'О начале торгов ценными бумагами 8 сентября 2014 года', 'О начале торгов ценными бумагами 8 сентября 2014 года', 'https://www.moex.com/n6177', 2014, 9, '', 'neutral', 'general', '2014-09-05 15:48:00');
INSERT INTO public.market_news (id, source, title, body, url, year, month, tickers, impact, category, published_at) VALUES (161, 'moex_sitenews', 'Итоги рынков Группы Московской Биржи за август 2014 года', 'Итоги рынков Группы Московской Биржи за август 2014 года', 'https://www.moex.com/n6174', 2014, 9, '', 'neutral', 'general', '2014-09-05 14:01:00');
INSERT INTO public.market_news (id, source, title, body, url, year, month, tickers, impact, category, published_at) VALUES (162, 'moex_sitenews', 'О времени начала Дополнительной торговой сессии 12,15 и 16 сентября 2014 года', 'О времени начала Дополнительной торговой сессии 12,15 и 16 сентября 2014 года', 'https://www.moex.com/n6173', 2014, 9, '', 'neutral', 'general', '2014-09-05 12:00:00');
INSERT INTO public.market_news (id, source, title, body, url, year, month, tickers, impact, category, published_at) VALUES (163, 'moex_sitenews', 'Определены цены исполнения по фьючерсным контрактам на корзину облигаций федерального займа', 'Определены цены исполнения по фьючерсным контрактам на корзину облигаций федерального займа', 'https://www.moex.com/n6172', 2014, 9, '', 'neutral', 'general', '2014-09-04 19:17:00');
INSERT INTO public.market_news (id, source, title, body, url, year, month, tickers, impact, category, published_at) VALUES (164, 'moex_sitenews', 'О приостановке торгов инвестиционными паями с 5 сентября 2014 года', 'О приостановке торгов инвестиционными паями с 5 сентября 2014 года', 'https://www.moex.com/n6171', 2014, 9, '', 'neutral', 'general', '2014-09-04 18:11:00');
INSERT INTO public.market_news (id, source, title, body, url, year, month, tickers, impact, category, published_at) VALUES (165, 'moex_sitenews', 'Об изменении размера минимального базового гарантийного обеспечения на срочном рынке', 'Об изменении размера минимального базового гарантийного обеспечения на срочном рынке', 'https://www.moex.com/n6170', 2014, 9, '', 'neutral', 'general', '2014-09-04 16:21:00');
INSERT INTO public.market_news (id, source, title, body, url, year, month, tickers, impact, category, published_at) VALUES (166, 'moex_sitenews', 'Московская Биржа расширяет список инструментов с льготными межмесячными и межконтрактными спредами', 'Московская Биржа расширяет список инструментов с льготными межмесячными и межконтрактными спредами', 'https://www.moex.com/n6169', 2014, 9, '', 'neutral', 'general', '2014-09-04 16:19:00');
INSERT INTO public.market_news (id, source, title, body, url, year, month, tickers, impact, category, published_at) VALUES (167, 'moex_sitenews', 'Итоги размещения депозитов Федерального Казначейства 4 сентября 2014 года', 'Итоги размещения депозитов Федерального Казначейства 4 сентября 2014 года', 'https://www.moex.com/n6168', 2014, 9, '', 'neutral', 'general', '2014-09-04 15:16:00');
INSERT INTO public.market_news (id, source, title, body, url, year, month, tickers, impact, category, published_at) VALUES (168, 'moex_sitenews', 'О включении биржевых облигаций ОАО "МРСК Юга" в Список ценных бумаг, допущенных к торгам, и о присвоении указанным биржевым облигациям идентификационных номеров', 'О включении биржевых облигаций ОАО "МРСК Юга" в Список ценных бумаг, допущенных к торгам, и о присвоении указанным биржевым облигациям идентификационных номеров', 'https://www.moex.com/n6167', 2014, 9, '', 'neutral', 'general', '2014-09-04 14:06:00');
INSERT INTO public.market_news (id, source, title, body, url, year, month, tickers, impact, category, published_at) VALUES (169, 'moex_sitenews', 'Об утверждении изменений в решения о выпусках и проспект биржевых облигаций ОАО "УБРиР"', 'Об утверждении изменений в решения о выпусках и проспект биржевых облигаций ОАО "УБРиР"', 'https://www.moex.com/n6166', 2014, 9, '', 'neutral', 'general', '2014-09-04 14:05:00');
INSERT INTO public.market_news (id, source, title, body, url, year, month, tickers, impact, category, published_at) VALUES (170, 'moex_sitenews', '04.09.2014 11-02 (мск) изменены значения верхних границ ценового коридора и диапазона оценки рыночных рисков ценной бумаги RU000A0JTED1 (НЛМК (ОАО) обл. сер. 08).', '04.09.2014 11-02 (мск) изменены значения верхних границ ценового коридора и диапазона оценки рыночных рисков ценной бумаги RU000A0JTED1 (НЛМК (ОАО) обл. сер. 08).', 'https://www.moex.com/n6165', 2014, 9, '', 'neutral', 'general', '2014-09-04 11:05:31');
INSERT INTO public.market_news (id, source, title, body, url, year, month, tickers, impact, category, published_at) VALUES (171, 'moex_sitenews', 'Итоги дополнительного выпуска биржевых облигаций ООО КБ "Национальный стандарт"', 'Итоги дополнительного выпуска биржевых облигаций ООО КБ "Национальный стандарт"', 'https://www.moex.com/n6164', 2014, 9, '', 'neutral', 'general', '2014-09-04 10:03:00');
INSERT INTO public.market_news (id, source, title, body, url, year, month, tickers, impact, category, published_at) VALUES (172, 'moex_sitenews', 'Об изменены значений нижних границ ценового коридора и диапазона оценки рыночных рисков валютной пары CNY/RUB, GLD/RUB и EUR/RUB', 'Об изменены значений нижних границ ценового коридора и диапазона оценки рыночных рисков валютной пары CNY/RUB, GLD/RUB и EUR/RUB', 'https://www.moex.com/n6163', 2014, 9, '', 'neutral', 'general', '2014-09-03 17:35:00');
INSERT INTO public.market_news (id, source, title, body, url, year, month, tickers, impact, category, published_at) VALUES (173, 'moex_sitenews', 'Об изменении значения нижних границ ценового коридора и диапазона оценки рыночных рисков валютной пары USD/RUB', 'Об изменении значения нижних границ ценового коридора и диапазона оценки рыночных рисков валютной пары USD/RUB', 'https://www.moex.com/n6162', 2014, 9, '', 'neutral', 'general', '2014-09-03 16:37:00');
INSERT INTO public.market_news (id, source, title, body, url, year, month, tickers, impact, category, published_at) VALUES (174, 'moex_sitenews', 'О начале торгов ценными бумагами 4 сентября 2014 года', 'О начале торгов ценными бумагами 4 сентября 2014 года', 'https://www.moex.com/n6161', 2014, 9, '', 'neutral', 'general', '2014-09-03 16:21:00');
INSERT INTO public.market_news (id, source, title, body, url, year, month, tickers, impact, category, published_at) VALUES (175, 'moex_sitenews', 'О включении  биржевых облигаций ООО "Обувьрус" в Список ценных бумаг, допущенных к торгам, и о присвоении указанным биржевым облигациям идентификационного номера', 'О включении  биржевых облигаций ООО "Обувьрус" в Список ценных бумаг, допущенных к торгам, и о присвоении указанным биржевым облигациям идентификационного номера', 'https://www.moex.com/n6160', 2014, 9, '', 'neutral', 'general', '2014-09-03 16:20:00');
INSERT INTO public.market_news (id, source, title, body, url, year, month, tickers, impact, category, published_at) VALUES (176, 'moex_sitenews', 'О внесении изменений в Список ценных бумаг, допущенных к торгам', 'О внесении изменений в Список ценных бумаг, допущенных к торгам', 'https://www.moex.com/n6159', 2014, 9, '', 'neutral', 'general', '2014-09-03 16:16:00');
INSERT INTO public.market_news (id, source, title, body, url, year, month, tickers, impact, category, published_at) VALUES (177, 'moex_sitenews', '4 сентября 2014 года состоится отбор заявок кредитных организаций на заключение договоров банковского депозита', '4 сентября 2014 года состоится отбор заявок кредитных организаций на заключение договоров банковского депозита', 'https://www.moex.com/n6158', 2014, 9, '', 'neutral', 'general', '2014-09-03 10:50:00');
INSERT INTO public.market_news (id, source, title, body, url, year, month, tickers, impact, category, published_at) VALUES (178, 'moex_sitenews', 'О размещении дополнительного выпуска биржевых облигаций серии БО-2 с обязательным централизованным хранением ООО Коммерческий Банк "Национальный стандарт"', 'О размещении дополнительного выпуска биржевых облигаций серии БО-2 с обязательным централизованным хранением ООО Коммерческий Банк "Национальный стандарт"', 'https://www.moex.com/n6157', 2014, 9, '', 'neutral', 'general', '2014-09-02 17:03:00');
INSERT INTO public.market_news (id, source, title, body, url, year, month, tickers, impact, category, published_at) VALUES (179, 'moex_sitenews', 'Об исключении ценных бумаг из Списка ценных бумаг, допущенных к торгам, и о прекращении торгов ценными бумагами', 'Об исключении ценных бумаг из Списка ценных бумаг, допущенных к торгам, и о прекращении торгов ценными бумагами', 'https://www.moex.com/n6156', 2014, 9, '', 'neutral', 'general', '2014-09-02 16:24:00');
INSERT INTO public.market_news (id, source, title, body, url, year, month, tickers, impact, category, published_at) VALUES (180, 'moex_sitenews', 'Об итогах размещения депозитов Федерального Казначейства 2 сентября 2014 года', 'Об итогах размещения депозитов Федерального Казначейства 2 сентября 2014 года', 'https://www.moex.com/n6154', 2014, 9, '', 'neutral', 'general', '2014-09-02 16:16:00');
INSERT INTO public.market_news (id, source, title, body, url, year, month, tickers, impact, category, published_at) VALUES (181, 'moex_sitenews', 'Об утверждении изменений в решения о выпусках и проспект биржевых облигаций ООО ИКБ "Совкомбанк"', 'Об утверждении изменений в решения о выпусках и проспект биржевых облигаций ООО ИКБ "Совкомбанк"', 'https://www.moex.com/n6155', 2014, 9, '', 'neutral', 'general', '2014-09-02 16:15:00');
INSERT INTO public.market_news (id, source, title, body, url, year, month, tickers, impact, category, published_at) VALUES (182, 'moex_sitenews', 'Об изменении параметров биржевых облигаций серии БО-2 ООО КБ "Национальный стандарт" с 03 сентября 2014 года', 'Об изменении параметров биржевых облигаций серии БО-2 ООО КБ "Национальный стандарт" с 03 сентября 2014 года', 'https://www.moex.com/n6153', 2014, 9, '', 'neutral', 'general', '2014-09-02 15:32:00');
INSERT INTO public.market_news (id, source, title, body, url, year, month, tickers, impact, category, published_at) VALUES (183, 'moex_sitenews', 'Об утверждении новых баз расчетов индексов Московской Биржи', 'Об утверждении новых баз расчетов индексов Московской Биржи', 'https://www.moex.com/n6151', 2014, 9, '', 'neutral', 'general', '2014-09-01 20:46:00');
INSERT INTO public.market_news (id, source, title, body, url, year, month, tickers, impact, category, published_at) VALUES (184, 'moex_sitenews', 'Объем торгов на Московской Бирже в августе составил 37,7 трлн рублей', 'Объем торгов на Московской Бирже в августе составил 37,7 трлн рублей', 'https://www.moex.com/n6149', 2014, 9, '', 'neutral', 'general', '2014-09-01 17:16:00');
INSERT INTO public.market_news (id, source, title, body, url, year, month, tickers, impact, category, published_at) VALUES (185, 'moex_sitenews', 'Об исключении ценных бумаг из Списка ценных бумаг, допущенных к торгам, и о прекращении торгов ценными бумагами', 'Об исключении ценных бумаг из Списка ценных бумаг, допущенных к торгам, и о прекращении торгов ценными бумагами', 'https://www.moex.com/n6148', 2014, 9, '', 'neutral', 'general', '2014-09-01 16:18:00');
INSERT INTO public.market_news (id, source, title, body, url, year, month, tickers, impact, category, published_at) VALUES (186, 'moex_sitenews', '2 сентября 2014 года состоится отбор заявок кредитных организаций на заключение договоров банковского депозита', '2 сентября 2014 года состоится отбор заявок кредитных организаций на заключение договоров банковского депозита', 'https://www.moex.com/n6147', 2014, 9, '', 'neutral', 'general', '2014-09-01 11:38:00');


--
-- Data for Name: realtime_price; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO public.realtime_price (id, ticker, price, updated_at) VALUES (1, 'AFLT', 47.69, '2026-04-02 17:30:35.038327+03');
INSERT INTO public.realtime_price (id, ticker, price, updated_at) VALUES (2, 'ALRS', 33.95, '2026-04-02 17:30:35.040393+03');
INSERT INTO public.realtime_price (id, ticker, price, updated_at) VALUES (3, 'CHMF', 843.6, '2026-04-02 17:30:35.042149+03');
INSERT INTO public.realtime_price (id, ticker, price, updated_at) VALUES (4, 'GAZP', 133.6, '2026-04-02 17:30:35.043615+03');
INSERT INTO public.realtime_price (id, ticker, price, updated_at) VALUES (5, 'GMKN', 136.76, '2026-04-02 17:30:35.044527+03');
INSERT INTO public.realtime_price (id, ticker, price, updated_at) VALUES (6, 'IRAO', 3.1695, '2026-04-02 17:30:35.045169+03');
INSERT INTO public.realtime_price (id, ticker, price, updated_at) VALUES (7, 'LKOH', 5557, '2026-04-02 17:30:35.045895+03');
INSERT INTO public.realtime_price (id, ticker, price, updated_at) VALUES (8, 'MGNT', 2983.5, '2026-04-02 17:30:35.046746+03');
INSERT INTO public.realtime_price (id, ticker, price, updated_at) VALUES (9, 'MOEX', 168.28, '2026-04-02 17:30:35.04826+03');
INSERT INTO public.realtime_price (id, ticker, price, updated_at) VALUES (10, 'MTSS', 224.65, '2026-04-02 17:30:35.049588+03');
INSERT INTO public.realtime_price (id, ticker, price, updated_at) VALUES (11, 'NLMK', 97.72, '2026-04-02 17:30:35.050632+03');
INSERT INTO public.realtime_price (id, ticker, price, updated_at) VALUES (12, 'NVTK', 1253.3, '2026-04-02 17:30:35.053255+03');
INSERT INTO public.realtime_price (id, ticker, price, updated_at) VALUES (13, 'PLZL', 2167, '2026-04-02 17:30:35.05565+03');
INSERT INTO public.realtime_price (id, ticker, price, updated_at) VALUES (14, 'ROSN', 470.2, '2026-04-02 17:30:35.057565+03');
INSERT INTO public.realtime_price (id, ticker, price, updated_at) VALUES (15, 'SBER', 316.59, '2026-04-02 17:30:35.059006+03');
INSERT INTO public.realtime_price (id, ticker, price, updated_at) VALUES (16, 'SNGS', 21.28, '2026-04-02 17:30:35.061282+03');
INSERT INTO public.realtime_price (id, ticker, price, updated_at) VALUES (17, 'TATN', 651.1, '2026-04-02 17:30:35.062707+03');
INSERT INTO public.realtime_price (id, ticker, price, updated_at) VALUES (18, 'VTBR', 89.785, '2026-04-02 17:30:35.063594+03');


--
-- Name: Leaderboard_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public."Leaderboard_id_seq"', 27, true);


--
-- Name: News_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public."News_id_seq"', 241, true);


--
-- Name: Price_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public."Price_id_seq"', 257787, true);


--
-- Name: Room_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public."Room_id_seq"', 16, true);


--
-- Name: ScenarioStep_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public."ScenarioStep_id_seq"', 303, true);


--
-- Name: StonkUser_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public."StonkUser_id_seq"', 26, true);


--
-- Name: Stonk_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public."Stonk_id_seq"', 18, true);


--
-- Name: User_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public."User_id_seq"', 31, true);


--
-- Name: dividend_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.dividend_id_seq', 864, true);


--
-- Name: market_news_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.market_news_id_seq', 188, true);


--
-- Name: realtime_price_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.realtime_price_id_seq', 108, true);


--
-- Name: Leaderboard Leaderboard_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."Leaderboard"
    ADD CONSTRAINT "Leaderboard_pkey" PRIMARY KEY (id);


--
-- Name: News News_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."News"
    ADD CONSTRAINT "News_pkey" PRIMARY KEY (id);


--
-- Name: Price Price_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."Price"
    ADD CONSTRAINT "Price_pkey" PRIMARY KEY (id);


--
-- Name: Room Room_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."Room"
    ADD CONSTRAINT "Room_pkey" PRIMARY KEY (id);


--
-- Name: ScenarioStep ScenarioStep_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."ScenarioStep"
    ADD CONSTRAINT "ScenarioStep_pkey" PRIMARY KEY (id);


--
-- Name: Scenario Scenario_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."Scenario"
    ADD CONSTRAINT "Scenario_pkey" PRIMARY KEY (id);


--
-- Name: StonkUser StonkUser_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."StonkUser"
    ADD CONSTRAINT "StonkUser_pkey" PRIMARY KEY (id);


--
-- Name: Stonk Stonk_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."Stonk"
    ADD CONSTRAINT "Stonk_pkey" PRIMARY KEY (id);


--
-- Name: User User_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."User"
    ADD CONSTRAINT "User_pkey" PRIMARY KEY (id);


--
-- Name: dividend dividend_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.dividend
    ADD CONSTRAINT dividend_pkey PRIMARY KEY (id);


--
-- Name: market_news market_news_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.market_news
    ADD CONSTRAINT market_news_pkey PRIMARY KEY (id);


--
-- Name: realtime_price realtime_price_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.realtime_price
    ADD CONSTRAINT realtime_price_pkey PRIMARY KEY (id);


--
-- Name: realtime_price realtime_price_ticker_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.realtime_price
    ADD CONSTRAINT realtime_price_ticker_key UNIQUE (ticker);


--
-- Name: Price_stonkId_idx; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX "Price_stonkId_idx" ON public."Price" USING btree ("stonkId");


--
-- Name: Price_stonkId_year_month_key; Type: INDEX; Schema: public; Owner: postgres
--

CREATE UNIQUE INDEX "Price_stonkId_year_month_key" ON public."Price" USING btree ("stonkId", year, month);


--
-- Name: Price_year_month_idx; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX "Price_year_month_idx" ON public."Price" USING btree (year, month);


--
-- Name: Room_code_key; Type: INDEX; Schema: public; Owner: postgres
--

CREATE UNIQUE INDEX "Room_code_key" ON public."Room" USING btree (code);


--
-- Name: ScenarioStep_scenarioId_stepIndex_key; Type: INDEX; Schema: public; Owner: postgres
--

CREATE UNIQUE INDEX "ScenarioStep_scenarioId_stepIndex_key" ON public."ScenarioStep" USING btree ("scenarioId", "stepIndex");


--
-- Name: Stonk_ticker_key; Type: INDEX; Schema: public; Owner: postgres
--

CREATE UNIQUE INDEX "Stonk_ticker_key" ON public."Stonk" USING btree (ticker);


--
-- Name: User_username_key; Type: INDEX; Schema: public; Owner: postgres
--

CREATE UNIQUE INDEX "User_username_key" ON public."User" USING btree (username);


--
-- Name: dividend_ticker_payment_date_key; Type: INDEX; Schema: public; Owner: postgres
--

CREATE UNIQUE INDEX dividend_ticker_payment_date_key ON public.dividend USING btree (ticker, payment_date);


--
-- Name: dividend_ticker_year_month_idx; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX dividend_ticker_year_month_idx ON public.dividend USING btree (ticker, year, month);


--
-- Name: dividend_ticker_ym; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX dividend_ticker_ym ON public.dividend USING btree (ticker, year, month);


--
-- Name: market_news_source_idx; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX market_news_source_idx ON public.market_news USING btree (source);


--
-- Name: market_news_url_key; Type: INDEX; Schema: public; Owner: postgres
--

CREATE UNIQUE INDEX market_news_url_key ON public.market_news USING btree (url);


--
-- Name: market_news_year_month_idx; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX market_news_year_month_idx ON public.market_news USING btree (year, month);


--
-- Name: market_news_ym; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX market_news_ym ON public.market_news USING btree (year, month);


--
-- Name: Leaderboard Leaderboard_roomId_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."Leaderboard"
    ADD CONSTRAINT "Leaderboard_roomId_fkey" FOREIGN KEY ("roomId") REFERENCES public."Room"(id) ON UPDATE CASCADE ON DELETE SET NULL;


--
-- Name: Leaderboard Leaderboard_userId_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."Leaderboard"
    ADD CONSTRAINT "Leaderboard_userId_fkey" FOREIGN KEY ("userId") REFERENCES public."User"(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: News News_scenarioId_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."News"
    ADD CONSTRAINT "News_scenarioId_fkey" FOREIGN KEY ("scenarioId") REFERENCES public."Scenario"(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: Price Price_stonkId_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."Price"
    ADD CONSTRAINT "Price_stonkId_fkey" FOREIGN KEY ("stonkId") REFERENCES public."Stonk"(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: Room Room_scenarioId_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."Room"
    ADD CONSTRAINT "Room_scenarioId_fkey" FOREIGN KEY ("scenarioId") REFERENCES public."Scenario"(id) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- Name: ScenarioStep ScenarioStep_scenarioId_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."ScenarioStep"
    ADD CONSTRAINT "ScenarioStep_scenarioId_fkey" FOREIGN KEY ("scenarioId") REFERENCES public."Scenario"(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: StonkUser StonkUser_roomId_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."StonkUser"
    ADD CONSTRAINT "StonkUser_roomId_fkey" FOREIGN KEY ("roomId") REFERENCES public."Room"(id) ON UPDATE CASCADE ON DELETE SET NULL;


--
-- Name: StonkUser StonkUser_userId_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."StonkUser"
    ADD CONSTRAINT "StonkUser_userId_fkey" FOREIGN KEY ("userId") REFERENCES public."User"(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- PostgreSQL database dump complete
--

\unrestrict okT3FqBqxGgYZZ3nu5LRZhAFrm8eWOE0PkXP8UxNISvKqEtTGFeQsCQQRyKXMyC

