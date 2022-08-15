--получить все заказы, стоимость которых выше средней

--1 стоимость одного заказа
SELECT sum("pto"."quantity" * "p"."price"), "pto"."orderId"
FROM "phones_to_orders" AS "pto"
  JOIN "phones" AS "p" ON "pto"."phoneId" = "p"."id"
GROUP BY "pto"."orderId"
ORDER BY "pto"."orderId";

--2 получить среднюю стоимость

SELECT avg("sum"."cost")
FROM
  (SELECT sum("pto"."quantity" * "p"."price") AS "cost", "pto"."orderId"
  FROM "phones_to_orders" AS "pto"
    JOIN "phones" AS "p" ON "pto"."phoneId" = "p"."id"
  GROUP BY "pto"."orderId")
AS "sum";

--вывести все заказы, стоимость которых выше средней
SELECT *
FROM
  (SELECT sum("pto"."quantity" * "p"."price") AS "cost", "pto"."orderId"
  FROM "phones_to_orders" AS "pto"
    JOIN "phones" AS "p" ON "pto"."phoneId" = "p"."id"
  GROUP BY "pto"."orderId")
AS "cost_order"
WHERE "cost_order"."cost" > (
          SELECT avg("cost_order"."cost")
          FROM
          (SELECT sum("pto"."quantity" * "p"."price") AS "cost", "pto"."orderId"
          FROM "phones_to_orders" AS "pto"
            JOIN "phones" AS "p" ON "pto"."phoneId" = "p"."id"
          GROUP BY "pto"."orderId")
        AS "cost_order");


--вывести все заказы, стоимость которых выше средней(через WITH)
WITH "cost_order" AS (
  SELECT sum("pto"."quantity" * "p"."price") AS "cost", "pto"."orderId"
  FROM "phones_to_orders" AS "pto"
    JOIN "phones" AS "p" ON "pto"."phoneId" = "p"."id"
  GROUP BY "pto"."orderId"
)

SELECT "co".*
FROM "cost_order" AS "co"
WHERE "co"."cost" > (
  SELECT avg("co"."cost")
  FROM "cost_order" AS "co"
);


-------------------------------------------------------------------

--вывести всех пользователей у которых количество заказов меньше среднего

--количество заказов каждого польозователя
SELECT "u"."firstName", "u"."lastName", count("o"."userId")
FROM "users" AS "u"
  JOIN "orders" AS "o" ON "u"."id" = "o"."userId"
GROUP BY "u"."firstName", "u"."lastName";

--найти средее
SELECT avg("count_orders"."count")
FROM(
  SELECT "u"."firstName", "u"."lastName", count("o"."userId") AS "count"
  FROM "users" AS "u"
  JOIN "orders" AS "o" ON "u"."id" = "o"."userId"
  GROUP BY "u"."firstName", "u"."lastName")
AS "count_orders";

--вывести всех пользователей у которых количество заказов меньше среднего
SELECT *
FROM(
  SELECT "u"."firstName", "u"."lastName", count("o"."userId") AS "count"
  FROM "users" AS "u"
  JOIN "orders" AS "o" ON "u"."id" = "o"."userId"
  GROUP BY "u"."firstName", "u"."lastName")
AS "count_orders"
WHERE "count_orders"."count" < (SELECT avg("count_orders"."count")
FROM(
  SELECT "u"."firstName", "u"."lastName", count("o"."userId") AS "count"
  FROM "users" AS "u"
  JOIN "orders" AS "o" ON "u"."id" = "o"."userId"
  GROUP BY "u"."firstName", "u"."lastName")
AS "count_orders");

--использовать WITH
WITH "count_orders" AS (
  SELECT "u"."firstName", "u"."lastName", count("o"."userId") AS "count"
FROM "users" AS "u"
  JOIN "orders" AS "o" ON "u"."id" = "o"."userId"
GROUP BY "u"."firstName", "u"."lastName"
)
SELECT "co".*
FROM "count_orders" AS "co"
WHERE "co"."count" < (SELECT avg("co"."count") FROM "count_orders" AS "co");
