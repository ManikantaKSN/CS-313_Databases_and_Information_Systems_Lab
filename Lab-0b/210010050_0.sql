 --q1
 SELECT act_fname as fname, act_lname as lname FROM actor UNION SELECT dir_fname as fname, dir_lname as lname FROM director;
 --q2
 SELECT rev_name, mov_title, rev_stars FROM reviewer, movie, rating WHERE rating.rev_id=reviewer.rev_id AND rating.mov_id = movie.mov_id AND rating.rev_stars >=7 AND reviewer.rev_name IS NOT NULL;
 --q3
 SELECT mov_title FROM movie WHERE movie.mov_id NOT IN (SELECT mov_id FROM rating);
 --q4
 SELECT mov_title, mov_year, mov_duration, mov_rel_date, mov_rel_country FROM movie WHERE movie.mov_rel_country <> 'USA';
 --q5
 SELECT rev_name FROM reviewer, rating WHERE reviewer.rev_id = rating.rev_id AND rating.rev_stars IS NULL;
 --q6
 SELECT rev_name, mov_title, rev_stars FROM reviewer, movie, rating WHERE reviewer.rev_id = rating.rev_id AND movie.mov_id = rating.mov_id AND rating.rev_id IS NOT NULL AND rating.rev_stars IS NOT NULL AND reviewer.rev_name IS NOT NULL;
 --q7
 SELECT rev_name, mov_title FROM reviewer, movie, rating WHERE reviewer.rev_id = rating.rev_id AND movie.mov_id = rating.mov_id AND rating.rev_id IN (SELECT rev_id FROM rating GROUP BY rev_id HAVING COUNT(*)>1);
 --q8
 SELECT movie.mov_title FROM movie WHERE movie.mov_id IN(SELECT mov_id FROM rating WHERE rev_id NOT IN (SELECT rev_id FROM reviewer WHERE rev_name='Paul Monks'));
 --q9
 SELECT rev_name, mov_title, rev_stars FROM reviewer, movie, rating WHERE rating.rev_id = reviewer.rev_id AND rating.mov_id = movie.mov_id AND rating.rev_stars = (SELECT MIN(rating.rev_stars) FROM rating) ;
 --q10
 SELECT mov_title FROM movie, director, movie_direction WHERE movie.mov_id = movie_direction.mov_id AND director.dir_id = movie_direction.dir_id AND director.dir_fname = 'James' AND director.dir_lname = 'Cameron' ;
 --q11
 SELECT rev_name FROM reviewer, rating WHERE reviewer.rev_id = rating.rev_id AND rating.rev_stars IS NULL;
 --q12
 SELECT act_fname, act_lname FROM actor, movie, movie_cast WHERE movie.mov_id = movie_cast.mov_id AND actor.act_id = movie_cast.act_id AND NOT movie.mov_year BETWEEN 1990 AND 2000;
 --q13
 SELECT dir_fname,dir_lname, gen_title,COUNT(gen_title) AS no_of_movies FROM director NATURAL JOIN movie_direction NATURAL JOIN movie_genres NATURAL JOIN genres GROUP BY dir_fname, dir_lname,gen_title ORDER BY dir_fname,dir_lname;
 --q14
 SELECT mov_title, mov_year, gen_title, dir_fname || ' ' || dir_lname AS dir_name FROM movie, movie_genres, genres, movie_direction, director WHERE movie.mov_id = movie_genres.mov_id AND movie.mov_id = movie_direction.mov_id AND movie_genres.gen_id = genres.gen_id AND movie_direction.dir_id = director.dir_id ;
 --q15
 SELECT gen_title, AVG(mov_duration) AS avg_time, COUNT(gen_title) AS no_of_movies FROM movie NATURAL JOIN  movie_genres NATURAL JOIN  genres GROUP BY gen_title;
 --q16
 SELECT mov_title, mov_year, dir_fname, dir_lname, act_fname, act_lname, role FROM movie NATURAL JOIN movie_direction NATURAL JOIN movie_cast NATURAL JOIN director NATURAL JOIN actor WHERE mov_duration=(SELECT MIN(mov_duration) FROM movie) ;
 --q17
 SELECT rev_name, mov_title, rev_stars FROM rating NATURAL JOIN movie NATURAL JOIN reviewer WHERE reviewer.rev_name IS NOT NULL;
 --q18
 SELECT mov_title, dir_fname, dir_lname, rev_stars FROM movie NATURAL JOIN rating NATURAL JOIN movie_direction NATURAL JOIN director WHERE rating.rev_stars IS NOT NULL ;
 --q19
 SELECT act_fname, act_lname, mov_title, role FROM actor NATURAL JOIN movie NATURAL JOIN movie_cast NATURAL JOIN movie_direction NATURAL JOIN director WHERE actor.act_fname = director.dir_fname AND actor.act_lname = director.dir_lname;
 --q20
 SELECT act_fname, act_lname FROM actor NATURAL JOIN movie NATURAL JOIN movie_cast WHERE movie.mov_title= 'Chinatown' ;
 --q21
 SELECT mov_title FROM actor NATURAL JOIN movie NATURAL JOIN movie_cast WHERE actor.act_fname= 'Harrison' AND actor.act_lname= 'Ford' ;
 --q22
 SELECT mov_title, mov_year, rev_stars FROM movie NATURAL JOIN movie_genres NATURAL JOIN genres NATURAL JOIN rating WHERE gen_title = 'Mystery' AND rev_stars = (SELECT MIN(rating.rev_stars) FROM rating NATURAL JOIN movie_genres NATURAL JOIN genres WHERE gen_title = 'Mystery');
 --q23
 SELECT mov_title, act_fname || ' ' || act_lname as act_name, mov_year, role, gen_title, dir_fname || ' ' || dir_lname as dir_name, mov_rel_date, rev_stars FROM movie NATURAL JOIN actor NATURAL JOIN movie_genres NATURAL JOIN genres NATURAL JOIN movie_cast NATURAL JOIN director NATURAL JOIN movie_direction NATURAL JOIN rating WHERE actor.act_gender = 'F';
 --q24
 SELECT act_fname, act_lname FROM actor NATURAL JOIN movie NATURAL JOIN movie_cast WHERE movie.mov_year BETWEEN (SELECT MIN(mov_year) FROM movie NATURAL JOIN director NATURAL JOIN movie_direction WHERE director.dir_fname = 'Stanley' AND director.dir_lname = 'Kubrick') AND (SELECT MAX(mov_year) FROM movie NATURAL JOIN director NATURAL JOIN movie_direction WHERE director.dir_fname = 'Stanley' AND director.dir_lname = 'Kubrick');