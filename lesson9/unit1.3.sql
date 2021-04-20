/*
 * 3.	(по желанию) Пусть имеется таблица с календарным полем created_at. В ней размещены разряженые календарные записи за август 
 * 2018 года '2018-08-01', '2016-08-04', '2018-08-16' и 2018-08-17. 
 * Составьте запрос, который выводит полный список дат за август, выставляя в соседнем поле значение 1, 
 * если дата присутствует в исходном таблице и 0, если она отсутствует.
 */
DELIMITER //
USE shop//
DROP TABLE IF EXISTS dates//
CREATE TEMPORARY TABLE  dates(
cur_date DATE
)//
DROP PROCEDURE IF EXISTS date_iteration//
CREATE PROCEDURE date_iteration(my_date DATE)
BEGIN
	DECLARE i INT DEFAULT 0;
	CYCLE: WHILE (i <= 30) DO
		INSERT INTO dates VALUES(my_date + INTERVAL i DAY);
		SET i = i + 1;
	END WHILE CYCLE;
END//
CALL date_iteration('2020-08-01')//
SELECT cur_date, products.id IS NOT NULL FROM dates 
	LEFT JOIN products  ON DATE(products.created_at) = dates.cur_date
ORDER BY cur_date//