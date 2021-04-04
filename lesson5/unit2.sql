USE lesson5;


-- 1 средний возраст пользователей
SELECT AVG(TIMESTAMPDIFF(YEAR, birthday_at, CURDATE())) FROM users;


-- 2 кол-во ДР по дням недели
-- создаем дату рождения в этом году, извлекаем день недели из этой даты, выводим название даты недели
SELECT 
DATE_FORMAT( CONCAT(YEAR(NOW()), '-', DATE_FORMAT(birthday_at, '%m-%d')),  '%w') AS day_of_week,
MAX(DATE_FORMAT( CONCAT(YEAR(NOW()), '-', DATE_FORMAT(birthday_at, '%m-%d')),  '%W')) AS en_day_of_week,
COUNT(*)  
FROM users 
GROUP BY day_of_week
ORDER BY day_of_week;


-- 3 произведение чисел в таблице
SELECT EXP(SUM(log(id))) FROM x;
