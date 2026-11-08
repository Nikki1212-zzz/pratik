-- Индивидуальное задание по УП.11
-- Студент: Мамедов Ярослав, группа 3ИП-12-24
-- Предметная область: Библиотека (Вариант 3)
-- Файл: 01_create_tables.sql (Создание таблиц БД в 3НФ)

PRAGMA foreign_keys = ON;

DROP TABLE IF EXISTS book_loans;
DROP TABLE IF EXISTS books;
DROP TABLE IF EXISTS librarians;
DROP TABLE IF EXISTS halls;
DROP TABLE IF EXISTS authors;
DROP TABLE IF EXISTS genres;
DROP TABLE IF EXISTS readers;

-- 1. Таблица читателей библиотеки
CREATE TABLE readers (
    reader_id INTEGER PRIMARY KEY AUTOINCREMENT,
    full_name TEXT NOT NULL,
    birth_date TEXT NOT NULL,
    phone TEXT NOT NULL UNIQUE,
    email TEXT UNIQUE,
    reg_date TEXT NOT NULL DEFAULT (date('now'))
);

-- 2. Таблица жанров литературы
CREATE TABLE genres (
    genre_id INTEGER PRIMARY KEY AUTOINCREMENT,
    genre_name TEXT NOT NULL UNIQUE,
    age_rating TEXT NOT NULL DEFAULT '0+',
    max_loan_days INTEGER NOT NULL DEFAULT 14 CHECK (max_loan_days > 0)
);

-- 3. Таблица авторов
CREATE TABLE authors (
    author_id INTEGER PRIMARY KEY AUTOINCREMENT,
    full_name TEXT NOT NULL UNIQUE,
    country TEXT NOT NULL,
    birth_year INTEGER CHECK (birth_year IS NULL OR birth_year > 0)
);

-- 4. Таблица читальных залов и секций хранения
CREATE TABLE halls (
    hall_id INTEGER PRIMARY KEY AUTOINCREMENT,
    hall_name TEXT NOT NULL UNIQUE,
    floor INTEGER NOT NULL CHECK (floor >= 1),
    capacity INTEGER NOT NULL CHECK (capacity > 0)
);

-- 5. Таблица книг (библиотечный фонд)
CREATE TABLE books (
    book_id INTEGER PRIMARY KEY AUTOINCREMENT,
    title TEXT NOT NULL,
    author_id INTEGER NOT NULL REFERENCES authors(author_id) ON DELETE RESTRICT,
    genre_id INTEGER NOT NULL REFERENCES genres(genre_id) ON DELETE RESTRICT,
    hall_id INTEGER NOT NULL REFERENCES halls(hall_id) ON DELETE RESTRICT,
    publish_year INTEGER NOT NULL CHECK (publish_year >= 1800),
    total_copies INTEGER NOT NULL DEFAULT 1 CHECK (total_copies >= 0),
    price REAL NOT NULL CHECK (price > 0)
);

-- 6. Таблица библиотекарей (сотрудников)
CREATE TABLE librarians (
    librarian_id INTEGER PRIMARY KEY AUTOINCREMENT,
    full_name TEXT NOT NULL,
    position TEXT NOT NULL,
    phone TEXT NOT NULL UNIQUE,
    experience_years INTEGER NOT NULL DEFAULT 1 CHECK (experience_years >= 0),
    salary REAL NOT NULL CHECK (salary > 0)
);

-- 7. Таблица выдачи книг читателям (развязка связи M:N)
CREATE TABLE book_loans (
    loan_id INTEGER PRIMARY KEY AUTOINCREMENT,
    book_id INTEGER NOT NULL REFERENCES books(book_id) ON DELETE CASCADE,
    reader_id INTEGER NOT NULL REFERENCES readers(reader_id) ON DELETE CASCADE,
    librarian_id INTEGER NOT NULL REFERENCES librarians(librarian_id) ON DELETE RESTRICT,
    loan_date TEXT NOT NULL DEFAULT (date('now')),
    due_date TEXT NOT NULL,
    return_date TEXT,
    fine_amount REAL NOT NULL DEFAULT 0.0 CHECK (fine_amount >= 0),
    status TEXT NOT NULL DEFAULT 'выдана' CHECK (status IN ('выдана', 'возвращена', 'просрочена'))
);
