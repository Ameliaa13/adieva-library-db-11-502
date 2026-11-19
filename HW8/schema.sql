--1
BEGIN;
INSERT INTO genres (title) VALUES ('Русская классика');
UPDATE books SET genre_id = (SELECT genre_id FROM genres WHERE title = 'Русская классика') WHERE id = 2;
COMMIT ;

BEGIN;
INSERT INTO  books(title, publication_year, author_id, genre_id) VALUES ('Вино из одуванчиков', 1952, 10, 9);
UPDATE loans SET book_id = (SELECT id FROM books WHERE title ='Вино из одуванчиков' ) WHERE id = 9;
COMMIT ;


--2

BEGIN;
INSERT INTO genres (title) VALUES ('Английская классика');
UPDATE books SET genre_id = (SELECT genre_id FROM genres WHERE title = 'Английская классика') WHERE id = 2;
ROLLBACK ;

BEGIN;
INSERT INTO  books(title, publication_year, author_id, genre_id) VALUES ('И грянул гром', 1952, 10, 9);
UPDATE loans SET book_id = (SELECT id FROM books WHERE title ='И грянул гром' ) WHERE id = 9;
ROLLBACK ;

--3

SELECT amount FROM books WHERE id = 2;
BEGIN;
INSERT INTO  genres (title) VALUES ('Научная фантастика');
UPDATE books SET amount = 2 WHERE id = 2;
SELECT 1/0;
COMMIT ;
--для проверки то не изменилось
SELECT amount FROM books WHERE id = 2;
SELECT * FROM genres WHERE title = 'Научная фантастика';


SELECT return_date FROM loans WHERE id = 4;
SELECT amount FROM books WHERE id = 4;
BEGIN;
UPDATE loans SET return_date = '2024-08-10' WHERE id = 4;
UPDATE books SET amount = amount + 1 WHERE id = 4;
INSERT INTO loans (book_id, reader_id, loan_date) VALUES (1, 3, '2024-13-45');
COMMIT;

--4

BEGIN TRANSACTION ISOLATION LEVEL READ UNCOMMITTED;
UPDATE books SET price = 1 WHERE id = 1;
SELECT id, title, price FROM books WHERE id = 1;

ROLLBACK;


BEGIN TRANSACTION ISOLATION LEVEL READ UNCOMMITTED ;
UPDATE loans SET return_date = '2024-08-10' WHERE id=4;
SELECT id, return_date FROM loans WHERE id = 4;

ROLLBACK ;

--5

BEGIN TRANSACTION ISOLATION LEVEL READ COMMITTED;
UPDATE books SET amount = amount - 1 WHERE id = 2;
SELECT id, amount FROM books WHERE id = 2;

COMMIT;

UPDATE books SET amount = 5 WHERE id = 2;


BEGIN TRANSACTION ISOLATION LEVEL READ COMMITTED;
UPDATE readers SET phone = '+79990000001' WHERE id = 1;
SELECT id, phone FROM readers WHERE id = 1;

ROLLBACK;

--6

BEGIN TRANSACTION ISOLATION LEVEL READ COMMITTED;
SELECT id, title, price FROM books WHERE id = 3;

SELECT id, title, price FROM books WHERE id = 3;
COMMIT;
UPDATE books SET price = 1200 WHERE id = 3;


BEGIN TRANSACTION ISOLATION LEVEL READ COMMITTED;
SELECT COUNT(*) FROM loans WHERE return_date IS NULL;

SELECT COUNT(*) FROM loans WHERE return_date IS NULL;
COMMIT;
UPDATE loans SET return_date = NULL WHERE id = 4;

--7

BEGIN TRANSACTION ISOLATION LEVEL REPEATABLE READ;
SELECT id, title, price FROM books WHERE id = 3;

SELECT id, title, price FROM books WHERE id = 3;
COMMIT;
SELECT id, title, price FROM books WHERE id = 3;
UPDATE books SET price = 1200 WHERE id = 3;


BEGIN TRANSACTION ISOLATION LEVEL REPEATABLE READ;
SELECT COUNT(*) FROM loans WHERE return_date IS NULL;

SELECT COUNT(*) FROM loans WHERE return_date IS NULL;
COMMIT;
SELECT COUNT(*) FROM loans WHERE return_date IS NULL;
UPDATE loans SET return_date = NULL WHERE id = 4;

--8

BEGIN TRANSACTION ISOLATION LEVEL REPEATABLE READ;
SELECT COUNT(*) FROM books WHERE genre_id = 1;

SELECT COUNT(*) FROM books WHERE genre_id = 1;
COMMIT;
SELECT COUNT(*) FROM books WHERE genre_id = 1;
DELETE FROM books WHERE title = 'Тестовая книга';


BEGIN TRANSACTION ISOLATION LEVEL REPEATABLE READ;
SELECT COUNT(*) FROM loans;

SELECT COUNT(*) FROM loans;
COMMIT;
SELECT COUNT(*) FROM loans;
DELETE FROM loans WHERE reader_id = 7 AND loan_date = '2024-08-01';

--9
BEGIN TRANSACTION ISOLATION LEVEL SERIALIZABLE;
SELECT COUNT(*) FROM genres WHERE title = 'Эпос';

INSERT INTO genres (title) VALUES ('Эпос');

COMMIT;


BEGIN TRANSACTION ISOLATION LEVEL SERIALIZABLE;
SELECT COUNT(*) FROM readers WHERE email = 'test@mail.ru';

INSERT INTO readers (full_name, email, registration_year, phone)
VALUES ('Тестов Тест Тестович', 'test@mail.ru', 2024, '+79990001122');

COMMIT;

--10

BEGIN TRANSACTION ISOLATION LEVEL SERIALIZABLE;
SELECT amount FROM books WHERE id = 2;
UPDATE books SET amount = amount - 1 WHERE id = 2;

COMMIT;

UPDATE books SET amount = 5 WHERE id = 2;


BEGIN TRANSACTION ISOLATION LEVEL SERIALIZABLE;
SELECT phone FROM readers WHERE id = 1;
UPDATE readers SET phone = '+79990000001' WHERE id = 1;

COMMIT;

UPDATE readers SET phone = '+79991112233' WHERE id = 1;

--11

SELECT amount FROM books WHERE id = 2;
SELECT registration_year FROM readers WHERE id = 1;
SELECT price FROM books WHERE id = 1;

BEGIN;

UPDATE books SET amount = amount - 1 WHERE id = 2;
UPDATE readers SET registration_year = 2025 WHERE id = 1;

SAVEPOINT sp1;

UPDATE books SET price = 1 WHERE id = 1;

SELECT price FROM books WHERE id = 1;

ROLLBACK TO SAVEPOINT sp1;

SELECT price FROM books WHERE id = 1;
SELECT amount FROM books WHERE id = 2;
SELECT registration_year FROM readers WHERE id = 1;

COMMIT;

SELECT amount FROM books WHERE id = 2;
SELECT registration_year FROM readers WHERE id = 1;
SELECT price FROM books WHERE id = 1;

UPDATE books SET amount = 5 WHERE id = 2;
UPDATE readers SET registration_year = 2022 WHERE id = 1;




SELECT COUNT(*) FROM genres;
SELECT amount FROM books WHERE id = 2;
SELECT price FROM books WHERE id = 3;

BEGIN;

INSERT INTO genres (title) VALUES ('Жанр А');
SAVEPOINT sp1;

UPDATE books SET amount = amount - 1 WHERE id = 2;
SAVEPOINT sp2;

UPDATE books SET price = 1 WHERE id = 3;

ROLLBACK TO SAVEPOINT sp2;
SELECT price FROM books WHERE id = 3;
SELECT amount FROM books WHERE id = 2;

ROLLBACK TO SAVEPOINT sp1;
SELECT amount FROM books WHERE id = 2;
SELECT * FROM genres WHERE title = 'Жанр А';

COMMIT;

SELECT * FROM genres WHERE title = 'Жанр А';
SELECT amount FROM books WHERE id = 2;
SELECT price FROM books WHERE id = 3;

DELETE FROM genres WHERE title = 'Жанр А';