import psycopg2
conn = psycopg2.connect(database='moviedb',
                        host="localhost",
                        user="postgres",
                        password="pg23",
                        port=5432)
mycursor = conn.cursor()
actor_id = int(input("Enter actor id: "))
first_name = input("Enter First name: ")
last_name = input("Enter Last name: ")
gender = input("Enter Gender: ")
mycursor.execute("SELECT * FROM actor WHERE actor_id = %s", (actor_id,))
actor_exists = mycursor.fetchone()
if actor_exists:
    print("Actor ID already exists")
else:
    mycursor.execute("INSERT INTO actor (actor_id, first_name, last_name, gender) VALUES (%s, %s, %s, %s)",
                       (actor_id, first_name, last_name, gender))
    conn.commit()
    print("Actor details inserted into the actor table successfully")
mycursor.close()
conn.close()