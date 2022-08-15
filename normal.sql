---FIRST normal form---
DROP TABLE "test";
CREATE TABLE "test"(
  "pr1" VARCHAR(64),
  "pr2" INT,
  PRIMARY KEY ("pr1", "pr2")
);



---SECOND normal form---
CREATE TABLE "positions"(
  "id" SERIAL PRIMARY KEY,
  "name",
  "isCar"
);

DROP TABLE "workers";
CREATE TABLE "workers"(
  "id" SERIAL PRIMARY KEY,
  "name",
  "department",
  "positionId" REFERENCES,
);
INSERT INTO "postions" ("name", "isCar")
VALUES
('HR', FALSE),
('clear', FALSE),
('driver', TRUE);

INSERT INTO "workers" ("name", "department", "positionId")
VALUES 
('Elon', xs, 1);



---THIRD normal form---
CREATE TABLE "positions"(
  "id" SERIAL PRIMARY KEY,
  "name",
  "isCar"
);

CREATE TABLE "departments"(
  "id" SERIAL PRIMARY KEY,
  "name",
  "phoneDepartments"
);

DROP TABLE "workers";
CREATE TABLE "workers"(
  "id" SERIAL PRIMARY KEY,
  "name",
  "department",
  "departmentId" REFERENCES,
  "positionId" REFERENCES
);

INSERT INTO "departmets" ("name", "phoneDepartments")
VALUES
('cc', '123'), ('xs', 'clear');

INSERT INTO "postions" ("name", "isCar")
VALUES
('HR', FALSE),
('clear', FALSE),
('driver', TRUE);

INSERT INTO "workers" ("name", "departmentId", "positionId")
VALUES 
('Elon', 2, 1);



---normal form БОЙСА-КОДДА (BCNF)---
CREATE TABLE "doctors"(
  "id" SERIAL PRIMARY KEY,
  "name"
);

CREATE TABLE "ills"(
  "id" SERIAL PRIMARY KEY,
  "name"
);

CREATE TABLE "d_t_i"(
  "dId" SERIAL PRIMARY KEY,
  "iId" SERIAL PRIMARY KEY,
  "diagnoz"
);

INSERT INTO "d_t_i" ("name", "phoneDepartments")
VALUES
(1, 1, 'd1'), 
(1, 2, 'd1'),
(2, 1, 'd2');