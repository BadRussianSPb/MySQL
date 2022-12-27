USE vk;
/* 1.
 * Написать скрипт, возвращающий список имен (только firstname) пользователей без повторений в алфавитном порядке. [ORDER BY]
 */

-- было в прошлом ДЗ со звездочкой...

SELECT DISTINCT 
	firstname 
FROM users u 
ORDER BY firstname;

/* 2.
 * Выведите количество мужчин старше 35 лет [COUNT].
 */

SELECT
	count(user_id) AS 'Кол-во старше 35'
FROM profiles p
WHERE TIMESTAMPDIFF(YEAR, birthday, now()) > 35; 

/* 3.
 *  Сколько заявок в друзья в каждом статусе? (таблица friend_requests) [GROUP BY]
 */

SELECT
	status AS 'Статус заявки',
	count(*) AS 'Кол-во заявок'
FROM friend_requests fr 
GROUP BY status
ORDER BY count(*) DESC;

/* 4.
 *   Выведите номер пользователя, который отправил больше всех заявок в друзья (таблица friend_requests) [LIMIT].
 */

SELECT 
	initiator_user_id AS '"Номер" пользователя',
	count(*) AS 'Кол-во запросов' 
FROM friend_requests fr 
GROUP BY initiator_user_id 
ORDER BY count(*) DESC
LIMIT 1;


/* 5.
 * Выведите названия и номера групп, имена которых состоят из 5 символов [LIKE].
 */

SELECT 
	id AS 'id группы',
	name AS 'Имя группы'
FROM communities c 
WHERE name LIKE '_____';