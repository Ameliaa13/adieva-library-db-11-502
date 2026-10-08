--1
SELECT * FROM books;
SELECT * FROM authors;
--2
SELECT loan_date, return_date FROM loans;
SELECT title, price FROM books;
--3
SELECT full_name AS ФИО , email FROM readers;
SELECT title, publication_year AS "Год издания" FROM books;
--4
SELECT title, amount, price, price* amount AS total  FROM books;
SELECT id, loan_date, return_date, return_date-loan_date AS total FROM loans;
--5
SELECT title, price, amount,
    CASE
        WHEN  amount BETWEEN 2 AND 4 THEN price* 0.7
        ELSE price * 0.5
    END AS sale
FROM books;
SELECT title, publication_year, price ,
    CASE
        WHEN publication_year < 1900 THEN  price *0.9
    END AS sale
FROM books;

--6
SELECT title, publication_year FROM books
    WHERE price > 1000;
SELECT full_name, email, registration_year FROM  readers
    WHERE registration_year > 2023;
--7

SELECT title, author_id, publication_year FROM books
    WHERE price >1000 AND author_id = 3;
SELECT reader_id, loan_date, return_date FROM loans
    WHERE loan_date > '2024-03-01' AND return_date < '2024-05-01';

--8
SELECT title,publication_year FROM books
    WHERE publication_year BETWEEN 1900 AND 1950;
SELECT title, author_id FROM books
    WHERE author_id IN(2, 4);

--9
SELECT name, country FROM authors
    ORDER BY country;
SELECT full_name, phone FROM readers
    ORDER BY full_name DESC ;

--10
SELECT full_name, email FROM readers
    WHERE email like '%mail.ru';
SELECT title, publication_year FROM books
    WHERE title like '____';

--11
SELECT DISTINCT genre_id FROM books;
SELECT DISTINCT country FROM authors;

--12
SELECT name, country FROM authors
    ORDER BY country
LIMIT 3;

SELECT title, price FROM books
    ORDER BY price DESC
LIMIT 3;

--13
SELECT title, name FROM books
    INNER JOIN authors
    ON authors.id = books.author_id;
SELECT title,return_date FROM books
    INNER JOIN loans
    ON books.id = loans.book_id;

--

INSERT INTO authors (name, country) VALUES ('Александр Пушкин', 'Россия');
INSERT INTO books(title, publication_year, author_id, genre_id) VALUES ('Идиот', 1869, 2, 2);
--14
SELECT name, title FROM authors
    LEFT JOIN books
    ON authors.id = books.author_id
    ORDER BY name;

SELECT title, return_date FROM loans
RIGHT JOIN books
ON books.id = loans.book_id
ORDER BY title;

--15
SELECT name, title FROM authors, genres;
SELECT full_name, title FROM readers, books;


--16
SELECT full_name, title, loan_date FROM readers
INNER JOIN loans ON readers.id = loans.reader_id
INNER JOIN books ON loans.book_id = books.id;

SELECT authors.name, books.title, genres.title AS genre
FROM authors
         INNER JOIN books ON authors.id = books.author_id
         INNER JOIN genres ON books.genre_id = genres.id;
