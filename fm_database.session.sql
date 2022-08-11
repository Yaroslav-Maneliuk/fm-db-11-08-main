--
SELECT sum("quantity")
FROM "phones_to_orders"

--
SELECT count("model")
FROM "phones";

--
SELECT AVG("price")
FROM "phones";

--
SELECT AVG("price"), "brand"
FROM "phones"
GROUP BY "brand";

--
SELECT AVG("price"), "brand"
FROM "phones"
WHERE "brand" = 'Honor'
GROUP BY "brand";

--количество моделей каждого бренда
SELECT count (*) AS "model's count", "brand"
FROM "phones"
GROUP BY "brand";

--количество заказов каждого пользователя
SELECT count ("userId") AS "user's orders", "userId"
FROM "orders"
GROUP BY "userId";


--стоимость всех телефонов, бренда Sony
SELECT sum ("quantity" * "price")
FROM "phones"
WHERE "brand" = 'Sony';


--стоимость всех телефонов, в диапазоне цен от 10000 до 20000
SELECT sum ("quantity" * "price") AS "cost"
FROM "phones"
WHERE "price" >= 10000 AND "price" <= 20000;

--сортировка ORDER BY (ASC/DESC)по возростанию/по убыванию
SELECT count (*) AS "model's count", "brand"
FROM "phones"
GROUP BY "brand"
ORDER BY "model's count" DESC
LIMIT 1;



--отсортировать по росту и вывести рост и имя
SELECT "height", "firstName"
FROM "users"
ORDER BY "height" DESC, "firstName" ASC;


-- SELECT max ("height"), "firstName"
-- FROM "users"
-- GROUP BY "firstName"
-- ORDER BY max ("height") DESC
-- LIMIT 1;


--вывести 10 позиций моделей телефонов, которых осталось меньше всего в магазине
SELECT *
FROM "phones"
ORDER BY "quantity" ASC
LIMIT 10;


--отсортируйте пользователей по возрасту, по фамилии, по имени
SELECT "firstName", "lastName", EXTRACT ("years" from age("birthday")) AS "age"
FROM "users"
ORDER BY "age" ASC, "lastName" ASC, "firstName" ASC;


--отсортируйте пользователей по возрасту (30-40), по фамилии, по имени
SELECT "firstName", "lastName", EXTRACT ("years" from age("birthday")) AS "age"
FROM "users"
WHERE EXTRACT ("years" from age("birthday")) BETWEEN 30 AND 40
ORDER BY "age" ASC, "lastName" ASC, "firstName" ASC;


--преобразовать код више(сделать таблицу в таблице)
SELECT *
    FROM  (SELECT "firstName", 
            "lastName", 
            EXTRACT ("years" from age("birthday")) AS "age"
          FROM "users") AS "sa"
WHERE "sa"."age" BETWEEN 30 AND 40
ORDER BY "sa"."age" ASC, "lastName" ASC, "firstName" ASC;



--посчитать количевство пользователей каждого возраста и отсортировать по возрасту (добавили фильтрацию HAVING)
SELECT count (*), 
  EXTRACT ("years" from age("birthday")) AS "age"
FROM "users"
GROUP BY "age"
HAVING count(*) < 5
ORDER BY "age" ASC;



--будут все на V
SELECT *
FROM "users"
WHERE "firstName" LIKE 'V%';

SELECT *
FROM "users"
WHERE "firstName" LIKE '_s%';

SELECT *
FROM "users"
WHERE "lastName" LIKE '%rr%';

SELECT *
FROM "users"
WHERE "lastName" SIMILAR TO '%r{2}%';

SELECT *
FROM "phones"
WHERE "brand" ILIKE 's%';


--найдите людей с инициалами 'EM'
SELECT *
FROM "users"
WHERE "firstName" ILIKE 'e%' AND "lastName" ILIKE 'm%';


--найдите все бренды, у которых кол-во штук телефонов на складе > 8000
SELECT sum ("quantity"), "brand"
FROM "phones"
GROUP BY "brand"
HAVING sum ("quantity") > 8000;