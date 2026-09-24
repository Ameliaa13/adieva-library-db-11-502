-- 1. Создаем таблицы по ER-диаграмме

create table authors (
    id serial primary key,
    name varchar(100) not null
);

create table genres (
    id serial primary key,
    title varchar(50) not null
);

create table books (
    id serial primary key,
    title varchar(150) not null,
    publication_year int,
    author_id int references authors(id) on delete cascade,
    genre_id int references genres(id) on delete set null
);

create table readers (
    id serial primary key,
    full_name varchar(100) not null,
    email varchar(100) unique,
    registration_year int
);

create table loans (
    id serial primary key,
    book_id int references books(id) on delete cascade,
    reader_id int references readers(id) on delete cascade,
    loan_date date default current_date
);

-- 2. ALTER запросы (дорабатываем структуру)

alter table readers add column phone varchar(20);

alter table books add column price numeric(10, 2) default 0.00;

alter table readers alter column email set not null;

alter table loans add column return_date date;


-- 3. Заполняем таблицы данными

insert into authors (name) values 
('Лев Толстой'),
('Фёдор Достоевский'),
('Михаил Булгаков'),
('Джордж Оруэлл');

insert into genres (title) values 
('Классическая проза'),
('Роман'),
('Фантастика'),
('Драма');

insert into books (title, publication_year, author_id, genre_id, price) values 
('Война и мир', 1869, 1, 1, 1500.00),
('Преступление и наказание', 1866, 2, 2, 850.00),
('Мастер и Маргарита', 1967, 3, 3, 1200.00),
('1984', 1949, 4, 3, 950.00);

insert into readers (full_name, email, registration_year, phone) values 
('Иванов Иван Иванович', 'ivanov@mail.ru', 2022, '+79991112233'),
('Петров Петр Петрович', 'petrov@gmail.com', 2024, '+79992223344'),
('Сидорова Анна Сергеевна', 'sidorova@yandex.ru', 2023, '+79993334455'),
('Смирнов Алексей Владимирович', 'smirnov@mail.ru', 2024, '+79994445566');

insert into loans (book_id, reader_id, loan_date, return_date) values 
(1, 1, '2024-01-15', '2024-02-01'),
(2, 2, '2024-03-10', null),
(3, 3, '2024-04-05', '2024-04-20'),
(4, 4, '2024-05-01', null);

-- 4. UPDATE запросы

-- меняем почту читателя
update readers 
set email = 'new_ivanov@mail.ru' 
where id = 1;

-- поднимаем цену на старые книги
update books 
set price = price * 1.10 
where publication_year < 1900;

-- проставляем дату возврата
update loans 
set return_date = '2024-03-25' 
where id = 2;

-- меняем телефон
update readers 
set phone = '+79000000000' 
where id = 3;