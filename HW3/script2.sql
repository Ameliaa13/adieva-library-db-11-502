
create table genres(
    id serial primary key,
    title varchar(100) not null
);

create table books(
    id serial primary key,
    title varchar(100) unique not null ,
    publication_year int,
    author_name varchar(100) not null ,
    genres_id int references genres(id) on delete set null,
    author_country varchar(50) not null
);

create table readers(
    id serial primary key,
    full_name varchar(100) not null,
    email varchar(50) unique not null,
    phone varchar(20),
    registration_year int
);

create table loans(
    id serial primary key ,
    book_id int references books(id) on delete cascade,
    reader_id int references readers(id) on delete cascade ,
    reader_phone varchar(20),
    reader_email varchar(50),
    loan_date date default current_date,
    return_date date
);

insert into genres(title) values
                              ('Классическая проза'),
                              ('Роман'),
                              ('Фантастика');

insert into books(title, publication_year, author_name,
                  genres_id, author_country) values
                                                 ('Война и мир', 1869, 'Лев Толстой', 1, 'Россия'),
                                                 ('Анна Каренина', 1877, 'Лев Толстой', 1, 'Россия'),
                                                 ('1984', 1949,  'Джордж Оруэлл', 1, 'Англия');

insert into readers(full_name, email, phone,
                    registration_year) values
                                           ('Иванов Иван Иванович', 'ivanov@mail.ru', '+79991112233', 2022),
                                           ('Петров Петр Петрович', 'petrov@gmail.com', '+79992223344', 2024);

insert into loans( book_id, reader_id, reader_phone,
                  reader_email, loan_date, return_date) values
                                                            (1, 1, '+79991112233', 'ivanov@mail.ru', '2024-01-15', '2024-02-01'),
                                                            (2, 1, '+79991112233', 'ivanov@mail.ru', '2024-03-10', null);


