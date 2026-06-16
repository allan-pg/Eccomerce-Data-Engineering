{{ config(
    materialized='table',
    format='parquet',
    external_location='s3://ecomerce-gold321/silver/fact_inventory/',
    partitioned_by=['load_date']
) }}

select 
      row_number() over(order by p.product_id, p.load_date) as product_sk,
      P.quantity_in_stock,
      ps.availability_status,
      current_date as load_date
from {{ ref('products_master') }} as p
Join {{ ref('product_status') }} ps on ps.availability_status_sk = p.availability_status_sk
