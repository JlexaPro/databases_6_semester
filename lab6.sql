-- USE labwork.sql;

--Лабораторная работа 6
--Запросы на операции реляционной алгебры
-- 1. Модифицируйте запросы, приведённые в примерах 1-3 так, чтобы выводилась вся информация из таблицы Клиенты, 
-- а не только Код клиента.

--UNION
SELECT *
FROM contract
WHERE fk_tour_id = 1

UNION

SELECT *
FROM contract
WHERE fk_tour_id = 2

ORDER BY fk_client_id;


-- INTERSECT
SELECT *
FROM contract
WHERE fk_tour_id = 1

INTERSECT

SELECT *
FROM contract
WHERE fk_tour_id = 2

ORDER BY fk_client_id;


--EXCEPT
SELECT *
FROM contract
WHERE fk_tour_id = 1

EXCEPT

SELECT *
FROM contract
WHERE fk_tour_id = 2

ORDER BY fk_client_id;


-- Выведите список клиентов, которые ездили только в один из туров 1 или 2
(SELECT *
FROM contract
WHERE fk_tour_id = 1

EXCEPT

SELECT *
FROM contract
WHERE fk_tour_id = 2)

UNION

(SELECT *
FROM contract
WHERE fk_tour_id = 2
 
EXCEPT
 
SELECT *
FROM contract
WHERE fk_tour_id = 1)

ORDER BY fk_client_id;


-- Разбейте все туры на три ценовые категории: Люкс, Стандарт и Бюджет.
-- Границы категорий определите самостоятельно.
SELECT 'budget' AS category_tour, COUNT(*) AS amount
FROM tour
WHERE tour_price <= 50000

UNION

SELECT 'standart', COUNT(*)
FROM tour
WHERE tour_price > 50000 AND tour_price < 120000

UNION

SELECT 'luxury', COUNT(*)
FROM tour
WHERE tour_price >= 120000;


-- Для каждого клиента выведите список стран, в которых он ещё не был.
SELECT client.full_name, tour.country 
FROM contract
		INNER JOIN tour ON contract.fk_tour_id != tour.tour_id
	INNER JOIN client ON contract.fk_client_id = client.client_id
GROUP BY client.full_name, tour.country 

EXCEPT

SELECT client.full_name, tour.country 
FROM contract
		INNER JOIN tour ON contract.fk_tour_id = tour.tour_id
	INNER JOIN client ON contract.fk_client_id = client.client_id
GROUP BY client.full_name, tour.country 	

ORDER BY full_name
