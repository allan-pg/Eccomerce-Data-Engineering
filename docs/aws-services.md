# AWS Services

## Amazon S3

Used for:

* Landing Layer
* Bronze Layer
* Silver Layer
* Gold Layer


## S3 Lifecycle Policies

### Rule 1

After 6 months of inactivity:

S3 Standard
→ Glacier Instant Retrieval

### Rule 2

After 1 year in Glacier Instant Retrieval:

Glacier Instant Retrieval
→ Glacier Deep Archive

Benefits:

* Reduced storage costs
* Long-term retention
* Automated archival


## AWS Glue

Used for:

* ETL Jobs
* Data Catalog
* Metadata Management


## Boto3

Used for infrastructure automation.

Examples:

* Bucket creation
* Lifecycle configuration
* IAM configuration
* Service provisioning


## AWS IAM

Provides:

* Authentication
* Authorization
* Role-Based Access Control


## AWS KMS

Provides:

* Encryption at rest
* Encryption key management


## Amazon Athena

Used for:

* SQL Queries
* Data Exploration
* Ad-hoc Analytics


## Monitoring

Services:

* Amazon CloudWatch
* Amazon SNS

Used for:

* Job Monitoring
* Failure Notifications
* Operational Visibility


## Future Enhancements

* AWS MWAA
* Step Functions
* CI/CD Pipelines
* Data Quality Monitoring
* Data Lineage
