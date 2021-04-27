USE shop;

DROP TABLE IF EXISTS logs;
CREATE TABLE logs(
	id INT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
	table_name ENUM('users', 'products', 'catalogs') NOT NULL,
	item_id BIGINT UNSIGNED NOT NULL,
	name VARCHAR(100),
	created_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP
) ENGINE=Archive;


DELIMITER //
DROP TRIGGER IF EXISTS users_logs_insert//
CREATE TRIGGER users_logs_insert AFTER INSERT ON users
FOR EACH ROW 
BEGIN 
	INSERT INTO logs values(DEFAULT, 'users', NEW.id, NEW.name, DEFAULT);
END//

DROP TRIGGER IF EXISTS products_logs_insert//
CREATE TRIGGER products_logs_insert AFTER INSERT ON products
FOR EACH ROW 
BEGIN 
	INSERT INTO logs values(DEFAULT, 'products', NEW.id, NEW.name, NEW.created_at);
END//

DROP TRIGGER IF EXISTS catalogs_logs_insert//
CREATE TRIGGER catalogs_logs_insert AFTER INSERT ON catalogs
FOR EACH ROW 
BEGIN 
	INSERT INTO logs values(DEFAULT, 'catalogs', NEW.id, NEW.name, DEFAULT);
END//

INSERT INTO users (name, birthday_at) values('Миша', '1999-04-15')//
INSERT INTO catalogs (name) values('Клавиатуры')//
INSERT INTO products (name) values('Logitech')//