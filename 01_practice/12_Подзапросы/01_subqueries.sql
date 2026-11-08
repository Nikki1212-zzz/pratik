-- Практическая работа №12. Подзапросы (Subqueries)
-- Студент: Мамедов Ярослав, группа 3ИП-12-24

-- 1. Скалярный подзапрос в WHERE: товары дороже средней цены
SELECT name, price
FROM product
WHERE price > (SELECT AVG(price) FROM product);

-- 2. Подзапрос с оператором IN: категории, в которых есть товары дороже 100 руб.
SELECT id, name
FROM category
WHERE id IN (SELECT DISTINCT category_id FROM product WHERE price > 100 AND category_id IS NOT NULL);

-- 3. Подзапрос с EXISTS: поставщики, поставляющие хотя бы один товар
SELECT s.id, s.name
FROM supplier s
WHERE EXISTS (SELECT 1 FROM product p WHERE p.supplier_id = s.id);
