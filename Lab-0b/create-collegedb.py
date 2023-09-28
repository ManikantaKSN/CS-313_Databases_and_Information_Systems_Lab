import psycopg2

conn = psycopg2.connect(
			host="/tmp",
			user="ayushmaan",
			password="123456",
			port=5432
			)
			
cursor.conn.cursor()

cursor.execute("SELECT 'CREATE DATABASE collegedb' WHERE NOT EXISTS (SELECT FROM pg_database WHERE datname = 'collegedb')")

print(cursor.fetchall())
