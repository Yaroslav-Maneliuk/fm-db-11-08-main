
CREATE SCHEMA "tr";

CREATE TABLE "tr"."users"(
  "id" SERIAL PRIMARY KEY,
  "login" VARCHAR(64) NOT NULL CHECK ("login" != ''),
  "password" VARCHAR(128) NOT NULL CHECK ("password" != ''),
  "email" VARCHAR(128) NOT NULL CHECK ("email" != '')
);


CREATE TABLE "tr"."vacancies"(
  "id" SERIAL PRIMARY KEY,
  "position" VARCHAR(64) NOT NULL CHECK ("position" != ''),
  "department" VARCHAR(128) NOT NULL CHECK ("department" != ''),
  "salary" NUMERIC(12, 2) NOT NULL CHECK ("salary" > 0)
);

ALTER TABLE "tr"."vacancies"
ADD COLUMN "userId" INTEGER REFERENCES "tr"."users"("id");

ALTER TABLE "tr"."vacancies"
ADD COLUMN "vacancyId" INTEGER REFERENCES "tr"."vacancies"("id");


ALTER TABLE "tr"."users"
ADD CONSTRAINT "unique_email" UNIQUE ("email");

ALTER TABLE "tr"."users"
DROP COLUMN "password";

ALTER TABLE "tr"."users"
ADD COLUMN "passwordHash" text;

ALTER TABLE "tr"."users"
ALTER COLUMN "passwordHash" SET NOT NULL;

