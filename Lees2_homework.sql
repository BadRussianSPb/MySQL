/* 1.
Написать крипт, добавляющий в БД vk, которую создали на занятии, 2-3 новые таблицы
(с перечнем полей, указанием индексов и внешних ключей) (CREATE TABLE)
*/

USE vk;
/*
сначала делаем ключи чтобы сохранить целостность базы, а потом героически их изничтожаем.
ALTER TABLE videos 
DROP FOREIGN KEY videos_ibfk_1;

ALTER TABLE profiles
DROP FOREIGN KEY fk_video_id;

... не до конца :)
*/

-- тип связи 1-М
DROP TABLE IF EXISTS video_albums;
CREATE TABLE video_albums (
	id SERIAL PRIMARY KEY,
	name varchar(255) DEFAULT 'ИМЯ НЕ ЗАДАНО',
    user_id BIGINT UNSIGNED DEFAULT NULL,

    FOREIGN KEY (user_id) REFERENCES users(id) ON UPDATE CASCADE ON DELETE SET NULL
);

DROP TABLE IF EXISTS videos;
CREATE TABLE videos (
	id SERIAL PRIMARY KEY,
	album_id BIGINT UNSIGNED NOT NULL,
	media_id BIGINT UNSIGNED NOT NULL,
	FOREIGN KEY (album_id) REFERENCES video_albums(id) ON UPDATE CASCADE ON DELETE CASCADE,
	FOREIGN KEY (media_id) REFERENCES media(id) ON UPDATE CASCADE ON DELETE CASCADE
);	
	
-- пришлось добавить в профиль колонку с айди видео

ALTER TABLE profiles ADD video_id BIGINT UNSIGNED;

ALTER TABLE profiles ADD CONSTRAINT fk_video_id 
    FOREIGN KEY (video_id) REFERENCES videos(id)
    ON UPDATE CASCADE ON DELETE set NULL;

-- есть еще такая идея с предопределенным набором статусов. можно конечно и в профиль добавить. тип связи 1-1

DROP TABLE IF EXISTS status;
CREATE TABLE status (
	user_id BIGINT UNSIGNED NOT NULL,
	status ENUM('offline', 'online', 'do not disturb'),
	PRIMARY KEY (user_id, status),
	FOREIGN KEY (user_id) REFERENCES users(id) ON UPDATE CASCADE ON DELETE CASCADE
);	
   

/* 2.
Заполнить 2 таблицы БД vk данными (по 10 записей в каждой таблице) (INSERT)
*/

DELETE FROM users; 
   INSERT INTO users
(firstname, lastname, email, password_hash, phone)
VALUES
('Вася', 'Иванов', 'v.ivanov@mail.com', '2fe3cb9e21922819e79a2781af74e36d', 79119115555),
('Петя', 'Иванов', 'pet.ivanov@gmail.ru', 'fe3e7168027d39ce098172e1708ccb79', 78119116644),
('Коля', 'Петров', 'koleso@inbox.com', 'c8d88434c8e4a864f000aadf11516890', 68458746633),
('Женя', 'Петров', 'evangelion@yandex.su', '8cb40215822c7a5e1ac9e3c4098173d3', 56224132277),
('Вася', 'Васичкин', 'vasek@drop.ru', 'c92c0babdc764d8674bcea14a55d867d', 88128121111);

DELETE FROM profiles;
INSERT INTO profiles 
(user_id, birthday)
VALUES
(1,'1976-11-08'),
(2, '1983-01-27'),
(3, '2011-01-09'),
(4, '2014-12-02'),
(5, '2000-05-07');


DELETE FROM video_albums; 
INSERT INTO video_albums 
(name, user_id)
VALUES
('Лето 2020', 1),
('Лето 2021', 1),
('Лето 2022', 1),
('', 2),
('', 2),
('Избранное', 2),
('Все сразу', 3),
('Тест', 4),
('Избранное', 5);


DELETE FROM videos; 
INSERT INTO videos 
(album_id, media_id)
VALUES
(1, 1),
(1, 2),
(1, 3),
(2, 2),
(2, 1),
(2, 2),
(3, 4),
(3, 5),
(4, 6),
(4, 7); -- сделаем вид, что медиа и их id уже есть...

INSERT INTO messages 
(from_user_id, to_user_id, body, created_at)
VALUES
(1, 2, 'Тест1', '1976-11-08'),
(1, 3, 'Тест2', '1976-11-08'),
(2, 3, 'Тест3', '2022-12-27'),
(2, 4, 'Тест4', '2022-12-25'),
(5, 1, 'Тест5', '1976-11-08'),
(3, 5, 'Тест6', '2976-11-08');

/*
3.* Написать скрипт, возвращающий список имен (только firstname) пользователей без повторений в алфавитном порядке (SELECT)
*/

SELECT DISTINCT 
firstname 
FROM 
users u 
ORDER BY firstname; 

/*
4.* Написать скрипт, отмечающий несовершеннолетних пользователей как неактивных (поле is_active = true). При необходимости предварительно добавить такое поле в таблицу profiles со значением по умолчанию = false (или 0) (ALTER TABLE + UPDATE)
*/

ALTER TABLE profiles ADD COLUMN is_active BOOL DEFAULT 0;
UPDATE profiles 
SET is_active = 1
WHERE (16 < YEAR(now()) - YEAR(birthday));  -- Грубо сделал по годам. Можно дальше развить месяц и день. 

/*
5.* Написать скрипт, удаляющий сообщения «из будущего» (дата позже сегодняшней) (DELETE)
*/

DELETE FROM messages 
WHERE created_at > UTC_DATE();



