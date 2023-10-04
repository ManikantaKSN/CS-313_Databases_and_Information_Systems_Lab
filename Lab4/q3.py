import psycopg2
conn = psycopg2.connect(database='moviedb',
                        host="localhost",
                        user="postgres",
                        password="pg23",
                        port=5432)
mycursor = conn.cursor()

print()
print("""NOW, WE INSERT THE ROLES OF THE NEWLY INSERTED ACTOR_ID INTO THE 
RELATION 'MOVIE_CAST' ONLY IF THE CORRESPONDING MOVIE EXISTS IN THE DATABASE AND 
WE DON'T ACCEPT THE UPDATE IF ATLEAST ONE MOVIE ENTERED DOESN'T EXIST IN THE DATABASE""")
print()
actor_id = int(input("Enter the previously inserted actor_id : "))
print()
no_of_movies = int(input("Enter the number of movies: "))
movies_info = []
success = True
for i in range(no_of_movies):
    movie_id = int(input(f"Enter movie id of movie number {i+1}: "))
    role = input(f"Enter role of the actor in movie number {i+1}: ")
    movies_info.append((movie_id, role))
    
mycursor.execute("BEGIN")
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
print()
mycursor.close()
conn.close()