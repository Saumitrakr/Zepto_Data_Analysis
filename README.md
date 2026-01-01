# 🛒 Zepto E-commerce SQL Data Analyst Project
This is a complete, real-world data analyst portfolio project based on an e-commerce inventory dataset scraped from [Zepto](https://www.zeptonow.com/) — one of India’s fastest-growing quick-commerce startups. This project simulates real analyst workflows, from raw data exploration to business-focused data analysis.


## 📌 Project Overview

This project uses a Zepto-style grocery SKU dataset to answer real-world business, product, and data analytics questions using SQL. The objective is to demonstrate data-driven decision-making around pricing, discounts, inventory management, demand forecasting, and category optimization—aligned with expectations for Product Analyst, Data Analyst, and Business Analyst roles.

## 📁 Dataset Overview
The dataset was sourced from [Kaggle](https://www.kaggle.com/datasets/palvinder2006/zepto-inventory-dataset/data?select=zepto_v2.csv) and was originally scraped from Zepto’s official product listings. It mimics what you’d typically encounter in a real-world e-commerce inventory system.

Each row represents a unique SKU (Stock Keeping Unit) for a product. Duplicate product names exist because the same product may appear multiple times in different package sizes, weights, discounts, or categories to improve visibility – exactly how real catalog data looks.

🧾 Columns:
- **sku_id:** Unique identifier for each product entry (Synthetic Primary Key)

- **name:** Product name as it appears on the app

- **category:** Product category like Fruits, Snacks, Beverages, etc.

- **mrp:** Maximum Retail Price (originally in paise, converted to ₹)

- **discountPercent:** Discount applied on MRP

- **discountedSellingPrice:** Final price after discount (also converted to ₹)

- **availableQuantity:** Units available in inventory

- **weightInGms:** Product weight in grams

- **outOfStock:** Boolean flag indicating stock availability

- **quantity:** Number of units per package (mixed with grams for loose produce)

## 🔧 Project Workflow

Here’s a step-by-step breakdown of what we do in this project:

### 1. Database & Table Creation
We start by creating a SQL table with appropriate data types:

```sql
CREATE TABLE zepto (
  sku_id SERIAL PRIMARY KEY,
  category VARCHAR(120),
  name VARCHAR(150) NOT NULL,
  mrp NUMERIC(8,2),
  discountPercent NUMERIC(5,2),
  availableQuantity INTEGER,
  discountedSellingPrice NUMERIC(8,2),
  weightInGms INTEGER,
  outOfStock BOOLEAN,
  quantity INTEGER
);
```

### 2. Data Import
- Loaded CSV using Table Data Import Wizard

### 3. 🔍 Data Exploration
- Counted the total number of records in the dataset

- Viewed a sample of the dataset to understand structure and content

- Checked for null values across all columns

- Identified distinct product categories available in the dataset

- Compared in-stock vs out-of-stock product counts

- Detected products present multiple times, representing different SKUs

### 4. 🧹 Data Cleaning
- Identified and removed rows where MRP or discounted selling price was zero

- Converted mrp and discountedSellingPrice from paise to rupees for consistency and readability
  
### 5. 📊 Business Insights

#### 1️⃣ Pricing & Discount Strategy (Product + Business)

1. Which SKUs offer the highest absolute discount (MRP − Selling Price)?

2. Which categories have the highest average discount percentage?

3. Is there a correlation between discount percentage and quantity sold?

4. Which products are over-discounted (high discount but low sales volume)?

5. What percentage of revenue comes from discounted vs non-discounted items?

6. Are heavier products given lower discounts compared to lighter ones?

7. Identify SKUs where the discounted price is close to MRP but sales are high—can discounts be optimized?

#### 2️⃣ Inventory & Supply Chain Analytics

8. Which SKUs are at risk of stockout based on low availableQuantity and high sales?

9. Which categories have the highest out-of-stock rate?

10. Identify products where availableQuantity is high but sales are low (dead inventory).

11. What is the average inventory per category, and how does it compare to demand?

12. Which SKUs contribute to the maximum inventory holding without proportional sales?

13. How many SKUs are out of stock but still have recorded demand?

#### 3️⃣ Demand & Sales Performance

14. What are the top 10 best-selling SKUs by quantity?

15. Which categories generate the highest total revenue?

16. What is the average order quantity per SKU, and which products are bulk-buy items?

17. Identify high-demand but low-availability products (supply constraint analysis).

18. Which products show high sales despite low discounts (strong intrinsic demand)?

#### 4️⃣ Category & Product Mix Optimization

19. Which category has the highest revenue per SKU?

20. What percentage of SKUs in each category contribute to 80% of category revenue (Pareto analysis)?

21. Are there categories where many SKUs exist but contribute little revenue?

22. Which categories rely heavily on discount-driven sales?

23. What is the average price per gram/kg by category, and are there pricing inconsistencies?

#### 5️⃣ Operational & Product Decision Questions

24. Which SKUs should be prioritized for restocking based on demand-to-availability ratio?

25. If discounts were reduced by 2–3%, which products are least likely to be impacted based on historical demand?




## 💡 Thanks for checking out the project!

