{{ config(
    materialized='table',
    format='parquet',
    external_location='s3://ecomerce-silver123/silver/product_reviews/',
    partitioned_by=['load_date']
) }}

select 
    row_number() over(
        order by 'r.cast(reviews.date as timestamp)'
    ) as rating_sk,

    p.product_sk,
    r.product_rating,

    'r.cast(reviews.comment as string)' as review_comment,
    'r.cast(reviews.date as timestamp)' as review_date,
    'r.cast(reviews.reviewername as string)' as reviewer_name,
    current_date as load_date

from {{ source('bronze_db', 'bronze_product_reviews') }} r
join {{ ref('products_master') }} p on p.product_id = r.product_id