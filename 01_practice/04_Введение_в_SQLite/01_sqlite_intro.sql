-- Практическая работа №4. Введение в SQLite
-- Студент: Мамедов Ярослав, группа 3ИП-12-24

DROP TABLE IF EXISTS student;
DROP TABLE IF EXISTS teacher;
DROP TABLE IF EXISTS user_avatar;
DROP TABLE IF EXISTS visit_log;

-- Задачи 1–5: Таблица student
CREATE TABLE student (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    fio TEXT NOT NULL,
    birth TEXT,
    avg_score REAL
);

INSERT INTO student (fio, birth, avg_score) VALUES
('Мамедов Я.А.', '2006-05-14', 4.7),
('Иванов И.И.', '2005-01-15', 4.5),
('Петров П.П.', '2005-11-02', 3.9);

SELECT * FROM student;

-- Задачи 6–7: Таблица teacher и фильтрация стажа > 5 лет
CREATE TABLE teacher (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    fio TEXT NOT NULL,
    subject TEXT NOT NULL,
    experience INTEGER
);

INSERT INTO teacher (fio, subject, experience) VALUES
('Наседкин М.Н.', 'Базы данных', 9),
('Смирнова Е.В.', 'Высшая математика', 12),
('Ковалёв А.С.', 'Программирование', 4),
('Орлова Т.И.', 'Операционные системы', 7),
('Морозов Д.К.', 'Информационная безопасность', 3);

SELECT * FROM teacher WHERE experience > 5;

-- Задача 8 (и продвинутый случай): Таблица с полем BLOB
CREATE TABLE user_avatar (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    username TEXT NOT NULL,
    photo BLOB
);

INSERT INTO user_avatar (username, photo) VALUES
('yaroslav_m', X'89504E470D0A1A0A');

-- Задача 9 (со звёздочкой): Таблица с DEFAULT (date('now'))
CREATE TABLE visit_log (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    visitor_name TEXT NOT NULL,
    visit_date TEXT DEFAULT (date('now'))
);

INSERT INTO visit_log (visitor_name) VALUES ('Мамедов Ярослав');
SELECT * FROM visit_log;
