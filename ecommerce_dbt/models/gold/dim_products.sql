 {{ config(
    materialized='table',
    format='parquet',
    external_location='s3://ecomerce-gold321/silver/dim_products/',
    partitioned_by=['load_date']
) }}
 
 
 select 
      row_number() over(order by p.product_id, p.load_date) as product_sk,
      p.product_id,
      p.sku,
      p.title,
      c.category_name,
      p.unit_price,
      p.product_rating,
      sp.shipping_period,
      p.created_at,
      p.updated_at,
      p.minimumorderquantity as minimum_order_quantity,
      current_date as load_date

from {{ ref('products_master') }} as p
join {{ ref('product_category') }} as c on p.category_sk = c.category_sk
join {{ ref('shipping_period') }} as sp  on
	sp.shipping_period_sk = p.shipping_period_sk
