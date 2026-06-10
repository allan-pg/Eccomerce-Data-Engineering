{{ config(
    materialized='table',
    format='parquet',
    external_location='s3://ecomerce-silver123/silver/addresses/',
    partitioned_by=['load_date']
) }}

select  
	row_number() over(order by a.address_line) as address_sk,
    c.city_sk,
	a.address_line,
    current_date as load_date
from (
     select distinct address_line, postalcode, city
     from {{ source('bronze_db', 'bronze_user_location') }}) a
join {{ ref('cities') }} c on c.city = a.city and a.postalcode = c.postalcode