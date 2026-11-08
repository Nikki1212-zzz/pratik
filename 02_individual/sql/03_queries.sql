-- Индивидуальное задание по УП.11
-- Студент: Мамедов Ярослав, группа 3ИП-12-24
-- Предметная область: Библиотека
-- Файл: 03_queries.sql (15 SQL-запросов к базе данных)

-- Запрос 1. Простая выборка: список всех читателей, отсортированный по дате регистрации (свежие сверху)
SELECT reader_id, full_name, phone, email, reg_date
FROM readers
ORDER BY reg_date DESC;

-- Запрос 2. Фильтрация WHERE + BETWEEN: книги стоимостью от 500 до 1200 руб.
SELECT book_id, title, publish_year, total_copies, price
FROM books
WHERE price BETWEEN 500 AND 1200
ORDER BY price ASC;

-- Запрос 3. Фильтрация LIKE и работа с IS NULL: выданные книги, которые ещё находятся на руках (return_date IS NULL)
SELECT loan_id, book_id, reader_id, loan_date, due_date, status
FROM book_loans
WHERE return_date IS NULL AND status LIKE 'выд%';

-- Запрос 4. Выборка библиотекарей со стажем от 5 лет и окладом выше 55000 руб.
SELECT librarian_id, full_name, position, experience_years, salary
FROM librarians
WHERE experience_years >= 5 AND salary > 55000
ORDER BY experience_years DESC;

-- Запрос 5. Агрегатные функции: общее число книг (наименований), общее число экземпляров, средняя, мин. и макс. цена книги
SELECT
    COUNT(*) AS total_titles,
    SUM(total_copies) AS total_books_copies,
    ROUND(AVG(price), 2) AS avg_book_price,
    MIN(price) AS min_price,
    MAX(price) AS max_price
FROM books;

-- Запрос 6. Группировка GROUP BY: количество операций выдачи и сумма штрафов по каждому статусу
SELECT
    status,
    COUNT(*) AS loans_count,
    SUM(fine_amount) AS total_fines
FROM book_loans
GROUP BY status
ORDER BY loans_count DESC;

-- Запрос 7. INNER JOIN (3 таблицы): список текущих выдач на руках с ФИО читателя и названием книги
SELECT
    bl.loan_id,
    r.full_name AS reader_name,
    b.title AS book_title,
    bl.loan_date,
    bl.due_date,
    bl.status
FROM book_loans bl
INNER JOIN readers r ON bl.reader_id = r.reader_id
INNER JOIN books b ON bl.book_id = b.book_id
WHERE bl.status IN ('выдана', 'просрочена')
ORDER BY bl.due_date ASC;

-- Запрос 8. INNER JOIN (4 таблицы): полный каталог книг с ФИО автора, названием жанра и читальным залом
SELECT
    b.book_id,
    b.title AS book_title,
    a.full_name AS author_name,
    g.genre_name,
    h.hall_name,
    b.publish_year,
    b.total_copies
FROM books b
INNER JOIN authors a ON b.author_id = a.author_id
INNER JOIN genres g ON b.genre_id = g.genre_id
INNER JOIN halls h ON b.hall_id = h.hall_id
ORDER BY b.title;

-- Запрос 9. LEFT JOIN + GROUP BY: сколько выдач оформил каждый библиотекарь и скольким уникальным читателям
SELECT
    l.full_name AS librarian_name,
    l.position,
    COUNT(bl.loan_id) AS total_loans_processed,
    COUNT(DISTINCT bl.reader_id) AS unique_readers
FROM librarians l
LEFT JOIN book_loans bl ON l.librarian_id = bl.librarian_id
GROUP BY l.librarian_id, l.full_name, l.position
ORDER BY total_loans_processed DESC;

-- Запрос 10. GROUP BY + HAVING: популярные книги, которые брали в библиотеке не менее 2 раз
SELECT
    b.book_id,
    b.title,
    COUNT(bl.loan_id) AS times_borrowed
FROM books b
INNER JOIN book_loans bl ON b.book_id = bl.book_id
GROUP BY b.book_id, b.title
HAVING COUNT(bl.loan_id) >= 2
ORDER BY times_borrowed DESC;

-- Запрос 11. LEFT JOIN + IS NULL: читатели, которые зарегистрировались, но ещё не взяли ни одной книги
SELECT
    r.reader_id,
    r.full_name,
    r.phone,
    r.reg_date
FROM readers r
LEFT JOIN book_loans bl ON r.reader_id = bl.reader_id
WHERE bl.loan_id IS NULL;

-- Запрос 12. Скалярный подзапрос: книги, оценочная стоимость которых выше средней цены книги по библиотеке
SELECT
    book_id,
    title,
    price
FROM books
WHERE price > (SELECT AVG(price) FROM books)
ORDER BY price DESC;

-- Запрос 13. Подзапрос с IN: читатели, которые брали книги автора Булгакова М.А.
SELECT
    reader_id,
    full_name,
    phone
FROM readers
WHERE reader_id IN (
    SELECT bl.reader_id
    FROM book_loans bl
    INNER JOIN books b ON bl.book_id = b.book_id
    INNER JOIN authors a ON b.author_id = a.author_id
    WHERE a.full_name LIKE 'Булгаков%'
);

-- Запрос 14. Выражение CASE: классификация читателей по активности (количеству взятых книг)
SELECT
    r.full_name,
    COUNT(bl.loan_id) AS borrowed_count,
    CASE
        WHEN COUNT(bl.loan_id) >= 3 THEN 'Активный читатель'
        WHEN COUNT(bl.loan_id) >= 1 THEN 'Обычный читатель'
        ELSE 'Новый читатель'
    END AS reader_category
FROM readers r
LEFT JOIN book_loans bl ON r.reader_id = bl.reader_id
GROUP BY r.reader_id, r.full_name
ORDER BY borrowed_count DESC;

-- Запрос 15. Аналитика заполняемости читальных залов книжным фондом (процент занятости вместимости)
SELECT
    h.hall_name,
    h.floor,
    h.capacity,
    COALESCE(SUM(b.total_copies), 0) AS stored_copies,
    ROUND(CAST(COALESCE(SUM(b.total_copies), 0) AS REAL) * 100.0 / h.capacity, 1) AS fill_percent
FROM halls h
LEFT JOIN books b ON h.hall_id = b.hall_id
GROUP BY h.hall_id, h.hall_name, h.floor, h.capacity
ORDER BY fill_percent DESC;
