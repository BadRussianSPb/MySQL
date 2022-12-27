USE vk;

/* 1.Пусть задан некоторый пользователь. Из всех пользователей соц. сети найдите человека,
 * который больше всех общался с выбранным пользователем (написал ему сообщений).
 */

-- в задании буквально читаю "НАПИСАЛ", т.к. общался включает в себя и "получил", а это уже другое решение

-- вариант 1 с вложеными запросами. Далее только JOINы
SELECT 
	(SELECT u.firstname FROM users u WHERE u.id = m.from_user_id) AS 'Имя',
	(SELECT u.lastname  FROM users u WHERE u.id = m.from_user_id) AS 'Фамилия',
	count(m.to_user_id) AS 'Писем адресату'
FROM messages m
WHERE to_user_id = 1    -- id адресата
GROUP BY m.from_user_id  
ORDER BY count(m.to_user_id) DESC
LIMIT 1; 


-- вариант 2 INNER JOIN
SELECT
	u.firstname AS 'Имя',
	u.lastname 'Фамилия',
	count(m.from_user_id) AS sended, 
	m.to_user_id AS 'id получателя'
FROM users u 
JOIN messages m ON u.id = m.from_user_id
WHERE m.to_user_id = 1
GROUP  BY m.from_user_id 
ORDER BY sended DESC
LIMIT 1;

/* 2.Подсчитать количество групп, в которые вступил каждый пользователь.
 */
SELECT
	u.id AS 'id пользователя',
	u.firstname AS 'Имя',
	count(uc.community_id) AS 'Кол-во групп'
FROM
users u 
LEFT JOIN users_communities uc ON u.id = uc.user_id
GROUP BY u.id 
ORDER BY count(uc.community_id) DESC ;

/* 3.Подсчитать количество пользователей в каждом сообществе.
 */
SELECT 
	community_id AS 'id группы',
	c.name AS 'Имя группы',
	count(user_id) AS 'Всего подписок'
FROM users_communities uc
JOIN communities c ON uc.community_id = c.id 
GROUP BY community_id
ORDER BY community_id ;

/* 4.*Подсчитать общее количество лайков, которые суммарно получили пользователи младше 18 лет.
 */

-- RIGHT JOIN 
SELECT
	count(l.id) AS 'Всего лайков'
FROM 
likes l
RIGHT JOIN media m ON (l.media_id  = m.id)
RIGHT JOIN profiles p ON (m.user_id = p.user_id) 
WHERE TIMESTAMPDIFF(YEAR, birthday, now()) > 18;

-- LEFT JOIN
SELECT
	count(l.id) AS 'Всего лайков'	 
FROM profiles p 
LEFT JOIN media m ON (p.user_id = m.user_id)
LEFT JOIN likes l ON (m.id = l.media_id)
WHERE TIMESTAMPDIFF(YEAR, birthday, now()) > 18;

/* 5.*Определить кто больше поставил лайков (всего): мужчины или женщины.
 */
SELECT 
	CASE p.gender
		WHEN 'm' THEN 'Мужчины'
		WHEN 'f' THEN 'Женщины'
	ELSE 'Н/д'
	END AS 'Гендерная группа',
	count(*) AS 'Кол-во лайков'
FROM 
likes l 
JOIN users u ON (l.user_id = u.id)
JOIN profiles p ON (u.id = p.user_id)
GROUP BY p.gender
LIMIT 1;
