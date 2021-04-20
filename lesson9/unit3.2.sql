/*
 *В таблице products есть два текстовых поля: name с названием товара и description с его описанием. 
 * Допустимо присутствие обоих полей или одно из них. Ситуация, когда оба поля принимают неопределенное значение NULL неприемлема. 
 * Используя триггеры, добейтесь того, чтобы одно из этих полей или оба поля были заполнены. При попытке присвоить полям NULL-значение необходимо отменить операцию.
*/
DELIMITER //
USE shop//
DROP TRIGGER IF EXISTS not_null_name_insert//
CREATE TRIGGER not_null_name_insert BEFORE INSERT ON products
FOR EACH ROW 
BEGIN 
	IF NEW.name IS NULL AND NEW.description IS NULL THEN 
		SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'null inserting is not allowed';
	END IF;
END//
DROP TRIGGER IF EXISTS not_null_name_update//
CREATE TRIGGER not_null_name_update BEFORE UPDATE ON products
FOR EACH ROW 
BEGIN 
	IF NEW.name IS NULL AND NEW.description IS NULL THEN 
		SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'null updating is not allowed';
	END IF;
END//
