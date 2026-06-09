{{ config(
    materialized='table',
    format='parquet',
    external_location='s3://ecomerce-silver123/silver/user_address/',
    partitioned_by=['load_date']
) }}

with user_location as (
    SELECT 
    address_line,
    postalcode,
    row_number() over(order by address_line asc) as rn           
    FROM {{ source('bronze_db', 'bronze_user_location') }}
)
select 
    address_line,
    postalcode,
    current_date as load_date
from user_location
where rn = 1
