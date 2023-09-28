import csv
import psycopg2

conn = psycopg2.connect(database='moviedb',
                        host="localhost",
                        user="postgres",
                        password="pg23",
                        port=5432) 
                        
mycursor = conn.cursor()

with open("actorData.csv", "r") as ip:
    csv_reader = csv.reader(ip)

    for record in csv_reader:
        line = "INSERT INTO actor VALUES (" + record[0] + ",\'" + record[1] + "\',\'" + record[2] + "\',\'" + record[
            3] + "\');"
        mycursor.execute(line)

with open("genresData.csv", "r") as ip:
    csv_reader = csv.reader(ip)

    for record in csv_reader:
        line = "INSERT INTO genres VALUES (" + record[0] + ",\'" + record[1] + "\');"
        mycursor.execute(line)

with open("directorData.csv", "r") as ip:
    csv_reader = csv.reader(ip)

    for record in csv_reader:
        line = "INSERT INTO director VALUES (" + record[0] + ",\'" +\
               record[1] + "\',\'" + record[2] + "\');"
        mycursor.execute(line)

with open("movieData.csv", "r") as ip:
    csv_reader = csv.reader(ip)

    for record in csv_reader:
        if record[5] != "":
            line = "INSERT INTO movie VALUES (" + \
                   record[0] + ",\'" + record[1] + "\'," + record[2] + "," + \
                   record[3] + ",\'" + record[4] + "\',\'" + record[5] + \
                   "\',\'" + record[6] + "\');"
        else:
            line = "INSERT INTO movie VALUES (" + \
                   record[0] + ",\'" + record[1] + "\'," + record[2] + "," + \
                   record[3] + ",\'" + record[4] + "\'," + "NULL" + \
                   ",\'" + record[6] + "\');"

        mycursor.execute(line)

with open("movieGenreData.csv", "r") as ip:
    csv_reader = csv.reader(ip)

    for record in csv_reader:
        line = "INSERT INTO movie_genres VALUES (" + \
               record[0] + "," + record[1] + ");"
        mycursor.execute(line)

with open("movieDirectionData.csv", "r") as ip:
    csv_reader = csv.reader(ip)

    for record in csv_reader:
        line = "INSERT INTO movie_direction VALUES (" + \
               record[0] + "," + record[1] + ");"
        mycursor.execute(line)

with open("reviewerData.csv", "r") as ip:
    csv_reader = csv.reader(ip)

    for record in csv_reader:
        if record[1] != "":
            line = "INSERT INTO reviewer VALUES (" + \
                   record[0] + ",\'" + record[1] + "\');"
        else:
            line = "INSERT INTO reviewer VALUES (" + \
                   record[0] + ", NULL );"
        mycursor.execute(line)

with open("ratingData.csv", "r") as ip:
    csv_reader = csv.reader(ip)

    for record in csv_reader:
        line = "INSERT INTO rating VALUES (" + record[0] + "," + record[1] + ","
        if record[2] == "":
            field2 = "NULL"
        else:
            field2 =  record[2] 
        if record[3] == "":
            field3 = "NULL"
        else:
            field3 = "\'" + record[3] + "\'"
        line = line + field2 + "," + field3 + ");"
        mycursor.execute(line)

with open("movieCastData.csv", "r") as ip:
    csv_reader = csv.reader(ip)

    for record in csv_reader:
        line = "INSERT INTO movie_cast VALUES (" + \
               record[0] + "," + record[1] + ",\'" + record[2] + "\');"
        mycursor.execute(line)

conn.commit()
conn.close()
mycursor.close()
