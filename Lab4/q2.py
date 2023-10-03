import psycopg2
conn = psycopg2.connect(database='moviedb',
                        host="localhost",
                        user="postgres",
                        password="pg23",
                        port=5432)
mycursor = conn.cursor()
sql_command = """
    ALTER TABLE movie_cast
    ADD PRIMARY KEY (mov_id, act_id);
    """
mycursor.execute(sql_command)
conn.commit()