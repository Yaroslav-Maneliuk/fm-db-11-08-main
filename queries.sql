INSERT INTO "users" (
    "firstName",
    "lastName",
    "email",
    "isMale",
    "birthday",
    "height"
  )
VALUES 
('Jonny', 'Depp', 'depp@gmail.com', true, '1963/10/10', 1.83),
('Jared', 'Leto', 'leto@gmail.com', true, '1969/10/10', 1.85);


--вывести id всех пользователей, которые делали заказы
SELECT "id" FROM "users"        --502
INTERSECT
SELECT "userId" FROM "orders"   --500


--вывести id всех пользователей, которые не делали заказы
SELECT "id" FROM "users"       --502
EXCEPT
SELECT "userId" FROM "orders"  --500

--обратный порядок к тому что више
SELECT "userId" FROM "orders" --500
EXCEPT
SELECT "id" FROM "users"      --502


--получить заказы конкретного пользователя с id=338 и вывести меил и пол и id заказов
SELECT "u"."email", "u"."isMale", "o"."id"
FROM "users" AS "u"
JOIN "orders" AS "o" ON "u"."id" = "o"."userId"
WHERE "u"."id" = 338;

--это же, но без JOIN
SELECT "u"."email", "u"."isMale", "o"."id"
FROM "users" AS "u", "orders" AS "o"
WHERE "u"."id" = 338 AND "u"."id" = "o"."userId";


--все id заказов которые покупали бренд Sony
SELECT "o"."id", "p"."brand", "p"."model"
FROM "orders" AS "o"
  JOIN "phones_to_orders" AS "pto" ON "o"."id" = "pto"."orderId"
  JOIN "phones" AS "p" ON "pto"."phoneId" = "p"."id"
WHERE "p"."brand" ILIKE 'sony';

--все id заказов которые покупали бренд Sony (групируем), сортируем по id
SELECT "o"."id", "p"."brand", count ("p"."model") AS "count"
FROM "orders" AS "o"
  JOIN "phones_to_orders" AS "pto" ON "o"."id" = "pto"."orderId"
  JOIN "phones" AS "p" ON "pto"."phoneId" = "p"."id"
WHERE "p"."brand" ILIKE 'sony'
GROUP BY "o"."id", "p"."brand"
HAVING count ("p"."model") = 4
ORDER BY  "o"."id";



-------------------------------------------------------
INSERT INTO "phones" (
    "brand",
    "model",
    "price",
    "quantity"
  )
VALUES 
('Musk', 'X500', 51230, 3),
('Musk', 'X503', 52730, 2);

--все бренды телефонов которые покупают, отсортировать по алфавиту
SELECT "p"."brand"
FROM "phones" AS "p"
  JOIN "phones_to_orders" AS "pto" ON "p"."id" = "pto"."phoneId"
  JOIN "orders" AS "o" ON "pto"."orderId" = "o"."id"
GROUP BY "p"."brand"
ORDER BY "p"."brand";

--то же но через DISTINCT(убирает повторения)
SELECT DISTINCT "p"."brand"
FROM "phones" AS "p"
  JOIN "phones_to_orders" AS "pto" ON "p"."id" = "pto"."phoneId"
  JOIN "orders" AS "o" ON "pto"."orderId" = "o"."id";

--количество проданных телефонов (по количеству моделей)
SELECT "p"."model", "p"."brand", sum("pto"."quantity")
FROM "phones_to_orders" AS "pto"
  JOIN "phones" AS "p" ON "pto"."phoneId" = "p"."id"  --49
GROUP BY "p"."model", "p"."brand";

--INNER JOIN = FULL JOIN


--проданные телефоны (количество по моделям)
SELECT "p"."model", "p"."brand"
FROM "phones_to_orders" AS "pto"
  FULL OUTER JOIN "phones" AS "p" ON "pto"."phoneId" = "p"."id"  --52
GROUP BY "p"."model", "p"."brand";

--левую табл забрали (49)
SELECT "p"."model", "p"."brand"
FROM "phones_to_orders" AS "pto"
  LEFT JOIN "phones" AS "p" ON "pto"."phoneId" = "p"."id"  
GROUP BY "p"."model", "p"."brand";

--правую табл забрали (52)
SELECT "p"."model", "p"."brand"
FROM "phones_to_orders" AS "pto"
  RIGHT JOIN "phones" AS "p" ON "pto"."phoneId" = "p"."id"  
GROUP BY "p"."model", "p"."brand";

--показывает те телефоны которые не покупают
SELECT "p"."model", "p"."brand"
FROM  "phones" AS "p"
  LEFT JOIN "phones_to_orders" AS "pto" ON "pto"."phoneId" = "p"."id" 
  WHERE "pto"."phoneId" IS NULL
GROUP BY "p"."model", "p"."brand";

SELECT "p"."model", "p"."brand"
FROM "phones_to_orders" AS "pto"
  RIGHT JOIN "phones" AS "p" ON "pto"."phoneId" = "p"."id"
  WHERE "pto"."phoneId" IS NULL
GROUP BY "p"."model", "p"."brand";


--выбрать почты пользователей которые покупают iPhone
SELECT "u"."email", "p"."brand"
FROM "users" AS "u"
  JOIN "orders" AS "o" ON "u"."id" = "o"."id"
  JOIN "phones_to_orders" AS "pto" ON "o"."id" = "pto"."phoneId"
  JOIN "phones" AS "p" ON "pto"."phoneId" = "p"."id"
WHERE "p"."brand" = 'Iphone'
GROUP BY "u"."email", "p"."brand";

--вывести пользователей у которых количество заказов = 3
SELECT "u"."firstName", "u"."lastName"
FROM "users" AS "u"
  JOIN "orders" AS "o" ON "u"."id" = "o"."id"
WHERE "o"."id" = 3
GROUP BY "u"."firstName", "u"."lastName";

--все айди заказов в которых покупали телефон с  id = 7, и почту покупателя
SELECT "o"."id", "u"."email", "pto"."orderId"
FROM "users" AS "u"
  JOIN "orders" AS "o" ON "u"."id" = "o"."id"
  JOIN "phones_to_orders" AS "pto" ON "o"."id" = "pto"."phoneId"
WHERE "pto"."orderId" = 7
GROUP BY "o"."id", "u"."email", "pto"."orderId";


--самый популярный телефон (тот который по к-ву больше всех продан)
SELECT "p"."model", "p"."brand", sum("pto"."quantity")
FROM "phones_to_orders" AS "pto"
  JOIN "phones" AS "p" ON "pto"."phoneId" = "p"."id"
GROUP BY "p"."model", "p"."brand"
ORDER BY sum("pto"."quantity") DESC
LIMIT 1;
