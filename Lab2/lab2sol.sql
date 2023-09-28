-- 210010016

-->

CREATE DATABASE universitydb;
\c universitydb

---------------------------------------------------------------------------
---------------------------------------------------------------------------

-->

\i create-tables.sql
\i populate.sql

---------------------------------------------------------------------------
---------------------------------------------------------------------------
--Question 1
-- Assuming (course_id,sec_id,semester) as a section..since this is the primary key of section table

SELECT min(c),max (c) 
FROM (
        SELECT count(ID) as c 
        FROM section NATURAL JOIN takes
        GROUP BY course_id,sec_id,semester,year
    ) as tab;

---------------------------------------------------------------------------
---------------------------------------------------------------------------
--Question 2
-- Assuming (course_id,sec_id,semester) as a section..since this is the primary key of section table

SELECT course_id,sec_id,semester,count(ID) as c 
FROM section NATURAL JOIN takes GROUP BY course_id,sec_id,semester 
HAVING count(ID)=
    (
        SELECT max (c) 
        FROM 
            (
                SELECT count(ID) as c 
                FROM section NATURAL JOIN takes 
                GROUP BY course_id,sec_id,semester,year
            ) as tab
    );



---------------------------------------------------------------------------
---------------------------------------------------------------------------
--Question 3

-- Assuming (course_id,sec_id,semester) as a section..since this is the primary key of section table

--> scalar subquery 
SELECT * FROM
(SELECT min(cnt) FROM 
    (
        SELECT count(ID) as cnt 
        FROM section NATURAL JOIN takes 
        GROUP BY course_id,sec_id,semester,year
    ) as tab) as min_count,
(SELECT max(cnt) FROM 
    (
        SELECT count(ID) as cnt 
        FROM section NATURAL LEFT JOIN takes 
        GROUP BY course_id,sec_id,semester,year
    ) as tab)max_count;

-->Using aggregation on a left outer join
SELECT min(cnt),max(cnt) FROM 
    (
        SELECT count(ID) as cnt 
        FROM section NATURAL LEFT JOIN takes 
        GROUP BY course_id,sec_id,semester,year
    ) as tab;


---------------------------------------------------------------------------
---------------------------------------------------------------------------
--Question 4

SELECT title FROM course WHERE course_id LIKE 'CS-1%';

---------------------------------------------------------------------------
---------------------------------------------------------------------------
--Question 5

INSERT INTO instructor VALUES (98765,'Hriday','Comp. Sci.',70000);
INSERT INTO teaches VALUES(98765,'CS-101',1,'Fall',2017);
INSERT INTO teaches VALUES(98765,'CS-190',1,'Spring',2017);

-->  Using the ”not exists ... except ...” structure
SELECT name FROM instructor as i
WHERE NOT EXISTS (
    (SELECT course_id FROM course WHERE course_id LIKE 'CS-1%')
    EXCEPT
    (SELECT course_id FROM instructor as inst NATURAL JOIN teaches as t WHERE inst.name = i.name)
);

--> Using matching of counts which we covered in class

SELECT i.name,count(course_id) 
FROM instructor as i NATURAL JOIN teaches as t
WHERE t.course_id LIKE 'CS-1%'
GROUP BY i.name
HAVING count(t.course_id) = 
(
    SELECT count(course_id) 
    FROM course WHERE course_id LIKE 'CS-1%'
) 
    AND NOT EXISTS 
    ( 
        SELECT course_id
        FROM course as c 
        WHERE c.course_id LIKE 'CS-1%'
        AND c.course_id NOT IN
        (
            SELECT c2.course_id
            FROM instructor as inst JOIN teaches as c2 ON inst.ID = c2.ID 
            WHERE inst.name = i.name
        ) 
    );

---------------------------------------------------------------------------
---------------------------------------------------------------------------
--Question 6
--> TO avoid foreign key value violation, we are removing last digit of instructor and concating 'I' at the beginning
INSERT INTO student (id,name,dept_name,tot_cred)
SELECT LEFT(CONCAT('I',id),5),name,dept_name,0 FROM instructor;

---------------------------------------------------------------------------
---------------------------------------------------------------------------
--Question 7
DELETE FROM student WHERE tot_cred = 0 AND id LIKE 'I%';

---------------------------------------------------------------------------
---------------------------------------------------------------------------
--Question 8


--> SALARY less than 29000. Update only for the instructors who has atleast 3 section courses

UPDATE instructor i
SET salary = 10000*
(SELECT count(course_id)
FROM teaches as t NATURAL JOIN section
WHERE i.id = t.id 
GROUP BY id
HAVING count(course_id)>2)
WHERE i.id IN 
(SELECT t.id
FROM teaches as t NATURAL JOIN section
WHERE i.id = t.id 
GROUP BY id
HAVING count(course_id)>2);

---------------------------------------------------------------------------
---------------------------------------------------------------------------
--Question 9
CREATE VIEW f_students AS SELECT id,course_id,sec_id,semester,year,grade FROM takes WHERE grade ='F';

---------------------------------------------------------------------------
---------------------------------------------------------------------------
--Question 10
INSERT INTO student VALUES ('99999','Dummy_fail','Physics',30);
INSERT INTO takes VALUES ('99999','CS-101',1,'Fall',2017,'F');
INSERT INTO takes VALUES ('99999','HIS-351',1,'Spring',2018,'F');


SELECT id FROM f_students GROUP BY id HAVING count(grade)>1;

---------------------------------------------------------------------------
---------------------------------------------------------------------------
--Question 11

CREATE TABLE gradings (
    grade varchar(2) PRIMARY KEY,
    points INT
);

INSERT INTO gradings VALUES('A',10);
INSERT INTO gradings VALUES('B',8);
INSERT INTO gradings VALUES('C',6);
INSERT INTO gradings VALUES('D',4);
INSERT INTO gradings VALUES('F',0);

INSERT INTO gradings VALUES('A+',10);
INSERT INTO gradings VALUES('B+',8);
INSERT INTO gradings VALUES('C+',6);
INSERT INTO gradings VALUES('D+',4);

INSERT INTO gradings VALUES('A-',10);
INSERT INTO gradings VALUES('B-',8);
INSERT INTO gradings VALUES('C-',6);
INSERT INTO gradings VALUES('D-',4);

---------------------------------------------------------------------------
---------------------------------------------------------------------------
--Question 12

SELECT name,avg(points) as cpi 
FROM student NATURAL JOIN takes NATURAL JOIN
gradings GROUP BY id;

---------------------------------------------------------------------------
---------------------------------------------------------------------------
--Question 13

-- Assuming (course_id,sec_id,semester) as a section..since this is the primary key of section table
SELECT course_id,sec_id,semester,room_number,time_slot_id
FROM section WHERE (room_number,time_slot_id) IN (SELECT room_number,time_slot_id FROM section GROUP BY room_number,time_slot_id HAVING count(*) >1) ;

---------------------------------------------------------------------------
---------------------------------------------------------------------------
--Question 14

CREATE VIEW faculty AS
(
    SELECT id,name,dept_name
    FROM instructor
);

---------------------------------------------------------------------------
---------------------------------------------------------------------------
--Question 15

CREATE VIEW CSinstructors AS
(
    SELECT *
    FROM instructor
    WHERE dept_name = 'Comp. Sci.'
);

---------------------------------------------------------------------------
---------------------------------------------------------------------------
--Question 16

INSERT INTO faculty VALUES ('12348','Anantha','Comp. Sci.');
-- INSERT 0 1
--> Anantha is added to instructor table too. With NUll salary
--> Anantha is also added to CSinstructors as he is from 'Comp. Sci.' department

INSERT INTO faculty VALUES ('12349','Gayathri','Elec. Eng.');
-- INSERT 0 1
--> Gayathri is added to instructor table too. With NUll salary

INSERT INTO CSinstructors VALUES ('12350','Phawde','Comp. Sci.');
-- INSERT 0 1
-->Phawde added to instructor with NULL salary 
--> Phawde is also added to faculty

INSERT INTO CSinstructors VALUES ('12351','Tembe','Biology');
--> INSERT 0 1
--> Tembe is not added to CSinstructors as he is not from Comp. Sci. department,But
--> Tembe is added to instructor with NULL salary
--> Tembe is also added to faculty view

--> At the last if we want to  delete all instructors from CSinstructors
-->who are not from Comp. Sci. Department, then we do as follows:
DELETE FROM CSinstructors WHERE dept_name <> 'Comp. Sci.';

---------------------------------------------------------------------------
---------------------------------------------------------------------------
--Question 17

CREATE USER hriday;
GRANT SELECT ON student TO hriday;
-- SET ROLE hriday;
-- hriday can only view students table. Nothing else
