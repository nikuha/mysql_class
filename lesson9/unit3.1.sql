/*
 * Создайте хранимую функцию hello(), которая будет возвращать приветствие, в зависимости от текущего времени суток. 
 * С 6:00 до 12:00 функция должна возвращать фразу "Доброе утро", 
 * с 12:00 до 18:00 функция должна возвращать фразу "Добрый день", 
 * с 18:00 до 00:00 — "Добрый вечер", с 00:00 до 6:00 — "Доброй ночи".
 */
DELIMITER //
USE shop//
DROP FUNCTION IF EXISTS hello//
CREATE FUNCTION hello()
RETURNS TINYTEXT
BEGIN 
	DECLARE cur_hour INT DEFAULT HOUR(NOW());
	IF cur_hour < 6 THEN 
		RETURN 'Доброй ночи!';
	ELSEIF cur_hour BETWEEN 6 AND 11 THEN
		RETURN 'Доброе утро!';
	ELSEIF cur_hour BETWEEN 12 AND 17 THEN
		RETURN 'Добрый день!';
	ELSE 
		RETURN 'Добрый вечер!!';
	END IF;
END//
SELECT hello()//