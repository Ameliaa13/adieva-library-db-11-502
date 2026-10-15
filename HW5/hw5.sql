SELECT AVG(price) AS average_price FROM books;
SELECT AVG(amount) as average_amount FROM books;

SELECT COUNT(*) FROM genres;
SELECT COUNT(DISTINCT country) FROM authors;

SELECT MAX(title) FROM books;
SELECT MIN(price) FROM books;

SELECT SUM(price * amount) FROM books;
SELECT SUM(books.price) FROM books;

SELECT STRING_AGG(name, ', ') FROM authors;
SELECT STRING_AGG(title, ', ') FROM books;

--?
SELECT
    author_id,
    COUNT(*) AS book_count,
    AVG(price) AS avg_price,
    SUM(amount) AS total_in_stock
FROM books GROUP BY author_id ORDER BY book_count DESC;

SELECT
    author_id,
    genre_id,
    COUNT(*) AS book_count
FROM books GROUP BY author_id, genre_id
           ORDER BY author_id, genre_id;

--

SELECT genre_id, AVG(price) AS average_price
FROM books WHERE publication_year > 1900
GROUP BY genre_id HAVING AVG(price) > 800;

SELECT reader_id, COUNT(*) AS books_taken_count
FROM loans WHERE loan_date >= '2024-01-01'
GROUP BY reader_id HAVING COUNT(*) > 1;

--

SELECT title, genre_id, SUM(amount) AS total_amount
FROM books GROUP BY
               GROUPING SETS ((title, genre_id), (genre_id), ());

SELECT title, author_id, SUM(price)  AS total_price
FROM books GROUP BY
               GROUPING SETS ((title, author_id), (author_id), ());

--
SELECT title, genre_id, SUM(price) AS total_price
FROM books GROUP BY
    ROLLUP (title, genre_id);

SELECT title, author_id, SUM(amount)  AS total_amount
FROM books GROUP BY
    ROLLUP (title, author_id);

--

SELECT title, genre_id, SUM(amount) AS total_amount
FROM books GROUP BY
    CUBE (title, genre_id);

SELECT title, author_id, SUM(price)  AS total_price
FROM books GROUP BY
    CUBE (title, author_id);

--


SELECT
    r.id AS reader_id,
    r.full_name,
    COUNT(l.id) AS total_loans
FROM loans l
         JOIN readers r ON l.reader_id = r.id
GROUP BY r.id, r.full_name
HAVING COUNT(l.id) >= 2
ORDER BY total_loans DESC, r.id;

SELECT
    g.title AS genre_title,
    COUNT(*) AS book_count,
    ROUND(AVG(b.price), 1) AS average_price
FROM books b
         JOIN genres g ON b.genre_id = g.id
WHERE b.publication_year >= 1900
GROUP BY g.title
HAVING AVG(b.price) > 800
ORDER BY average_price DESC;