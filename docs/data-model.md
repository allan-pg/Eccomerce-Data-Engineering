# Data Model

## Integration Core (Silver)

The Silver Layer stores normalized entities.

![Silver Layer Diagram](../diagrams/eccomerce_silver_model.jpg) 

### Customers

Contains:

* Customer Information
* birth date
* hair type and color
  

### Products

Contains:

* Product Attributes
* Unit Pricing of products
* product rating
* stock status either available or out of stock
* minimum order quantity one can make
* quantity of products in stock

### Product_category

Contains:

* Different categories of products

### Shipping_period

Contains:
* how long it takes to ship a product e.g one week

### cart_items

Contains:

* Customer Purchases
* Transaction Information

### adresses

Contains:
* Customer geographical location

### Product Reviews
* Different reviews for a product


## Star Schema (Gold)

![Gold Layer Diagram](../diagrams/ecommerce_star_schema.jpg)

### Fact Table

fact_orders

Measures:

* Quantity Sold
* Total line amount
* Discount Amount

Fact_inventory

* quantity in stock
* availability status (instock, out of stock)


### Dimensions

dim_customer

Attributes:

* Customer Name
* adress
* Gender


dim_product

Attributes:

* Product Name
* Category
* Brand


dim_date

Attributes:

* Day
* Month
* Quarter
* Year



This design supports fast analytical queries and dashboard reporting.
