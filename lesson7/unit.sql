USE lesson7;

/*
 * 1 Составьте список пользователей users, которые осуществили хотя бы один заказ orders в интернет магазине.
 */
SELECT * FROM users WHERE EXISTS (SELECT 1 FROM orders WHERE user_id=users.id);


/*
 * 2 Выведите список товаров products и разделов catalogs, который соответствует товару.
 */
SELECT 
	p.name, c.name AS catalogue
FROM 
	products p
LEFT JOIN 
	catalogs c ON (p.catalog_id=c.id); 


/*
 * (по желанию) Пусть имеется таблица рейсов flights (id, from, to) и таблица городов cities (label, name). 
 * Поля from, to и label содержат английские названия городов, поле name — русское. 
 * Выведите список рейсов flights с русскими названиями городов.
 */
SELECT 
	f.id, c_from.name AS from_ru, c_to.name AS to_ru
FROM 
	flights f
LEFT JOIN 
	cities c_from ON (c_from.label = f.from)
LEFT JOIN 
	cities c_to ON (c_to.label = f.to)
	


