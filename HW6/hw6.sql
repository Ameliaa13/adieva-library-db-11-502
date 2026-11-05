SELECT title,
       price,
       price - (SELECT AVG(price) FROM books) AS diff_from_avg
FROM books;

SELECT title,
       price,
       (SELECT MAX(price) FROM books) AS max_price
FROM books;

--2
SELECT g.title AS genre, t.avg_price
FROM (SELECT genre_id, AVG(price) AS avg_price
      FROM books
      GROUP BY genre_id) t
         JOIN genres g ON g.id = t.genre_id;

SELECT r.full_name, l.loans_count
FROM (SELECT reader_id, COUNT(*) AS loans_count
      FROM loans
      GROUP BY reader_id) l
         JOIN readers r ON r.id = l.reader_id
ORDER BY l.loans_count DESC;

--3
SELECT title, price
FROM books
WHERE price > (SELECT AVG(price) FROM books);

SELECT full_name, registration_year
FROM readers
WHERE registration_year = (SELECT MIN(registration_year) FROM readers);

--4
SELECT genre_id, AVG(price) AS avg_price
FROM books
GROUP BY genre_id
HAVING AVG(price) > (SELECT AVG(price) FROM books);

SELECT author_id, SUM(amount) AS total_amount
FROM books
GROUP BY author_id
HAVING SUM(amount) > (SELECT AVG(amount) FROM books);

--5
SELECT title, price
FROM books
WHERE price > ALL (SELECT price FROM books WHERE genre_id = 2);

SELECT title, publication_year
FROM books
WHERE publication_year < ALL (SELECT publication_year FROM books WHERE genre_id = 3);

--6
SELECT title
FROM books
WHERE id IN (SELECT book_id FROM loans WHERE return_date IS NULL);

SELECT name, country
FROM authors
WHERE id IN (SELECT author_id FROM books WHERE price > 1000);

--7
SELECT title, price
FROM books
WHERE price > ANY (SELECT price FROM books WHERE author_id = 2);

SELECT full_name
FROM readers
WHERE id = ANY (SELECT reader_id FROM loans WHERE return_date IS NULL);

--8
SELECT r.full_name
FROM readers r
WHERE EXISTS (SELECT 1 FROM loans l WHERE l.reader_id = r.id);

SELECT b.title
FROM books b
WHERE NOT EXISTS (SELECT 1 FROM loans l WHERE l.book_id = b.id);

--9
SELECT title, genre_id, price
FROM books
WHERE (genre_id, price) IN (SELECT genre_id, MAX(price)
                            FROM books
                            GROUP BY genre_id);

SELECT title, author_id, publication_year
FROM books
WHERE (author_id, publication_year) IN (SELECT author_id, MIN(publication_year)
                                        FROM books
                                        GROUP BY author_id);

--10
SELECT a.name,
       (SELECT COUNT(*) FROM books b WHERE b.author_id = a.id) AS books_count
FROM authors a;

SELECT b.title, b.genre_id, b.price
FROM books b
WHERE b.price > (SELECT AVG(b2.price)
                 FROM books b2
                 WHERE b2.genre_id = b.genre_id);


SELECT r.full_name
FROM readers r
WHERE (SELECT COUNT(*) FROM loans l WHERE l.reader_id = r.id) > 1;

SELECT b.title,
       (SELECT MAX(l.loan_date) FROM loans l WHERE l.book_id = b.id) AS last_loan_date
FROM books b;


SELECT l.id, l.reader_id, l.book_id, l.loan_date
FROM loans l
WHERE l.loan_date = (SELECT MIN(l2.loan_date)
                     FROM loans l2
                     WHERE l2.reader_id = l.reader_id);

