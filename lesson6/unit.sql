USE vk;


/* 1. Пусть задан некоторый пользователь.
Найдите человека, который больше всех общался с нашим пользователем, иначе, кто написал пользователю наибольшее число сообщений. (можете взять пользователя с любым id).
*/
SET @user_id = 9;

SELECT id, concat(first_name, ' ', last_name) FROM users WHERE id = (
	SELECT from_user_id FROM messages WHERE to_user_id = @user_id GROUP BY from_user_id ORDER BY count(*) DESC LIMIT 1
);
/*
 * (по желанию: можете найти друга, с которым пользователь больше всего общался)
 */
SELECT id, concat(first_name, ' ', last_name) FROM users WHERE id IN (
	SELECT from_user_id FROM messages WHERE to_user_id = @user_id GROUP BY from_user_id ORDER BY count(*) DESC
) ORDER BY id IN (
	SELECT DISTINCT IF(to_user_id = @user_id, from_user_id, to_user_id) AS friend
	FROM friend_requests 
	WHERE request_type = 1 AND (to_user_id = @user_id OR from_user_id = @user_id)
) DESC 
LIMIT 1;


/*
 * 2. Подсчитать общее количество лайков на посты, которые получили пользователи младше 18 лет.
 */
SELECT count(*) FROM posts_likes WHERE like_type = 1 AND post_id IN (
	SELECT id FROM posts WHERE user_id IN (
		SELECT user_id FROM profiles WHERE TIMESTAMPDIFF(YEAR, birthday, NOW()) < 18
	)
);


/*
 * 3. Определить, кто больше поставил лайков (всего) - мужчины или женщины?
 */   
SELECT count(*), (
	SELECT 
       CASE (gender) 
	   WHEN 'f' THEN 'female'
	   WHEN 'm' THEN 'man'
	   WHEN 'x' THEN NULL
	   END
	FROM profiles WHERE user_id=posts_likes.user_id) AS gender  
FROM posts_likes WHERE like_type = 1
GROUP BY gender
HAVING gender IS NOT NULL
ORDER BY count(*) DESC
LIMIT 1;


/*
 * 4. (по желанию) Найти пользователя, который проявляет наименьшую активность в использовании социальной сети 
 * (тот, кто написал меньше всего сообщений, отправил меньше всего заявок в друзья, ...).
 */
SELECT 
	concat(first_name, ' ', last_name),  
	(SELECT count(*) FROM messages WHERE from_user_id = users.id) AS messages_count
FROM 
	users
ORDER BY
	messages_count
LIMIT 1;

