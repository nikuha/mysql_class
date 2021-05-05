USE ski_school;

-- представление для подсчета зарплат инструкторов
DROP VIEW IF EXISTS instructors_salary;
CREATE VIEW instructors_salary AS 
SELECT 
	i.id AS instructor_id, concat(i.first_name, ' ', i.last_name) AS instructor, l.start_time, l.price*(i.percent/100) AS salary
FROM lessons l
LEFT JOIN instructors i ON l.instructor_id = i.id;

-- расчет зарплаты за месяц
-- SELECT instructor, sum(salary) FROM instructors_salary WHERE date(start_time) BETWEEN '2021-05-01' AND '2021-05-31' GROUP BY instructor_id;





-- расчет количества часов по категориям 
DROP VIEW IF EXISTS category_orders;
CREATE VIEW category_orders AS 
SELECT 
	c.id AS category_id, c.name AS category, l.start_time, TIMESTAMPDIFF(HOUR, l.start_time , l.end_time) AS duration
FROM categories c
LEFT JOIN orders o  ON o.category_id = c.id
LEFT JOIN lessons l ON l.order_id = o.id;


-- расчет часов разных категорий занятий за месяц
-- SELECT category, sum(duration) FROM category_orders WHERE date(start_time) BETWEEN '2021-05-01' AND '2021-05-31' GROUP BY category_id;


