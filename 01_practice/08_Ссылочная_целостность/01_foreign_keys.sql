-- Практическая работа №8. Ссылочная целостность и внешние ключи
-- Студент: Мамедов Ярослав, группа 3ИП-12-24

PRAGMA foreign_keys = ON;

DROP TABLE IF EXISTS order_item;
DROP TABLE IF EXISTS orders;
DROP TABLE IF EXISTS product;
DROP TABLE IF EXISTS category;
DROP TABLE IF EXISTS client;
DROP TABLE IF EXISTS employee;

-- 1-4. Таблицы Клиент и Заказ с ON DELETE CASCADE
CREATE TABLE client (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    name TEXT NOT NULL
);

CREATE TABLE orders (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    client_id INTEGER REFERENCES client(id) ON DELETE CASCADE,
    amount REAL NOT NULL
);

INSERT INTO client (name) VALUES ('Иванов А.А.'), ('Петров В.В.'), ('Сидоров К.К.');
INSERT INTO orders (client_id, amount) VALUES (1, 1500.0), (1, 2300.0), (2, 900.0), (3, 4100.0);

-- При удалении клиента с id = 1 его заказы удаляются каскадно:
DELETE FROM client WHERE id = 1;

-- 6. Таблица Товар с FK на Категория и ON DELETE SET NULL
CREATE TABLE category (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    name TEXT NOT NULL
);

CREATE TABLE product (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    name TEXT NOT NULL,
    price REAL NOT NULL,
    category_id INTEGER REFERENCES category(id) ON DELETE SET NULL
);

INSERT INTO category (name) VALUES ('Аксессуары'), ('Одежда');
INSERT INTO product (name, price, category_id) VALUES
('Шейкер 700 мл', 650.0, 1),
('Футболка спортивная', 1800.0, 2);

-- Удаляем категорию 1 -> у шейкера category_id станет NULL
DELETE FROM category WHERE id = 1;

-- 7-8. Связь M:N через промежуточную таблицу order_item с составным PRIMARY KEY
CREATE TABLE order_item (
    order_id INTEGER REFERENCES orders(id) ON DELETE CASCADE,
    product_id INTEGER REFERENCES product(id) ON DELETE RESTRICT,
    quantity INTEGER NOT NULL CHECK (quantity > 0),
    PRIMARY KEY (order_id, product_id)
);

INSERT INTO order_item (order_id, product_id, quantity) VALUES (3, 1, 2), (3, 2, 1);

-- 9 (со звёздочкой). Самоссылающаяся таблица «Сотрудник» (manager_id -> employee.id)
CREATE TABLE employee (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    fio TEXT NOT NULL,
    position TEXT NOT NULL,
    manager_id INTEGER REFERENCES employee(id) ON DELETE SET NULL
);

INSERT INTO employee (fio, position, manager_id) VALUES
('Воронов И.С.', 'Директор клуба', NULL),
('Громов С.В.', 'Старший тренер', 1),
('Калинина В.О.', 'Тренер групповых программ', 2);
