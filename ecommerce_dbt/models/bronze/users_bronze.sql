select *
from {{ source('bronze_db', 'bronze_users') }}

