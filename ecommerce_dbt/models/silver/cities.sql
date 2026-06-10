{{ config(
    materialized='table',
    format='parquet',
    external_location='s3://ecomerce-silver123/silver/cities/',
    partitioned_by=['load_date']
) }}

select 
    row_number() over(order by c.city) as city_sk,
    c.city,
    c.postalcode,
    s.state_sk,
    current_date as load_date
from (
    select distinct state, city, postalcode
    from {{ source('bronze_db', 'bronze_user_location') }}) c

join {{ ref('states') }} s on s.state = c.state