USE lesson5;

-- 1. указываем текущее время для полей
UPDATE users SET created_at = NOW(), updated_at = NOW();

SELECT * FROM users;

-- преобразование таблицы к заданию 2
-- ALTER TABLE users MODIFY created_at VARCHAR(20);
-- ALTER TABLE users MODIFY updated_at VARCHAR(20);
-- UPDATE users SET created_at = '20.10.2017 8:10', updated_at = '03.05.2018 16:03';

-- 2 замена формата 20.10.2017 8:10 на 2017-10-20 8:10
UPDATE users SET created_at = concat(
substring(created_at, 7, 4), '-', 
substring(created_at, 4, 2), '-', 
substring(created_at, 1, 2), ' ', 
substring(created_at, 12, 5)
), updated_at = concat(
substring(updated_at, 7, 4), '-', 
substring(updated_at, 4, 2), '-', 
substring(updated_at, 1, 2), ' ', 
substring(updated_at, 12, 5)
);

-- преобразуем поля в datetime
ALTER TABLE users MODIFY created_at DATETIME DEFAULT CURRENT_TIMESTAMP;
ALTER TABLE users MODIFY updated_at DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP;


-- 3. сортировка по кол-ву, нули в конце
SELECT * FROM storehouses_products ORDER BY value = 0, value;


-- 4 выводим пользователей, родившихся в мае и августе
SELECT id, name, birthday_at, DATE_FORMAT(birthday_at, '%M') AS `month` FROM users WHERE MONTH(birthday_at) IN (5, 8);


-- 5 отсортировать вывод 
SELECT * FROM catalogs WHERE id IN (5, 1, 2) ORDER BY id = 5 DESC, id = 1 DESC, id = 2 DESC;


