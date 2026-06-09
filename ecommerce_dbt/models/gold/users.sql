{{ config(
    materialized='table',
    format='parquet',
    external_location='s3://ecomerce-silver123/silver/users/',
    partitioned_by=['load_date']
) }}

with clean_users as (
    select *,
           row_number() over (
               partition by user_id
               order by load_date desc
           ) as rn_id
    from {{ source('bronze_db', 'bronze_users') }}
),
user_location as (
    SELECT user_id,
       address_line,
       postalcode,
       row_number() over(order by address_line asc) as location_id
       
    FROM {{ source('bronze_db', 'bronze_user_location') }}
)
select
    cu.user_id,
    cu.first_name,
    cu.last_name,
    cu.age,
    cu.gender,
    cu.birth_date,
    row_number() over (order by cu.user_id) as user_sk,
    ul.location_id,
    current_date as load_date   
from clean_users as cu
join user_location as ul
on cu.user_id = ul.user_id
where rn_id = 1
