--q1
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