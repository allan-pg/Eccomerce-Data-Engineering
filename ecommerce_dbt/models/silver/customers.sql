{{ config(
    materialized='table',
    format='parquet',
    external_location='s3://ecomerce-silver123/silver/users/',
    partitioned_by=['load_date']
) }}

select 
	row_number() over(order by u.user_id, u.load_date) as user_sk,
    a.address_sk,
	u.user_id,
	u.first_name,
	u.last_name,
	u.birth_date,
	u.User_name,
	U.gender,
	u.eyecolor as eye_color,
	u.hair_color,
	u.hair_type,
	current_date as load_date
from {{ source('bronze_db', 'bronze_users') }} u
join {{ source('bronze_db', 'bronze_user_location') }} l on l.user_id = u.user_id
join {{ ref('adress') }} a on a.address_line = l.address_line