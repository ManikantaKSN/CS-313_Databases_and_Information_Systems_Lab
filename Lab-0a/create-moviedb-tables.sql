
    
CREATE TABLE  genres (
        gen_id INT NOT NULL PRIMARY KEY,
        gen_title VARCHAR(20)
        );
       

CREATE TABLE  director (
           dir_id INT NOT NULL PRIMARY KEY,
           dir_fname VARCHAR(50),
           dir_lname VARCHAR(50)
           );
           
CREATE TABLE movie (
               mov_id INT NOT NULL PRIMARY KEY,
               mov_title VARCHAR(50),
               mov_year INT,
               mov_duration INT,
               mov_lang VARCHAR(30),
               mov_rel_date DATE,
               mov_rel_country VARCHAR(10)
               );
               
CREATE TABLE  movie_genres (
                   mov_id INT NOT NULL,
                   gen_id INT NOT NULL REFERENCES genres (gen_id),
                   CONSTRAINT fk_mov_gen1 FOREIGN KEY(mov_id)  REFERENCES movie(mov_id),
                   CONSTRAINT fk_mov_gen2 FOREIGN KEY(gen_id)  REFERENCES genres(gen_id)
                   );
                   
CREATE TABLE  movie_direction (
                       dir_id INT NOT NULL REFERENCES director (dir_id),
                       mov_id INT NOT NULL REFERENCES movie (mov_id)
                       );

CREATE TABLE  reviewer (
                    rev_id INT NOT NULL PRIMARY KEY,
                    rev_name VARCHAR(30)
                    );
                    


CREATE TABLE rating (
                        mov_id INT NOT NULL REFERENCES movie (mov_id),
                        rev_id INT NOT NULL REFERENCES reviewer (rev_id),
                        rev_stars INT,
                        num_o_rating INT
                        );
                        

CREATE TABLE movie_cast (
                            act_id INT NOT NULL REFERENCES actor (act_id),
                            mov_id INT NOT NULL REFERENCES movie (mov_id),
                            role VARCHAR(30)
                            );
                            
CREATE TABLE actor (
			   act_id INT NOT NULL PRIMARY KEY,
			   act_fname VARCHAR(20),
			   act_lname VARCHAR(20),
			   act_gender VARCHAR(1)
			   );



