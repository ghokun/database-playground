DROP SCHEMA IF EXISTS find_all CASCADE;
CREATE SCHEMA find_all;

CREATE TABLE find_all.table_1 (
  id   SERIAL,
  name TEXT NOT NULL,
  PRIMARY KEY (id)
);

CREATE TABLE find_all.table_2 (
  id   SERIAL,
  name TEXT NOT NULL,
  PRIMARY KEY (id)

);

CREATE TABLE find_all.table_3 (
  id         SERIAL,
  name       TEXT NOT NULL,
  table_1_id INT  NULL,
  table_2_id INT  NULL,
  PRIMARY KEY (id),
  CONSTRAINT fk_table_1 FOREIGN KEY (table_1_id) REFERENCES find_all.table_1 (id),
  CONSTRAINT fk_table_2 FOREIGN KEY (table_2_id) REFERENCES find_all.table_2 (id)
);


INSERT INTO find_all.table_1(id, name)
VALUES (1, 'parent1');

INSERT INTO find_all.table_2(id, name)
VALUES (1, 'child1'),
       (2, 'child2'),
       (3, 'child3'),
       (4, 'child4'),
       (5, 'child5');

INSERT INTO find_all.table_3(id, name, table_1_id, table_2_id)
VALUES (1, 'link1', 1, 1),
       (2, 'link2', 1, 2),
       (3, 'link3', 1, 3),
       (4, 'link4', 1, 4),
       (5, 'link5', 1, 5);

-- is equal to stream().allMatch()
SELECT t1.id
  FROM find_all.table_1 t1
  LEFT JOIN find_all.table_3 t3 ON t3.table_1_id = t1.id
 GROUP BY t1.id
HAVING COUNT(*) = (
  SELECT COUNT(DISTINCT (t2in.id))
    FROM find_all.table_2 t2in
    JOIN find_all.table_3 t3in ON t3in.table_2_id = t2in.id
   WHERE t3in.table_1_id = t1.id
     AND t2in.name LIKE '%child%');

