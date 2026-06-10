{{ config(
    materialized='table',
    format='parquet',
    external_location='s3://ecomerce-silver123/silver/shipping_period/',
    partitioned_by=['load_date']
) }}

select 
    row_number() over(order by shippinginformation) as shipping_period_sk,
    shippinginformation as shipping_period,
    current_date as load_date
    from (
        select distinct shippinginformation 
        from {{ source('bronze_db', 'bronze_products') }}
    )