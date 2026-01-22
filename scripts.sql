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
