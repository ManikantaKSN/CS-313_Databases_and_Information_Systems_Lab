import psycopg2

conn = psycopg2.connect(
                        host="/tmp",
                        user="postgres",
                        password="Password@123",
                        port=5432) 

# preparing a cursor object
cursor = conn.cursor()


# creating database
#cursor.execute("CREATE DATABASE IF NOT EXISTS movieDB")

cursor.execute("SELECT 'CREATE DATABASE mydb' WHERE NOT EXISTS (SELECT FROM pg_database WHERE datname = 'mydb')")

print(cursor.fetchall())

