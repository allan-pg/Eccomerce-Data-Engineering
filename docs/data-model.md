# Data Model

## Integration Core (Silver)

The Silver Layer stores normalized entities.

![Silver Layer Diagram](diagrams/ecommerce_silver_model.jpg) 

### Customers

Contains:

* Customer Information
* Contact Details
* Demographics

### Products

Contains:

* Product Attributes
* Pricing
* Inventory

### Orders

Contains:

* Customer Purchases
* Transaction Information

### Order Items

Contains:

* Product-Level Purchase Details

---

## Star Schema (Gold)

### Fact Table

fact_sales

Measures:

* Quantity Sold
* Revenue
* Discount Amount
* Order Count

---

### Dimensions

dim_customer

Attributes:

* Customer Name
* Age Group
* Gender

---

dim_product

Attributes:

* Product Name
* Category
* Brand

---

dim_date

Attributes:

* Day
* Month
* Quarter
* Year

---

## Star Schema Design

```
            dim_customer
                   |
                   |
```

dim_product ---- fact_sales ---- dim_date

This design supports fast analytical queries and dashboard reporting.
