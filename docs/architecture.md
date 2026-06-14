# Architecture

## Overview

The platform follows the Medallion Architecture pattern.

Source systems deliver raw JSON data which progresses through Landing, Bronze, Silver, and Gold layers.

---

## Layer 1: Landing

Purpose:

Store raw source files exactly as received.

Characteristics:

* Raw JSON
* Immutable
* Historical retention
* Source of truth

Storage:

Amazon S3

---

## Layer 2: Bronze

Purpose:

Convert raw JSON into structured datasets.

Transformations:

* JSON flattening
* Schema standardization
* Metadata enrichment
* Data type conversions

Storage Format:

Parquet

Tools:

* PySpark
* AWS Glue

---

## Layer 3: Silver

Purpose:

Create an Integration Core.

Responsibilities:

* Data cleansing
* Standardization
* Deduplication
* Relationship management

Example Entities:

* Customers
* Products
* Orders
* Order Items

Although only one source currently exists, the architecture supports future source integrations.

---

## Layer 4: Gold

Purpose:

Business-ready datasets.

Modeling Methodology:

Kimball Dimensional Modeling

Output:

* Fact Tables
* Dimension Tables

Used by:

* Athena
* Power BI
* QuickSight

---

## Benefits

* Scalability
* Reusability
* Cost Optimization
* Governance
* Analytics Readiness
