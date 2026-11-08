# Практическая работа №6. Изменение структуры таблиц
**Студент:** Мамедов Ярослав, группа 3ИП-12-24

## Выполнение задач (1–9)
В скрипте `01_alter_table.sql` последовательно выполнены операции:
1. Добавление столбца: `ALTER TABLE product ADD COLUMN description TEXT;`
2. Переименование столбца: `ALTER TABLE product RENAME COLUMN name TO title;`
3. Удаление столбца: `ALTER TABLE product DROP COLUMN description;`
4. Переименование таблицы: `ALTER TABLE category RENAME TO categories;`
5. Пересоздание таблицы `product` с сохранением всех строк (задачи 7–9): создана таблица `new_product` с типом `price REAL CHECK (price > 0)`, данные перенесены через `INSERT INTO new_product SELECT id, title, CAST(price AS REAL), created FROM product;`, старая таблица удалена (`DROP TABLE product`), а новая переименована (`ALTER TABLE new_product RENAME TO product`). Функция `typeof(price)` подтвердила, что тип данных изменился с `text` на `real`.

## Задача на поиск ошибки
**Вопрос:** Почему команда `ALTER TABLE product ALTER COLUMN price TYPE REAL;` не сработает в SQLite?
**Ответ:** В SQLite у команды `ALTER TABLE` урезанный синтаксис: она умеет только добавлять/удалять/переименовывать столбцы и переименовывать саму таблицу. Конструкции `ALTER COLUMN ... TYPE` в SQLite нет — для смены типа столбца или добавления `CHECK` используется алгоритм через создание новой таблицы и перенос данных.

## Задача на предсказание результата
**Вопрос:** В таблице `product` 5 строк. Что произойдёт при выполнении `ALTER TABLE product ADD COLUMN new_col TEXT;` и затем `SELECT COUNT(*) FROM product;`?
**Ответ:** Во все 5 существующих строк добавится новый столбец `new_col` со значением `NULL`. Количество строк не изменится, поэтому `SELECT COUNT(*) FROM product;` вернёт **5**.
