-- ==== Setup & data understanding ======

-- upload data and check all columns
select * from top_rated_mov_tmdb_1902_2026.top_rated_movies;

-- check the total number of rows
select count(*) as total_raw_rows
from top_rated_mov_tmdb_1902_2026.top_rated_movies;

-- check the unique id's in raw data
select count(distinct id) from top_rated_mov_tmdb_1902_2026.top_rated_movies;

-- check the column names
select column_name 
from information_schema.columns
where table_schema = 'top_rated_mov_tmdb_1902_2026'
and table_name = 'top_rated_movies';

-- ======================================
-- Cleaning Data to Silver & Gold Layers
-- ======================================
with base as (
select id
	, trim(title) as title
	, trim(regexp_replace(overview, E'[\\r\\n]+', ' ', 'g')) as overview
	, nullif(trim(release_date), '')::date as release_date
	, popularity::float4 as popularity
	, vote_average::float4 as vote_average
	, vote_count::int as vote_count
	, row_number() over(partition by id order by id asc) as id_rank
from top_rated_mov_tmdb_1902_2026.top_rated_movies
) select id
	, title
	, overview
	, release_date
	, popularity
	, vote_average
	, vote_count
	, case 
		when release_date is not null then true
		else false
	end as has_release_date
	, case
		when (row_number() over(order by popularity desc)::numeric / count(*) over() * 100)::numeric < 0.99 then true
		else false
	end as is_popularity_outlier
from base
where id_rank = 1;
