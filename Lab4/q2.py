import psycopg2

conn = psycopg2.connect(database='moviedb',
                        host="localhost",
                        user="postgres",
                        password="pg23",
                        port=5432)
mycursor = conn.cursor()

try:
    command = """
    ALTER TABLE movie_cast
    ADD PRIMARY KEY (mov_id, act_id);
    """
    mycursor.execute(command)
    conn.commit()
    print("Primary key declared for table 'movie_cast'")
except:
    print("Multiple primary keys for table 'movie_cast' are not allowed")

mycursor.close()
conn.close()