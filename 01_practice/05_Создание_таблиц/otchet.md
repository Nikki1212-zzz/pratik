# Практическая работа №5. Создание таблиц и ограничения
**Студент:** Мамедов Ярослав, группа 3ИП-12-24

## Выполнение задач (1–9)
В базе `shop_constraints.db` созданы таблицы с ограничениями целостности:
- `category` (`id` PK, `name` NOT NULL UNIQUE);
- `product` (`id` PK, `name` NOT NULL, `price` CHECK(price > 0), `category_id` FK, `created` DEFAULT);
- `supplier` (`id` PK, `name` NOT NULL, `phone` UNIQUE, `email` UNIQUE);
- `shipment` (`id` PK, `product_id` FK, `supplier_id` FK, `quantity` CHECK(quantity > 0), `shipment_date` DEFAULT CURRENT_DATE CHECK(shipment_date >= '2020-01-01'));
- `product_supplier` с составным ограничением уникальности `UNIQUE (product_id, supplier_id)`, которое не даёт дважды привязать одного и того же поставщика к одному товару.

При проверке попытка вставить товар с отрицательной ценой или дату поставки `2019-05-01` предсказуемо останавливается ошибкой `CHECK constraint failed`.

## Задача на поиск ошибки
**Вопрос:** Дан код с `price REAL CHECK (price > 0)` и запрос `INSERT INTO product (name, price) VALUES ('Тест', 0);`. Почему вставка не пройдёт?
**Ответ:** В условии написано строгое неравенство `price > 0`. Значение `0` не больше нуля, поэтому условие `0 > 0` ложно, и срабатывает ошибка `CHECK constraint failed`. Если нужно разрешить нулевую цену, условие должно быть `CHECK (price >= 0)`.

## Задача на предсказание результата
**Вопрос:** В таблице `category` есть только строка `id = 1, name = 'Еда'`. Включён `PRAGMA foreign_keys = ON;`. Что произойдёт при вставке товара с `category_id = 1` и товара с `category_id = 99`?
**Ответ:** Первая команда (`category_id = 1`) выполнится успешно, так как категория с `id = 1` существует. Вторая команда (`category_id = 99`) завершится ошибкой `FOREIGN KEY constraint failed`, так как категории с `id = 99` в родительской таблице нет.
