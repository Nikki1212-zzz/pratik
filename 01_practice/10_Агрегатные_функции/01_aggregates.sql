-- Практическая работа №10. Агрегатные функции, GROUP BY и HAVING
-- Студент: Мамедов Ярослав, группа 3ИП-12-24

DROP TABLE IF EXISTS product;
CREATE TABLE product (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    name TEXT NOT NULL,
    price REAL NOT NULL,
    category_id INTEGER
);

INSERT INTO product (name, price, category_id) VALUES
('Хлеб', 40, 1),
('Мыло', 80, 2),
('Молоко', 60, 1),
('Сыр', 200, NULL),
('Чай', 150, 2),
('Кофе', 320, 2),
('Творог', 110, 1),
('Шампунь', 250, 2);

-- 1. Сколько всего товаров?
SELECT COUNT(*) AS total_products FROM product;

-- 2. Средняя цена
SELECT ROUND(AVG(price), 2) AS avg_price FROM product;

-- 3. Количество товаров по категориям
SELECT category_id, COUNT(*) AS cnt FROM product GROUP BY category_id;

-- 4. Сумма цен по категориям
SELECT category_id, SUM(price) AS sum_price FROM product GROUP BY category_id;

-- 5. Категории, где больше 2 товаров
SELECT category_id, COUNT(*) AS cnt
FROM product
GROUP BY category_id
HAVING COUNT(*) > 2;

-- 6. Самая дорогая и самая дешёвая цена
SELECT MAX(price) AS max_price, MIN(price) AS min_price FROM product;

-- 7. Категории, где средняя цена > 100
SELECT category_id, ROUND(AVG(price), 2) AS avg_price
FROM product
GROUP BY category_id
HAVING AVG(price) > 100;

-- 8. Товары, у которых цена выше средней по всей таблице
SELECT id, name, price
FROM product
WHERE price > (SELECT AVG(price) FROM product);

-- 9 (со звёздочкой). Для каждой категории — количество, средняя и макс. цена, сортировка по средней цене
SELECT
    category_id,
    COUNT(*) AS items_count,
    ROUND(AVG(price), 2) AS avg_price,
    MAX(price) AS max_price
FROM product
GROUP BY category_id
ORDER BY avg_price DESC;

-- Продвинутый случай: количество уникальных непустых категорий
SELECT COUNT(DISTINCT category_id) AS unique_categories FROM product;
