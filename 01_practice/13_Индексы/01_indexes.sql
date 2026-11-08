-- Практическая работа №13. Индексы и оптимизация запросов
-- Студент: Мамедов Ярослав, группа 3ИП-12-24

-- 1. Создание одиночного индекса по названию товара
CREATE INDEX IF NOT EXISTS idx_product_name ON product(name);

-- 2. Создание составного индекса по категории и цене
CREATE INDEX IF NOT EXISTS idx_product_cat_price ON product(category_id, price);

-- 3. Проверка плана выполнения запроса через индекс
EXPLAIN QUERY PLAN
SELECT id, name, price
FROM product
WHERE category_id = 1 AND price > 50;
