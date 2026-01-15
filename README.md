# Zepto SQL Data Analysis Project

## Overview
This project presents an end-to-end SQL analysis of Zepto’s product inventory data. The objective is to clean raw SKU-level data, resolve duplicates caused by multiple pack sizes and categories, and generate meaningful business insights related to pricing, discounts, inventory, and revenue.

The project mirrors a real-world retail analytics workflow, starting from data exploration and cleaning to advanced analytical querying.

---

## Dataset Description
The dataset contains product-level details including:
- SKU ID  
- Product name and category  
- MRP and discounted selling price  
- Discount percentage  
- Available quantity and stock status  
- Product weight  

---

## Approach and Methodology

### 1. Data Exploration
- Checked total number of records and sampled the data
- Identified null values across critical columns
- Analyzed unique product categories
- Compared in-stock vs out-of-stock products
- Detected products appearing multiple times under different SKUs

### 2. Data Cleaning
- Removed products with zero MRP or selling price
- Converted prices from paise to rupees
- Replaced zero quantities with NULL values
- Investigated duplicate listings caused by different quantities or pricing

### 3. Data Aggregation
- Aggregated duplicate SKUs using weighted averages
- Created intermediate and final tables:
  - `zepto_final`: Unique product entries at name and category level
  - `zepto_cat_resolved`: Final table with unique product names and merged categories

### 4. Business Analysis
The analysis answers multiple business-focused questions such as:
- Top products offering the highest discounts
- High-MRP products that are currently out of stock
- Estimated revenue contribution by category
- Products with high price but low discounts
- Categories offering the highest average discounts
- Best value products based on price per gram
- Inventory weight distribution by category
- Top revenue-generating products
- Relationship between discount levels and quantity sold
- Revenue contribution from discounted vs non-discounted products

---

## SQL Concepts Used
- Common Table Expressions (CTEs)
- Window functions (DENSE_RANK, ROW_NUMBER)
- Conditional logic using CASE statements
- Aggregate functions and weighted averages
- Deduplication and data normalization
- Ranking and bucketing analysis

---

