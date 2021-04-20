/* 
 * 4.	(по желанию) Пусть имеется любая таблица с календарным полем created_at. 
 * Создайте запрос, который удаляет устаревшие записи из таблицы, оставляя только 5 самых свежих записей.
 */
USE shop;
CREATE VIEW last_products AS SELECT id FROM products ORDER BY created_at DESC LIMIT 5;
DELETE FROM products WHERE id NOT IN (SELECT id FROM last_products);
SELECT * FROM products;