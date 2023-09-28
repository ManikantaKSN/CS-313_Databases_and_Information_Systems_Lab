 --part1 of the assignment1
 --q1
 \c collegedb
 SELECT pname FROM professor NATURAL JOIN department WHERE department.numphds<50;
 --q2
 SELECT sname FROM student WHERE student.gpa IN (SELECT MAX(gpa) FROM student);
 --q3
 SELECT cno, AVG(gpa) AS avg_gpa FROM course NATURAL JOIN student NATURAL JOIN enroll WHERE course.dname = 'Computer Sciences' GROUP BY course.cno;
 --q4
 WITH counts(ct) AS(SELECT COUNT(*) AS ct FROM student NATURAL JOIN enroll GROUP BY student.sname) SELECT s.sname, s.sid FROM student s NATURAL JOIN enroll e GROUP BY s.sname, s.sid HAVING COUNT(*) = (SELECT MAX(ct) FROM counts);
 --q5
 WITH counts(ct) AS (SELECT count(*) AS ct FROM professor NATURAL JOIN department GROUP BY department.dname) SELECT dname, COUNT(*) AS number FROM department NATURAL JOIN professor GROUP BY department.dname HAVING COUNT(*) = (SELECT MAX(ct) FROM counts);
 --q6
 SELECT sname, major.dname FROM student, major, enroll, course where course.cname='Thermodynamics' AND course.cno=enroll.cno AND enroll.sid=major.sid AND student.sid=major.sid;
 --q7
 SELECT DISTINCT major.dname FROM major WHERE major.dname NOT IN (SELECT DISTINCT major.dname FROM major, enroll, course WHERE course.cname='Compiler Construction' AND course.cno=enroll.cno AND enroll.sid=major.sid);
 --q8
 (SELECT sname FROM student NATURAL JOIN enroll NATURAL JOIN course WHERE enroll.dname='Mathematics' GROUP BY sname HAVING count(cname)<=2) INTERSECT (SELECT sname FROM student WHERE sname IN(SELECT sname FROM student NATURAL JOIN enroll NATURAL JOIN course WHERE enroll.dname='Civil Engineering'));
 --q9
 WITH tabd(dn) AS (SELECT department.dname as dn FROM student, department, major WHERE student.sid = major.sid AND department.dname =major.dname AND student.gpa < 1.5) SELECT major.dname, AVG(gpa) AS avg_gpa FROM tabd, student, department, major WHERE tabd.dn = department.dname AND department.dname = major.dname AND major.sid = student.sid GROUP BY major.dname;
 --q10
 SELECT student.sid, sname, gpa FROM student, course, enroll WHERE course.dname='Civil Engineering' and course.cno=enroll.cno and student.sid=enroll.sid GROUP BY student.sid HAVING COUNT(student.sid)=(SELECT COUNT(course.cno) FROM course WHERE course.dname='Civil Engineering');
 --part 2 of the assignment1
 --q1
 CREATE DATABASE salesdb;
 \c salesdb
 --q2
 \i tableSales.sql
 --q3
 \i dataSales.sql
 --q4
 SELECT cust_name FROM customer WHERE customer.grade = 2;
 --q5
 SELECT ord_num, ord_date, ord_description FROM orders GROUP BY ord_num, ord_date, ord_description ORDER BY ord_date ASC;
 --q6
 SELECT ord_num, ord_date, ord_amount FROM orders WHERE orders.ord_amount >= 800 GROUP BY ord_num, ord_date, ord_amount ORDER BY ord_amount DESC ;
 --q7
 SELECT * FROM customer ORDER BY working_area ASC, cust_name DESC;
 --q8
 SELECT cust_name FROM customer WHERE customer.cust_name LIKE 'S%';
 --q9
 SELECT ord_num, ord_date FROM orders WHERE ord_date BETWEEN '2008-03-01' AND '2008-03-31';
 --q10
 SELECT ord_amount * 1.1 AS new_ord_amount FROM orders;
 --q11
 SELECT ord_num, ord_amount-advance_amount AS balance_amount FROM orders WHERE ord_amount BETWEEN 2000 AND 4000;
 --q12
 SELECT ord_num, cust_code, ord_amount FROM orders WHERE orders.ord_amount IN (SELECT ord_amount FROM orders WHERE orders.cust_code= 'C00022');
 --q13
 WITH max_com(maxcom) AS (SELECT max(commission) FROM agents WHERE agents.working_area = 'Bangalore') SELECT agent_name, agent_code FROM agents, max_com WHERE agents.commission > max_com.maxcom;
 --q14
 WITH min_com(mincom) AS (SELECT min(commission) FROM agents WHERE agents.working_area = 'Bangalore') SELECT agent_name FROM agents, min_com WHERE agents.commission > min_com.mincom;
 --q15
 SELECT agent_code FROM agents WHERE agents.agent_code IN (SELECT agent_code FROM orders GROUP BY agent_code HAVING COUNT(*)>=1);
 --q16
 SELECT cust_name FROM customer WHERE customer.cust_code NOT IN ( SELECT cust_code FROM orders NATURAL JOIN customer);
 --q17
 SELECT agent_code FROM agents NATURAL JOIN orders WHERE orders.ord_amount >=800;
 --q18
 SELECT distinct agent_name FROM agents NATURAL JOIN orders WHERE orders.ord_amount >=800;
 --q19
 SELECT cust_name, cust_code FROM customer WHERE customer.working_area IN ('Paris', 'New York', 'Bangalore');
 --q20
 SELECT agent_name FROM agents NATURAL JOIN orders WHERE orders.ord_amount = 1000;
 --q21
 SELECT SUM(ord_amount) AS total, AVG(ord_amount), MIN(ord_amount), MAX(ord_amount) FROM orders;
 --q22
 SELECT COUNT(cust_code) AS no_of_customers FROM customer WHERE customer.working_area= 'New York';
 --q23
 SELECT COUNT(distinct(ord_amount)) AS distinct_order_amounts FROM orders;
 --q24
 SELECT agent_name, agent_code FROM agents WHERE agents.agent_code IN (SELECT agent_code FROM orders GROUP BY agent_code HAVING COUNT(*)>=2);
 --q25
 SELECT working_area, COUNT(*) FROM agents GROUP BY working_area;
 --q26
 SELECT agent_name, working_area AS busy_working_area FROM agents WHERE agents.working_area IN (SELECT working_area FROM orders NATURAL JOIN agents GROUP BY working_area HAVING COUNT(*) >=2);
 --q27
 SELECT agent_name, avg(ord_amount) FROM agents NATURAL JOIN orders GROUP BY agent_name;
 --q28
 INSERT INTO agents VALUES ('0000',0,0,0,0);
 UPDATE customer
 SET agent_code = '0000'
 WHERE agent_code IN (SELECT agent_code FROM
 agents WHERE working_area = 'Bangalore'
 );
 UPDATE orders
 SET agent_code = '0000'
 WHERE agent_code IN (SELECT agent_code FROM
 agents WHERE working_area = 'Bangalore');
 DELETE FROM agents
 WHERE working_area='Bangalore';
 --q29
 ALTER TABLE customer
 ADD COLUMN Address varchar(50) NULL;
 UPDATE customer
 SET Address = 'Dharwad, Karnataka'
 WHERE cust_code='C00013';
 --q30
 ALTER TABLE agents
 DROP COLUMN country;
 --q31
 DELETE FROM orders;
 --q32
 DROP TABLE customer CASCADE;