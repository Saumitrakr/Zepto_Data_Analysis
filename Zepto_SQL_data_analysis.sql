drop table if exists zepto;

use sql_projects;

create table zepto (
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

-- data exploration

-- count of rows
select count(*) from zepto;

-- sample data
SELECT * FROM zepto
LIMIT 10;

-- null values
Select * FROM zepto
Where name Is Null
OR
category is null
OR
mrp is null
OR
discountPercent is null
OR
discountedSellingPrice is null
OR
weightInGms is null
OR
availableQuantity is null
OR
outOfStock is null
OR
quantity is null;

 -- different product categories
Select distinct category
from zepto
order by category;

-- products in stock vs out of stock
SELECT outOfStock, COUNT(sku_id)
FROM zepto
GROUP BY outOfStock;

-- product names present multiple times
Select name, COUNT(sku_id) AS "Number of SKUs"
from zepto
group by name
having count(sku_id) > 1
order by count(sku_id) DESC;






-- data cleaning

-- products with price = 0
Select * FROM zepto
where mrp = 0 OR discountedSellingPrice = 0;

Delete from zepto
where mrp = 0;

-- convert paise to rupees
Update zepto
set mrp = mrp / 100.0,
discountedSellingPrice = discountedSellingPrice / 100.0;

SELECT mrp, discountedSellingPrice FROM zepto;

-- checking duplicate items based on names & category
Select name, category, count(*) from zepto
group by name, category;

Select * from zepto
where name = "Onion";

-- removing zeroes from quantity 
Select * from zepto where quantity=0;

Update zepto
set quantity = NULL
where quantity = 0;

-- to remove data where same item is listed multiple times bcoz of different quantity or less mrp bcoz of more quantity 
Select name, category, 
	sum(quantity) as total_quantity, 
	round(sum(mrp*quantity)/sum(quantity),2) as agg_mrp, 
    round(avg(discountPercent),2) as avg_disc_percent, 
    round(sum(discountedSellingPrice*quantity)/sum(quantity),2) as agg_disc_SP,
    max(outOfStock) as outOfStock
from zepto
group by name, category;


-- creating a separate table with aggregated mrp, discount and quantity
Create table zepto_final as 
Select name, category, 
	sum(quantity) as total_quantity, 
	round(sum(mrp*quantity)/sum(quantity),2) as agg_mrp, 
    round(avg(discountPercent),2) as avg_disc_percent, 
    round(sum(discountedSellingPrice*quantity)/sum(quantity),2) as agg_disc_SP,
    max(outOfStock) as outOfStock
from zepto
group by name, category;


-- still duplicates where name is exact same but different category mentioned 
Select * from zepto_final
where name = "MTR Breakfast Khatta Meetha Poha Mix";

-- checking if there is any duplicates with same name and category in final zepto 
With duplicates as (
	Select *, row_number() over (partition by name, category order by category) as rn from zepto_final
)
Select * from duplicates where rn>1;



Select * from zepto_final;

-- only name duplicates are remaining with different categories
Select name, count(*) as cnt from zepto_final group by name having cnt>1 ;

-- listing all items where name is exact same but different categories
Select * from zepto_final 
where name in (
	Select name from zepto_final group by name, agg_mrp having count(distinct category)>1
)
order by name;

-- creating a separate table where all names are unique and different categories of same item are clubbed
Create table zepto_cat_resolved as
Select name, 
	group_concat(distinct category order by category separator ',') as categories,
    sum(total_quantity) as total_quantity,
    round(sum(agg_mrp*total_quantity)/sum(total_quantity),2) as agg_mrp,
    round(avg(avg_disc_percent),2) as avg_discount_percent,
    round(sum(agg_disc_SP*total_quantity)/sum(total_quantity),2) as agg_discounted_SP,
    max(outOfStock) as outOfStock
from zepto_final
group by name;

Select * from zepto_cat_resolved limit 100;


-- DATA ANALYSIS QUESTIONS


-- Q1. Find the top 10 best-value products based on the discount percentage

Select distinct name, category, agg_mrp, avg_discount_Percent from zepto_cat_resolved
order by avg_disc_Percent desc limit 10;


-- Q2.What are the Products with High MRP but Out of Stock

Select * from zepto_cat_resolved
where outOfStock = 1
order by agg_mrp desc
limit 50;

-- Select * from zepto_cat_resolved where name = "Fortune Soyabean Oil";

-- SELECT DISTINCT name,mrp
-- FROM zepto
-- WHERE outOfStock = TRUE and mrp > 300
-- ORDER BY mrp DESC;

-- Q3.Calculate Estimated Revenue for each category
Select category,
	SUM(agg_disc_SP * total_quantity) AS total_revenue
from zepto_final
group by category
order by total_revenue desc;

-- Q4. Find all products where MRP is greater than ₹500 and discount is less than 10%.
Select name, agg_mrp, avg_discount_percent
from zepto_cat_resolved
where agg_mrp > 500 AND avg_discount_percent < 10
order by agg_mrp desc, avg_discount_percent desc;

-- Q5. Identify the top 5 categories offering the highest average discount percentage.
Select category,
round(avg(avg_disc_Percent),2) as avg_discount
from zepto_final
group by category
order by avg_discount desc limit 5;

-- Q6. Find the price per gram for products above 100g and sort by best value.
Select distinct name, weightInGms, discountedSellingPrice,
round(discountedSellingPrice/weightInGms,2) AS price_per_gram
from zepto
where weightInGms >= 100
order by price_per_gram;

-- Q7.Group the products into categories like Low, Medium, Bulk.
Select distinct name, weightInGms,
case when weightInGms < 1000 THEN 'Low'
	when weightInGms < 5000 THEN 'Medium'
	else 'Bulk'
	end as weight_category
from zepto;

-- Q8.What is the Total Inventory Weight Per Category 
Select category,
sum(weightInGms * availableQuantity) AS total_weight
from zepto
group by category
order by total_weight;

-- Q9. Find the top 10 products generating the highest total revenue
Select name,
	categories,
    total_quantity,
    agg_discounted_SP,
	total_quantity*agg_discounted_SP as product_revenue 
from zepto_cat_resolved
order by product_revenue desc limit 10;

-- Q10. Find products where discount percent is above the category average.
WITH cat_discount as
(	
	Select zf.name, zf.category, zf.avg_disc_percent, z.cat_disc_percent from zepto_final zf
    join
	(Select category, avg(discountPercent) as cat_disc_percent from zepto
	group by category) z
    on zf.category = z.category
)
Select * from cat_discount
where avg_disc_percent > cat_disc_percent;

-- Q11. Rank products within each category by selling price
WITH sellingprice_rank as
(
	Select name, 
		category, 
        agg_disc_SP, 
		dense_rank() over(partition by category order by agg_disc_SP desc) as rnk_SP 
	from zepto_final
)
Select * from sellingprice_rank
where rnk_SP<=3;

-- Q12. Find the top 3 discounted products in each category.
WITH discount_rank as
(
	Select name, 
		category, 
        avg_disc_percent, 
		dense_rank() over(partition by category order by avg_disc_percent desc) as rnk_discount
	from zepto_final
)
Select * from discount_rank
where rnk_discount<=3;
 
-- Q13. Identify categories where more than 20% of products are out of stock.
Select category, 
	(sum(outOfStock)/count(*))*100 as percent_outOfStock
from zepto_final
group by category
having percent_outOfStock>20;

-- Q14. Which SKUs offer the highest absolute discount (MRP − Selling Price)?
Select name,
	categories,
    (agg_mrp - agg_discounted_SP) as absolute_discount
from zepto_cat_resolved
order by absolute_discount desc limit 10;

-- Q15. Find correlation between discount percentage and quantity sold
Select 
	case when avg_discount_percent<10 then "Low"
		when avg_discount_percent<25 then "Medium"
        when avg_discount_percent<40 then "High"
        else "Extreme"
	end as discount_bucket,
    avg(total_quantity) as quantitysold	
from zepto_cat_resolved
group by discount_bucket;

-- Q16. What percentage of revenue comes from discounted vs non-discounted items?
WITH discount_revenue as (
	Select
		case when avg_discount_percent<7.5 then "non-discounted"
			else "discounted"
		end as discount_category,
		sum(total_quantity*agg_discounted_SP) as revenue
	from zepto_cat_resolved
	group by discount_category
),
s as
(Select sum(revenue) as totalrevenue
from discount_revenue)
Select discount_category, round((revenue/s.totalrevenue)*100,2) as revenue_percentage
from discount_revenue, s;

