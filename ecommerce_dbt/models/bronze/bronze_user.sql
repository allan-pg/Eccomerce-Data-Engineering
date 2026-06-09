select *
from {{ source('bronze', 'bronze_cart_items') }}

