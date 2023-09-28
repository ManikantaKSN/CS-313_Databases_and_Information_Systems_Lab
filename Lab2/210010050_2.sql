CREATE DATABASE universitydb;
\c universitydb
\i create-tables.sql
\i populate.sql
--q1
-- assuming (courseid, sectionid) as a section and not considering semester and year
WITH cntb(cid, sid, cnt) AS (SELECT course_id, sec_id, COUNT(*) AS cnt FROM 
section NATURAL JOIN takes GROUP BY course_id, sec_id) SELECT MAX(cnt), MIN(cnt) FROM cntb;
--q2
-- assuming (courseid, sectionid) as a section and not considering semester and year
SELECT course_id, sec_id, id FROM takes WHERE (course_id, sec_id) IN 
(WITH cntb(cid, sid, cnt) AS (SELECT course_id, sec_id, count(*) AS cnt FROM section NATURAL JOIN takes GROUP BY course_id, sec_id) 
SELECT course_id, sec_id FROM section NATURAL JOIN takes GROUP BY course_id, sec_id HAVING COUNT(*) = (SELECT MAX(cnt) FROM cntb)) ;
--q3
-- assuming (courseid, sectionid) as a section and not considering semester and year
--using scalar subquery**
SELECT * FROM
(SELECT min(cnt) FROM (SELECT count(*) as cnt FROM section NATURAL JOIN takes 
GROUP BY course_id,sec_id) as cntb) as tb1,
(SELECT max(cnt) FROM (SELECT count(*) as cnt FROM section NATURAL JOIN takes 
GROUP BY course_id,sec_id) as cntb) as tb2;
--using aggregation on a left outer join
with cntb(cid, sid, cnt) as (select course_id, sec_id, count(*) as cnt from 
section natural left join takes group by course_id, sec_id) select max(cnt), min(cnt) from cntb;
--q4
select course_id, title from course where course.course_id like 'CS-1%';
--q5
INSERT INTO instructor VALUES (98765,'MrRobert','Comp. Sci.',75000);
INSERT INTO teaches VALUES(98765,'CS-101',1,'Fall',2017);
INSERT INTO teaches VALUES(98765,'CS-190',1,'Spring',2017);
-->  Using the "not exists ... except ..." structure
SELECT name FROM instructor as i1
WHERE NOT EXISTS (
    (SELECT course_id FROM course WHERE course_id LIKE 'CS-1%')
    EXCEPT
    (SELECT course_id FROM instructor as i2 NATURAL JOIN teaches WHERE i1.name = i2.name)
);
SELECT i.name,count(course_id) FROM instructor as i NATURAL JOIN teaches as t WHERE t.course_id LIKE 'CS-1%'
GROUP BY i.name HAVING count(t.course_id) = (SELECT count(course_id) FROM course WHERE course_id LIKE 'CS-1%') 
AND NOT EXISTS (SELECT course_id FROM course as c WHERE c.course_id LIKE 'CS-1%' AND c.course_id NOT IN
(SELECT c2.course_id FROM instructor as inst JOIN teaches as c2 ON inst.ID = c2.ID WHERE inst.name = i.name));
--q6
--to avoid foreign key value violation, we are concating 'I' at the end of id to indicate that its an instructor, 
--as there is already a student who has the same id as an instructor 
INSERT INTO student (id, name, dept_name, tot_cred)
(SELECT LEFT(CONCAT('I',id),5), name, dept_name, 0 FROM instructor);
--q7
SELECT * FROM instructor;
DELETE FROM student WHERE tot_cred = 0 AND id LIKE 'I%';
--q8
-- updating only for the instructors who has atleast '3' section courses since there is a salary check : salary > 29000
UPDATE instructor
SET salary = 10000*
(SELECT count(*) FROM teaches NATURAL JOIN section
WHERE instructor.id = teaches.id GROUP BY id HAVING count(course_id)>2)
WHERE instructor.id IN 
(SELECT id FROM teaches NATURAL JOIN section WHERE instructor.id = teaches.id 
GROUP BY id HAVING count(course_id)>2);
--q9
INSERT INTO student VALUES (33333, 'tempst', 'Comp. Sci.',8);
INSERT INTO takes VALUES (33333, 'CS-101', 1,'Fall','2017','F'),(33333, 'CS-190', 2,'Spring','2017','F');
CREATE VIEW fail_students AS SELECT * FROM takes WHERE grade ='F';
--q10
SELECT id, COUNT(grade) as no_of_courses_failed FROM fail_students GROUP BY id HAVING COUNT(grade)>=2;
--there are no students with more than 1 'F' grades, hence prints zero rows
--q11
CREATE TABLE gradetable(
    grade VARCHAR(2) NOT NULL PRIMARY KEY,
    points INT 
);
INSERT INTO gradetable (grade, points) VALUES 
('A',10),('A+',10),('A-',10),('B',8),('B+',8),('B-',8),('C',6),('C+',6),('C-',6),
('D',4),('D+',4),('D-',4),('F',0);
SELECT * FROM gradetable;
--q12
-- Including the student who has not taken any course, we get his cgpa as 0 and not as 0.000... in the table data retrieved by the query
WITH cum_grade_pa(id, cgpa) AS (
SELECT id, sum(points * credits) / sum(credits) AS CGPA
FROM takes NATURAL JOIN gradetable NATURAL JOIN course GROUP BY id ORDER BY id)
(SELECT * FROM cum_grade_pa ORDER BY id) UNION
(SELECT id, 0 AS CGPA FROM student WHERE id NOT IN (SELECT id FROM takes));
--q13
-- Assuming (course_id,sec_id,semester) as a section..since this is the primary key of section table
SELECT course_id,sec_id,semester,room_number,time_slot_id
FROM section WHERE (room_number,time_slot_id) IN (SELECT room_number,time_slot_id FROM section GROUP BY room_number,time_slot_id HAVING count(*) >1);
--q14
CREATE VIEW faculty AS (SELECT id, name, dept_name FROM instructor);
SELECT * FROM faculty;
--q15
CREATE VIEW CSinstructors AS (SELECT * FROM instructor WHERE instructor.dept_name = 'Comp. Sci.');
SELECT * FROM CSinstructors;
--q16
INSERT INTO faculty values ('98665','Pranay','Comp. Sci.');
-- INSERT 0 1
--> inserted Pranay into the instructor table and the view CSinstructors also.
--> salary of Pranay is null
INSERT INTO CSinstructors VALUES ('98668','Karam','Comp. Sci.');
-- INSERT 0 1
--> inserted Karam into the instructor table and the view faculty also.
--> salary of Karam is null
INSERT INTO faculty VALUES ('12349','Gayathri','Elec. Eng.');
-- INSERT 0 1
--> Gayathri is added to instructor table too, with NUll salary
INSERT INTO CSinstructors VALUES ('98669','Kerry','Biology');
--> INSERT 0 1
--> Kerry is not added to CSinstructors view as he is not from Comp. Sci. department
--> Kerry is added to instructor with NULL salary
--> Kerry is also added to faculty view
--q17
CREATE USER tempuser;
GRANT SELECT ON student TO tempuser;
SET ROLE tempuser;
SELECT * FROM student; -- retrieves the table
SELECT * from takes; -- shows an error