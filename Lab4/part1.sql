---part1
---q1(Inside terminal 1)
begin;
---q2(inside terminal 1)
INSERT INTO actor VALUES (126, 'Logan', 'Roy', 'M');
---q3(Inside terminal 2)
SELECT * FROM actor;
---q4(Inside terminal 1)
commit;
---q5(Inside terminal 2)
SELECT * FROM actor;
---q6
--Inside terminal 1
begin; 
INSERT INTO actor VALUES (127, 'Kendall', 'Roy', 'M');
---Inside terminal 2
SELECT * FROM actor;
---Inside terminal 1
rollback;
---Inside terminal 2
SELECT * FROM actor;
---q7(Inside terminal 1)
begin;
INSERT INTO actors VALUES (128, 'Roman', 'Roy', 'M');
---Shows an error since the relation "actors" doesn't exist.
commit;
---Since there was an error it didn't get committed but there was a ROLLBACK.