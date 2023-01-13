USE VK;

/* 1.
 * Используя транзакцию, написать функцию, которая удаляет всю информацию об указанном пользователе из БД.
 * Пользователь задается по id. Удалить нужно все сообщения, лайки, медиа записи, профиль и запись из таблицы users.
 * Функция должна возвращать номер пользователя.
 */

DROP FUNCTION IF EXISTS vk.del_user_data;

DELIMITER //
//

CREATE DEFINER=`root`@`localhost` FUNCTION `vk`.`del_user_data`(idu BIGINT) RETURNS char(20) CHARSET utf8mb4
    READS SQL DATA
BEGIN
	DECLARE spam INT;
	SET spam = (
		SELECT
		count(id)
		FROM
		users u 
		WHERE u.id = idu  -- 
	);
	IF (spam = 1) THEN
		-- удаляем сообщения
		DELETE FROM messages m WHERE m.from_user_id = idu OR m.to_user_id = idu; 
		-- удаляем лайки
		DELETE FROM likes l WHERE l.user_id = idu;
		-- удаляем медиа
		DELETE FROM media m	WHERE m.user_id = idu;
		-- удаляем профиль
		DELETE FROM profiles p WHERE p.user_id = idu;
		-- удаляем аккаунт
		DELETE FROM users u WHERE u.id = idu;
		RETURN concat('Данные id ', idu, ' удалены.');
	ELSE
		RETURN concat('ID ', idu, ' не найден.');
	END IF;	
END//
DELIMITER ;


-- пришлось повозиться со связанными таблицами. ключевое здесь CASCADE 
ALTER TABLE likes DROP FOREIGN KEY `likes_ibfk_2`;
ALTER TABLE likes ADD CONSTRAINT `likes_ibfk_2` FOREIGN KEY (media_id) REFERENCES media(id) ON UPDATE CASCADE ON DELETE CASCADE;
ALTER TABLE profiles DROP FOREIGN KEY `profiles_ibfk_2`;
ALTER TABLE profiles ADD CONSTRAINT `profiles_ibfk_2` FOREIGN KEY (photo_id) REFERENCES media(id) ON UPDATE CASCADE ON DELETE CASCADE;
ALTER TABLE friend_requests DROP FOREIGN KEY `friend_requests_ibfk_1`;
ALTER TABLE friend_requests ADD CONSTRAINT `friend_requests_ibfk_1` FOREIGN KEY (initiator_user_id) REFERENCES users(id) ON UPDATE CASCADE ON DELETE CASCADE;
ALTER TABLE friend_requests DROP FOREIGN KEY `friend_requests_ibfk_2`;
ALTER TABLE friend_requests ADD CONSTRAINT `friend_requests_ibfk_2` FOREIGN KEY (target_user_id) REFERENCES users(id) ON UPDATE CASCADE ON DELETE CASCADE;
ALTER TABLE users_communities DROP FOREIGN KEY `users_communities_ibfk_1`;
ALTER TABLE users_communities ADD CONSTRAINT `users_communities_ibfk_1` FOREIGN KEY (user_id) REFERENCES users(id) ON UPDATE CASCADE ON DELETE CASCADE;

-- сама транзакция. Как сдесь ролбэк организовать я так и не понял.
SET @id_to_del = 2;
START TRANSACTION;
SELECT
	del_user_data(@id_to_del) AS 'Сообщение';
COMMIT;

/* 2.
 * Предыдущую задачу решить с помощью процедуры.
 */

DROP PROCEDURE IF EXISTS vk.user_del;

DELIMITER $$
$$
CREATE PROCEDURE vk.user_del(idu BIGINT)
BEGIN
	-- сделал без внутренней переменной
	IF ((
		SELECT
		count(id)
		FROM
		users u 
		WHERE u.id = idu  -- 
	) = 1) THEN
		-- удаляем сообщения
		DELETE FROM messages m WHERE m.from_user_id = idu OR m.to_user_id = idu; 
		-- удаляем лайки
		DELETE FROM likes l WHERE l.user_id = idu;
		-- удаляем медиа
		DELETE FROM media m	WHERE m.user_id = idu;
		-- удаляем профиль
		DELETE FROM profiles p WHERE p.user_id = idu;
		-- удаляем аккаунт
		DELETE FROM users u WHERE u.id = idu;
		SELECT concat('Данные id ', idu, ' удалены.');
	ELSE
		SELECT concat('ID ', idu, ' не найден.');
	END IF;	

END$$
DELIMITER ;

CALL user_del(11);
	
/* 3*.
 * Написать триггер, который проверяет новое появляющееся сообщество.
 * Длина названия сообщества (поле name) должна быть не менее 5 символов.
 * Если требование не выполнено, то выбрасывать исключение с пояснением. 
 */

DELIMITER $$
$$
CREATE TRIGGER name_check
BEFORE INSERT  
ON communities FOR EACH ROW
BEGIN 
	IF LENGTH(NEW.name) < 5 THEN 
		SIGNAL SQLSTATE '12345'
		SET MESSAGE_TEXT = 'Имя группы короче 5 символов';
	END IF;
END
$$
DELIMITER ;

INSERT INTO communities
(name)
VALUES('123');
