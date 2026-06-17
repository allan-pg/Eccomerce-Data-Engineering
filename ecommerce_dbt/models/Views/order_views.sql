{{ config(
    materialized='table'
) }}

select 
        o.cart_id,
	    p.product_id,
        p.sku,
        p.title,
        p.category_name,
        p.unit_price,
        p.product_rating,
        p.shipping_period,
	    concat(c.first_name, ' ',c.last_name) as customer_name,	    
	    c.birth_date,
        year(current_date) - year(c.birth_date) AS age,
        CASE
            WHEN date_diff('year', c.birth_date, current_date) < 18 THEN 'Under 18'
            WHEN date_diff('year', c.birth_date, current_date) BETWEEN 18 AND 24 THEN '18-24'
            WHEN date_diff('year', c.birth_date, current_date) BETWEEN 25 AND 34 THEN '25-34'
            WHEN date_diff('year', c.birth_date, current_date) BETWEEN 35 AND 44 THEN '35-44'
            WHEN date_diff('year', c.birth_date, current_date) BETWEEN 45 AND 54 THEN '45-54'
            WHEN date_diff('year', c.birth_date, current_date) BETWEEN 55 AND 64 THEN '55-64'
            ELSE '65+'
        END AS age_group,
	    c.User_name,
	    c.gender,
	    c.eye_color,
	    c.hair_color,
	    c.hair_type,
	    p.product_sk,
	    o.quantity,
	    o.line_total,
	    o.discounted_total
from {{ ref('fact_orders') }} as o
join {{ ref('dim_products') }} as p 
        on p.product_sk = o.product_sk
join {{ ref('dim_location') }} as l 
        on l.address_sk = o.address_sk
join {{ ref('dim_customers') }} as c 
        on c.user_sk = o.user_sk