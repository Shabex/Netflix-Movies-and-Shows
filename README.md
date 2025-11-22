 # Netflix-Movies-and-TV Shows SQL data Analysis
![Netflix Logo](https://github.com/Shabex/Netflix-Movies-and-Shows/blob/main/netflix-logo-png-fqwt81hprrz7xsfg.jpg)

# Overview
This project involves a comprehensive analysis of Netflix's movies and TV shows data using SQL. The goal is to extract valuable insights and answer various business questions based on the dataset. The following README provides a detailed account of the project's objectives, business problems, solutions, findings, and conclusions.

# Objectives
- Analyze the distribution of content types (movies vs TV shows).
- Identify the most common ratings for movies and TV shows.
- List and analyze content based on release years, countries, and durations.
- Explore and categorize content based on specific criteria and keywords.
  
# Dataset
The data for this project is sourced from the Kaggle dataset:

Dataset Link: Movies Dataset
Schema
```sql
drop table if exists netflix;

create table netflix 
(
	show_id	varchar(10),					
	type varchar(10),
	title varchar(120),
	director varchar(220),
	casts varchar(780),
	country	 varchar(130),
	date_added date,
	release_year int,
	rating	varchar(10),
	duration varchar(15),
	listed_in varchar(100),
	description varchar(280)
);

select * from netflix;

select count(*) from netflix;
```
Business Problems and Solutions
1. Count the Number of Movies vs TV Shows
```sql
select * from netflix;

select 
   		type,
   		count(*) as total_types
	from netflix
	group by type;

```
Objective: Determine the distribution of content types on Netflix.

2. Find the Most Common Rating for Movies and TV Shows
   --  Used CTE
``` sql

select * from netflix;

with t1 as (
			select 	type,
					rating,
					count(*) as counts,
					rank() over(partition by type order by count(*) desc) as ranking
				from netflix
				group by 1,2
			)
	select 
			type,
			rating,
			counts,
			ranking
		from t1
		where ranking = 1;
	
```
Objective: Identify the most frequently occurring rating for each type of content.

3. List All Movies Released in a Specific Year (e.g., 2020)
``` sql
Select * from netflix;

Select *
	from netflix
	where release_year = 2020 
		and 
			type = 'Movie'
	order by title;
```
Objective: Retrieve all movies released in a specific year.

4. 
   
5. 


6. 


7. Find the Top 5 Countries with the Most Content on Netflix
``` sql
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
```
Objective: Identify the top 5 countries with the highest number of content items.

6. Identify the Longest Movie
```sql
SELECT 
    *
FROM netflix
WHERE type = 'Movie'
ORDER BY SPLIT_PART(duration, ' ', 1)::INT DESC;
```
Objective: Find the movie with the longest duration.

8. Find Content Added in the Last 5 Years
```sql
SELECT *
FROM netflix
WHERE TO_DATE(date_added, 'Month DD, YYYY') >= CURRENT_DATE - INTERVAL '5 years';
```
Objective: Retrieve content added to Netflix in the last 5 years.

10. Find All Movies/TV Shows by Director 'Rajiv Chilaka'
```sql
SELECT *
FROM (
    SELECT 
        *,
        UNNEST(STRING_TO_ARRAY(director, ',')) AS director_name
    FROM netflix
) AS t
WHERE director_name = 'Rajiv Chilaka';
```
Objective: List all content directed by 'Rajiv Chilaka'.

12. List All TV Shows with More Than 5 Seasons
```sql
SELECT *
FROM netflix
WHERE type = 'TV Show'
  AND SPLIT_PART(duration, ' ', 1)::INT > 5;
```
Objective: Identify TV shows with more than 5 seasons.

14. Count the Number of Content Items in Each Genre
```sql
SELECT 
    UNNEST(STRING_TO_ARRAY(listed_in, ',')) AS genre,
    COUNT(*) AS total_content
FROM netflix
GROUP BY 1;
```
Objective: Count the number of content items in each genre.

10.Find each year and the average numbers of content release in India on netflix.
return top 5 year with highest avg content release!
```sql
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
```
Objective: Calculate and rank years by the average number of content releases by India.

11. List All Movies that are Documentaries'
```sql
SELECT * 
FROM netflix
WHERE listed_in LIKE '%Documentaries';
```
Objective: Retrieve all movies classified as documentaries.

13. Find All Content Without a Director
```sql
SELECT * 
FROM netflix
WHERE director IS NULL;
```
Objective: List content that does not have a director.

15. Find How Many Movies Actor 'Salman Khan' Appeared in the Last 10 Years
```sql
SELECT * 
FROM netflix
WHERE casts LIKE '%Salman Khan%'
  AND release_year > EXTRACT(YEAR FROM CURRENT_DATE) - 10;
```
Objective: Count the number of movies featuring 'Salman Khan' in the last 10 years.


17. Find the Top 10 Actors Who Have Appeared in the Highest Number of Movies Produced in India
```sql
SELECT 
    UNNEST(STRING_TO_ARRAY(casts, ',')) AS actor,
    COUNT(*)
FROM netflix
WHERE country = 'India'
GROUP BY actor
ORDER BY COUNT(*) DESC
LIMIT 10;
```
Objective: Identify the top 10 actors with the most appearances in Indian-produced movies.

19. Categorize Content Based on the Presence of 'Kill' and 'Violence' Keywords
```sql
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
```
Objective: Categorize content as 'Bad' if it contains 'kill' or 'violence' and 'Good' otherwise. Count the number of items in each category.

Findings and Conclusion
Content Distribution: The dataset contains a diverse range of movies and TV shows with varying ratings and genres.
Common Ratings: Insights into the most common ratings provide an understanding of the content's target audience.
Geographical Insights: The top countries and the average content releases by India highlight regional content distribution.
Content Categorization: Categorizing content based on specific keywords helps in understanding the nature of content available on Netflix.
This analysis provides a comprehensive view of Netflix's content and can help inform content strategy and decision-making.

Author - Shaban Ibrahim
