{{ config(
    materialized='table'
) }}

select  
        p.product_id,
        p.sku,
        p.title,
        p.category_name,
        i.availability_status,
        i.quantity_in_stock,
        15 as reorder_level,
        case
          when i.quantity_in_stock <= 15 then True
          else False
      end as needs_reorder
from {{ ref('fact_inventory') }} as i 
join {{ ref('dim_products') }} as p on i.product_sk = p.product_sk