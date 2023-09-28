CREATE TABLE student (

		sid	INT NOT NULL PRIMARY KEY,
		sname	VARCHAR(100),
		gender	VARCHAR(100),
		gpa	NUMERIC(3,2)
		
		);
		
CREATE TABLE department (

		dname	VARCHAR(100) NOT NULL PRIMARY KEY,	
		numphds	INT 
		
		);
		
CREATE TABLE professor (
			
		pname	VARCHAR(100) NOT NULL PRIMARY KEY,
		dname	VARCHAR(100) REFERENCES department(dname)
				
		);
		
CREATE TABLE course (
		
		cno	INT NOT NULL,
		cname	VARCHAR(100),
		dname	VARCHAR(100) NOT NULL REFERENCES department(dname),
		PRIMARY KEY( cno, dname )
				
		);
		
CREATE TABLE major (

		dname	VARCHAR(100) REFERENCES department(dname),
		sid	INT REFERENCES student(sid)

		);
		
CREATE TABLE enroll (
		
		sid	INT REFERENCES student(sid),
		grade	NUMERIC(3,2) NOT NULL,
		dname	VARCHAR(100),
		cno	INT,
		FOREIGN KEY(dname, cno) REFERENCES course( dname, cno )
				
		);

