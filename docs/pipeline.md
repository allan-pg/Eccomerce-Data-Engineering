# Pipeline Design

## Data Extraction

Data is extracted from DummyJSON APIs.

Sources:

* Products API
* Users API
* Carts API

Raw responses are stored in the Landing bucket.


## Landing to Bronze

Tool:

PySpark

Process:

1. Read JSON files
2. Flatten nested structures
3. Standardize column names
4. Cast data types
5. Write Parquet files
6. Data Masking of PII columns

Example:

users.address.city

becomes

address_city

Output:

* bronze_products
* bronze_users
* bronze_carts


## Bronze to Silver

Purpose:

Build the Integration Core.

Activities:

* Data validation
* Relationship creation
* Standardization
* Business rule application

Output:

* customers
* adress
* states
* cities
* countries
* products_master
* product_category
* product_status
* product_reviews
* shipping_period
* cart_items


## Silver to Gold

Tool:

dbt

Activities:

* Star schema creation
* Fact table generation
* Dimension creation
* Aggregations

Output:

* fact_sales
* fact_inventory
* dim_customer
* dim_product
* dim_date
* dim_status
* dim_location
* dim_reviews


## Analytics Consumption

Business users access data through:

* Amazon Athena
* Power BI
* Amazon QuickSight
