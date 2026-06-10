{{ config(
    materialized='table',
    format='parquet',
    external_location='s3://ecomerce-silver123/silver/states/',
    partitioned_by=['load_date']
) }}
select 
    row_number() over(order by st.state) as state_sk,
    c.country_sk,
    st.state,
    st.statecode,
    current_date as load_date
from (
    select distinct state, statecode, country 
    from {{ source('bronze_db', 'bronze_user_location') }})  st

join {{ ref('countries') }} c on c.country = st.country