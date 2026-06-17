{{ config(
    materialized='table',
    format='parquet',
    external_location='s3://ecomerce-gold321/silver/dim_location/',
    partitioned_by=['load_date']
) }}

select row_number() over(order by a.address_line) as address_sk,
        a.address_line,
        c.city,
        c.postalcode as postal_code,
        s.statecode as state_code,
        s.state,
        co.country,
         current_date as load_date     

from {{ ref('adress') }} as a
join {{ ref('cities') }} as c on a.city_sk = c.city_sk
join {{ ref('states') }} as s on c.state_sk = s.state_sk
join {{ ref('countries') }} as co on co.country_sk = s.country_sk
