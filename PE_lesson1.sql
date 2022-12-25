/* 1.
 * Создайте таблицу с мобильными телефонами, используя графический интерфейс.
 *Необходимые поля таблицы: product_name (название товара), manufacturer (производитель),
 * product_count (количество), price (цена). Заполните БД произвольными данными.
 */

DROP DATABASE IF EXISTS less1;
CREATE DATABASE less1;
USE less1;

DROP TABLE IF EXISTS phones;
CREATE TABLE phones (
	id SERIAL PRIMARY KEY, -- SERIAL = BIGINT UNSIGNED NOT NULL AUTO_INCREMENT UNIQUE
	product_name VARCHAR(100) COMMENT 'Название телефона',
	manufacturer VARCHAR(100) COMMENT 'Производитель',
	product_count INT COMMENT 'Количество',
	price FLOAT COMMENT 'Цена'
);

INSERT INTO phones 
(product_name, manufacturer, product_count, price)
VALUES
('iPhone 12','Apple',0,56490),
('iPhone 8','Apple',1,98990),
('Galaxy S22 Ultra','Samsung',10,99990),
('Galaxy Z Flip4','Samsung',1,59990),
('Galaxy A52','Samsung',20,22990),
('Redmi 9C','Xiaomi',1,7990),
('12 Pro','Xiaomi',2,69990),
('11T','Xiaomi',3,25990);

/* 2.
 * Напишите SELECT-запрос, который выводит название товара, производителя и цену для товаров,
 * количество которых превышает 2.
 */

SELECT
product_name AS Модель,
manufacturer AS Бренд,
price AS Цена  
FROM
phones
WHERE
product_count > 2;

/* 3.
 * Выведите SELECT-запросом весь ассортимент товаров марки “Samsung”
 * */

SELECT
product_name AS Модели_Samsung
FROM
phones
WHERE
manufacturer = 'Samsung';

/* 4. С помощью SELECT-запроса с оператором LIKE найти:
 */
 -- 4.1.* Товары, в которых есть упоминание "Iphone"

SELECT
product_name  AS Айфонцы
FROM
phones
WHERE
product_name LIKE '%iPhone%';

-- 4.2.* Товары, в которых есть упоминание "Samsung"

SELECT
product_name AS Самсунги
FROM
phones
WHERE
manufacturer LIKE '%Samsung%';  -- у меня в названиях нету производителя. Поменял на производителя.

-- 4.3.* Товары, в названии которых есть ЦИФРЫ

SELECT
product_name AS С_цифрами
FROM
phones
WHERE
CONVERT (product_name, CHAR(128)) LIKE '[0-9]';  -- LIKE '%[0-9]%' тоже не работает... 

-- 4.4.* Товары, в названии которых есть ЦИФРА "8"

SELECT
product_name AS С_восьмерками
FROM
phones
WHERE
product_name LIKE '%8%';
