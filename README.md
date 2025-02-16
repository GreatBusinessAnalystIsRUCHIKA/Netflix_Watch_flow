# Netflix_Content_flow_Analysis_using_sql
![Netlix_LOGO](https://github.com/GreatBusinessAnalystIsRUCHIKA/Netflix_Watch_flow/blob/main/HD-wallpaper-netflix-logo-black-logo-netflix-pro-red.jpg)

## 📌 Overview  
This project explores Netflix’s vast content library using **SQL**. The dataset includes details like movie titles, genres, release years, countries, ratings, and more. By writing SQL queries, we uncover trends, patterns, and insights about Netflix’s content distribution.  

## 🚀 Key Objectives  
This project aims to answer exciting questions, such as:  

- 📊 **Movies vs. TV Shows:** What's the distribution?  
- 🔍 **Most Common Ratings:** Which ratings dominate Netflix content?  
- 📆 **Netflix Evolution:** How has the content changed over time?  
- 🌍 **Top Content-Producing Countries:** Who contributes the most?  
- 🎥 **Longest Movie:** What’s the longest runtime on Netflix?  
- 📺 **TV Shows with Many Seasons:** Which shows have more than 5 seasons?  
- 🎭 **Most Featured Actors in India:** Who appears the most?  
- ⚔️ **Violent Content Analysis:** How many descriptions contain "violence" or "kill"?  

## 📊 Dataset Information  
- The dataset contains details of Netflix content, including:  
  - **Title, Type (Movie/TV Show), Genre, Director, Cast, Release Year, Country, Rating, Duration, Date Added, and Description**.  
- **Source:** [Netflix Movies and TV Shows Dataset](https://www.kaggle.com/datasets)  

## 🛠️ Technologies Used  
- **SQL (PostgreSQL)** – For writing and optimizing queries.  
- **Power BI / Tableau** *(Optional)* – For visualizing trends.  

## 📜 SQL Queries Used  
Some key SQL techniques applied:  

- 🔹 **String Functions:** `STRING_TO_ARRAY`, `SPLIT_PART`, `UNNEST`  
- 🔹 **Window Functions:** `RANK() OVER (PARTITION BY …)`  
- 🔹 **Aggregate Functions:** `COUNT()`, `AVG()`, `ROUND()`  
- 🔹 **Date Functions:** `TO_DATE`, `INTERVAL`

## 📈 Insights & Findings  
✅ **Movies dominate** Netflix’s content compared to TV Shows.  
✅ The **most frequent rating** for content is PG-13.  
✅ The **top 5 content-producing countries** include the USA, India, and the UK.  
✅ The **longest movie** on Netflix has a runtime of over 200 minutes!  
✅ Some TV shows run for **more than 10 seasons**.  
✅ A significant portion of descriptions contain **"violence" or "kill"**, hinting at action-heavy content.  

```sql
-- 1. Content Mix: How many Movies vs. TV Shows are available?  
SELECT type, COUNT(*) FROM netflix GROUP BY 1;

-- 2. Dominant Ratings: What is the most common rating for Movies and TV Shows?  
WITH RatingCounts AS (
    SELECT type, rating, COUNT(*) AS rating_count FROM netflix GROUP BY type, rating
),
RankedRatings AS (
    SELECT type, rating, rating_count, RANK() OVER (PARTITION BY type ORDER BY rating_count DESC) AS rank
    FROM RatingCounts
)
SELECT type, rating AS most_frequent_rating FROM RankedRatings WHERE rank = 1;

-- 3. Flashback to 2020: List all Movies & TV Shows released in 2020  
SELECT * FROM netflix WHERE release_year = 2020;

-- 4. Top 5 Countries with the most Netflix content  
SELECT country, COUNT(*) AS total_content FROM (
    SELECT UNNEST(STRING_TO_ARRAY(country, ',')) AS country FROM netflix
) AS t WHERE country IS NOT NULL GROUP BY country ORDER BY total_content DESC LIMIT 5;

-- 5. Longest Movie on Netflix  
SELECT * FROM netflix WHERE type = 'Movie' ORDER BY SPLIT_PART(duration, ' ', 1)::INT DESC LIMIT 1;

-- 6. Latest Movies & TV Shows added in the last 5 years  
SELECT * FROM netflix WHERE TO_DATE(date_added, 'Month DD, YYYY') >= CURRENT_DATE - INTERVAL '5 years';

-- 7. Works of Rajiv Chilaka  
SELECT * FROM (SELECT *, UNNEST(STRING_TO_ARRAY(director, ',')) AS director_name FROM netflix) AS t 
WHERE director_name = 'Rajiv Chilaka';

-- 8. TV Shows with more than 5 seasons  
SELECT * FROM netflix WHERE type = 'TV Show' AND SPLIT_PART(duration, ' ', 1)::INT > 5;

-- 9. Most Popular Genres  
SELECT UNNEST(STRING_TO_ARRAY(listed_in, ',')) AS genre, COUNT(*) AS total_content FROM netflix GROUP BY 1;

-- 10. Top 5 Years India Released the Most Content  
SELECT country, release_year, COUNT(show_id) AS total_release,
ROUND(COUNT(show_id)::numeric / (SELECT COUNT(show_id) FROM netflix WHERE country = 'India')::numeric * 100, 2) 
AS avg_release FROM netflix WHERE country = 'India' GROUP BY country, release_year ORDER BY avg_release DESC LIMIT 5;

-- 11. Netflix's Documentary Collection  
SELECT * FROM netflix WHERE listed_in LIKE '%Documentaries%';

-- 12. Content Released Without a Director  
SELECT * FROM netflix WHERE director IS NULL;

-- 13. Salman Khan Movies Released in the Last 10 Years  
SELECT * FROM netflix WHERE casts LIKE '%Salman Khan%' AND release_year > EXTRACT(YEAR FROM CURRENT_DATE) - 10;

-- 14. Bollywood’s Busiest Stars: Top 10 most-featured actors in Indian Netflix Movies  
SELECT UNNEST(STRING_TO_ARRAY(casts, ',')) AS actor, COUNT(*) FROM netflix WHERE country = 'India'
GROUP BY actor ORDER BY COUNT(*) DESC LIMIT 10;

-- 15. Classifying Netflix Content as 'Good' or 'Bad' based on violent descriptions  
SELECT category, COUNT(*) AS content_count FROM (
    SELECT CASE WHEN description ILIKE '%kill%' OR description ILIKE '%violence%' THEN 'Bad' ELSE 'Good' END AS category
    FROM netflix
) AS categorized_content GROUP BY category;

## 🎯 Future Enhancements  
- 🚀 Optimize queries for better performance.  
- 📊 Use **Power BI/Tableau** for interactive data visualization.  
- 🔍 Expand analysis to **trend forecasting over years**.  

## 📢 Let's Connect!  
💡 Found something interesting? Feel free to **fork** this repo, open **issues**, or contribute! 🚀  

---

### 🏆 Happy Querying! 🎬📊  
