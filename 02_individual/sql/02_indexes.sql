-- Индивидуальное задание по УП.11
-- Студент: Мамедов Ярослав, группа 3ИП-12-24
-- Предметная область: Библиотека
-- Файл: 02_indexes.sql (Создание индексов и проверка плана выполнения)

-- Индекс 1: Ускорение поиска выдач по читателю и статусу возврата
CREATE INDEX IF NOT EXISTS idx_loans_reader_status
ON book_loans (reader_id, status);

-- Индекс 2: Ускорение выборки книг по автору и жанру
CREATE INDEX IF NOT EXISTS idx_books_author_genre
ON books (author_id, genre_id);

-- Индекс 3 (дополнительный): Поиск читателя по ФИО
CREATE INDEX IF NOT EXISTS idx_readers_full_name
ON readers (full_name);

-- Проверка использования индекса через EXPLAIN QUERY PLAN
EXPLAIN QUERY PLAN
SELECT book_id, title, publish_year
FROM books
WHERE author_id = 1 AND genre_id = 1;
