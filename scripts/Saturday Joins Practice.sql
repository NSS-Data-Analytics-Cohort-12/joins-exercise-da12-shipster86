-- 1. Give the name, release year, and worldwide gross of the lowest grossing movie.
SELECT specs.film_title, specs.release_year, revenue.worldwide_gross
FROM specs
INNER JOIN revenue
USING (movie_id)
ORDER BY revenue.worldwide_gross;
--Semi-Tough, 1977, 37187139

-- 2. What year has the highest average imdb rating?
SELECT specs.release_year AS release_year, AVG(rating.imdb_rating) AS avg_rating
FROM specs
INNER JOIN rating
USING (movie_id)
	GROUP BY release_year
ORDER BY avg_rating DESC;
--1991

-- 3. What is the highest grossing G-rated movie? Which company distributed it?
SELECT revenue.worldwide_gross AS gross, specs.mpaa_rating AS rating, distributors.company_name, specs.film_title
FROM revenue
INNER JOIN specs
USING (movie_id)
INNER JOIN distributors
ON domestic_distributor_id = distributor_id
	WHERE mpaa_rating = 'G'
ORDER BY gross DESC;
-- Toy Story 4, Walt Disney

-- 4. Write a query that returns, for each distributor in the distributors table, the distributor name and the number of movies associated with that distributor in the movies 
-- table. Your result set should include all of the distributors, whether or not they have any movies in the movies table.
SELECT distributors.company_name AS company, COUNT(specs.film_title) AS total_films
FROM distributors
LEFT JOIN specs
ON distributor_id = domestic_distributor_id
GROUP BY company
	ORDER BY total_films DESC;

-- 5. Write a query that returns the five distributors with the highest average movie budget.
SELECT distributors.company_name AS company, AVG(revenue.film_budget) AS budget
FROM revenue
LEFT JOIN specs
USING (movie_id)
INNER JOIN distributors
ON domestic_distributor_id = distributor_id
	GROUP BY company
	ORDER BY budget DESC
	LIMIT 5;
--Walt Disney, Sony Pictures, Lionsgate, DreamWorks, Warner Bros.

-- 6. How many movies in the dataset are distributed by a company which is not headquartered in California? Which of these movies has the highest imdb rating?
SELECT specs.film_title, distributors.company_name AS company, distributors.headquarters AS location
FROM distributors
LEFT JOIN specs
ON domestic_distributor_id = distributor_id
	WHERE distributors.headquarters NOT LIKE '%CA'
GROUP BY location, company;

--Two movies.

SELECT specs.film_title AS movie, distributors.company_name AS company, distributors.headquarters AS location, rating.imdb_rating AS rating
FROM distributors
LEFT JOIN specs
ON domestic_distributor_id = distributor_id
	INNER JOIN rating
	USING (movie_id)
	WHERE distributors.headquarters NOT LIKE '%CA%';
-- My Big Fat Greek Wedding

-- 7. Which have a higher average rating, movies which are over two hours long or movies which are under two hours?
SELECT (specs.length_in_min/ 60) AS length, AVG(rating.imdb_rating) AS average_rating
FROM specs
LEFT JOIN rating
USING (movie_id)
GROUP BY length
ORDER BY length DESC;

--OR Jennifer's Union Idea:
SELECT 'movies over 2 hours' AS movie_length, AVG(rating.imdb_rating) AS avg_rating
FROM rating 
JOIN specs 
USING(movie_id)
WHERE specs.length_in_min >= 120

UNION 

SELECT 'movies under 2 hours' AS movie_length, AVG(rating.imdb_rating) AS avg_rating
FROM rating 
JOIN specs 
USING(movie_id)
WHERE specs.length_in_min < 120;