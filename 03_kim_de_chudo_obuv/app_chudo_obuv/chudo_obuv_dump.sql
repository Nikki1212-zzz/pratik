-- КИМ ДЭ 09.02.07-2 (Модуль 1. Разработка базы данных «Чудо Обувь»)
-- Студент: Мамедов Ярослав, группа 3ИП-12-24

PRAGMA foreign_keys = ON;

DROP TABLE IF EXISTS order_items;
DROP TABLE IF EXISTS orders;
DROP TABLE IF EXISTS stock_items;
DROP TABLE IF EXISTS sizes;
DROP TABLE IF EXISTS products;
DROP TABLE IF EXISTS users;
DROP TABLE IF EXISTS roles;

CREATE TABLE roles (
    role_id INTEGER PRIMARY KEY,
    role_name TEXT NOT NULL UNIQUE
);

CREATE TABLE users (
    user_id INTEGER PRIMARY KEY,
    last_name TEXT NOT NULL,
    first_name TEXT NOT NULL,
    middle_name TEXT,
    login TEXT NOT NULL UNIQUE,
    role_id INTEGER NOT NULL,
    FOREIGN KEY (role_id) REFERENCES roles(role_id)
);

CREATE TABLE products (
    product_id INTEGER PRIMARY KEY,
    category TEXT NOT NULL,
    subcategory TEXT,
    product_name TEXT NOT NULL,
    manufacturer TEXT,
    image_path TEXT,
    description TEXT,
    composition TEXT,
    price NUMERIC NOT NULL CHECK (price >= 0)
);

CREATE TABLE sizes (
    size_id INTEGER PRIMARY KEY,
    size_value TEXT NOT NULL UNIQUE
);

CREATE TABLE stock_items (
    stock_item_id INTEGER PRIMARY KEY,
    product_id INTEGER NOT NULL,
    size_id INTEGER NOT NULL,
    quantity_available INTEGER NOT NULL CHECK (quantity_available >= 0),
    FOREIGN KEY (product_id) REFERENCES products(product_id),
    FOREIGN KEY (size_id) REFERENCES sizes(size_id),
    UNIQUE (product_id, size_id)
);

CREATE TABLE orders (
    order_id INTEGER PRIMARY KEY,
    order_date DATE NOT NULL,
    user_id INTEGER NOT NULL,
    FOREIGN KEY (user_id) REFERENCES users(user_id)
);

CREATE TABLE order_items (
    order_item_id INTEGER PRIMARY KEY,
    order_id INTEGER NOT NULL,
    product_id INTEGER NOT NULL,
    size_id INTEGER NOT NULL,
    quantity INTEGER NOT NULL CHECK (quantity > 0),
    price NUMERIC NOT NULL CHECK (price >= 0),
    FOREIGN KEY (order_id) REFERENCES orders(order_id) ON DELETE CASCADE,
    FOREIGN KEY (product_id) REFERENCES products(product_id),
    FOREIGN KEY (size_id) REFERENCES sizes(size_id)
);

-- Импортированные данные из Excel-файлов заказчика
INSERT INTO "order_items" VALUES(1,1,1,3,1,2190);
INSERT INTO "order_items" VALUES(2,1,7,5,1,2790);
INSERT INTO "order_items" VALUES(3,2,10,19,1,25000);
INSERT INTO "order_items" VALUES(4,2,13,23,1,7500);
INSERT INTO "order_items" VALUES(5,3,12,21,1,17000);
INSERT INTO "order_items" VALUES(6,3,20,21,1,8565);
INSERT INTO "order_items" VALUES(7,3,22,18,1,7795);
INSERT INTO "order_items" VALUES(8,4,17,23,1,7757);
INSERT INTO "order_items" VALUES(9,4,16,23,1,12340);
INSERT INTO "order_items" VALUES(10,4,15,25,1,7130);
INSERT INTO "order_items" VALUES(11,4,21,19,1,8765);
INSERT INTO "order_items" VALUES(12,4,11,25,1,15000);
INSERT INTO "order_items" VALUES(13,5,25,29,1,9567);
INSERT INTO "order_items" VALUES(14,5,29,29,1,21500);
INSERT INTO "order_items" VALUES(15,5,24,25,1,7890);
INSERT INTO "order_items" VALUES(16,6,26,27,1,24569);
INSERT INTO "order_items" VALUES(17,6,30,31,1,14567);
INSERT INTO "order_items" VALUES(18,6,31,29,1,15670);
INSERT INTO "order_items" VALUES(19,7,6,1,1,4290);
INSERT INTO "order_items" VALUES(20,7,1,4,2,2190);
INSERT INTO "order_items" VALUES(21,7,8,11,1,1690);
INSERT INTO "order_items" VALUES(22,8,28,34,1,25625);
INSERT INTO "order_items" VALUES(23,8,24,27,3,7890);
INSERT INTO "order_items" VALUES(24,8,23,33,2,6550);
INSERT INTO "order_items" VALUES(25,9,2,16,1,2490);
INSERT INTO "order_items" VALUES(26,9,5,5,2,3190);
INSERT INTO "order_items" VALUES(27,10,18,18,1,7550);
INSERT INTO "order_items" VALUES(28,10,15,21,1,7130);
INSERT INTO "order_items" VALUES(29,10,16,19,1,12340);
INSERT INTO "order_items" VALUES(30,10,21,18,2,8765);
INSERT INTO "orders" VALUES(1,'2026-04-02',3);
INSERT INTO "orders" VALUES(2,'2026-04-05',17);
INSERT INTO "orders" VALUES(3,'2026-04-08',7);
INSERT INTO "orders" VALUES(4,'2026-04-12',15);
INSERT INTO "orders" VALUES(5,'2026-04-18',12);
INSERT INTO "orders" VALUES(6,'2026-04-22',9);
INSERT INTO "orders" VALUES(7,'2026-04-25',14);
INSERT INTO "orders" VALUES(8,'2026-04-28',20);
INSERT INTO "orders" VALUES(9,'2026-05-05',5);
INSERT INTO "orders" VALUES(10,'2026-05-08',17);
INSERT INTO "products" VALUES(1,'Детская обувь','Кроссовки','Кроссовки детские «Звёздочка» экокожа','Малыш-Спорт','IMG_KS_195217.png','Кроссовки детские «Звёздочка» экокожа. Производитель: ООО «Малыш-Спорт», г. Смоленск','Верх — экокожа (полиуретан на хлопковой основе), подкладка — хлопок 100%, подошва — ПВХ',2190);
INSERT INTO "products" VALUES(2,'Детская обувь','Кроссовки','Кроссовки детские «Гонщик» экокожа','Топ-Топ','IMG_KS_195213.png','Кроссовки детские «Гонщик» экокожа. Производитель: Фабрика «Топ-Топ», г. Киров','Верх — экокожа (микрофибра), подкладка — текстиль сетчатый (полиэстер), подошва — термопластичная резина (ТЭП)',2490);
INSERT INTO "products" VALUES(3,'Детская обувь','Кроссовки','Кроссовки детские «Радуга» экокожа перфорированная','Лапушка','IMG_KS_195222.png','Кроссовки детские «Радуга» экокожа перфорированная. Производитель: ИП Смирнова Л.В. (бренд «Лапушка»), г. Вологда','Верх — экокожа перфорированная, вставки — нейлон, стелька — ортопедическая с латексной подушкой, подошва — ЭВА',1990);
INSERT INTO "products" VALUES(4,'Детская обувь','Сапоги','Сапожки детские «Снежинка» зимние на меху','Тёплые ножки','IMG_KB_185501.png','Сапожки детские «Снежинка» зимние на меху. Производитель: ООО «Тёплые ножки», г. Новосибирск','Верх — экокожа морозостойкая, утеплитель — искусственный мех (акрил 70%, полиэстер 30%), подкладка — флис, подошва — термоэластопласт (ТЭП)',3490);
INSERT INTO "products" VALUES(5,'Детская обувь','Сапоги','Сапожки детские «Медвежонок» демисезонные непромокаемые','Северята','IMG_KB_164816.png','Сапожки детские «Медвежонок» демисезонные непромокаемые. Производитель: Компания «Северята», г. Архангельск','Верх — плащёвая ткань с водоотталкивающей пропиткой (полиэстер 100%), отделка — экокожа, подкладка — микрофибра, мембрана — AirTex, подошва — резина',3190);
INSERT INTO "products" VALUES(6,'Детская обувь','Сапоги','Сапожки детские «Принцесса» кожаные','Весна','IMG_KB_164811.png','Сапожки детские «Принцесса» кожаные. Производитель: Мастерская «Весна», г. Тула','Верх — натуральная кожа (КРС), подкладка — шерсть натуральная (70%), байка (30%), стелька — войлочная, подошва — полиуретан',4290);
INSERT INTO "products" VALUES(7,'Детская обувь','Босоножки','Сандалии детские «Пчёлка» ортопедические летние','Здоровый шаг','IMG_KSd_195207.png','Сандалии детские «Пчёлка» ортопедические летние. Производитель: ООО «Здоровый шаг», г. Воронеж','Верх — нубук натуральный, подкладка — кожа растительного дубления, стелька — анатомическая с супинатором (латекс + пробка), подошва — каучук',2790);
INSERT INTO "products" VALUES(8,'Детская обувь','Босоножки','Сандалии детские «Морячок» текстильные с фиксатором','Карапуз','IMG_KSd_185508.png','Сандалии детские «Морячок» текстильные с фиксатором. Производитель: ИП Кузнецов А.Д. (бренд «Карапуз»), г. Краснодар','Верх — джинсовая ткань (хлопок 100%), окантовка — искусственная кожа, подкладка — хлопок, подошва — ЭВА лёгкая',1690);
INSERT INTO "products" VALUES(9,'Детская обувь','Туфли','Туфли детские «Бантик» лаковые праздничные','Маленький франт','IMG_KSho_185512.png','Туфли детские «Бантик» лаковые праздничные. Производитель: Дом обуви «Маленький франт», г. Москва','Верх — искусственная лаковая кожа (ПВХ), носок усиленный — термопластичный полиуретан, подкладка — кожа искусственная дышащая, стелька — анатомическая с амортизацией, подошва — полиуретан',2390);
INSERT INTO "products" VALUES(10,'Женская обувь','Сапоги','Сапоги зимние натуральная кожа','Барбари','IMG_WB_170905.png','Сапоги женские зимние, нескользящая, устойчивая подошва, натуральный мех. Производитель: Дом обуви «Барбари», г. Новороссийск','Верх — натуральная кожа, подкладка — евромех, натуральный мех, текстильный утеплитель, подошва — резина',25000);
INSERT INTO "products" VALUES(11,'Женская обувь','Сапоги','Сапоги осенние натуральная кожа','Барбари','IMG_WB_170859.png','Сапоги женские демисезонные из высококачественной натуральной кожи. Производитель: Дом обуви «Барбари», г. Новороссийск','Верх — натуральная кожа, подкладка — текстильный утеплитель, стелька — текстиль, подошва — ТПР',15000);
INSERT INTO "products" VALUES(12,'Женская обувь','Сапоги','Сапоги трубы демисезонные замшевые','Твой комфорт','IMG_WB_170906.png','Сапоги женские демисезонные замшевые. Производитель: ОАО «Твой комфорт», г. Ярославль','Верх — натуральная замша, утепленные, тракторная подошва, стелька — байка, подошва — резина',17000);
INSERT INTO "products" VALUES(13,'Женская обувь','Босоножки','Босоножки «Песчаный берег» коричневые','Стиль и комфорт','IMG_WSd_174332.png','Коричневая кожаная модель с открытым носком, боковой пряжкой и закрытым каблуком. Производитель: ИП «Стиль и комфорт», г. Санкт-Петербург','Верх — 100% козья кожа, подкладка — 100% кожа; подошва: 100% кожа',7500);
INSERT INTO "products" VALUES(14,'Женская обувь','Босоножки','Женские босоножки «Черный кофе» со скульптурным каблуком','Кожевенные традиции','IMG_WSd_185156.png','Открытый носок и ремешок со сборной пряжкой, низкий каблук и резиновая подошва гарантируют комфорт. Производитель: ЗАО «Кожевенные традиции», г. Вятка','Верх — кожа собственного производств, подкладка — кожа; подошва: резина',5600);
INSERT INTO "products" VALUES(15,'Женская обувь','Босоножки','Босоножки женские «Летний бриз»','Модный силуэт','IMG_WSd_185551.png','Босоножки женские кожаные белые, регулируемый ремешок, закрытый каблук и кожаная подошва. Производитель: ООО «Модный силуэт», г. Кострома','Верх — натуральная кожа, подкладка — натуральная кожа, подошва — кожа',7130);
INSERT INTO "products" VALUES(16,'Женская обувь','Туфли','Демисезонные туфли натуральная кожа','Модный силуэт','IMG_WSho_174409.png','Комфортные лаконичные лодочки, классический дизайна с современными акцентами. Производитель: ООО «Модный силуэт», г. Кострома','Верх — натуральная овечья кожа, подкладка и стелька — натуральная овечья кожа, подошва — резина',12340);
INSERT INTO "products" VALUES(17,'Женская обувь','Туфли','Туфли женские натуральная кожа с металлическими вставками','Кожевенные традиции','IMG_WSho_185202.png','Стильные туфли для весеннего и летнего сезона. Производитель: ЗАО «Кожевенные традиции», г. Вятка','Верх — натуральная телячьей кожа, металлическая пряжка, подкладка и стелька— натуральная овечья кожа, подошва — резина',7757);
INSERT INTO "products" VALUES(18,'Женская обувь','Туфли','Туфли классические лодочки натуральная кожа','Стиль и комфорт','IMG_WSho_185545.png','Модель из натуральной кожи, классический острый носок и изящная шпилька. Производитель: ИП «Стиль и комфорт», г. Санкт-Петербург','Верх — натуральная кожа, подкладка и стелька — натуральная кожа, подошва — тунит',7550);
INSERT INTO "products" VALUES(19,'Женская обувь','Кроссовки','Кроссовки белые с оранжевым и красным','Топ-Топ','IMG_WS_174110.png','Многослойный верх из кожи и текстиля. Производитель: Фабрика «Топ-Топ», г. Киров','Верх — 70% кожа, 30% текстиль, подкладка — текстиль, подошва — резина',9450);
INSERT INTO "products" VALUES(20,'Женская обувь','Кроссовки','Кроссовки летние кожаные','Топ-Топ','IMG_WS_185528.png','Уверенность на каждом шагу. Материал обеспечивает долговечность и комфорт при носке. Производитель: Фабрика «Топ-Топ», г. Киров','Верх — 87% кожа, 11% текстиль, 2% синтетика; подкладка: 100% текстиль; подошва: резина, пластик',8565);
INSERT INTO "products" VALUES(21,'Женская обувь','Кроссовки','Кроссовки кожаные','Стиль и комфорт','IMG_WS_185535.png','Кроссовки женские из натуральной кожи. Производитель: ИП «Стиль и комфорт», г. Санкт-Петербург','Верх — натуральная кожа, подкладка — кожа, подошва — полиуретан',8765);
INSERT INTO "products" VALUES(22,'Женская обувь','Кроссовки','Кроссовки «Стиль и комфорт»','Стиль и комфорт','IMG_WS_185538.png','Кроссовки женские из натуральной кожи и синтетических материалов, сетчатые вставки. Производитель: ИП «Стиль и комфорт», г. Санкт-Петербург','Верх — 70% кожа, 20% полиамид, 10% полиуретан; подкладка — текстиль, подошва — ТПУ',7795);
INSERT INTO "products" VALUES(23,'Мужская обувь','Кроссовки','Кроссовки для бега «Драйв»','Азимут','IMG_MS_185531.png','Сочетание стиля, комфорта и современных технологий. Производитель: Фабрика «Азимут», г. Санкт-Петербург','Верх —  сетка, подкладка — текстиль, подошва —  резина',6550);
INSERT INTO "products" VALUES(24,'Мужская обувь','Кроссовки','Кроссовки «Азимут Бег»','Азимут','IMG_MS_185532.png','Универсальный выбор для повседневного использования. Производитель: Фабрика «Азимут», г. Санкт-Петербург','Верх — 6% кожа, 29% текстиль, 15% полимерные материалы; подкладка — 100% текстиль; подошва — полимерные материалы, резина',7890);
INSERT INTO "products" VALUES(25,'Мужская обувь','Кроссовки','Кроссовки','Топ-Топ','IMG_MS_185533.png','Кроссовки для мужчин, идеальное сочетание стиля и комфорта. Производитель: Фабрика «Топ-Топ», г. Киров','Верх — 56% кожа, 29% текстиль, 15% полимерные материалы; подкладка — 100% текстиль; подошва — полимерные материалы, резина',9567);
INSERT INTO "products" VALUES(26,'Мужская обувь','Туфли','Черные туфли в классическом стиле — база для деловых образов','Барбари','IMG_MSho_190514.png','Модель выполнена из натуральной кожи, на резиновой подошве. Производитель: Дом обуви «Барбари», г. Новороссийск','Верх — натуральная кожа, подкладка — текстиль, стелька — натуральная кожа, подошва — резина',24569);
INSERT INTO "products" VALUES(27,'Мужская обувь','Туфли','Туфли мужские светлые классика демисезонные','Берестов','IMG_MSho_190518.png','Туфли на низком каблуке кожаные','Верх — натуральная кожа, подкладка — текстиль, стелька — натуральная кожа, подошва — ТЭП',10155);
INSERT INTO "products" VALUES(28,'Мужская обувь','Туфли','Туфли из натуральной кожи','Берестов','IMG_MSho_191612.png','Модель выполнена из натуральной кожи, на резиновой подошве, поддеживает классический и деловой стиль образов. Производитель: Дом обуви «Берестов», г. Москва','Верх — натуральная кожа, подкладка — натуральная кожа, стелька — натуральная кожа, подошва — резина',25625);
INSERT INTO "products" VALUES(29,'Мужская обувь','Ботинки','Ботинки мужские демисезонные','Барбари','IMG_MB_174349.png','Ботинки из натуральной кожи темно-коричневого и черного цвета на шнурках. Производитель: Дом обуви «Берестов», г. Москва','Верх — натуральная кожа, подкладка — текстиль, подошва — искусственный материал',21500);
INSERT INTO "products" VALUES(30,'Мужская обувь','Ботинки','Ботинки черные из натуральной кожи','Кожевенные традиции','IMG_MB_191200.png','Ботинки представляют баланс традиций и современности. Выполнены из натуральной кожи насыщенного черного цвета. Производитель: ЗАО «Кожевенные традиции», г. Вятка','Верх — натуральная кожа, подкладка — ворсин, стелька — ворсин, подошва — тунит',14567);
INSERT INTO "products" VALUES(31,'Мужская обувь','Ботинки','Ботинки зимние классические','Барбари','IMG_MB_191205.png','Выбор на каждый день — натуральная кожа, натуральный мех. Производитель: Дом обуви «Барбари», г. Новороссийск','Верх — натуральная кожа, подкладка — натуральный мех, стелька — натуральный мех, подошва — ТЭП',15670);
INSERT INTO "roles" VALUES(1,'Администратор');
INSERT INTO "roles" VALUES(2,'Менеджер');
INSERT INTO "roles" VALUES(3,'Авторизованный пользователь');
INSERT INTO "sizes" VALUES(1,'18');
INSERT INTO "sizes" VALUES(2,'19');
INSERT INTO "sizes" VALUES(3,'20');
INSERT INTO "sizes" VALUES(4,'21');
INSERT INTO "sizes" VALUES(5,'22');
INSERT INTO "sizes" VALUES(6,'23');
INSERT INTO "sizes" VALUES(7,'24');
INSERT INTO "sizes" VALUES(8,'25');
INSERT INTO "sizes" VALUES(9,'26');
INSERT INTO "sizes" VALUES(10,'27');
INSERT INTO "sizes" VALUES(11,'28');
INSERT INTO "sizes" VALUES(12,'29');
INSERT INTO "sizes" VALUES(13,'30');
INSERT INTO "sizes" VALUES(14,'31');
INSERT INTO "sizes" VALUES(15,'32');
INSERT INTO "sizes" VALUES(16,'33');
INSERT INTO "sizes" VALUES(17,'34');
INSERT INTO "sizes" VALUES(18,'35');
INSERT INTO "sizes" VALUES(19,'36');
INSERT INTO "sizes" VALUES(20,'36.5');
INSERT INTO "sizes" VALUES(21,'37');
INSERT INTO "sizes" VALUES(22,'37.5');
INSERT INTO "sizes" VALUES(23,'38');
INSERT INTO "sizes" VALUES(24,'38.5');
INSERT INTO "sizes" VALUES(25,'39');
INSERT INTO "sizes" VALUES(26,'39.5');
INSERT INTO "sizes" VALUES(27,'40');
INSERT INTO "sizes" VALUES(28,'40.5');
INSERT INTO "sizes" VALUES(29,'41');
INSERT INTO "sizes" VALUES(30,'41.5');
INSERT INTO "sizes" VALUES(31,'42');
INSERT INTO "sizes" VALUES(32,'42.5');
INSERT INTO "sizes" VALUES(33,'43');
INSERT INTO "sizes" VALUES(34,'44');
INSERT INTO "sizes" VALUES(35,'45');
INSERT INTO "stock_items" VALUES(1,1,3,20);
INSERT INTO "stock_items" VALUES(2,1,4,20);
INSERT INTO "stock_items" VALUES(3,1,5,20);
INSERT INTO "stock_items" VALUES(4,1,6,20);
INSERT INTO "stock_items" VALUES(5,1,7,20);
INSERT INTO "stock_items" VALUES(6,1,8,20);
INSERT INTO "stock_items" VALUES(7,2,16,2);
INSERT INTO "stock_items" VALUES(8,2,17,2);
INSERT INTO "stock_items" VALUES(9,3,2,30);
INSERT INTO "stock_items" VALUES(10,3,3,30);
INSERT INTO "stock_items" VALUES(11,4,2,15);
INSERT INTO "stock_items" VALUES(12,4,3,15);
INSERT INTO "stock_items" VALUES(13,5,4,5);
INSERT INTO "stock_items" VALUES(14,5,5,5);
INSERT INTO "stock_items" VALUES(15,5,6,5);
INSERT INTO "stock_items" VALUES(16,6,1,4);
INSERT INTO "stock_items" VALUES(17,6,2,4);
INSERT INTO "stock_items" VALUES(18,6,3,4);
INSERT INTO "stock_items" VALUES(19,7,4,4);
INSERT INTO "stock_items" VALUES(20,7,5,4);
INSERT INTO "stock_items" VALUES(21,7,6,4);
INSERT INTO "stock_items" VALUES(22,7,7,4);
INSERT INTO "stock_items" VALUES(23,8,10,7);
INSERT INTO "stock_items" VALUES(24,8,11,7);
INSERT INTO "stock_items" VALUES(25,8,12,7);
INSERT INTO "stock_items" VALUES(26,8,13,7);
INSERT INTO "stock_items" VALUES(27,9,1,7);
INSERT INTO "stock_items" VALUES(28,9,2,7);
INSERT INTO "stock_items" VALUES(29,9,3,7);
INSERT INTO "stock_items" VALUES(30,10,19,12);
INSERT INTO "stock_items" VALUES(31,10,21,12);
INSERT INTO "stock_items" VALUES(32,11,25,2);
INSERT INTO "stock_items" VALUES(33,11,27,2);
INSERT INTO "stock_items" VALUES(34,12,21,5);
INSERT INTO "stock_items" VALUES(35,12,25,5);
INSERT INTO "stock_items" VALUES(36,12,27,5);
INSERT INTO "stock_items" VALUES(37,13,19,10);
INSERT INTO "stock_items" VALUES(38,13,21,10);
INSERT INTO "stock_items" VALUES(39,13,23,10);
INSERT INTO "stock_items" VALUES(40,13,25,10);
INSERT INTO "stock_items" VALUES(41,13,27,10);
INSERT INTO "stock_items" VALUES(42,14,18,3);
INSERT INTO "stock_items" VALUES(43,15,21,23);
INSERT INTO "stock_items" VALUES(44,15,25,23);
INSERT INTO "stock_items" VALUES(45,15,27,23);
INSERT INTO "stock_items" VALUES(46,16,19,25);
INSERT INTO "stock_items" VALUES(47,16,21,25);
INSERT INTO "stock_items" VALUES(48,16,23,25);
INSERT INTO "stock_items" VALUES(49,17,19,4);
INSERT INTO "stock_items" VALUES(50,17,23,4);
INSERT INTO "stock_items" VALUES(51,17,25,4);
INSERT INTO "stock_items" VALUES(52,17,27,4);
INSERT INTO "stock_items" VALUES(53,18,18,9);
INSERT INTO "stock_items" VALUES(54,18,23,9);
INSERT INTO "stock_items" VALUES(55,19,18,2);
INSERT INTO "stock_items" VALUES(56,19,19,2);
INSERT INTO "stock_items" VALUES(57,20,21,5);
INSERT INTO "stock_items" VALUES(58,20,22,5);
INSERT INTO "stock_items" VALUES(59,20,23,5);
INSERT INTO "stock_items" VALUES(60,20,24,5);
INSERT INTO "stock_items" VALUES(61,21,18,16);
INSERT INTO "stock_items" VALUES(62,21,19,16);
INSERT INTO "stock_items" VALUES(63,21,23,16);
INSERT INTO "stock_items" VALUES(64,21,25,16);
INSERT INTO "stock_items" VALUES(65,22,18,3);
INSERT INTO "stock_items" VALUES(66,22,23,3);
INSERT INTO "stock_items" VALUES(67,23,30,18);
INSERT INTO "stock_items" VALUES(68,23,31,18);
INSERT INTO "stock_items" VALUES(69,23,32,18);
INSERT INTO "stock_items" VALUES(70,23,33,18);
INSERT INTO "stock_items" VALUES(71,24,23,50);
INSERT INTO "stock_items" VALUES(72,24,24,50);
INSERT INTO "stock_items" VALUES(73,24,25,50);
INSERT INTO "stock_items" VALUES(74,24,26,50);
INSERT INTO "stock_items" VALUES(75,24,27,50);
INSERT INTO "stock_items" VALUES(76,24,29,50);
INSERT INTO "stock_items" VALUES(77,25,29,3);
INSERT INTO "stock_items" VALUES(78,25,31,3);
INSERT INTO "stock_items" VALUES(79,25,34,3);
INSERT INTO "stock_items" VALUES(80,26,27,23);
INSERT INTO "stock_items" VALUES(81,26,29,23);
INSERT INTO "stock_items" VALUES(82,26,33,23);
INSERT INTO "stock_items" VALUES(83,27,31,15);
INSERT INTO "stock_items" VALUES(84,27,33,15);
INSERT INTO "stock_items" VALUES(85,27,34,15);
INSERT INTO "stock_items" VALUES(86,28,34,3);
INSERT INTO "stock_items" VALUES(87,29,29,1);
INSERT INTO "stock_items" VALUES(88,29,31,1);
INSERT INTO "stock_items" VALUES(89,30,31,20);
INSERT INTO "stock_items" VALUES(90,30,33,20);
INSERT INTO "stock_items" VALUES(91,31,29,30);
INSERT INTO "stock_items" VALUES(92,31,31,30);
INSERT INTO "users" VALUES(1,'Иванов','Иван','Сергеевич','isivanov',1);
INSERT INTO "users" VALUES(2,'Петров','Петр','Алексеевич','papetrov',2);
INSERT INTO "users" VALUES(3,'Сидорова','Анна','Дмитриевна','asidorova',3);
INSERT INTO "users" VALUES(4,'Кузнецова','Екатерина','Андреевна','ekuznetsova',2);
INSERT INTO "users" VALUES(5,'Смирнов','Дмитрий','Владимирович','dsmirnov',3);
INSERT INTO "users" VALUES(6,'Попов','Алексей','Николаевич','apopov',1);
INSERT INTO "users" VALUES(7,'Васильева','Ольга','Игоревна','ovasileva',3);
INSERT INTO "users" VALUES(8,'Соколов','Павел','Викторович','psokolov',2);
INSERT INTO "users" VALUES(9,'Михайлова','Татьяна','Юрьевна','tmikhailova',3);
INSERT INTO "users" VALUES(10,'Новикова','Наталья','Сергеевна','nnovikova',2);
INSERT INTO "users" VALUES(11,'Фёдоров','Андрей','Максимович','afedorov',1);
INSERT INTO "users" VALUES(12,'Морозов','Сергей','Павлович','smorozov',3);
INSERT INTO "users" VALUES(13,'Волкова','Юлия','Александровна','jvolkova',2);
INSERT INTO "users" VALUES(14,'Алексеев','Артём','Евгеньевич','aalekseev',3);
INSERT INTO "users" VALUES(15,'Лебедева','Ирина','Владимировна','ilebedeva',3);
INSERT INTO "users" VALUES(16,'Егоров','Никита','Денисович','negorov',2);
INSERT INTO "users" VALUES(17,'Павлова','Елена','Петровна','epavlova',3);
INSERT INTO "users" VALUES(18,'Козлов','Роман','Олегович','rkozlov',1);
INSERT INTO "users" VALUES(19,'Степанова','Виктория','Романовна','vstepanova',2);
INSERT INTO "users" VALUES(20,'Николаев','Владимир','Иванович','vnikolaev',3);
