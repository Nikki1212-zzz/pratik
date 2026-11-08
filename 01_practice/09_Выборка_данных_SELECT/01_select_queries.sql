-- Практическая работа №9. Выборка данных SELECT
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
('Морковь', 30, 1),
('Масло сливочное', 180, 1),
('Халва', 120, 1),
('Кофе зерновой', 450, 2);

-- 1. Все товары дороже 100
SELECT * FROM product WHERE price > 100;

-- 2. Товары от 50 до 200
SELECT * FROM product WHERE price BETWEEN 50 AND 200;

-- 3. Товары, название которых начинается на «Х»
SELECT * FROM product WHERE name LIKE 'Х%';

-- 4. Товары без категории (IS NULL)
SELECT * FROM product WHERE category_id IS NULL;

-- 5. Сортировка по цене по убыванию
SELECT name, price FROM product ORDER BY price DESC;

-- 6. Первые 3 записи
SELECT * FROM product LIMIT 3;

-- 7. Товары, цена которых заканчивается на 0 (при целочисленной записи)
SELECT * FROM product WHERE CAST(price AS INTEGER) LIKE '%0';

-- 8. Товары, название которых содержит букву «о»
SELECT * FROM product WHERE LOWER(name) LIKE '%о%';

-- 9 (со звёздочкой). Товары дороже средней цены, у которых категория не NULL, по убыванию, LIMIT 5
SELECT id, name, price, category_id
FROM product
WHERE price > (SELECT AVG(price) FROM product)
  AND category_id IS NOT NULL
ORDER BY price DESC
LIMIT 5;
