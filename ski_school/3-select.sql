USE ski_school;

-- выборка заявок с категорией, клиентом, временем занятий за определенный день
SELECT 
	o.id, o.status, r.name AS resort, concat(a.first_name, ' ', a.last_name) AS admin, c.name AS category,  
	concat(cl.first_name, ' ', cl.last_name) AS client_name, IF(cl.phone, cl.phone, cl.email) AS client_contact,
	time(l.start_time) AS lesson_start, time(l.end_time) AS lesson_end, l.equipment, 
	concat(i.first_name, ' ', i.last_name) AS instructor
FROM orders o
LEFT JOIN clients cl ON cl.id = o.client_id 
LEFT JOIN categories c ON c.id = o.category_id 
LEFT JOIN admins a ON a.id = o.admin_id 
LEFT JOIN resorts r ON r.id = o.resort_id 
JOIN lessons l ON l.order_id = o.id AND date(l.start_time) = '2021-05-04' 
LEFT JOIN instructors i ON i.id = l.instructor_id 
ORDER BY r.id, l.start_time;


-- расчет агентских для партнеров
SELECT 
	p.name, count(o.id) AS orders_count, sum(o.price) AS orders_price, sum(o.price*(p.percent/100)) AS agent_sum
FROM partners p 
LEFT JOIN orders o ON o.partner_id = p.id
WHERE EXISTS (SELECT 1 FROM lessons l WHERE l.order_id = o.id AND date(l.start_time) BETWEEN '2021-05-01' AND '2021-05-31')
GROUP BY p.id;


-- выборка клиентов с кол-вом заявок и суммой заказов
SELECT 
	concat(cl.first_name, ' ', cl.last_name) AS client_name, IF(cl.phone, cl.phone, cl.email) AS client_contact, 
	count(*) AS orders_count, sum(o.price) AS orders_sum
FROM clients cl
LEFT JOIN orders o ON o.client_id = cl.id
GROUP BY cl.id
ORDER BY orders_sum DESC;



