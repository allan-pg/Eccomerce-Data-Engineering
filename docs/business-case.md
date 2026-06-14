# Requirements Gathering Summary

## Background

Following discussions with key stakeholders from the Sales, Inventory, and Finance teams of the e-commerce department, several pain points were identified around the current data landscape.

The organization generates large volumes of transactional and operational data from customers, products, and orders. However, this data is stored in raw, nested JSON formats, making it difficult for business users to directly extract insights.

As a result, teams rely on manual reporting and inconsistent datasets, which slows down decision-making.

---

## Problem Statement (As Defined by Business Stakeholders)

Business users currently lack a single source of truth that provides clean, trusted, and analysis-ready datasets for decision-making across sales, inventory, and customer operations.

### Key Challenges Identified

- Data is nested and not structured for analytics use cases  
- Inconsistent definitions of key metrics (e.g., revenue, stock levels, order totals)  
- Heavy reliance on engineering teams for basic reporting requests  
- Delayed visibility into inventory shortages and sales performance  
- Difficulty in building reliable dashboards across departments  

---

## Business Requirements

### Sales Team Requirements

The Sales team requires a trusted dataset to:

- Track daily, weekly, and monthly revenue trends  
- Identify top-performing products and categories  
- Analyze customer purchasing behavior and repeat purchases  
- Monitor order-level and product-level performance  
- Enable faster decision-making through near real-time reporting  

---

### Inventory Team Requirements

The Inventory and Warehouse teams require better visibility into stock movement to:

- Track current stock levels across all products  
- Identify low-stock and out-of-stock items early  
- Monitor product turnover rates  
- Support replenishment and procurement decisions  
- Reduce risk of stockouts and overstocking  

---

### Customer Analytics Requirements

The Marketing and CRM teams require customer insights to:

- Understand customer purchasing patterns and frequency  
- Segment customers based on value and engagement  
- Identify high-value (VIP) customers  
- Improve targeting for marketing campaigns  
- Support retention and loyalty strategies  

---

## Expected Business Outcomes

By implementing a structured data pipeline and analytics-ready data models, the organization expects to achieve:

- A **single source of truth** for all analytics data  
- Faster and more reliable reporting across departments  
- Reduced dependency on engineering for ad-hoc queries  
- Scalable architecture for future data growth  
- Improved decision-making through timely and accurate insights  