import csv
import psycopg2

conn = psycopg2.connect(database='collegedb',
                        host="localhost",
                        user="postgres",
                        password="pg23",
                        port=5432) 
                        
mycursor = conn.cursor()

with open("studentData.csv", "r") as ip:
    csv_reader = csv.reader(ip)

    for record in csv_reader:
        line = "INSERT INTO student VALUES (\'" + record[0] + "\',\'" + record[1] + "\',\'" + record[2] + "\',\'" + record[3] + "\' );"
        mycursor.execute(line)

with open("departmentData.csv", "r") as ip:
    csv_reader = csv.reader(ip)

    for record in csv_reader:
        line = "INSERT INTO department VALUES (\'" + record[0] + "\',\'" + record[1] + "\');"
        mycursor.execute(line)
        
with open("professorData.csv", "r") as ip:
    csv_reader = csv.reader(ip)

    for record in csv_reader:
        line = "INSERT INTO professor VALUES (\'" + record[0] + "\',\'" + record[1] + "\');"
        mycursor.execute(line)

with open("courseData.csv", "r") as ip:
    csv_reader = csv.reader(ip)

    for record in csv_reader:
        line = "INSERT INTO course VALUES (\'" + record[0] + "\',\'" + record[1] + "\',\'" + record[2] + "\');"
        mycursor.execute(line)
        
with open("majorData.csv", "r") as ip:
    csv_reader = csv.reader(ip)

    for record in csv_reader:
        line = "INSERT INTO major VALUES (\'" + record[0] + "\',\'" + record[1] + "\');"
        mycursor.execute(line)

with open("enrollData.csv", "r") as ip:
    csv_reader = csv.reader(ip)

    for record in csv_reader:
        line = "INSERT INTO enroll VALUES (\'" + record[0] + "\'," + record[1] + ",\'" + record[2] + "\',\'" + record[3] + "\' );"
        mycursor.execute(line)

conn.commit()
conn.close()
mycursor.close()
