from datetime import datetime
from pyspark.sql.functions import *
from utils.utils import boto3, s3_client, glue_client, athena_client, get_spark

spark = get_spark()

#Read data from landing folder in aws s3
carts_df = spark.read.json('s3a://ecomerce-landing123/carts/')
products_df = spark.read.json('s3a://ecomerce-landing123/products/')
users_df = spark.read.json('s3a://ecomerce-landing123/users/')

#Write data to bronze s3 buckets
bronze_path = "s3a://ecomerce-bronze123"

#Glue database catalog
database = "bronze_db"

load_date = datetime.now().strftime("%Y%m%d_%H%M%S")

# Getting headers for carts
def cart_header_create(df):

    bronze_cart_header = df.select(
        col("id").cast("int").alias("cart_id"),
        col("userId").cast("int").alias("user_id"),
        col("total").cast("double").alias("total"),
        col("discountedTotal").cast("double").alias("discounted_total"),
        col("totalProducts").cast("int").alias("total_products"),
        col("totalQuantity").cast("int").alias("total_quantity")
    ).withColumn("load_date", lit(load_date))

    path = f"{bronze_path}/bronze_cart_header"

    bronze_cart_header.write \
        .format("parquet") \
        .mode("append") \
        .partitionBy("load_date") \
        .option("path", path) \
        .saveAsTable(f"{database}.bronze_cart_header")

# Getting line items for carts
def carts_line_items(df):

    cart_items = df.select(
        col("id").cast("int").alias("cart_id"),
        col("userId").cast("int").alias("user_id"),
        explode("products").alias("product")
    )

    bronze_cart_items = cart_items.select(
        col("cart_id"),
        col("user_id"),
        col("product.id").cast("int").alias("product_id"),
        col("product.title").cast("string").alias("title"),
        col("product.price").cast("double").alias("price"),
        col("product.quantity").cast("int").alias("quantity"),
        col("product.total").cast("double").alias("line_total"),
        col("product.discountedTotal").cast("double").alias("discounted_total"),
        col("product.discountPercentage").cast("double").alias("discount_pct")
    ).withColumn("load_date", lit(load_date))

    path = f"{bronze_path}/bronze_cart_items"

    bronze_cart_items.write \
        .format("parquet") \
        .mode("append") \
        .partitionBy("load_date") \
        .option("path", path) \
        .saveAsTable(f"{database}.bronze_cart_items")

# Getting products information from products folder s3 bucket
def get_products(df):

    bronze_products = df.select(
        col("id").cast("int").alias("product_id"),
        col("title").cast("string").alias("product_title"),
        col("category").cast("string").alias("product_category"),
        col("price").cast("double").alias("product_price"),
        col("discountPercentage").cast("double").alias("discount_percentage"),
        col("rating").cast("double").alias("product_rating"),
        col("stock").cast("int").alias("quantity_in_stock"),
        col("tags")[0].cast("string").alias("tag_1"),
        col("tags")[1].cast("string").alias("tag_2"),
        col("brand").cast("string").alias("brand"),
        col("sku").cast("string").alias("product_sku"),
        col("weight").cast("double").alias("weight"),
        col("dimensions.width").cast("double").alias("product_width"),
        col("dimensions.height").cast("double").alias("product_height"),
        col("dimensions.depth").cast("double").alias("product_depth"),
        col("warrantyInformation").cast("string").alias("warranty_information"),
        col("shippingInformation").cast("string").alias("shipping_information"),
        col("availabilityStatus").cast("string").alias("availability_status"),
        col("returnPolicy").cast("string").alias("return_policy"),
        col("minimumOrderQuantity").cast("int").alias("min_order_quantity"),
        col("meta.createdAt").cast("timestamp").alias("created_at"),
        col("meta.updatedAt").cast("timestamp").alias("updated_at"),
        col("meta.barcode").cast("string").alias("bar_code"),
        col("meta.qrCode").cast("string").alias("qr_code"),
        col("images")[0].cast("string").alias("product_image"),
        col("thumbnail").cast("string").alias("product_thumbnail")
    ).withColumn("load_date", lit(load_date))

    path = f"{bronze_path}/bronze_products"

    bronze_products.write \
        .format("parquet") \
        .mode("append") \
        .partitionBy("load_date") \
        .option("path", path) \
        .saveAsTable(f"{database}.bronze_products")

# Fetching product reviews 
def product_reviews(df):

    exploded = df.select(
        col("id").cast("int").alias("product_id"),
        explode("reviews").alias("reviews")
    )

    bronze_reviews = exploded.select(
        col("product_id"),
        col("reviews.rating").cast("int").alias("product_rating"),
        col("reviews.comment").cast("string").alias("comment"),
        col("reviews.date").cast("timestamp").alias("review_date"),
        col("reviews.reviewerName").cast("string").alias("reviewer_name"),
        col("reviews.reviewerEmail").cast("string").alias("reviewer_email")
    ).withColumn("load_date", lit(load_date))

    path = f"{bronze_path}/bronze_product_reviews"

    bronze_reviews.write \
        .format("parquet") \
        .mode("append") \
        .partitionBy("load_date") \
        .option("path", path) \
        .saveAsTable(f"{database}.bronze_product_reviews")   

#Getting users information and hashing PII information
def user_info(df):

    bronze_users = df.select(
        col("id").cast("int").alias("user_id"),
        col("firstName").alias("first_name"),
        col("lastName").alias("last_name"),
        col("maidenName").alias("maiden_name"),
        col("age").cast("int").alias("age"),
        col("gender").alias("gender"),
        col("username").alias("user_name"),
        col("role").alias("role"),
        col("birthDate").cast("date").alias("birth_date"),
        col("image").alias("user_role"),
        sha2(col("email"), 256).alias("email_hash"),
        sha2(col("phone"), 256).alias("phone_hash"),
        sha2(col("ip"), 256).alias("ip_hash"),
        sha2(col("macAddress"), 256).alias("mac_hash"),
        sha2(col("ssn"), 256).alias("ssn_hash"),
        sha2(col("ein"), 256).alias("ein_hash"),
        sha2(col("userAgent"), 256).alias("user_agent_hash"),
        col("bloodGroup").alias("blood_group"),
        col("height").cast("double").alias("height"),
        col("weight").cast("double").alias("weight"),
        col("eyeColor").alias(eye_color"),
        col("hair.color").alias("hair_color"),
        col("hair.type").alias("hair_type"),
        col("university").alias("university"),
        col("crypto.coin").alias("crypto_coin"),
        sha2(col("crypto.wallet"), 256).alias("crypto_wallet_hash"),
        col("crypto.network").alias("crypto_network")
    ).withColumn("load_date", lit(load_date))

    path = f"{bronze_path}/bronze_users"

    bronze_users.write \
        .format("parquet") \
        .mode("append") \
        .partitionBy("load_date") \
        .option("path", path) \
        .saveAsTable(f"{database}.bronze_users")

# Get the company of the user
def company_info(df):

    bronze_company = df.select(
        col("id").cast("int").alias("user_id"),
        col("company.name").alias("company_name"),
        col("company.department"),
        col("company.title").alias("job_title"),
        col("company.address.address").alias("company_address"),
        col("company.address.city").alias("city"),
        col("company.address.state").alias("state"),
        col("company.address.stateCode").alias("state_code"),
        col("company.address.postalCode").alias("postal_code"),
        col("company.address.country").alias("country"),
        col("company.address.coordinates.lat").cast("double").alias("latitude"),
        col("company.address.coordinates.lng").cast("double").alias("longitude")
    ).withColumn("load_date", lit(load_date))

    path = f"{bronze_path}/bronze_user_company"

    bronze_company.write \
        .format("parquet") \
        .mode("append") \
        .partitionBy("load_date") \
        .option("path", path) \
        .saveAsTable(f"{database}.bronze_user_company")

# getting the user location
def location_info(df):

    bronze_location = df.select(
        col("id").cast("int").alias("user_id"),
        col("address.address").alias("address_line"),
        col("address.city").alias("city"),
        col("address.state").alias("state),
        col("address.stateCode").alias("state_code"),
        col("address.postalCode").alias("postal_code"),
        col("address.country").alias("country"),
        col("address.coordinates.lat").cast("double").alias("latitude"),
        col("address.coordinates.lng").cast("double").alias("longitude")
    ).withColumn("load_date", lit(load_date))

    path = f"{bronze_path}/bronze_user_location"

    bronze_location.write \
        .format("parquet") \
        .mode("append") \
        .partitionBy("load_date") \
        .option("path", path) \
        .saveAsTable(f"{database}.bronze_user_location")

# Run the pipeline
cart_header_create(carts_df)
carts_line_items(carts_df)
get_products(products_df)
product_reviews(products_df)
user_info(users_df)
company_info(users_df)
location_info(users_df)








