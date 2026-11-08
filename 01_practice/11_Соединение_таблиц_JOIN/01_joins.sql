-- Практическая работа №11. Соединение таблиц JOIN
-- Студент: Мамедов Ярослав, группа 3ИП-12-24

DROP TABLE IF EXISTS product;
DROP TABLE IF EXISTS category;
DROP TABLE IF EXISTS supplier;

CREATE TABLE category (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    name TEXT NOT NULL
);

CREATE TABLE supplier (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    name TEXT NOT NULL
);

CREATE TABLE product (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    name TEXT NOT NULL,
    price REAL NOT NULL,
    category_id INTEGER REFERENCES category(id),
    supplier_id INTEGER REFERENCES supplier(id)
);

INSERT INTO category (id, name) VALUES (1, 'Еда'), (2, 'Быт'), (3, 'Напитки');
INSERT INTO supplier (id, name) VALUES (1, 'ООО ПродуктТорг'), (2, 'АО ХимБыт');
INSERT INTO product (id, name, price, category_id, supplier_id) VALUES
(1, 'Хлеб', 40, 1, 1),
(2, 'Мыло', 80, 2, 2),
(3, 'Молоко', 60, 1, 1),
(4, 'Сыр', 200, NULL, 1);

-- 1. Товары с названиями категорий (INNER JOIN)
SELECT p.name AS product_name, c.name AS category_name
FROM product p
INNER JOIN category c ON p.category_id = c.id;

-- 2. Все категории, даже без товаров (LEFT JOIN от category)
SELECT c.name AS category_name, p.name AS product_name
FROM category c
LEFT JOIN product p ON c.id = p.category_id;

-- 3. Товары без категории (LEFT JOIN + IS NULL)
SELECT p.name AS product_name, p.price
FROM product p
LEFT JOIN category c ON p.category_id = c.id
WHERE c.id IS NULL;

-- 4. Количество товаров в каждой категории (включая пустые категории = 0)
SELECT c.name AS category_name, COUNT(p.id) AS product_count
FROM category c
LEFT JOIN product p ON c.id = p.category_id
GROUP BY c.id, c.name;

-- 5. Товары и категории через FULL JOIN
SELECT p.name AS product_name, c.name AS category_name
FROM product p
FULL JOIN category c ON p.category_id = c.id;

-- 6. Категории без товаров
SELECT c.id, c.name AS empty_category
FROM category c
LEFT JOIN product p ON c.id = p.category_id
WHERE p.id IS NULL;

-- 7. Соединение 3 таблиц: товар, категория, поставщик
SELECT p.name AS product_name, c.name AS category_name, s.name AS supplier_name
FROM product p
INNER JOIN category c ON p.category_id = c.id
INNER JOIN supplier s ON p.supplier_id = s.id;

-- 8. Товары, у которых категория начинается на «Е»
SELECT p.name AS product_name, c.name AS category_name
FROM product p
INNER JOIN category c ON p.category_id = c.id
WHERE c.name LIKE 'Е%';

-- 9 (со звёздочкой). Self-join: пары товаров из одной категории с разными id
SELECT p1.name AS first_product, p2.name AS second_product, p1.category_id
FROM product p1
INNER JOIN product p2
    ON p1.category_id = p2.category_id
   AND p1.id < p2.id;

-- Продвинутый случай: замена RIGHT JOIN через LEFT JOIN (меняем таблицы местами)
SELECT p.name AS product_name, c.name AS category_name
FROM category c
LEFT JOIN product p ON p.category_id = c.id;
