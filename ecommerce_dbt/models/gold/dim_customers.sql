{{ config(
    materialized='table',
    format='parquet',
    external_location='s3://ecomerce-gold321/silver/dim_customers/',
    partitioned_by=['load_date']
) }}

select 
	row_number() over(order by c.user_id, c.load_date) as user_sk,
	c.user_id,
	c.first_name,
	c.last_name,
	c.birth_date,
	c.User_name,
	c.gender,
	c.eye_color,
	c.hair_color,
	c.hair_type,
	current_date as load_date

from {{ ref('customers') }} c
