{{ config(
    materialized='table',
    format='parquet',
    external_location='s3://ecomerce-gold321/silver/fact_orders/',
    partitioned_by=['load_date']
) }}

select 
    c.cart_id,
	Customer.user_sk,
	cu.address_sk,
	p.product_sk,
	c.quantity,
	c.line_total,
	c.discounted_total,
    current_date as load_date

from {{ ref('cart_items') }} as c
join {{ ref('dim_customers') }} as customer on customer.user_sk = c.user_sk
join {{ ref('dim_products') }} as p on p.product_sk = c.product_sk
Join {{ ref('customers') }} as cu on cu.user_sk = customer.user_sk
