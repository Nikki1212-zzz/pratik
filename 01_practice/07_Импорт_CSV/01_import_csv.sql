-- Практическая работа №7. Импорт данных из CSV и очистка
-- Студент: Мамедов Ярослав, группа 3ИП-12-24

DROP TABLE IF EXISTS tmp_product;
DROP TABLE IF EXISTS tmp_dirty_product;
DROP TABLE IF EXISTS product;

-- Основная таблица с правильными типами
CREATE TABLE product (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    name TEXT NOT NULL,
    price REAL NOT NULL,
    category_id INTEGER,
    arrival_date TEXT DEFAULT (date('now'))
);

-- Шаг 1: Временная таблица для импорта
CREATE TABLE tmp_dirty_product (
    name TEXT,
    price TEXT,
    category_id TEXT,
    arrival_date TEXT
);

-- Задача 10 (со звёздочкой): Поиск некорректных строк во временной таблице до переноса
-- (где цена пустая или меньше либо равна 0)
SELECT *
FROM tmp_dirty_product
WHERE NULLIF(TRIM(price), '') IS NULL
   OR CAST(price AS REAL) <= 0;

-- Задачи 3, 4, 7, 9: Очистка через TRIM, LOWER, CAST и перевод даты из DD.MM.YYYY в YYYY-MM-DD
INSERT INTO product (name, price, category_id, arrival_date)
SELECT
    LOWER(TRIM(name)),
    CAST(TRIM(price) AS REAL),
    CAST(TRIM(category_id) AS INTEGER),
    substr(TRIM(arrival_date), 7, 4) || '-' || substr(TRIM(arrival_date), 4, 2) || '-' || substr(TRIM(arrival_date), 1, 2)
FROM tmp_dirty_product
WHERE NULLIF(TRIM(price), '') IS NOT NULL
  AND CAST(price AS REAL) > 0;

-- Шаг 6: Удаление временной таблицы после успешного переноса
-- DROP TABLE tmp_dirty_product;
