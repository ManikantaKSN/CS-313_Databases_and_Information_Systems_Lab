--Question 2

SELECT sname
FROM student as d
WHERE d.gpa=(SELECT max(s.gpa) FROM student as s);

----------------------------------------------------------------------------
----------------------------------------------------------------------------

--Question 3

SELECT c.cno,avg(gpa)
FROM student as s NATURAL JOIN enroll NATURAL JOIN course as c NATURAL JOIN department as d 
WHERE c.dname = 'Computer Sciences'
GROUP BY c.cno; 

----------------------------------------------------------------------------
----------------------------------------------------------------------------

--Question 4

SELECT sname, count(e.cno)
FROM student as s NATURAL JOIN enroll as e 
GROUP BY sname
HAVING count(e.cno)=
(
SELECT max(d.count) FROM
(SELECT count(e.cno)
FROM student as s NATURAL JOIN enroll as e 
GROUP BY sname

) as d
);


----------------------------------------------------------------------------
----------------------------------------------------------------------------

--Question 5

SELECT dname
FROM professor as p NATURAL JOIN department as d
GROUP BY dname
HAVING count(p.pname)=
(SELECT max(d.count)
FROM
(
SELECT count(pname) FROM professor as p NATURAL JOIN department as d
GROUP BY dname
) as d);

----------------------------------------------------------------------------
----------------------------------------------------------------------------

--Question 6

SELECT sname,m.dname
FROM student as s NATURAL JOIN enroll as e NATURAL JOIN course as c, major as m
WHERE  s.sid=m.sid AND c.cname='Thermodynamics';

----------------------------------------------------------------------------
----------------------------------------------------------------------------

--Question 7

-- (May be wrong)
-- SELECT DISTINCT m.dname
-- FROM student as s NATURAL JOIN major as m
-- WHERE s.sname IN
-- (
-- SELECT s.sname
-- FROM student as s NATURAL JOIN enroll as e NATURAL JOIN course as c
-- WHERE c.cname <> 'Compiler Construction'
-- );

SELECT DISTINCT m.dname
FROM major as m
WHERE NOT EXISTS (
    SELECT 
    FROM student as s
    NATURAL JOIN enroll as e
    NATURAL JOIN course as c
    WHERE c.cname = 'Compiler Construction'
    and s.sid = m.sid

);


----------------------------------------------------------------------------
----------------------------------------------------------------------------

--Question 8
-- SELECT sname,cname
-- FROM student as s NATURAL JOIN enroll as e NATURAL JOIN course as c
-- WHERE EXISTS
-- (
-- SELECT c1.cno
-- FROM course as c1
-- WHERE dname='Mathematics' and c.cno= c1.cno);

(SELECT sname
FROM student as s NATURAL JOIN enroll as e NATURAL JOIN course as c
WHERE e.dname='Mathematics'
GROUP BY sname
HAVING count(cname)<=2)
INTERSECT
(
SELECT sname FROM student WHERE sname = SOME(
SELECT sname
FROM student as s NATURAL JOIN enroll as e NATURAL JOIN course as c
WHERE e.dname='Civil Engineering'));




----------------------------------------------------------------------------
----------------------------------------------------------------------------

--Question 9

SELECT dname, avg(gpa)
FROM student as s NATURAL JOIN major as m
WHERE gpa < 1.5
GROUP BY dname;

----------------------------------------------------------------------------
----------------------------------------------------------------------------

--Question 10

SELECT cno
FROM course
WHERE dname='Civil Engineering';

SELECT s.sid,sname,gpa
FROM student as s NATURAL JOIN enroll as e
WHERE e.cno = ALL (SELECT cno
FROM course
WHERE dname='Civil Engineering');

select s.sname, m.dname from student as s, major as m, enroll as e, course as c where c.cname='Thermodynamics' and c.cno=e.cno and e.sid=m.sid and s.sid=m.sid;
select distinct m.dname from major as m where m.dname not in (select distinct m.dname from major as m, enroll as e, course as c where c.cname='Compiler Construction' and c.cno=e.cno and e.sid=m.sid);
select mtable.msname from (select s.sname as msname, count(s.sname) as mcount from student as s, enroll as e, course as c where c.dname='Mathematics' and c.cno=e.cno and e.sid=s.sid group by s.sname) as mtable, (select s.sname as csname from student as s, enroll as e, course as c where c.dname='Civil Engineering' and c.cno=e.cno and e.sid=s.sid) as ctable where mcount<=2 and csname=msname;
select dtable.ddname, avg(s.gpa) from (select d.dname as ddname from student as s, department as d, major as m where s.gpa<1.5 and d.dname=m.dname and s.sid=m.sid) as dtable, student as s, department as d, major as m where dtable.ddname=d.dname and d.dname=m.dname and m.sid=s.sid group by dtable.ddname;
select s.sid, s.sname, s.gpa from student as s, course as c, enroll as e where c.dname='Civil Engineering' and c.cno=e.cno and s.sid=e.sid group by s.sid having count(s.sid)=(select count(c.cno) from course as c where c.dname='Civil Engineering');