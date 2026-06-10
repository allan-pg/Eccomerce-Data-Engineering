{{ config(
    materialized='table',
    format='parquet',
    external_location='s3://ecomerce-silver123/silver/cart_items/',
    partitioned_by=['load_date']
) }}

select 
    row_number() over(order by c.cart_id, c.load_date) as cart_item_sk,
    c.cart_id,
	u.user_sk,
	p.product_sk,
	c.quantity,
	c.line_total,
	c.discounted_total,
    current_date as load_date
from {{ source('bronze_db', 'bronze_cart_items') }} c
join {{ ref('customers') }} u on u.user_id = c.user_id
JOIN {{ ref('products_master') }} p on p.product_id = c.product_id
	