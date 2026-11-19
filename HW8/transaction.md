1. BEGIN...COMMIT

1.1. Добавить новый жанр 'Русская классика' и изменить жанр у книги Преуступление и накзание 

```sql
BEGIN;
INSERT INTO genres (title) VALUES ('Русская классика');
UPDATE books SET genre_id = (SELECT genre_id FROM genres WHERE title = 'Русская классика') WHERE id = 2;
COMMIT ;
```
![img.png](img.png)

1.2. добавить новую книгу 'Вино из одуванчиков' и поменять запись брони с айди 9 на айди новой книжки

```sql
BEGIN;
INSERT INTO  books(title, publication_year, author_id, genre_id) VALUES ('Вино из одуванчиков', 1952, 10, 9);
UPDATE loans SET book_id = (SELECT id FROM books WHERE title ='Вино из одуванчиков' ) WHERE id = 9;
COMMIT ;
```

![img_1.png](img_1.png)


2. ROLLBACK

2.1. Добавить новый жанр 'Английская классика' и изменить жанр у книги Преуступление и накзание

```sql
BEGIN;
INSERT INTO genres (title) VALUES ('Английская классика');
UPDATE books SET genre_id = (SELECT genre_id FROM genres WHERE title = 'Английская классика') WHERE id = 2;
ROLLBACK ;
```
![img_2.png](img_2.png)

2.2. добавить новую книгу 'И грянул гром' и поменять запись брони с айди 9 на айди новой книжки

```sql
BEGIN;
INSERT INTO  books(title, publication_year, author_id, genre_id) VALUES ('И грянул гром', 1952, 10, 9);
UPDATE loans SET book_id = (SELECT id FROM books WHERE title ='И грянул гром' ) WHERE id = 9;
ROLLBACK ;
```

![img_3.png](img_3.png)


3. ошибка в транзакции

3.1. новый жанр, измение в кол-ве книг, а потом деление на 0

```sql
SELECT amount FROM books WHERE id = 2;
BEGIN;
INSERT INTO  genres (title) VALUES ('Научная фантастика');
UPDATE books SET amount = 2 WHERE id = 2;
SELECT 1/0;
COMMIT ;
--для проверки то не изменилось
SELECT amount FROM books WHERE id = 2;
SELECT * FROM genres WHERE title = 'Научная фантастика';
```
![img_4.png](img_4.png)

3.2. на некорректную дату

```sql
SELECT return_date FROM loans WHERE id = 4;
SELECT amount FROM books WHERE id = 4;
BEGIN;
UPDATE loans SET return_date = '2024-08-10' WHERE id = 4;
UPDATE books SET amount = amount + 1 WHERE id = 4;
INSERT INTO loans (book_id, reader_id, loan_date) VALUES (1, 3, '2024-13-45');
COMMIT;
```

![img_5.png](img_5.png)

4. READ UNCOMMITTED / READ COMMITTED. грязные данные

4.1.
сначала транзакции в 1й консоли (ролбэк в конце над сделать, после выполнения 2й консоли)
меняем цену книги с айди 1
```sql
BEGIN TRANSACTION ISOLATION LEVEL READ UNCOMMITTED;
UPDATE books SET price = 1 WHERE id = 1;
SELECT id, title, price FROM books WHERE id = 1;

ROLLBACK;
```
транзакции во 2й консоли
проверяем цену (изменилась или нет)
```sql
BEGIN TRANSACTION ISOLATION LEVEL READ UNCOMMITTED;
SELECT id, title, price FROM books WHERE id = 1;
COMMIT;
```
Внтри 1й консоли изменения есть, но тк они не закоммичены, то 2я консоль видит старые данные

![img_6.png](img_6.png)

![img_7.png](img_7.png)
![img_8.png](img_8.png)

4.2.

сначала транзакции в 1й консоли (ролбэк в конце над сделать, после выполнения 2й консоли)
меняем дату возврата книги с айди 4
```sql
BEGIN TRANSACTION ISOLATION LEVEL READ UNCOMMITTED ;
UPDATE loans SET return_date = '2024-08-10' WHERE id=4;
SELECT id, return_date FROM loans WHERE id = 4;

ROLLBACK ;
```
транзакции во 2й консоли
проверяем  дату возврата (изменилась или нет)
```sql
BEGIN TRANSACTION ISOLATION LEVEL READ UNCOMMITTED ;
SELECT id, return_date FROM loans WHERE id=4;
COMMIT ;
```
Внтри 1й консоли изменения есть, но тк они не закоммичены, то 2я консоль видит старые данные

![img_9.png](img_9.png)
![img_10.png](img_10.png)
![img_11.png](img_11.png)


5. Сделай UPDATE без COMMIT в T1 и попробуй прочитать в T2.

5.1. сначала меняем кол-во книг с id=2 в 1й консоли, не делая коммит, и смотрим кол-во (новое). Потом 
во второй консоли смотрим кол-во (старое). Потом делаем коммит в 1й и смотрим опять во 2й консоли, 
кол-во изменилось. В конце в 1й консоли вернула старое кол-во

первая консоль
```sql
BEGIN TRANSACTION ISOLATION LEVEL READ COMMITTED;
UPDATE books SET amount = amount - 1 WHERE id = 2;
SELECT id, amount FROM books WHERE id = 2;

COMMIT;

UPDATE books SET amount = 5 WHERE id = 2;
```

вторая консоль
```sql
BEGIN TRANSACTION ISOLATION LEVEL READ COMMITTED;
SELECT id, amount FROM books WHERE id = 2;

SELECT id, amount FROM books WHERE id = 2;
COMMIT;
```

![img_12.png](img_12.png)
![img_13.png](img_13.png)
![img_14.png](img_14.png)
![img_15.png](img_15.png)


5.2.меняем номер в 1й консоли, выводим изменения, потом во 2й смотрим какой номер (выдает старый), пытаемся поменятьБ
но запрос завсает и ждет когда 1я консоль сделает коммит. После коммита, 2я консоль может поменять данные. В конце откат

первая консоль
```sql
BEGIN TRANSACTION ISOLATION LEVEL READ COMMITTED;
UPDATE readers SET phone = '+79990000001' WHERE id = 1;
SELECT id, phone FROM readers WHERE id = 1;

ROLLBACK;
```

вторая консоль
```sql
BEGIN TRANSACTION ISOLATION LEVEL READ COMMITTED;
SELECT id, phone FROM readers WHERE id = 1;
UPDATE readers SET phone = '+79990000002' WHERE id = 1;

ROLLBACK;
```

![img_16.png](img_16.png)
![img_17.png](img_17.png)
![img_18.png](img_18.png)


6. Покажи неповторяющееся чтение (T1 дважды SELECT, между ними T2 делает UPDATE+COMMIT).

6.1. дважды читали цену, а резултаты разные 

первая консоль
```sql
BEGIN TRANSACTION ISOLATION LEVEL READ COMMITTED;
SELECT id, title, price FROM books WHERE id = 3;

SELECT id, title, price FROM books WHERE id = 3;
COMMIT;
UPDATE books SET price = 1200 WHERE id = 3;
```
вторая консоль
```sql
BEGIN;
UPDATE books SET price = 1300 WHERE id = 3;
COMMIT;
```

![img_19.png](img_19.png)
![img_20.png](img_20.png)
![img_21.png](img_21.png)

6.2. дважды читали число невозвращенных книг, а резултаты разные

```sql
BEGIN TRANSACTION ISOLATION LEVEL READ COMMITTED;
SELECT COUNT(*) FROM loans WHERE return_date IS NULL;

SELECT COUNT(*) FROM loans WHERE return_date IS NULL;
COMMIT;
UPDATE loans SET return_date = NULL WHERE id = 4;
```

```sql
BEGIN;
UPDATE loans SET return_date = '2024-08-10' WHERE id = 4;
COMMIT;
```

![img_22.png](img_22.png)
![img_23.png](img_23.png)
![img_24.png](img_24.png)
![img_25.png](img_25.png)


7. Проверь, что T1 не видит изменений от T2, пока не завершится.

7.1. первая консоль не увидит изменения пока 2я не завершится

```sql
BEGIN TRANSACTION ISOLATION LEVEL REPEATABLE READ;
SELECT id, title, price FROM books WHERE id = 3;

SELECT id, title, price FROM books WHERE id = 3;
COMMIT;
SELECT id, title, price FROM books WHERE id = 3;
UPDATE books SET price = 1200 WHERE id = 3;
```

```sql
BEGIN;
UPDATE books SET price = 1300 WHERE id = 3;
COMMIT;
```

![img_26.png](img_26.png)
![img_27.png](img_27.png)
![img_28.png](img_28.png)

7.2. про невозвращенные книги

```sql
BEGIN TRANSACTION ISOLATION LEVEL REPEATABLE READ;
SELECT COUNT(*) FROM loans WHERE return_date IS NULL;

SELECT COUNT(*) FROM loans WHERE return_date IS NULL;
COMMIT;
SELECT COUNT(*) FROM loans WHERE return_date IS NULL;
UPDATE loans SET return_date = NULL WHERE id = 4;
```

```sql
BEGIN;
UPDATE loans SET return_date = '2024-08-10' WHERE id = 4;
COMMIT;
```

![img_29.png](img_29.png)
![img_30.png](img_30.png)
![img_31.png](img_31.png)

8. фантомное чтение 

8.1. считаем книжки с genre_id = 1, добавляем новую тестовую книгу,
в 1й консоли опять посчитали ниче не поменялось, сделали коммит и теперь таких книг 3, 
и в конце почистили от этой книги

```sql
BEGIN TRANSACTION ISOLATION LEVEL REPEATABLE READ;
SELECT COUNT(*) FROM books WHERE genre_id = 1;

SELECT COUNT(*) FROM books WHERE genre_id = 1;
COMMIT;
SELECT COUNT(*) FROM books WHERE genre_id = 1;
DELETE FROM books WHERE title = 'Тестовая книга';
```

```sql
BEGIN;
INSERT INTO books (title, publication_year, author_id, genre_id, price, amount)
VALUES ('Тестовая книга', 2000, 1, 1, 500, 1);
COMMIT;
```

![img_32.png](img_32.png)
![img_33.png](img_33.png)
![img_34.png](img_34.png)

8.2. тоже самое но с выдачей

```sql
BEGIN TRANSACTION ISOLATION LEVEL REPEATABLE READ;
SELECT COUNT(*) FROM loans;

SELECT COUNT(*) FROM loans;
COMMIT;
SELECT COUNT(*) FROM loans;
DELETE FROM loans WHERE reader_id = 7 AND loan_date = '2024-08-01';
```

```sql

BEGIN;
INSERT INTO loans (book_id, reader_id, loan_date) VALUES (2, 7, '2024-08-01');
COMMIT;

```

![img_35.png](img_35.png)
![img_36.png](img_36.png)
![img_37.png](img_37.png)


9. Смоделируй конфликт: две транзакции вставляют одинаковые данные.

9.1. работа с новым жанорм, одну из вставок транзакций отменится (выполнилось у 1го, а у 2го ошибка)

```sql
BEGIN TRANSACTION ISOLATION LEVEL SERIALIZABLE;
SELECT COUNT(*) FROM genres WHERE title = 'Эпос';

INSERT INTO genres (title) VALUES ('Эпос');

COMMIT;
```

```sql
BEGIN TRANSACTION ISOLATION LEVEL SERIALIZABLE;
SELECT COUNT(*) FROM genres WHERE title = 'Эпос';

INSERT INTO genres (title) VALUES ('Эпос');

COMMIT;
```

![img_38.png](img_38.png)
![img_39.png](img_39.png)

9.2. тоже самое, но уже с читателем

```sql
BEGIN TRANSACTION ISOLATION LEVEL SERIALIZABLE;
SELECT COUNT(*) FROM readers WHERE email = 'test@mail.ru';

INSERT INTO readers (full_name, email, registration_year, phone)
VALUES ('Тестов Тест Тестович', 'test@mail.ru', 2024, '+79990001122');

COMMIT;

```

```sql
BEGIN TRANSACTION ISOLATION LEVEL SERIALIZABLE;
SELECT COUNT(*) FROM readers WHERE email = 'test@mail.ru';

INSERT INTO readers (full_name, email, registration_year, phone)
VALUES ('Тестов Тест Тестович', 'test@mail.ru', 2024, '+79990001122');

COMMIT;

```


![img_40.png](img_40.png)
![img_41.png](img_41.png)

10. Поймай ошибку could not serialize access due to concurrent update и повтори транзакцию.

10.1 про остаток книг, только после совершения коммита в 1й консоли можно выполнить во второй

```sql
BEGIN TRANSACTION ISOLATION LEVEL SERIALIZABLE;
SELECT amount FROM books WHERE id = 2;
UPDATE books SET amount = amount - 1 WHERE id = 2;

COMMIT;

UPDATE books SET amount = 5 WHERE id = 2;
```

```sql
BEGIN TRANSACTION ISOLATION LEVEL SERIALIZABLE;
SELECT amount FROM books WHERE id = 2;
UPDATE books SET amount = amount - 1 WHERE id = 2;

ROLLBACK;
BEGIN TRANSACTION ISOLATION LEVEL SERIALIZABLE;
SELECT amount FROM books WHERE id = 2;
UPDATE books SET amount = amount - 1 WHERE id = 2;
COMMIT;
SELECT amount FROM books WHERE id = 2;
```

![img_42.png](img_42.png)
![img_43.png](img_43.png)
![img_44.png](img_44.png)

10.2. про телефон читателя


```sql
BEGIN TRANSACTION ISOLATION LEVEL SERIALIZABLE;
SELECT phone FROM readers WHERE id = 1;
UPDATE readers SET phone = '+79990000001' WHERE id = 1;

COMMIT;

UPDATE readers SET phone = '+79991112233' WHERE id = 1;
```

```sql
BEGIN TRANSACTION ISOLATION LEVEL SERIALIZABLE;
SELECT phone FROM readers WHERE id = 1;
UPDATE readers SET phone = '+79990000002' WHERE id = 1;

ROLLBACK;
BEGIN TRANSACTION ISOLATION LEVEL SERIALIZABLE;
UPDATE readers SET phone = '+79990000002' WHERE id = 1;
COMMIT;
SELECT phone FROM readers WHERE id = 1;
```

![img_45.png](img_45.png)
![img_46.png](img_46.png)
![img_47.png](img_47.png)

11. Создай транзакцию с несколькими изменениями и точкой сохранения.

```sql
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
```

![img_48.png](img_48.png)
![img_49.png](img_49.png)
![img_50.png](img_50.png)
![img_51.png](img_51.png)
![img_52.png](img_52.png)
![img_53.png](img_53.png)
![img_54.png](img_54.png)
![img_55.png](img_55.png)

12. Добавь два SAVEPOINT, попробуй вернуть на первый и второй.

```sql
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
```

![img_56.png](img_56.png)
![img_57.png](img_57.png)
![img_58.png](img_58.png)
![img_59.png](img_59.png)
![img_60.png](img_60.png)
![img_61.png](img_61.png)
![img_62.png](img_62.png)
![img_63.png](img_63.png)


выводы:

**Транзакции**

В 1 пункте мы делали BEGIN ... COMMIT: вставка в одну таблицу и изменение связанной записи в другой применились вместе, только после коммита. 
Во 2 пункте то же самое с ROLLBACK, и после отката в таблицах ничего не поменялось, всё как было до транзакции. 
В 3 пункте мы специально сделали ошибку (деление на 0 и неправильную дату). 
После ошибки транзакция уже не выполняет команды, а COMMIT просто откатывает всё. 
Откатились и те запросы, которые до ошибки прошли нормально, то есть работает принцип "или всё, или ничего".

Ещё заметила, что у таблиц отставали счетчики id (из-за этого вылезала ошибка про повторяющийся ключ), пришлось их выровнять через setval. И при откате счетчик назад не возвращается, так что в id могут быть пропуски.

**Уровни изоляции**

- READ UNCOMMITTED: в постгресе он работает так же как READ COMMITTED, поэтому грязных данных мы не увидели. Пока в 1й консоли нет коммита, 2я консоль видит старую цену и старую дату возврата.
- READ COMMITTED: пока нет коммита, 2я консоль видит старое значение, после коммита уже новое. Если во 2й консоли пытаться поменять строку, которую не закоммитила 1я, то запрос зависает и ждет. Еще на этом уровне есть неповторяющееся чтение: в 1й транзакции два одинаковых SELECT дали разные результаты (цена книги и количество невозвращенных книг), тк между ними 2я консоль сделала UPDATE и COMMIT.
- REPEATABLE READ: 1я транзакция видит данные такими, какими они были при первом запросе, и новые изменения из 2й консоли не видит, пока сама не завершится. Фантомного чтения тоже не получилось: после INSERT во 2й консоли количество книг и выдач в 1й не поменялось, новая строка появилась только после COMMIT.
- SERIALIZABLE: когда обе транзакции вставляли одинаковые данные (жанр и читателя), у первой все прошло, а у второй была ошибка сериализации. Так же и с одновременным изменением одной строки (остаток книг и телефон): вторая транзакция получила ошибку, ее пришлось откатить и выполнить заново, после этого все прошло.

Если коротко, чем выше уровень, тем меньше аномалий при параллельной работе, но тем больше ожиданий и ошибок, а при ошибках сериализации транзакцию надо запускать заново.

**SAVEPOINT**

С одной точкой сохранения: изменения до SAVEPOINT остались и сохранились после COMMIT, а то что было после точки (цена книги = 1) отменилось. 
С двумя точками: откат на sp2 отменяет только последнее изменение, откат на sp1 отменяет всё что было после нее, но вставка жанра до sp1 осталась. После отката на sp1 вторая точка sp2 пропала, к ней уже не вернуться.

SAVEPOINT удобно использовать в длинных транзакциях, чтобы при ошибке не отменять всё целиком, а только последнюю часть.