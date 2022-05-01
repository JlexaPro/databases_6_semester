-- 1. Используя запросы CREATE TABLE создать таблицы «Магазины», «Товары», 
-- «Цены» и связи между ними в соответствии с приведенной схемой
-- данных (жирным шрифтом выделены первичные ключи).

---
--- drop tables
---

DROP TABLE IF EXISTS price CASCADE;
DROP TABLE IF EXISTS shop CASCADE;
DROP TABLE IF EXISTS product CASCADE;

---
--- create tables
---

CREATE TABLE shop (
	shop_id INT PRIMARY KEY,
	address VARCHAR(100) NOT NULL,
	telephone VARCHAR(30) NOT NULL
	);

CREATE TABLE product (
	product_id INT PRIMARY KEY,
	title VARCHAR(50) NOT NULL,
	supplier VARCHAR(50) NOT NULL
	);

CREATE TABLE price (
	shop_id INT REFERENCES shop(shop_id),
	product_id INT REFERENCES product(product_id),
	price DECIMAL NOT NULL
	--- CONSTRAINT shop_id REFERENCES shop(shop_id) -- fk_shop_id FOREIGN KEY 
	--- CONSTRAINT product_id REFERENCES product(product_id) -- fk_product_id FOREIGN KEY
	CONSTRAINT ABS_price CHECK (price > 0)
	);
    

-- 2. Используя запрос ALTER TABLE добавить в таблицу «Цены» числовое поле «Количество»    
ALTER TABLE price 
	ADD amount INT NOT NULL;    
    

-- 3. Используя запросы INSERT INTO добавить в созданную базу данных следующую информацию:    
INSERT INTO shop VALUES
(213, 'пр. Ленина, 12', 'тел. 224-42-48'),
(116, 'ул. Ново-Садовая, 10', 'тел. 242-13-04'),
(12, 'пр. Металлургов, 27', 'тел. 971-59-42'),
(65, 'ул. Фрунзе, 133', 'тел. 337-82-19');

INSERT INTO product VALUES
(1, 'молоко, 1 л.', '«Простоквашино»'),
(2, 'молоко, 1 л.', '«Юнимилк»'),
(3, 'батон «Весенний», 400 гр.', '«БКК»'),
(4, 'зефир «Шармель», 300 гр.', '«БКК»'),
(5, 'зефир «Шармель», 300 гр.', '«Сладко»');


-- 4. Создайте форму для заполнения таблицы Цены. Для выбора магазина и
-- товара используйте поля со списком. Данные для заполнения приведены
-- в таблице ниже
INSERT INTO price (product_id, shop_id, price, amount) VALUES
(1, 12, 26, 129),
(1, 65, 32, 34),
(1, 116, 28, 47),
(1, 213, 30, 15),
(2, 12, 27, 220),
(2, 116, 29, 130),
(2, 213, 30, 37),
(3, 12, 14, 55),
(3, 65, 16, 120),
(3, 116, 15, 25),
(3, 213, 15, 40),
(4, 12, 56, 12),
(4, 116, 64, 52),
(5, 12, 60, 34),
(5, 65, 62, 30),
(5, 213, 59, 50);


-- 5. Используя запрос UPDATE повысить цены во всех магазинах на все товары на 10
UPDATE price
SET price = price * 1.1;


-- 6. Используя запрос UPDATE понизить цены на товар «молоко» поставщика
-- «Простоквашино» во всех магазинах на 7
UPDATE price
SET price = price * 0.93
FROM product
WHERE product.title = 'молоко, 1 л.' AND product.supplier = '«Простоквашино»' AND price.product_id = product.product_id;


-- 7. Используя запрос UPDATE понизить цены на все товары в заданном магазине на 5
UPDATE price
SET price = price * 0.95
FROM shop
WHERE shop.shop_id = 12 AND shop.shop_id = price.shop_id;


-- 8. Для каждого кода товара получить магазин, в котором этот товар продаётся 
-- по минимальной цене и саму эту цену.
SELECT shop_id, min_product.product_id, min_product.min_price
FROM price
INNER join
	(
    SELECT product_id, MIN(price) min_price
    FROM price
    GROUP by product_id
	ORDER by product_id
	) AS min_product
ON price.product_id = min_product.product_id AND price.price = min_product.min_price
ORDER BY product_id;


-- 9. Определить номер и адрес магазина(ов) с максимальным ассортиментом
-- (количеством кодов товаров).
SELECT total_amount.shop_id, address, total
FROM 
	(
	SELECT shop.shop_id, address, SUM(amount) total
	FROM price
	JOIN shop ON price.shop_id = shop.shop_id
	GROUP BY shop.shop_id, address
	) total_amount
ORDER BY total DESC
LIMIT 1;


-- 10. Для каждого магазина определить общую стоимость имеющихся в нём
-- товаров.
SELECT total_amount.shop_id, address, total_price
FROM 
	(
	SELECT shop.shop_id, address, SUM(price*amount) total_price
	FROM price
	JOIN shop ON price.shop_id = shop.shop_id
	GROUP BY shop.shop_id, address
	) total_amount;


-- 11. Для каждого поставщика определить общую стоимость его товаров во
-- всех магазинах.
SELECT total_price_supplier.supplier, total_price
FROM 
	(
	SELECT product.supplier, SUM(price*amount) total_price
	FROM price
	JOIN product ON price.product_id = product.product_id
	GROUP BY product.product_id
	) total_price_supplier;
