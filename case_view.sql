SELECT "model", "description"
FROM "phones"
WHERE "description" IS NULL;


----------------------------CASE----------------------------
/*
  CASE
    WHEN cond1 = true THEN act1
    WHEN cond2 = false THEN act2
    ELSE act3
  END
*/

/*
  CASE expression
    WHEN var1 THEN act1
    WHEN var2 THEN act2
    ELSE act3
  END
*/

------------------------------------------------------------

SELECT (
  CASE
    WHEN TRUE THEN 1
    WHEN FALSE THEN 2
    ELSE 3
  END
) AS "case";


SELECT (
  CASE
    WHEN "isMale" = TRUE THEN 'male'
    WHEN "isMale" = FALSE THEN 'female'
    ELSE 'other'
  END
) AS "gender", "email"
FROM "users";


SELECT (
  CASE EXTRACT ("month" FROM "birthday")
    WHEN 1 THEN 'winter'
    WHEN 2 THEN 'winter'
    WHEN 3 THEN 'spring'
    WHEN 4 THEN 'spring'
    WHEN 5 THEN 'spring'
    WHEN 6 THEN 'summer'
    WHEN 7 THEN 'summer'
    WHEN 8 THEN 'summer'
    WHEN 9 THEN 'fall'
    WHEN 10 THEN 'fall'
    WHEN 11 THEN 'fall'
    WHEN 12 THEN 'winter'
    ELSE 'other'
  END
) AS "season", "birthday"
FROM "users";


--вывести всех людей, кто старше 30 - взрослые, кто младше - юные
SELECT (
  CASE
    WHEN age("birthday") >= make_interval(30) THEN 'adult'
    WHEN age("birthday") <= make_interval(30) THEN 'young'
  END
) AS "age", "birthday"
FROM "users";


--вывести модель и бренд если Iphone - apple, other - для остальных
SELECT (
  CASE
    WHEN "model" = 'Iphone' THEN 'apple'
    WHEN "model" != 'Iphone' THEN 'other'
  END
) AS "model", "brand"
FROM "phones";

SELECT (
  CASE
    WHEN "model" = 'Iphone' THEN 'apple'
    ELSE 'other'
  END
) AS "model", "brand"
FROM "phones";


--вывести модель, бренд, цену и "доступность" телефона ( <6000 - cheap; 6000...12000 - average; >12000 - expensive )
SELECT (
  CASE
    WHEN "price" < 6000 THEN 'cheap'
    WHEN "price" >= 6000 AND "price" <= 12000 THEN 'average'
    ELSE 'expensive'
  END
) AS "model", "brand", "price"
FROM "phones";


--вывести модель, бренд, цену и колонку в которой указано цена выше средней или ниже: если выше - above, иначе - below
SELECT (
  CASE
    WHEN (SELECT avg("price") FROM "phones") > "price" THEN 'above'
    ELSE 'below'
  END
) AS "avg", "model", "brand", "price"
FROM "phones";


--сколько телефонов которые стоят меньше чем 16к
SELECT sum(
  CASE
    WHEN "price" > 16000 THEN 1
    ELSE 0
  END
)
FROM "phones";



--COALESCE - возвращается первый попавшийся аргумент который отличается от NULL
SELECT 
COALESCE (NULL, 5, 74);

SELECT "model",
COALESCE ("description", 'not description')
FROM "phones";



-----------------NULLIF--------------------------
SELECT NULLIF(12, 12);     --NULL
SELECT NULLIF(13, 12);     --13
SELECT NULLIF(NULL, 8);    --NULL



---------------ВЫРАЖЕНИЯ ПОДЗАПРОСОВ----------------------------------------
SELECT *
FROM "users" AS "u"
WHERE "u"."id" IN (SELECT "userId" FROM "orders");

SELECT *
FROM "users" AS "u"
WHERE "u"."id" NOT IN (SELECT "userId" FROM "orders");


SELECT *
FROM "users" AS "u"
WHERE EXISTS (SELECT * FROM "orders" AS "o" WHERE "u"."id" = "o"."userId");

SELECT *
FROM "users" AS "u"
WHERE NOT EXISTS (SELECT * FROM "orders" AS "o" WHERE "u"."id" = "o"."userId");

SELECT *
FROM "users" AS "u"
WHERE "u"."id" != SOME (SELECT "userId" FROM "orders");



--------------------------VIEW------------------------------
DROP VIEW "season_email";
CREATE OR REPLACE VIEW "season_email" AS (
  SELECT (
    CASE EXTRACT ("month" FROM "birthday")
      WHEN 1 THEN 'winter'
      WHEN 2 THEN 'winter'
      WHEN 3 THEN 'spring'
      WHEN 4 THEN 'spring'
      WHEN 5 THEN 'spring'
      WHEN 6 THEN 'summer'
      WHEN 7 THEN 'summer'
      WHEN 8 THEN 'summer'
      WHEN 9 THEN 'fall'
      WHEN 10 THEN 'fall'
      WHEN 11 THEN 'fall'
      WHEN 12 THEN 'winter'
      ELSE 'other'
    END
  ) AS "season", "birthday", "email"
  FROM "users"
);

SELECT * 
FROM "season_email";


SELECT count(*), "season"
FROM "season_email"
GROUP BY "season";


--создать view в котором будут email, имя, фамилия, количество заказов
DROP VIEW "amount_order_user";
CREATE OR REPLACE VIEW "amount_order_user" AS(
  SELECT "u"."firstName", "u"."lastName", count("o"."userId") AS "amount"
  FROM "users" AS "u"
    JOIN "orders" AS "o" ON "u"."id" = "o"."userId"
  GROUP BY "u"."firstName", "u"."lastName"
);

--с помощью view посчитать сколько людей с 1,2,3,4,5 закзами

SELECT count(*), "amount"
FROM "amount_order_user"
GROUP BY "amount";



--создать view, в котором будут fullName, age, gender пользователя
DROP VIEW "card";

CREATE OR REPLACE VIEW "card" AS(
SELECT (
  CASE
    WHEN "isMale" = TRUE THEN 'male'
    ELSE 'other'
    END
  ) AS "gender",
  concat("firstName", ' ', "lastName") AS "fullName",
  EXTRACT ("years" from age("birthday")) AS "age"
  FROM "users"
);

--вывести всех юзеров, используя это представление, отсортировав по возрасту
SELECT "fullName", "age", "gender"
From "card"
ORDER BY "age";

--посчитать сколько мужчин и женщин по каждому возрасту
SELECT "age", "gender", count("gender") AS "amount"
FROM "card"
GROUP BY "age", "gender"
ORDER BY "age";


CREATE VIEW "amount_age_by_gender" AS (SELECT "age", "gender", count("gender") AS "amount"
FROM "card"
GROUP BY "age", "gender"
ORDER BY "age");

SELECT * FROM "amount_age_by_gender";