# Architecture

## Overview

The platform follows the Medallion Architecture pattern.

Source systems deliver raw JSON data which progresses through Landing, Bronze, Silver, and Gold layers.


## Layer 1: Landing

### Purpose

Store raw source files exactly as received from upstream systems or external data providers. This layer acts as the initial ingestion point for all incoming data.

### Characteristics

- Raw JSON format (untransformed data)
- Immutable (no updates or deletions)
- Maintains full historical record of all ingested data
- Serves as the system of record for replay and recovery
- Supports auditability and traceability of all raw inputs


### Storage

- Amazon S3 (Landing Bucket)


### Data Retention & Archival Policy

To optimize storage costs while maintaining compliance and audit requirements, the following lifecycle policies are applied:

- Data stored in the Landing layer for up to 6 months remains in standard S3 storage
- Files not accessed or used within 6 months are automatically transitioned to **S3 Glacier Instant Retrieval (Tier 1 archival)** for cost optimization while still allowing fast access when needed
- If data remains unused for an additional 6 months (total of 12 months)**, it is further transitioned to **S3 Glacier Deep Archive (Tier 2 archival) for long-term, low-cost retention


### Business Rationale

This lifecycle strategy ensures:

- Reduced storage costs over time
- Fast retrieval for recently archived data when required
- Long-term retention for audit, compliance, and historical analysis
- Separation of frequently accessed vs rarely accessed data

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


## Benefits

* Scalability
* Reusability
* Cost Optimization
* Governance
* Analytics Readiness
