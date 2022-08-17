
DROP TABLE "shops";
CREATE TABLE "shops" (
  "id" SERIAL PRIMARY KEY,
  "address" JSONB
);

INSERT INTO "shops"("address")
VALUES 
('{"contry":"Ukraien", "town":"Dnipro", "local":{"street":"Avenu5", "house":8}}');


CREATE TYPE STATUS_TASK AS ENUM('done', 'inprocess', 'rejected');

CREATE TABLE "users_tasks"(
  "id" SERIAL PRIMARY KEY,
  "body" TEXT NOT NULL,
  "userId" INTEGER REFERENCES "users"("id"),
  "status" STATUS_TASK NOT NULL,
  "deadLine" TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP CHECK("deadLine" >= CURRENT_TIMESTAMP)
);

INSERT INTO "users_tasks"("body", "userId", "status")
VALUES 
('text task 1', 3, 'done'),
('text task 2', 30, 'done');

ALTER TABLE "users_tasks"
ADD COLUMN "createdAt" TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP;

--добавить колонку marks, оценки от 1 до 5
ALTER TABLE "users_tasks"
ADD COLUMN "marks" INTEGER CHECK("marks" >= 0 AND "marks" <= 5);

--удалить колонку marks
ALTER TABLE "users_tasks"
DROP COLUMN "marks";

ALTER TABLE "users_tasks"
ADD CONSTRAINT "check_createdAt" CHECK("createdAt" <= CURRENT_TIMESTAMP);

ALTER TABLE "users_tasks"
ADD CHECK("createdAt" <= CURRENT_TIMESTAMP);    --сформируется имя по умолчанию

ALTER TABLE "users_tasks"
DROP CONSTRAINT "check_createdAt";

--удаление NOT NULL
ALTER TABLE "users_tasks"
ALTER COLUMN "createdAt" DROP NOT NULL; 

--добавление NOT NULL
ALTER TABLE "users_tasks"
ALTER COLUMN "createdAt" SET NOT NULL; 

--добавление DEFAULT
ALTER TABLE "users_tasks"
ALTER COLUMN "status" SET DEFAULT 'inprocess';

--удаление DEFAULT
ALTER TABLE "users_tasks"
ALTER COLUMN "status" DROP DEFAULT;


--изменение типа данных
ALTER TABLE "users_tasks"
ALTER COLUMN "body" TYPE VARCHAR(1024);


--переименование RENAME
ALTER TABLE "users_tasks"
RENAME COLUMN "body" TO "content";

ALTER TABLE "users_tasks" RENAME TO "tasks";
ALTER TABLE "tasks" RENAME TO "users_tasks";
