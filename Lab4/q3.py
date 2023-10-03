import psycopg2

conn = psycopg2.connect(database='moviedb',
                        host="localhost",
                        user="postgres",
                        password="pg23",
                        port=5432)

mycursor = conn.cursor()
# Assuming that actor ids are entered in serial order or increasing order, i.e
# act_id of an actor inserted later is greater in value than that of an actor inserted earlier.
mycursor.execute("SELECT MAX(act_id) FROM actor")
actor_id = mycursor.fetchone()[0]
print("For actor_id : ",actor_id)
no_of_movies = int(input("Enter the number of movies: "))
movies_info = []
success = True

for i in range(no_of_movies):
    movie_id = int(input(f"Enter movie id of movie number {i+1}: "))
    role = input(f"Enter role of the actor in movie number {i+1}: ")
    movies_info.append((movie_id, role))
    
for i, (movie_id, role) in enumerate(movies_info):
    mycursor.execute("SELECT * FROM movie WHERE mov_id = %s", (movie_id,))
    exists = mycursor.fetchone()
    if exists:
        mycursor.execute("INSERT INTO movie_cast (act_id, mov_id, role) VALUES (%s, %s, %s)",
                               (actor_id, movie_id, role))
    else:
        print(f"Movie number {i+1} is not present in the database. Database is not updated")
        conn.rollback()
        success = False
        break 
conn.commit()

if success:
    print("Database update successful")
mycursor.close()
conn.close()