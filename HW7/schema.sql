--1. cte
WITH russian_books AS (
    SELECT b.* FROM books b
            INNER JOIN authors a ON a.id = b.author_id WHERE a.country='Россия')
SELECT title FROM russian_books GROUP BY title ;

WITH usa_readers AS
    ( SELECT DISTINCT r.id, r.full_name FROM readers r
            INNER JOIN loans l ON r.id = l.reader_id
            INNER JOIN books b on b.id = l.book_id
            INNER JOIN authors a on a.id = b.author_id WHERE a.country = 'США')
SELECT full_name AS reader_name FROM usa_readers ;

WITH book_loans_count AS
    (SELECT l.book_id, COUNT(*) AS amount FROM loans l
            GROUP BY l.book_id)
SELECT b.title, blc.amount FROM book_loans_count blc
INNER JOIN books b ON blc.book_id = b.id;

--2

SELECT title FROM books WHERE price > 1000
UNION
SELECT title FROM books WHERE publication_year <1900;

SELECT id FROM readers WHERE registration_year = 2024
INTERSECT
SELECT reader_id FROM loans WHERE return_date IS NULL;

SELECT title FROM books
EXCEPT
SELECT b.title FROM books b
INNER JOIN loans l On b.id = l.book_id;

--3

SELECT b.title, b.genre_id, b.price,
    AVG (b.price) OVER (PARTITION BY b.genre_id) AS avg_genre_price,
    b.price - AVG(b.price) OVER (PARTITION BY  b.genre_id) AS diff
FROM books b;

SELECT b.title, b.author_id,
    COUNT(*) OVER (PARTITION BY b.author_id) AS amount,
    MAX(b.price) OVER (PARTITION BY b.author_id) AS max_price
FROM books b;

--4

SELECT l.reader_id, l.book_id, l.loan_date,
    COUNt(*) OVER (PARTITION BY l.reader_id ORDER BY l.loan_date) AS loan_number
FROM loans l;

SELECT genre_id, title, price,
       SUM(price) OVER (PARTITION BY genre_id ORDER BY price) AS total
FROM books;

--5

SELECT title, publication_year, price,
       SUM(price) OVER (ORDER BY publication_year, id ROWS BETWEEN 2 PRECEDING AND CURRENT ROW) AS sum_3_books
FROM books;

SELECT title, price,
       ROUND(AVG(price) OVER ( ORDER BY price ROWS BETWEEN 1 PRECEDING AND 1 FOLLOWING ), 2) AS moving_avg
FROM books;

SELECT title, publication_year,
       COUNT(*) OVER (ORDER BY publication_year RANGE BETWEEN 50 PRECEDING AND CURRENT ROW ) AS books_last_50_years
FROM books;

SELECT title, price,
       SUM(price) OVER (ORDER BY price RANGE BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW) AS running_total
FROM books;

--6

SELECT title, genre_id, price,
       ROW_NUMBER() OVER (PARTITION BY genre_id ORDER BY price DESC) AS rn
FROM books;

SELECT title, price,
       RANK() OVER (ORDER BY price DESC) AS rnk
FROM books;

SELECT title, price,
       DENSE_RANK() OVER (ORDER BY price DESC) AS dense_rnk
FROM books;

SELECT title, price,
       NTILE(4) OVER (ORDER BY price DESC) AS price_group
FROM books;

SELECT title, price,
       ROUND(PERCENT_RANK() OVER (ORDER BY price)::numeric, 3) AS pct_rank
FROM books;

SELECT full_name, registration_year,
       CUME_DIST() OVER (ORDER BY registration_year) AS cume
FROM readers;

SELECT reader_id, book_id, loan_date,
       LAG(loan_date) OVER (PARTITION BY reader_id ORDER BY loan_date) AS prev_loan,
       loan_date - LAG(loan_date) OVER (PARTITION BY reader_id ORDER BY loan_date) AS days_between
FROM loans;

SELECT title, publication_year,
       LEAD(title) OVER (ORDER BY publication_year, id) AS next_book
FROM books;

SELECT title, genre_id, price,
       FIRST_VALUE(title) OVER (PARTITION BY genre_id ORDER BY price) AS cheapest_in_genre
FROM books;

SELECT title, genre_id, price,
       LAST_VALUE(title) OVER ( PARTITION BY genre_id ORDER BY price ROWS BETWEEN UNBOUNDED PRECEDING AND UNBOUNDED FOLLOWING ) AS priciest_in_genre
FROM books;

SELECT title, price,
       NTH_VALUE(title, 2) OVER ( ORDER BY price ROWS BETWEEN UNBOUNDED PRECEDING AND UNBOUNDED FOLLOWING ) AS second_cheapest
FROM books;