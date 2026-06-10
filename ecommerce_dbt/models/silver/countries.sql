{{ config(
    materialized='table',
    format='parquet',
    external_location='s3://ecomerce-silver123/silver/countries/',
    partitioned_by=['load_date']
) }}

select 
    row_number() over(order by country) as country_sk,
    country,
    current_date as load_date
from (
        select distinct country 
        from {{ source('bronze_db', 'bronze_user_location') }}
    )