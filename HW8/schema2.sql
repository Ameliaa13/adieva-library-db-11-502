--4
BEGIN TRANSACTION ISOLATION LEVEL READ UNCOMMITTED;
SELECT id, title, price FROM books WHERE id = 1;
COMMIT;

BEGIN TRANSACTION ISOLATION LEVEL READ UNCOMMITTED ;
SELECT id, return_date FROM loans WHERE id=4;
COMMIT ;

--5

BEGIN TRANSACTION ISOLATION LEVEL READ COMMITTED;
SELECT id, amount FROM books WHERE id = 2;

SELECT id, amount FROM books WHERE id = 2;
COMMIT;


BEGIN TRANSACTION ISOLATION LEVEL READ COMMITTED;
SELECT id, phone FROM readers WHERE id = 1;
UPDATE readers SET phone = '+79990000002' WHERE id = 1;

ROLLBACK;

--6

BEGIN;
UPDATE books SET price = 1300 WHERE id = 3;
COMMIT;


BEGIN;
UPDATE loans SET return_date = '2024-08-10' WHERE id = 4;
COMMIT;

--7

BEGIN;
UPDATE books SET price = 1300 WHERE id = 3;
COMMIT;


BEGIN;
UPDATE loans SET return_date = '2024-08-10' WHERE id = 4;
COMMIT;

--8

BEGIN;
INSERT INTO books (title, publication_year, author_id, genre_id, price, amount)
VALUES ('Тестовая книга', 2000, 1, 1, 500, 1);
COMMIT;


BEGIN;
INSERT INTO loans (book_id, reader_id, loan_date) VALUES (2, 7, '2024-08-01');
COMMIT;

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

ROLLBACK;
BEGIN TRANSACTION ISOLATION LEVEL SERIALIZABLE;
SELECT amount FROM books WHERE id = 2;
UPDATE books SET amount = amount - 1 WHERE id = 2;
COMMIT;
SELECT amount FROM books WHERE id = 2;



BEGIN TRANSACTION ISOLATION LEVEL SERIALIZABLE;
SELECT phone FROM readers WHERE id = 1;
UPDATE readers SET phone = '+79990000002' WHERE id = 1;

ROLLBACK;
BEGIN TRANSACTION ISOLATION LEVEL SERIALIZABLE;
UPDATE readers SET phone = '+79990000002' WHERE id = 1;
COMMIT;
SELECT phone FROM readers WHERE id = 1;