--  Netflix Movies and Shows Project 3

-- 5	7	104	208	771	123	19	4	8	10	79	250
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

select count(*) 
		from netflix;

/*
	Business Problems to Solve
		1. Count the number of Movies vs TV Shows
		2. Find the most common rating for movies and TV shows
		3. List all movies released in a specific year (e.g., 2020)
		4. Find the top 5 countries with the most content on Netflix
		5. Identify the longest movie
		6. Find content added in the last 5 years
		7. Find all the movies/TV shows by director 'Rajiv Chilaka'!
		8. List all TV shows with more than 5 seasons
		9. Count the number of content items in each genre
		10.Find each year and the average numbers of content release in India on netflix. 
		return top 5 year with highest avg content release!
		11. List all movies that are documentaries
		12. Find all content without a director
		13. Find how many movies actor 'Salman Khan' appeared in last 10 years!
		14. Find the top 10 actors who have appeared in the highest number of movies produced in India.
		15.
		Categorize the content based on the presence of the keywords 'kill' and 'violence' in 
		the description field. Label content containing these keywords as 'Bad' and all other 
		content as 'Good'. Count how many items fall into each category.
*/

-- 1. Count the number of Movies vs TV Shows

select * from netflix;

select 
		type,
		count(*) as total_types
	from netflix
	group by type;

-- 2. Find the most common rating for movies and TV shows
--  Used CTE
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
	
	
-- 3. List all movies released in a specific year (e.g., 2020)
Select * from netflix;

Select *
	from netflix
	where release_year = 2020 
		and 
			type = 'Movie'
	order by title;

-- 	4. Find the top 5 countries with the most content on Netflix
			-- top 5 countries
			-- most content

select * from netflix;

select trim(unnest(string_to_array(country, ','))) as country
		from netflix;

select country,
	string_to_array(country, ',') as new_country,
	unnest(string_to_array(country, ',')) as each_country
	from netflix;

select 
		trim(unnest(string_to_array(country, ','))) as each_country,
		count(*)
	from netflix
	group by each_country
	order by 2 desc
	limit 5;

-- 	5. Identify the longest movie
select type,title,duration,
	max(split_part(duration,' ',1)::numeric) as max_length
	from netflix
	where 
		type ilike '%movie%'
		and 
		duration is not null
	group by title, type, duration
	order by max_length desc;

-- Alternative Method

alter table netflix
	add column durations int,
	add column units varchar(10);

update netflix
	set
		durations = REGEXP_REPLACE(duration, '\D', '', 'g') :: int,
		units = case
					when duration ilike '%min%' then 'mins'
					when duration ilike  '%season%' then 'season/s'
				end;

alter table netflix
	drop column duration;
	
select * from netflix;

select 	
		type,
		title,
		max(durations) as max_duration,
		units
	from netflix
	where type ='Movie'
	group by type, title,durations,units
	having durations = max(durations)
	order by max_duration desc
	limit 1;




-- 		6. Find content added in the last 5 years
select * from netflix;

select *
		from netflix
		where date_added >= current_date - interval '5 years';

select current_date;

-- 	7. Find all the movies/TV shows by director 'Rajiv Chilaka'!

select director from netflix;

select director,
	string_to_array(director, ',') as new_director,
	unnest(string_to_array(director, ',')) as each_director
	from netflix;

select 	
		type,
		trim(unnest(string_to_array(director, ','))) as director,
		title
	from netflix
	where director ilike '%Rajiv Chilaka%';

-- 8. List all TV shows with more than 5 seasons
		-- TV shows
		-- more than 5 seasons
select *
	from netflix;

select *
		-- max(split_part(duration,' ')::numeric) as max_length
		from netflix
		where
			type ilike '%TV%'
			and 
			split_part(duration,' ',1)::int >= 5 
		order by duration desc;

select * 
	from netflix
		where 
			type = 'TV Show' 
			and
			units ilike '%Season%'
			and 
			durations >= 5;

-- 	9. Count the number of content items in each genre
Select * from netflix;

select 
		-- string_to_array(listed_in,',') as genre_array,
		-- unnest(string_to_array(listed_in,',')) as genre_list,
		trim(unnest(string_to_array(listed_in,','))) as genre,
		count(*)
	from netflix
	group by 1
	order by 2 desc;
/* 10.Find each year and the average numbers of content release in India on netflix. 
		
		return top 5 year with highest avg content release!*/
			-- year release
			-- av no. of content
			-- country india
			-- top 5 average content

select 
	trim(unnest(string_to_array(country,','))) as countrys
	from netflix
	where country ='India';


select 
	 	country,
		Extract(Year from date_added) as year,
		count(*) as total,
		Round(count(*)::numeric/(select count (*) from netflix where country = 'India')::numeric*100,2) as Avg_content
	from netflix
	where country ilike '%India%'
	group by country, year
	order by Avg_content desc;

-- 11. List all movies that are documentaries
select *
	from netflix
	where listed_in = 'Documentaries';

select *
	from netflix
	where type ilike '%movie%'
		and
		listed_in ilike '%docume%';


-- 12. Find all content without a director
select *
	from netflix
	where director is null
		or director = '';

-- 13. Find how many movies actor 'Salman Khan' appeared in last 10 years!
		-- Movies
		-- Cast = Salman Khan
select
		count(*)
	from netflix
	where casts ilike '%Salman%'
		and 
		type ilike 'Movie'
		and 
		release_year>=extract(year from current_date)-10;

-- 14. Find the top 10 actors who have appeared in the highest number of movies produced in India.
		-- Top 10 Actor/Casts
		-- Highest number of - movies
		-- Country India

select *
	from netflix;
select 
		country,
		trim(actors) as actors,
		count(*) as No_of_movies
	from netflix
	cross join lateral unnest(string_to_array(casts,',')) as actors
	where country ilike '%India%'
		and type like 'Movie'
	group by trim(actors),country
	order by 3 desc
	limit 10;
	
/*
	15.
		Categorize the content based on the presence of the keywords 'kill' and 'violence' in 
		the description field. 
		Label content containing these keywords as 'Bad' and all other 
		content as 'Good'. 
		Count how many items fall into each category.
*/

select *
	from netflix;

with content_category as
		(
			select *,
			CASE
				WHEN description ilike '%kill%'  
					OR description ilike '%violence%' THEN 'Bad Content'
				else
					'Good Content'			
			END as category
		from netflix
		)
	select 
			category,
			count(*)
		from content_category
		group by category;



	
	
	


	