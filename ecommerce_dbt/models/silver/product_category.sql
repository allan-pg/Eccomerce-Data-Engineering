{{ config(
    materialized='table',
    format='parquet',
    external_location='s3://ecomerce-silver123/silver/product_category/',
    partitioned_by=['load_date']
) }}

select 
    row_number() over(order by category) as category_sk,
    category as category_name,
    current_date as load_date
    from (
        select distinct category 
        from {{ source('bronze_db', 'bronze_products') }}
    )
