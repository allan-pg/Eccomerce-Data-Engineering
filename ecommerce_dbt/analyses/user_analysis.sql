with clean_users as (

    select *,
           row_number() over (
               partition by user_id, load_date
               order by load_date desc
           ) as rn_id
    from {{ ref("users") }}

)

select
    rn_id,
    user_id,
    first_name,
    last_name,
    age,
    gender,
    birthdate,
    row_number() over (
        order by user_id
    ) as user_sk
from clean_users
