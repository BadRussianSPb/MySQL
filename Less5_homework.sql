USE VK;

/* 1.
 * Создайте представление с произвольным SELECT-запросом из прошлых уроков [CREATE VIEW]
 */

CREATE OR REPLACE VIEW likes_gender_sort AS
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
GROUP BY p.gender;


/* 2.
 * Выведите данные, используя написанное представление [SELECT]
 */

SELECT *
FROM likes_gender_sort
LIMIT 1;

/* 3.
 * Удалите представление [DROP VIEW]
 */

DROP VIEW likes_on_gender;


/* 4*.
 * Сколько новостей (записей в таблице media) у каждого пользователя? Вывести поля:
 * news_count (количество новостей), user_id (номер пользователя), user_email (email пользователя).
 * Попробовать решить с помощью CTE или с помощью обычного JOIN.
 */

-- Вариант с JOIN

SELECT
	ROW_NUMBER() OVER() AS '№ п.п.',
	count(m.id) AS news_count,
	m.user_id,
	u.email
FROM media m
JOIN users u ON (m.user_id = u.id)
GROUP BY m.user_id
ORDER BY news_count DESC;


-- Вариант с CTE

WITH media_count AS (
	SELECT 
		count(m.id) AS news_count,
		m.user_id 
		FROM media m 
	GROUP BY m.user_id)

SELECT
	ROW_NUMBER() OVER() AS '№ п.п.',
	news_count,
	user_id,
	email 
FROM media_count
JOIN users u ON u.id = media_count.user_id;
