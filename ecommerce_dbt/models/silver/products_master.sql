{{ config(
    materialized='table',
    format='parquet',
    external_location='s3://ecomerce-silver123/silver/products_master/',
    partitioned_by=['load_date']
) }}

select 
      row_number() over(order by p.product_id, p.load_date) as product_sk,
      p.product_id,
      p.sku,
      p.title,
      c.category_sk,
      p.price as unit_price,
      p.product_rating,
      p.quantity_in_stock,
      s.shipping_period_sk,
      a.availability_status_sk,
      p.created_at,
      p.updated_at,
      p.minimumorderquantity,
      current_date as load_date
from {{ source('bronze_db', 'bronze_products') }} p   
join {{ ref('product_category') }} c on c.category_name = p.category
join {{ ref('shipping_period') }} s on s.shipping_period = p.shippinginformation
join {{ ref('product_status') }} a on a.availability_status = p.availabilitystatus
