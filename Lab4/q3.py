import psycopg2

def add_movie_info(connection, actor_id, movies_info):
    mycursor = conn.cursor()
    for i, (movie_id, role) in enumerate(movies_info, 1):
        mycursor.execute("SELECT 1 FROM movie WHERE mov_id = %s", (movie_id,))
        exists = mycursor.fetchone()
        if exists:
            mycursor.execute("INSERT INTO movie_cast (mov_id, act_id, role) VALUES (%s, %s, %s)",
                               (movie_id, actor_id, role))
        else:
            print(f"Movie number {i} is not present in the database. Database is not updated")
            connection.rollback()
            return False 
    connection.commit()
    return True

conn = psycopg2.connect(database='moviedb',
                        host="localhost",
                        user="postgres",
                        password="pg23",
                        port=5432)
actor_id = int(input("Enter actor id: "))
num_movies = int(input("Enter the number of movies: "))
movies_info = []

for i in range(1, num_movies + 1):
    movie_id = int(input(f"Enter movie id of movie number {i}: "))
    role = input(f"Enter role of the actor in movie number {i}: ")
    movies_info.append((movie_id, role))

conn.autocommit = False
success = add_movie_info(conn, actor_id, movies_info)
if success:
    print("Database update successfull")