{{ config(
    materialized='table',
    format='parquet',
    external_location='s3://ecomerce-silver123/silver/product_status/',
    partitioned_by=['load_date']
) }}

select 
    row_number() over(order by availabilitystatus) as availability_status_sk,
    availabilitystatus as availability_status,
    current_date as load_date
    from (
        select distinct availabilitystatus 
        from {{ source('bronze_db', 'bronze_products') }}
    )