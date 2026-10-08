1. Выборка всех данных из таблицы 

1.1. Выбрать все строки и столбцы из books

SELECT * FROM books;
![img.png](img.png)

1.2. Выбрать все строки и столбцы из authors
SELECT * FROM authors;
![img_1.png](img_1.png)

2. Выборка отдельных столбцов

2.1. Выбрать только строки, состоящие из loan_date, return_date из loans

SELECT loan_date, return_date FROM loans;
![img_2.png](img_2.png)

2.2. Выбрать строки, состоящие из title, price из books
SELECT title, price FROM books;
![img_3.png](img_3.png)

3. Присвоение новых имен столбцам при формировании выборки

3.1. Выбрать строки со столбцами ull_name, который будет с новым именем - ФИО , 
и email из readers

SELECT full_name AS ФИО , email FROM readers;
![img_4.png](img_4.png)

3.2. Выбрать строки со столбцами title, publication_year, который будет с новым именем -
Год издания, из books

SELECT title, publication_year AS "Год издания" FROM books;
![img_5.png](img_5.png)

4. Выборка данных с созданием вычисляемого столбца

4.1. Выбрать title, amount, price и новый столбнц в котором будет сумма книг 
(цена на кол-во) из books

SELECT title, amount, price, price* amount AS total  FROM books;
![img_6.png](img_6.png)

4.2.Выбрать id, loan_date, return_date и новый столбнц в котором будет кол-во дней из loans

SELECT id, loan_date, return_date, return_date-loan_date AS total FROM loans;
![img_7.png](img_7.png)


5. Выборка данных, вычисляемые столбцы, логические функции

5.1. Выбрать title, price, amount если кол-во от 2 до 4 то скидка 30%,
иначе 50%

SELECT title, price, amount,
    CASE
        WHEN  amount BETWEEN 2 AND 4 THEN price* 0.7
        ELSE price * 0.5
    END AS sale
FROM books;
![img_8.png](img_8.png)

5.2.Выбрать title, publication_year, price если год издания до 1900, то скидка 10%

SELECT title, publication_year, price ,
    CASE
        WHEN publication_year < 1900 THEN  price *0.9
    END AS sale
FROM books;
![img_9.png](img_9.png)

6. Выборка данных по условию

6.1. Выбрать title, publication_year из books где цена больше 1000

SELECT title, publication_year FROM books
    WHERE price > 1000;
![img_10.png](img_10.png)

6.2. Выбрать full_name, email, registration_year из readers где год регистрации похже 2023

SELECT full_name, email, registration_year FROM  readers
    WHERE registration_year > 2023;
![img_11.png](img_11.png)


7.  Выборка данных, логические операции

7.1. Выбрать title, author_id, publication_year из books, где цена больше 1000 
и айди автора должно быть 3

SELECT title, author_id, publication_year FROM books
    WHERE price >1000 AND author_id = 3;
![img_12.png](img_12.png)

7.2. Выбрать reader_id, loan_date, return_date из loans, где дата брони позже 1го марта 2024
и дата возврата до 1го мая 2024

SELECT reader_id, loan_date, return_date FROM loans
    WHERE loan_date > '2024-03-01' AND return_date < '2024-05-01';
![img_13.png](img_13.png)


8. Выборка данных, операторы BETWEEN, IN

8.1. Выбрать title,publication_year из books где
год издания между 1900 и 1950

SELECT title,publication_year FROM books
    WHERE publication_year BETWEEN 1900 AND 1950;
![img_14.png](img_14.png)

8.2. Выбрать title, author_id из books
где айди автора либо 2 либо 4

SELECT title, author_id FROM books
    WHERE author_id IN(2, 4);
![img_15.png](img_15.png)

9. Выборка данных с сортировкой

9.1. Выбрать name, country из authors сортируя по странам

SELECT name, country FROM authors
    ORDER BY country;
![img_16.png](img_16.png)

9.2. Выбрать full_name, phone из readers сортируя по full_name не по алфавиту

SELECT full_name, phone FROM readers
    ORDER BY full_name DESC ;
![img_17.png](img_17.png)


10. Выборка данных, оператор LIKE

10.1. Выбрать  full_name, email из readers где маил заканчивается на mail.ru

SELECT full_name, email FROM readers
    WHERE email like '%mail.ru';
![img_18.png](img_18.png)

10.2. Выбрать title, publication_year из books где название состоит из 4 символов 
SELECT title, publication_year FROM books
    WHERE title like '____';
![img_19.png](img_19.png)

11. Выбор уникальных элементов столбца

11.1. Выбрать уникальные значениея genre_id из books

SELECT DISTINCT genre_id FROM books;
![img_20.png](img_20.png)

11.2. Выбрать уникальные значениея country из authors

SELECT DISTINCT country FROM authors;
![img_21.png](img_21.png)

12. Выбор ограниченного количества возвращаемых строк.

12.1. ВЫбрать 3 name, country из authors сортируя по алфавиту country 

SELECT name, country FROM authors
    ORDER BY country
    LIMIT 3;
![img_22.png](img_22.png)

12.2. ВЫбрать 3 title, price из books сортируя по убыванию price

SELECT title, price FROM books
    ORDER BY price DESC
    LIMIT 3;
![img_23.png](img_23.png)

JOIN

13. Соединение INNER JOIN

13.1. Выбрать titl из bookse и name из authors соединяя по айди автора

SELECT title, name FROM books
    INNER JOIN authors
    ON authors.id = books.author_id;
![img_24.png](img_24.png)

13.2.Выбрать title из bookse и return_date из loans соединяя по айди книги

SELECT title,return_date FROM books
    INNER JOIN loans
    ON books.id = loans.book_id;
![img_25.png](img_25.png)

14. Внешнее соединение LEFT и RIGHT OUTER JOIN

14.1. Выбрать titl из bookse и name из authors соединяя по айди автора включая и авторов без книг

SELECT name, title FROM authors
    LEFT JOIN books
    ON authors.id = books.author_id
    ORDER BY name;
![img_26.png](img_26.png)

14.2. Выбрать title из bookse и return_date из loans соединяя по айди книги включая и 
книги, которых нет в loans

SELECT title, return_date FROM loans
    RIGHT JOIN books
    ON books.id = loans.book_id
    ORDER BY title;
![img_27.png](img_27.png)

15. Перекрестное соединение CROSS JOIN

15.1. Выбрать name из authors и title из genres 

SELECT name, title FROM authors, genres;
![img_28.png](img_28.png)

15.2. Выбрать все возможные комбинации ФИО читателей и названий книг

SELECT full_name, title FROM readers, books;
![img_29.png](img_29.png)


16. Запросы на выборку из нескольких таблиц


16.1. Выбрать ФИО читателя, название книги и дату выдачи


SELECT full_name, title, loan_date FROM readers
INNER JOIN loans ON readers.id = loans.reader_id
INNER JOIN books ON loans.book_id = books.id;
![img_30.png](img_30.png)

16.2.Выбрать имя автора, название книги и название жанра

SELECT authors.name, books.title, genres.title AS genre
FROM authors
INNER JOIN books ON authors.id = books.author_id
INNER JOIN genres ON books.genre_id = genres.id;
![img_31.png](img_31.png)