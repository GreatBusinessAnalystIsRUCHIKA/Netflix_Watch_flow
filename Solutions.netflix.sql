DROP TABLE IF EXISTS netflix;
CREATE TABLE netflix
(
    show_id      VARCHAR(5),
    type         VARCHAR(10),
    title        VARCHAR(250),
    director     VARCHAR(550),
    casts        VARCHAR(1050),
    country      VARCHAR(550),
    date_added   VARCHAR(55),
    release_year INT,
    rating       VARCHAR(15),
    duration     VARCHAR(15),
    listed_in    VARCHAR(250),
    description  VARCHAR(550)
);

1. What’s the Content Mix on Netflix?
How many Movies vs. TV Shows are available on Netflix?

SELECT 
    type,
    COUNT(*)
FROM netflix
GROUP BY 1;

2. Which Rating Dominates Netflix?
What is the most common rating for both Movies and TV Shows?

WITH RatingCounts AS (
    SELECT 
        type,
        rating,
        COUNT(*) AS rating_count
    FROM netflix
    GROUP BY type, rating
),
RankedRatings AS (
    SELECT 
        type,
        rating,
        rating_count,
        RANK() OVER (PARTITION BY type ORDER BY rating_count DESC) AS rank
    FROM RatingCounts
)
SELECT 
    type,
    rating AS most_frequent_rating
FROM RankedRatings
WHERE rank = 1;

3. Flashback to 2020: What Was Released?
Can we list all the Movies and TV Shows that debuted on Netflix in 2020?

SELECT * 
FROM netflix
WHERE release_year = 2020;

4. Which Countries Contribute the Most to Netflix’s Library?
Which top 5 countries have the highest number of content titles on Netflix?

SELECT * 
FROM
(
    SELECT 
        UNNEST(STRING_TO_ARRAY(country, ',')) AS country,
        COUNT(*) AS total_content
    FROM netflix
    GROUP BY 1
) AS t1
WHERE country IS NOT NULL
ORDER BY total_content DESC
LIMIT 5;

5. What’s the Longest Movie on Netflix?
Which film holds the record for the longest runtime?

SELECT 
    *
FROM netflix
WHERE type = 'Movie'
ORDER BY SPLIT_PART(duration, ' ', 1)::INT DESC;

6. What's New? Content Added in the Last 5 Years
What are the latest Movies and TV Shows added to Netflix in the past 5 years?

SELECT *
FROM netflix
WHERE TO_DATE(date_added, 'Month DD, YYYY') >= CURRENT_DATE - INTERVAL '5 years';

7. The Works of Rajiv Chilaka
Which Movies and TV Shows has director Rajiv Chilaka created on Netflix?

SELECT *
FROM (
    SELECT 
        *,
        UNNEST(STRING_TO_ARRAY(director, ',')) AS director_name
    FROM netflix
) AS t
WHERE director_name = 'Rajiv Chilaka';

8. Which TV Shows Have the Most Seasons?
Can we find TV Shows with more than 5 seasons?

SELECT *
FROM netflix
WHERE type = 'TV Show'
  AND SPLIT_PART(duration, ' ', 1)::INT > 5;

9. What Are the Most Popular Genres on Netflix?
How many content items belong to each genre?

SELECT 
    UNNEST(STRING_TO_ARRAY(listed_in, ',')) AS genre,
    COUNT(*) AS total_content
FROM netflix
GROUP BY 1;

10. When Did India Release the Most Content on Netflix?
Which 5 years saw the highest average content releases from India?

SELECT 
    country,
    release_year,
    COUNT(show_id) AS total_release,
    ROUND(
        COUNT(show_id)::numeric /
        (SELECT COUNT(show_id) FROM netflix WHERE country = 'India')::numeric * 100, 2
    ) AS avg_release
FROM netflix
WHERE country = 'India'
GROUP BY country, release_year
ORDER BY avg_release DESC
LIMIT 5;

11. Exploring Netflix’s Documentary Collection
Which Movies are categorized as Documentaries?

SELECT * 
FROM netflix
WHERE listed_in LIKE '%Documentaries';

12. Who Needs a Director?
Can we find content that was released without a director?

SELECT * 
FROM netflix
WHERE director IS NULL;

13. How Many Salman Khan Movies Were Released in the Last 10 Years?
How frequently has Salman Khan appeared in Netflix-released Movies over the past decade?

SELECT * 
FROM netflix
WHERE casts LIKE '%Salman Khan%'
  AND release_year > EXTRACT(YEAR FROM CURRENT_DATE) - 10;

14. Bollywood’s Busiest Stars
Who are the top 10 most-featured actors in Indian Netflix Movies?


SELECT 
    UNNEST(STRING_TO_ARRAY(casts, ',')) AS actor,
    COUNT(*)
FROM netflix
WHERE country = 'India'
GROUP BY actor
ORDER BY COUNT(*) DESC
LIMIT 10;

15. How Violent Is Netflix?
Can we classify Netflix content as 'Bad' (mentions ‘kill’ or ‘violence’) or 'Good' based on descriptions?

SELECT 
    category,
    COUNT(*) AS content_count
FROM (
    SELECT 
        CASE 
            WHEN description ILIKE '%kill%' OR description ILIKE '%violence%' THEN 'Bad'
            ELSE 'Good'
        END AS category
    FROM netflix
) AS categorized_content
GROUP BY category;

