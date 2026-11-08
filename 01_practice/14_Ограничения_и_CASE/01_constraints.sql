-- Практическая работа №14. Ограничения и условные выражения CASE
-- Студент: Мамедов Ярослав, группа 3ИП-12-24

SELECT
    name,
    price,
    COALESCE(CAST(category_id AS TEXT), 'Без категории') AS category_info,
    CASE
        WHEN price >= 200 THEN 'Премиум'
        WHEN price >= 70 THEN 'Средний сегмент'
        ELSE 'Эконом'
    END AS price_segment
FROM product
ORDER BY price DESC;
