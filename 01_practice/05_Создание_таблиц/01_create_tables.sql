-- Практическая работа №5. Создание таблиц и ограничения целостности
-- Студент: Мамедов Ярослав, группа 3ИП-12-24

PRAGMA foreign_keys = ON;

DROP TABLE IF EXISTS product_supplier;
DROP TABLE IF EXISTS shipment;
DROP TABLE IF EXISTS product;
DROP TABLE IF EXISTS supplier;
DROP TABLE IF EXISTS category;

-- 1. Таблица категорий
CREATE TABLE category (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    name TEXT NOT NULL UNIQUE
);

-- 2-3. Таблица товаров с CHECK (price > 0) и ссылкой на category
CREATE TABLE product (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    name TEXT NOT NULL,
    price REAL NOT NULL CHECK (price > 0),
    category_id INTEGER REFERENCES category(id),
    created TEXT DEFAULT (date('now'))
);

-- 4. Вставка тестовых записей
INSERT INTO category (name) VALUES ('Спортивное питание'), ('Инвентарь');
INSERT INTO product (name, price, category_id) VALUES
('Протеин Whey 1 кг', 2400.00, 1),
('Гантели разборные 15 кг', 3900.00, 2);

-- 6. Таблица поставщиков (phone UNIQUE, email UNIQUE)
CREATE TABLE supplier (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    name TEXT NOT NULL,
    phone TEXT NOT NULL UNIQUE,
    email TEXT UNIQUE
);

INSERT INTO supplier (name, phone, email) VALUES
('ООО ФитнесОпт', '+7(495)111-22-33', 'info@fitopt.ru'),
('АО СпортСнаб', '+7(495)444-55-66', 'sales@sportsnab.ru');

-- 7 и 9 (со звёздочкой): Таблица поставок с CHECK (quantity > 0) и CHECK на дату >= '2020-01-01'
CREATE TABLE shipment (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    product_id INTEGER NOT NULL REFERENCES product(id),
    supplier_id INTEGER NOT NULL REFERENCES supplier(id),
    quantity INTEGER NOT NULL CHECK (quantity > 0),
    shipment_date TEXT DEFAULT CURRENT_DATE CHECK (shipment_date >= '2020-01-01')
);

INSERT INTO shipment (product_id, supplier_id, quantity, shipment_date) VALUES
(1, 1, 25, '2026-10-15'),
(2, 2, 10, '2026-10-18');

-- 8. Таблица с составным UNIQUE (product_id, supplier_id)
CREATE TABLE product_supplier (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    product_id INTEGER NOT NULL REFERENCES product(id),
    supplier_id INTEGER NOT NULL REFERENCES supplier(id),
    contract_price REAL CHECK (contract_price > 0),
    UNIQUE (product_id, supplier_id)
);

INSERT INTO product_supplier (product_id, supplier_id, contract_price) VALUES
(1, 1, 1950.00),
(2, 2, 3100.00);
