-- Практическая работа №6. Изменение структуры таблиц (ALTER TABLE)
-- Студент: Мамедов Ярослав, группа 3ИП-12-24

DROP TABLE IF EXISTS product;
DROP TABLE IF EXISTS categories;
DROP TABLE IF EXISTS category;

CREATE TABLE category (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    name TEXT NOT NULL UNIQUE
);

CREATE TABLE product (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    name TEXT NOT NULL,
    price TEXT -- специально создаём как TEXT для демонстрации задачи 7
);

INSERT INTO category (name) VALUES ('Напитки'), ('Батончики');
INSERT INTO product (name, price) VALUES
('Изотоник 0.5л', '150.00'),
('Протеиновый батончик', '180.00');

-- Задача 1: Добавляем столбец description TEXT
ALTER TABLE product ADD COLUMN description TEXT;

-- Задача 2: Переименовываем столбец name в title
ALTER TABLE product RENAME COLUMN name TO title;

-- Задача 3: Удаляем столбец description
ALTER TABLE product DROP COLUMN description;

-- Задача 4: Переименовываем таблицу category -> categories
ALTER TABLE category RENAME TO categories;

-- Задача 6: Добавляем столбец со значением по умолчанию
ALTER TABLE product ADD COLUMN created TEXT DEFAULT '2026-10-26';

-- Задачи 7, 8, 9 (со звёздочкой): Полный скрипт пересоздания таблицы product
-- с изменением типа price (TEXT -> REAL), добавлением CHECK (price > 0) и сохранением данных
BEGIN TRANSACTION;

CREATE TABLE new_product (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    title TEXT NOT NULL,
    price REAL NOT NULL CHECK (price > 0),
    created TEXT DEFAULT (date('now'))
);

INSERT INTO new_product (id, title, price, created)
SELECT id, title, CAST(price AS REAL), created
FROM product;

DROP TABLE product;

ALTER TABLE new_product RENAME TO product;

COMMIT;

SELECT * FROM product;
