USE imdb;

/* Now that you have imported the data sets, let’s explore some of the tables. 
 To begin with, it is beneficial to know the shape of the tables and whether any column has null values.
 Further in this segment, you will take a look at 'movies' and 'genre' tables.*/



-- Segment 1:




-- Q1. Find the total number of rows in each table of the schema?
-- Type your code below:
SELECT 'director_mapping' AS table_name, COUNT(*) AS total_rows FROM director_mapping
UNION ALL
SELECT 'genre', COUNT(*) FROM genre
UNION ALL
SELECT 'movie', COUNT(*) FROM movie
UNION ALL
SELECT 'names', COUNT(*) FROM names
UNION ALL
SELECT 'ratings', COUNT(*) FROM ratings
UNION ALL
SELECT 'role_mapping', COUNT(*) FROM role_mapping;






-- Q2. Which columns in the movie table have null values?
-- Type your code below:
SELECT 'title' AS TABLE_NAME ,COUNT(*) AS TOTAL_NULL FROM movie WHERE title = NULL
UNION ALL 
SELECT 'year' , COUNT(*) FROM MOVIE WHERE year IS NULL
UNION ALL 
SELECT 'date_published' , COUNT(*) FROM MOVIE WHERE date_published IS NULL 
UNION ALL 
SELECT 'duration' , COUNT(*) FROM MOVIE WHERE duration IS NULL 
UNION ALL 
SELECT 'country', COUNT(*) FROM MOVIE WHERE country IS NULL 
UNION ALL 
SELECT 'worlwide_gross_income',COUNT(*) FROM MOVIE WHERE worlwide_gross_income IS NULL 
UNION ALL 
SELECT 'languages', COUNT(*) FROM MOVIE WHERE languages IS NULL 
UNION ALL 
SELECT 'production_company', COUNT(*) FROM MOVIE WHERE production_company IS NULL ;
/*country	20
worlwide_gross_income	3724
languages	194
production_company	528*/







-- Now as you can see four columns of the movie table has null values. Let's look at the at the movies released each year. 
-- Q3. Find the total number of movies released each year? How does the trend look month wise? (Output expected)

/* Output format for the first part:

+---------------+-------------------+
| Year			|	number_of_movies|
+-------------------+----------------
|	2017		|	2134			|
|	2018		|		.			|
|	2019		|		.			|
+---------------+-------------------+


Output format for the second part of the question:
+---------------+-------------------+
|	month_num	|	number_of_movies|
+---------------+----------------
|	1			|	 134			|
|	2			|	 231			|
|	.			|		.			|
+---------------+-------------------+ */
-- Type your code below:
-- PART -1 
SELECT 
  YEAR AS YEARS, 
  COUNT(*) AS number_of_movies 
FROM 
  MOVIE 
GROUP BY 
  YEAR;
 
-- PART 2 
SELECT 
  MONTH(date_published) AS MONTH_NUM, 
  COUNT(*) AS number_of_movies 
FROM 
  MOVIE 
WHERE 
  date_published IS NOT NULL 
GROUP BY 
  MONTH(date_published) 
ORDER BY 
  MONTH(date_published) ASC;











/*The highest number of movies is produced in the month of March.
So, now that you have understood the month-wise trend of movies, let’s take a look at the other details in the movies table. 
We know USA and India produces huge number of movies each year. Lets find the number of movies produced by USA or India for the last year.*/
  
-- Q4. How many movies were produced in the USA or India in the year 2019??
-- Type your code below:
SELECT 
  '2019' AS YEARS, 
  COUNT(*) AS NUM_OF_MOVIES 
FROM 
  MOVIE 
WHERE 
  YEAR = 2019 
  AND (
    COUNTRY LIKE '%INDIA%' 
    OR COUNTRY LIKE '%USA%'
  );










/* USA and India produced more than a thousand movies(you know the exact number!) in the year 2019.
Exploring table Genre would be fun!! 
Let’s find out the different genres in the dataset.*/

-- Q5. Find the unique list of the genres present in the data set?
-- Type your code below:

SELECT 
  DISTINCT GENRE 
FROM 
  GENRE;
 











/* So, RSVP Movies plans to make a movie of one of these genres.
Now, wouldn’t you want to know which genre had the highest number of movies produced in the last year?
Combining both the movie and genres table can give more interesting insights. */

-- Q6.Which genre had the highest number of movies produced overall?
-- Type your code below:
SELECT 
  GENRE, 
  COUNT(ID) AS NO_OF_MOVIES 
FROM 
  MOVIE AS M 
  INNER JOIN GENRE AS G ON M.ID = G.movie_id 
GROUP BY 
  GENRE 
ORDER BY 
  NO_OF_MOVIES DESC;









/* So, based on the insight that you just drew, RSVP Movies should focus on the ‘Drama’ genre. 
But wait, it is too early to decide. A movie can belong to two or more genres. 
So, let’s find out the count of movies that belong to only one genre.*/

-- Q7. How many movies belong to only one genre?
-- Type your code below:
-- Q7. How many movies belong to only one genre?

SELECT 
    COUNT(*) AS movies_with_one_genre
FROM (
    SELECT 
        movie_id
    FROM 
        genre
    GROUP BY 
        movie_id
    HAVING 
        COUNT(genre) = 1
) AS single_genre_movies;










/* There are more than three thousand movies which has only one genre associated with them.
So, this figure appears significant. 
Now, let's find out the possible duration of RSVP Movies’ next project.*/

-- Q8.What is the average duration of movies in each genre? 
-- (Note: The same movie can belong to multiple genres.)


/* Output format:

+---------------+-------------------+
| genre			|	avg_duration	|
+-------------------+----------------
|	thriller	|		105			|
|	.			|		.			|
|	.			|		.			|
+---------------+-------------------+ */
-- Type your code below:
SELECT 
  GENRE, 
  ROUND(AVG(duration),2) AS AVG_DURATION 
FROM 
  MOVIE AS M 
  INNER JOIN GENRE AS G ON M.ID = G.MOVIE_ID 
GROUP BY 
  GENRE;









/* Now you know, movies of genre 'Drama' (produced highest in number in 2019) has the average duration of 106.77 mins.
Lets find where the movies of genre 'thriller' on the basis of number of movies.*/

-- Q9.What is the rank of the ‘thriller’ genre of movies among all the genres in terms of number of movies produced? 
-- (Hint: Use the Rank function)
/* Output format:
+---------------+-------------------+---------------------+
| genre			|		movie_count	|		genre_rank    |	
+---------------+-------------------+---------------------+
|drama			|	2312			|			2		  |
+---------------+-------------------+---------------------+*/
-- Type your code below:
WITH GENRE_COUNT AS (
  SELECT 
    GENRE, 
    COUNT(ID) AS MOVIE_COUNT, 
    RANK() OVER(
      ORDER BY 
        COUNT(ID) DESC
    ) AS GENRE_RANK 
  FROM 
    MOVIE AS M 
    INNER JOIN GENRE AS G ON M.ID = G.MOVIE_ID 
  GROUP BY 
    GENRE
) 
SELECT 
  GENRE, 
  MOVIE_COUNT, 
  GENRE_RANK 
FROM 
  GENRE_COUNT 
WHERE 
  GENRE = 'thriller';










/*Thriller movies is in top 3 among all genres in terms of number of movies
 In the previous segment, you analysed the movies and genres tables. 
 In this segment, you will analyse the ratings table as well.
To start with lets get the min and max values of different columns in the table*/




-- Segment 2:




-- Q10.  Find the minimum and maximum values in  each column of the ratings table except the movie_id column?
/* Output format:
+---------------+-------------------+---------------------+----------------------+-----------------+-----------------+
| min_avg_rating|	max_avg_rating	|	min_total_votes   |	max_total_votes 	 |min_median_rating|max_median_rating|
+---------------+-------------------+---------------------+----------------------+-----------------+-----------------+
|		0		|			5		|	       177		  |	   2000	    		 |		0	       |	8			 |
+---------------+-------------------+---------------------+----------------------+-----------------+-----------------+*/
-- Type your code below:

SELECT 
  MIN(avg_rating) AS min_avg_rating, 
  MAX(avg_rating) AS max_avg_rating, 
  MIN(total_votes) AS min_total_votes, 
  MAX(total_votes) AS max_total_votes, 
  MIN(median_rating) AS min_median_rating, 
  MAX(median_rating) AS max_median_rating 
FROM 
  RATINGS;








    

/* So, the minimum and maximum values in each column of the ratings table are in the expected range. 
This implies there are no outliers in the table. 
Now, let’s find out the top 10 movies based on average rating.*/

-- Q11. Which are the top 10 movies based on average rating?
/* Output format:
+---------------+-------------------+---------------------+
| title			|		avg_rating	|		movie_rank    |
+---------------+-------------------+---------------------+
| Fan			|		9.6			|			5	  	  |
|	.			|		.			|			.		  |
|	.			|		.			|			.		  |
|	.			|		.			|			.		  |
+---------------+-------------------+---------------------+*/
-- Type your code below:
-- Keep in mind that multiple movies can be at the same rank. You only have to find out the top 10 movies (if there are more than one movies at the 10th place, consider them all.)


WITH MV_RANK AS (
  SELECT 
    TITLE, 
    AVG_RATING, 
    DENSE_RANK() OVER(
      ORDER BY 
        AVG_RATING DESC
    ) AS MOVIE_RANK 
  FROM 
    MOVIE AS M 
    INNER JOIN RATINGS AS R ON M.ID = R.MOVIE_ID
) 
SELECT 
  TITLE, 
  AVG_RATING, 
  MOVIE_RANK 
FROM 
  MV_RANK 
WHERE 
  MOVIE_RANK <= 10;








/* Do you find you favourite movie FAN in the top 10 movies with an average rating of 9.6? If not, please check your code again!!
So, now that you know the top 10 movies, do you think character actors and filler actors can be from these movies?
Summarising the ratings table based on the movie counts by median rating can give an excellent insight.*/

-- Q12. Summarise the ratings table based on the movie counts by median ratings.
/* Output format:

+---------------+-------------------+
| median_rating	|	movie_count		|
+-------------------+----------------
|	1			|		105			|
|	.			|		.			|
|	.			|		.			|
+---------------+-------------------+ */
-- Type your code below:
-- Order by is good to have
SELECT 
  median_rating, 
  COUNT(ID) AS MOVIE_COUNT 
FROM 
  MOVIE AS M 
  INNER JOIN RATINGS AS R ON M.ID = R.MOVIE_ID 
GROUP BY 
  MEDIAN_RATING 
ORDER BY 
  MEDIAN_RATING ASC;






/* Movies with a median rating of 7 is highest in number. 
Now, let's find out the production house with which RSVP Movies can partner for its next project.*/

-- Q13. Which production house has produced the most number of hit movies (average rating > 8)??
/* Output format:
+------------------+-------------------+---------------------+
|production_company|movie_count	       |	prod_company_rank|
+------------------+-------------------+---------------------+
| The Archers	   |		1		   |			1	  	 |
+------------------+-------------------+---------------------+*/
-- Type your code below:
WITH MV_PROD AS (
  SELECT 
    production_company, 
    COUNT(ID) AS MOVIE_COUNT, 
    AVG_RATING, 
    DENSE_RANK() OVER(
      ORDER BY 
        COUNT(ID)
    ) AS PROD_COMPANY_RANK 
  FROM 
    MOVIE AS M 
    INNER JOIN RATINGS AS R ON M.ID = R.MOVIE_ID 
  GROUP BY 
    PRODUCTION_COMPANY, 
    AVG_RATING
) 
SELECT 
  PRODUCTION_COMPANY, 
  MOVIE_COUNT, 
  PROD_COMPANY_RANK 
FROM 
  MV_PROD 
WHERE 
  AVG_RATING > 8 
  AND PRODUCTION_COMPANY IS NOT NULL;









-- It's ok if RANK() or DENSE_RANK() is used too
-- Answer can be Dream Warrior Pictures or National Theatre Live or both

-- Q14. How many movies released in each genre during March 2017 in the USA had more than 1,000 votes?
/* Output format:

+---------------+-------------------+
| genre			|	movie_count		|
+-------------------+----------------
|	thriller	|		105			|
|	.			|		.			|
|	.			|		.			|
+---------------+-------------------+ */
-- Type your code below:
SELECT 
  GENRE, 
  COUNT(ID) AS MOVIE_COUNT 
FROM 
  MOVIE AS M 
  INNER JOIN RATINGS AS R ON M.ID = R.MOVIE_ID 
  INNER JOIN GENRE AS G ON M.ID = G.MOVIE_ID 
WHERE 
  YEAR = 2017 
  AND MONTH(date_published)= 3 
  AND COUNTRY = 'USA' 
  AND TOTAL_VOTES > 1000 
GROUP BY 
  GENRE 
ORDER BY 
  MOVIE_COUNT DESC;





-- Lets try to analyse with a unique problem statement.
-- Q15. Find movies of each genre that start with the word ‘The’ and which have an average rating > 8?
/* Output format:
+---------------+-------------------+---------------------+
| title			|		avg_rating	|		genre	      |
+---------------+-------------------+---------------------+
| Theeran		|		8.3			|		Thriller	  |
|	.			|		.			|			.		  |
|	.			|		.			|			.		  |
|	.			|		.			|			.		  |
+---------------+-------------------+---------------------+*/
-- Type your code below:

SELECT 
  TITLE, 
  avg_rating, 
  GENRE 
FROM 
  MOVIE AS M 
  INNER JOIN GENRE AS G ON M.ID = G.MOVIE_ID 
  INNER JOIN RATINGS AS R ON M.ID = R.MOVIE_ID 
WHERE 
  TITLE LIKE '%THE%' 
  AND avg_rating > 8 
ORDER BY 
  avg_rating DESC;








-- You should also try your hand at median rating and check whether the ‘median rating’ column gives any significant insights.
-- Q16. Of the movies released between 1 April 2018 and 1 April 2019, how many were given a median rating of 8?
-- Type your code below:
SELECT 
  TITLE, 
  median_rating, 
  date_published 
FROM 
  MOVIE AS M 
  INNER JOIN RATINGS AS R ON M.ID = R.MOVIE_ID 
WHERE 
  DATE(date_published) >= '2018-4-1' 
  AND DATE(date_published) <= '2019-4-1' 
  AND median_rating = 8 
ORDER BY 
  DATE_PUBLISHED;









-- Once again, try to solve the problem given below.
-- Q17. Do German movies get more votes than Italian movies? 
-- Hint: Here you have to find the total number of votes for both German and Italian movies.
-- Type your code below:
SELECT 
  languages, 
  SUM(total_votes) AS TOTAL_VOTES 
FROM 
  MOVIE AS M 
  INNER JOIN RATINGS AS R ON M.ID = R.MOVIE_ID 
WHERE 
  LANGUAGES = 'Italian' 
  OR LANGUAGES = 'German' 
GROUP BY 
  LANGUAGES;









-- Answer is Yes

/* Now that you have analysed the movies, genres and ratings tables, let us now analyse another table, the names table. 
Let’s begin by searching for null values in the tables.*/




-- Segment 3:



-- Q18. Which columns in the names table have null values??
/*Hint: You can find null values for individual columns or follow below output format
+---------------+-------------------+---------------------+----------------------+
| name_nulls	|	height_nulls	|date_of_birth_nulls  |known_for_movies_nulls|
+---------------+-------------------+---------------------+----------------------+
|		0		|			123		|	       1234		  |	   12345	    	 |
+---------------+-------------------+---------------------+----------------------+*/
-- Type your code below:
WITH NULL1 AS (
  SELECT 
    COUNT(*) AS name_nulls 
  FROM 
    NAMES 
  WHERE 
    NAME IS NULL
), 
NULL2 AS (
  SELECT 
    COUNT(*) AS height_nulls 
  FROM 
    NAMES 
  WHERE 
    height IS NULL
), 
NULL3 AS (
  SELECT 
    COUNT(*) AS date_of_birth_nulls 
  FROM 
    NAMES 
  WHERE 
    date_of_birth IS NULL
), 
NULL4 AS (
  SELECT 
    COUNT(*) AS known_for_movies_nulls 
  FROM 
    NAMES 
  WHERE 
    known_for_movies IS NULL
) 
SELECT 
  NAME_NULLS, 
  HEIGHT_NULLS, 
  date_of_birth_nulls, 
  known_for_movies_nulls 
FROM 
  NULL1, 
  NULL2, 
  NULL3, 
  NULL4;

 






/* There are no Null value in the column 'name'.
The director is the most important person in a movie crew. 
Let’s find out the top three directors in the top three genres who can be hired by RSVP Movies.*/

-- Q19. Who are the top three directors in the top three genres whose movies have an average rating > 8?
-- (Hint: The top three genres would have the most number of movies with an average rating > 8.)
/* Output format:

+---------------+-------------------+
| director_name	|	movie_count		|
+---------------+-------------------|
|James Mangold	|		4			|
|	.			|		.			|
|	.			|		.			|
+---------------+-------------------+ */
-- Type your code below:
with top_3_GENRE as (
  SELECT 
    GENRE, 
    COUNT(M.ID) AS MOVIE_COUNT 
  FROM 
    MOVIE AS M 
    INNER JOIN DIRECTOR_MAPPING AS D ON M.ID = D.MOVIE_ID 
    INNER JOIN NAMES AS N ON D.NAME_ID = N.ID 
    INNER JOIN GENRE AS G ON M.ID = G.MOVIE_ID 
    INNER JOIN RATINGS AS R ON M.ID = R.MOVIE_ID 
  WHERE 
    AVG_RATING > 8 
  GROUP BY 
    GENRE 
  ORDER BY 
    MOVIE_COUNT DESC 
  LIMIT 
    3
), DIRECTOR_NAMES AS (
  SELECT 
    N.NAME AS DIRECTOR_NAME, 
    G.GENRE, 
    COUNT(DISTINCT M.ID) AS MOVIE_COUNT 
  FROM 
    MOVIE AS M 
    INNER JOIN GENRE AS G ON M.ID = G.MOVIE_ID 
    INNER JOIN RATINGS AS R ON M.ID = R.MOVIE_ID 
    INNER JOIN DIRECTOR_MAPPING AS D ON M.ID = D.MOVIE_ID 
    INNER JOIN NAMES AS N ON N.ID = D.NAME_ID 
  WHERE 
    AVG_RATING > 8 
    AND G.GENRE IN (
      SELECT 
        GENRE 
      FROM 
        TOP_3_GENRE
    ) 
  GROUP BY 
    DIRECTOR_NAME, 
    G.GENRE
), 
DG_RANK AS (
  SELECT 
    DIRECTOR_NAME, 
    SUM(MOVIE_COUNT) AS MOVIE_COUNT, 
    DENSE_RANK() OVER(
      ORDER BY 
        SUM(MOVIE_COUNT) DESC
    ) AS RANKS 
  FROM 
    DIRECTOR_NAMES 
  GROUP BY 
    DIRECTOR_NAME
) 
SELECT 
  DIRECTOR_NAME, 
  MOVIE_COUNT 
FROM 
  DG_RANK 
WHERE 
  RANKS <= 3;




/* James Mangold can be hired as the director for RSVP's next project. Do you remeber his movies, 'Logan' and 'The Wolverine'. 
Now, let’s find out the top two actors.*/

-- Q20. Who are the top two actors whose movies have a median rating >= 8?
/* Output format:

+---------------+-------------------+
| actor_name	|	movie_count		|
+-------------------+----------------
|Christain Bale	|		10			|
|	.			|		.			|
+---------------+-------------------+ */
-- Type your code below:
WITH TOP_2_ACTOR AS (
  SELECT 
    N.NAME AS ACTOR_NAME, 
    COUNT(DISTINCT M.ID) AS MOVIE_COUNT, 
    DENSE_RANK() OVER(
      ORDER BY 
        COUNT(DISTINCT M.ID) DESC
    ) AS RANKS 
  FROM 
    MOVIE AS M 
    INNER JOIN RATINGS AS R ON M.ID = R.MOVIE_ID 
    INNER JOIN ROLE_MAPPING AS RM ON RM.MOVIE_ID = M.ID 
    INNER JOIN NAMES AS N ON N.ID = RM.NAME_ID 
  WHERE 
    R.MEDIAN_RATING >= 8 
    AND CATEGORY = 'ACTOR' 
  GROUP BY 
    ACTOR_NAME 
  ORDER BY 
    MOVIE_COUNT DESC
) 
SELECT 
  ACTOR_NAME, 
  MOVIE_COUNT 
FROM 
  TOP_2_ACTOR 
WHERE 
  RANKS <= 2;








/* Have you find your favourite actor 'Mohanlal' in the list. If no, please check your code again. 
RSVP Movies plans to partner with other global production houses. 
Let’s find out the top three production houses in the world.*/

-- Q21. Which are the top three production houses based on the number of votes received by their movies?
/* Output format:
+------------------+--------------------+---------------------+
|production_company |   vote_count		|		prod_comp_rank|
+------------------+--------------------+---------------------+
| The Archers		|		830			|		1	  		  |
|	.				|		.			|			.		  |
|	.				|		.			|			.		  |
+-------------------+-------------------+---------------------+*/
-- Type your code below:
SELECT 
  PRODUCTION_COMPANY AS PRODUCTION_HOUSES, 
  SUM(total_votes) AS VOTE_COUNT, 
  DENSE_RANK() OVER(
    ORDER BY 
      SUM(total_votes) DESC
  ) AS PROD_COMP_RANK 
FROM 
  MOVIE AS M 
  INNER JOIN RATINGS AS R ON R.MOVIE_ID = M.ID 
GROUP BY 
  PRODUCTION_HOUSES;










/*Yes Marvel Studios rules the movie world.
So, these are the top three production houses based on the number of votes received by the movies they have produced.

Since RSVP Movies is based out of Mumbai, India also wants to woo its local audience. 
RSVP Movies also wants to hire a few Indian actors for its upcoming project to give a regional feel. 
Let’s find who these actors could be.*/

-- Q22. Rank actors with movies released in India based on their average ratings. Which actor is at the top of the list?
-- Note: The actor should have acted in at least five Indian movies. 
-- (Hint: You should use the weighted average based on votes. If the ratings clash, then the total number of votes should act as the tie breaker.)

/* Output format:
+---------------+-------------------+---------------------+----------------------+-----------------+
| actor_name	|	total_votes		|	movie_count		  |	actor_avg_rating 	 |actor_rank	   |
+---------------+-------------------+---------------------+----------------------+-----------------+
|	Yogi Babu	|			3455	|	       11		  |	   8.42	    		 |		1	       |
|		.		|			.		|	       .		  |	   .	    		 |		.	       |
|		.		|			.		|	       .		  |	   .	    		 |		.	       |
|		.		|			.		|	       .		  |	   .	    		 |		.	       |
+---------------+-------------------+---------------------+----------------------+-----------------+*/
-- Type your code below:
WITH ACTOR AS (
  SELECT 
    N.NAME AS ACTOR_NAME, 
    COUNT(DISTINCT M.ID) AS MOVIE_COUNT, 
    SUM(R.TOTAL_VOTES) AS TOTAL_VOTES, 
    SUM(R.AVG_RATING * R.TOTAL_VOTES)/ SUM(R.TOTAL_VOTES) AS AVG_RATING 
  FROM 
    MOVIE AS M 
    INNER JOIN RATINGS AS R ON M.ID = R.MOVIE_ID 
    INNER JOIN ROLE_MAPPING AS RM ON RM.MOVIE_ID = M.ID 
    INNER JOIN NAMES AS N ON N.ID = RM.NAME_ID 
  WHERE 
    CATEGORY = 'ACTOR' 
    AND M.COUNTRY = 'India' 
  GROUP BY 
    ACTOR_NAME 
  HAVING 
    COUNT(DISTINCT M.ID) >= 5
), 
RANK_ACTOR AS (
  SELECT 
    *, 
    DENSE_RANK() OVER(
      ORDER BY 
        TOTAL_VOTES DESC, 
        AVG_RATING DESC
    ) AS ACTOR_RANK 
  FROM 
    ACTOR
) 
SELECT 
  ACTOR_NAME, 
  TOTAL_VOTES, 
  MOVIE_COUNT, 
  ROUND(AVG_RATING, 2) AS AVG_RATING, 
  ACTOR_RANK 
FROM 
  RANK_ACTOR;









-- Top actor is Vijay Sethupathi

-- Q23.Find out the top five actresses in Hindi movies released in India based on their average ratings? 
-- Note: The actresses should have acted in at least three Indian movies. 
-- (Hint: You should use the weighted average based on votes. If the ratings clash, then the total number of votes should act as the tie breaker.)
/* Output format:
+---------------+-------------------+---------------------+----------------------+-----------------+
| actress_name	|	total_votes		|	movie_count		  |	actress_avg_rating 	 |actress_rank	   |
+---------------+-------------------+---------------------+----------------------+-----------------+
|	Tabu		|			3455	|	       11		  |	   8.42	    		 |		1	       |
|		.		|			.		|	       .		  |	   .	    		 |		.	       |
|		.		|			.		|	       .		  |	   .	    		 |		.	       |
|		.		|			.		|	       .		  |	   .	    		 |		.	       |
+---------------+-------------------+---------------------+----------------------+-----------------+*/
-- Type your code below:

WITH hindi_actresses AS (
    SELECT 
        n.name AS actress_name,
        COUNT(DISTINCT m.id) AS movie_count,
        SUM(r.total_votes) AS total_votes,
        ROUND(SUM(r.avg_rating * r.total_votes) / SUM(r.total_votes), 2) AS actress_avg_rating
    FROM 
        movie m
    JOIN 
        ratings r ON m.id = r.movie_id
    JOIN 
        role_mapping rm ON m.id = rm.movie_id
    JOIN 
        names n ON n.id = rm.name_id
    WHERE 
        m.country = 'India'
        AND m.languages = 'Hindi'
        AND rm.category = 'ACTRESS'
    GROUP BY 
        n.name
    HAVING 
        COUNT(DISTINCT m.id) >= 3
),
ranked_actresses AS (
    SELECT 
        *,
        DENSE_RANK() OVER (
            ORDER BY actress_avg_rating DESC, total_votes DESC
        ) AS actress_rank
    FROM 
        hindi_actresses
)
SELECT 
    actress_name,
    total_votes,
    movie_count,
    actress_avg_rating,
    actress_rank
FROM 
    ranked_actresses
WHERE 
    actress_rank <= 5
ORDER BY 
    actress_rank;




/* Taapsee Pannu tops with average rating 7.74. 
Now let us divide all the thriller movies in the following categories and find out their numbers.*/


/* Q24. Consider thriller movies having at least 25,000 votes. Classify them according to their average ratings in
   the following categories:  

			Rating > 8: Superhit
			Rating between 7 and 8: Hit
			Rating between 5 and 7: One-time-watch
			Rating < 5: Flop
	
    Note: Sort the output by average ratings (desc).
--------------------------------------------------------------------------------------------*/
/* Output format:
+---------------+-------------------+
| movie_name	|	movie_category	|
+---------------+-------------------+
|	Get Out		|			Hit		|
|		.		|			.		|
|		.		|			.		|
+---------------+-------------------+*/

-- Type your code below:
WITH THRILLER AS (
  SELECT 
    GENRE, 
    SUM(total_votes) AS TOTAL_VOTES, 
    TITLE AS MOVIE_NAME, 
    AVG(avg_rating) AS AVG_RATINGS 
  FROM 
    MOVIE AS M 
    INNER JOIN RATINGS AS R ON M.ID = R.MOVIE_ID 
    INNER JOIN GENRE AS G ON M.ID = G.MOVIE_ID 
  WHERE 
    GENRE = 'Thriller' 
  GROUP BY 
    TITLE, 
    GENRE 
  HAVING 
    SUM(total_votes) >= 25000 
  ORDER BY 
    AVG(avg_rating) DESC
) 
SELECT 
  MOVIE_NAME, 
  CASE WHEN AVG_RATINGS > 8 THEN 'SUPERHIT' WHEN AVG_rATINGS BETWEEN 7 
  AND 8 THEN 'HIT' WHEN AVG_RATINGS BETWEEN 5 
  AND 7 THEN 'ONE TIME WATCH' WHEN AVG_RATINGS < 5 THEN 'FLOP MOVIE' END AS MOVIE_CATEGORY 
FROM 
  THRILLER;





/* Until now, you have analysed various tables of the data set. 
Now, you will perform some tasks that will give you a broader understanding of the data in this segment.*/

-- Segment 4:

-- Q25. What is the genre-wise running total and moving average of the average movie duration? 
-- (Note: You need to show the output table in the question.) 
/* Output format:
+---------------+-------------------+---------------------+----------------------+
| genre			|	avg_duration	|running_total_duration|moving_avg_duration  |
+---------------+-------------------+---------------------+----------------------+
|	comdy		|			145		|	       106.2	  |	   128.42	    	 |
|		.		|			.		|	       .		  |	   .	    		 |
|		.		|			.		|	       .		  |	   .	    		 |
|		.		|			.		|	       .		  |	   .	    		 |
+---------------+-------------------+---------------------+----------------------+*/
-- Type your code below:
SELECT 
  GENRE, 
  ROUND(
    AVG(DURATION), 
    2
  ) AS AVG_DURATION, 
  ROUND(
    SUM(
      AVG(M.duration)
    ) OVER (
      ORDER BY 
        G.genre
    ), 
    2
  ) AS running_total_duration, 
  ROUND(
    AVG(
      AVG(M.duration)
    ) OVER (
      ORDER BY 
        G.genre ROWS BETWEEN 2 PRECEDING 
        AND CURRENT ROW
    ), 
    2
  ) AS moving_avg_duration 
FROM 
  MOVIE AS M 
  INNER JOIN GENRE AS G ON M.ID = G.MOVIE_ID 
GROUP BY 
  GENRE 
ORDER BY 
  AVG_DURATION DESC;









-- Round is good to have and not a must have; Same thing applies to sorting


-- Let us find top 5 movies of each year with top 3 genres.

-- Q26. Which are the five highest-grossing movies of each year that belong to the top three genres? 
-- (Note: The top 3 genres would have the most number of movies.)

/* Output format:
+---------------+-------------------+---------------------+----------------------+-----------------+
| genre			|	year			|	movie_name		  |worldwide_gross_income|movie_rank	   |
+---------------+-------------------+---------------------+----------------------+-----------------+
|	comedy		|			2017	|	       indian	  |	   $103244842	     |		1	       |
|		.		|			.		|	       .		  |	   .	    		 |		.	       |
|		.		|			.		|	       .		  |	   .	    		 |		.	       |
|		.		|			.		|	       .		  |	   .	    		 |		.	       |
+---------------+-------------------+---------------------+----------------------+-----------------+*/
-- Type your code below:

-- Top 3 Genres based on most number of movies
WITH TOP_3GENRE AS (
  SELECT 
    GENRE, 
    COUNT(id) AS COUNTS 
  FROM 
    MOVIE AS M 
    INNER JOIN GENRE AS G ON M.ID = G.MOVIE_ID 
  GROUP BY 
    GENRE 
  ORDER BY 
    COUNTS DESC 
  LIMIT 
    3
), GROSS_AMT AS (
  SELECT 
    GENRE, 
    YEAR(date_published) AS YEARS, 
    TITLE AS MOVIE_NAME, 
    CAST(
      REPLACE(
        REPLACE(worlwide_gross_income, '$', ''), 
        ',', 
        ''
      ) AS UNSIGNED
    ) AS WORLD_GROSS_INCOME 
  FROM 
    MOVIE AS M 
    INNER JOIN GENRE AS G ON G.MOVIE_ID = M.ID 
  WHERE 
    GENRE IN (
      SELECT 
        GENRE 
      FROM 
        TOP_3GENRE
    )
), 
RANKING AS (
  SELECT 
    GENRE, 
    YEARS, 
    MOVIE_NAME, 
    WORLD_GROSS_INCOME, 
    DENSE_RANK() OVER(
      PARTITION BY YEARS, 
      GENRE 
      ORDER BY 
        WORLD_GROSS_INCOME DESC
    ) AS MOVIE_RANK 
  FROM 
    GROSS_AMT
) 
SELECT 
  * 
FROM 
  RANKING 
WHERE 
  MOVIE_RANK <= 5;













-- Finally, let’s find out the names of the top two production houses that have produced the highest number of hits among multilingual movies.
-- Q27.  Which are the top two production houses that have produced the highest number of hits (median rating >= 8) among multilingual movies?
/* Output format:
+-------------------+-------------------+---------------------+
|production_company |movie_count		|		prod_comp_rank|
+-------------------+-------------------+---------------------+
| The Archers		|		830			|		1	  		  |
|	.				|		.			|			.		  |
|	.				|		.			|			.		  |
+-------------------+-------------------+---------------------+*/
-- Type your code below:
WITH PROD_MULTI AS (
  SELECT 
    production_company, 
    COUNT(ID) AS MOVIE_COUNT, 
    DENSE_RANK() OVER(
      ORDER BY 
        COUNT(ID) DESC
    ) AS PROD_CAMP_RANK 
  FROM 
    MOVIE AS M 
    INNER JOIN RATINGS AS R ON R.MOVIE_ID = M.ID 
  WHERE 
    median_rating >= 8 
    AND POSITION(',' IN m.languages) > 0 
  GROUP BY 
    production_company 
  HAVING 
    production_company IS NOT NULL 
  ORDER BY 
    MOVIE_COUNT DESC
) 
SELECT 
  * 
FROM 
  PROD_MULTI 
WHERE 
  PROD_CAMP_RANK <= 2;





-- Multilingual is the important piece in the above question. It was created using POSITION(',' IN languages)>0 logic
-- If there is a comma, that means the movie is of more than one language


-- Q28. Who are the top 3 actresses based on the number of Super Hit movies (Superhit movie: average rating of movie > 8) in 'drama' genre?

-- Note: Consider only superhit movies to calculate the actress average ratings.
-- (Hint: You should use the weighted average based on votes. If the ratings clash, then the total number of votes
-- should act as the tie breaker. If number of votes are same, sort alphabetically by actress name.)

/* Output format:
+---------------+-------------------+---------------------+----------------------+-----------------+
| actress_name	|	total_votes		|	movie_count		  |	  actress_avg_rating |actress_rank	   |
+---------------+-------------------+---------------------+----------------------+-----------------+
|	Laura Dern	|			1016	|	       1		  |	   9.6000		     |		1	       |
|		.		|			.		|	       .		  |	   .	    		 |		.	       |
|		.		|			.		|	       .		  |	   .	    		 |		.	       |
+---------------+-------------------+---------------------+----------------------+-----------------+*/

-- Type your code below:
WITH WEIGHTED AS (
  SELECT 
    NAME AS ACTRESS_NAME, 
    SUM(TOTAL_VOTES) AS TOTAL_VOTE, 
    COUNT(DISTINCT M.ID) AS MOVIE_COUNT, 
    ROUND(
      SUM(TOTAL_VOTES * AVG_RATING)/ SUM(TOTAL_VOTES), 
      4
    ) AS ACTRESS_AVG_RATING 
  FROM 
    MOVIE AS M 
    JOIN RATINGS AS R ON M.ID = R.MOVIE_ID 
    JOIN GENRE AS G ON M.ID = G.MOVIE_ID 
    JOIN role_mapping AS RM ON M.ID = RM.MOVIE_ID 
    JOIN NAMES AS N ON RM.NAME_ID = N.ID 
  WHERE 
    AVG_RATING > 8 
    AND GENRE = 'DRAMA' 
    AND category = 'actress' 
  GROUP BY 
    NAME
), 
RANKED AS (
  SELECT 
    *, 
    DENSE_RANK() OVER(
      ORDER BY 
        TOTAL_VOTE DESC, 
        ACTRESS_AVG_RATING DESC, 
        ACTRESS_NAME ASC
    ) AS ACTRESS_RANK 
  FROM 
    WEIGHTED
) 
SELECT 
  * 
FROM 
  RANKED 
WHERE 
  ACTRESS_RANK <= 3;








/* Q29. Get the following details for top 9 directors (based on number of movies)
Director id
Name
Number of movies
Average inter movie duration in days
Average movie ratings
Total votes
Min rating
Max rating
total movie durations

Format:
+---------------+-------------------+---------------------+----------------------+--------------+--------------+------------+------------+----------------+
| director_id	|	director_name	|	number_of_movies  |	avg_inter_movie_days |	avg_rating	| total_votes  | min_rating	| max_rating | total_duration |
+---------------+-------------------+---------------------+----------------------+--------------+--------------+------------+------------+----------------+
|nm1777967		|	A.L. Vijay		|			5		  |	       177			 |	   5.65	    |	1754	   |	3.7		|	6.9		 |		613		  |
|	.			|		.			|			.		  |	       .			 |	   .	    |	.		   |	.		|	.		 |		.		  |
|	.			|		.			|			.		  |	       .			 |	   .	    |	.		   |	.		|	.		 |		.		  |
|	.			|		.			|			.		  |	       .			 |	   .	    |	.		   |	.		|	.		 |		.		  |
|	.			|		.			|			.		  |	       .			 |	   .	    |	.		   |	.		|	.		 |		.		  |
|	.			|		.			|			.		  |	       .			 |	   .	    |	.		   |	.		|	.		 |		.		  |
|	.			|		.			|			.		  |	       .			 |	   .	    |	.		   |	.		|	.		 |		.		  |
|	.			|		.			|			.		  |	       .			 |	   .	    |	.		   |	.		|	.		 |		.		  |
|	.			|		.			|			.		  |	       .			 |	   .	    |	.		   |	.		|	.		 |		.		  |
+---------------+-------------------+---------------------+----------------------+--------------+--------------+------------+------------+----------------+

--------------------------------------------------------------------------------------------*/
-- Type you code below:
SELECT 
  NAME_ID AS DIRECTOR_ID, 
  NAME AS DIRECTOR_NAME, 
  COUNT(M.ID) AS NUMBER_OF_MOVIE, 
  AVG(duration) AS AVG_INTER_MOVIE_DAYS, 
  AVG(AVG_RATING) AS AVG_RATING, 
  SUM(TOTAL_VOTES) AS TOTAL_VOTES, 
  MIN(AVG_RATING) AS MIN_RATING, 
  MAX(AVG_RATING) AS MAX_RATING, 
  SUM(duration) AS TOTAL_DURATION 
FROM 
  MOVIE AS M 
  INNER JOIN RATINGS AS R ON M.ID = R.MOVIE_ID 
  INNER JOIN DIRECTOR_MAPPING AS DM ON DM.MOVIE_ID = M.ID 
  INNER JOIN NAMES AS N ON DM.NAME_ID = N.ID 
GROUP BY 
  DIRECTOR_ID, 
  DIRECTOR_NAME 
ORDER BY 
  NUMBER_OF_MOVIE DESC 
LIMIT 9;






