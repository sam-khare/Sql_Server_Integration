---1837760 80% of the sales
--SELECT SUM(SALES)*(0.80) as total_sales
--FROM [master].[dbo].[Orders]

WITH product_sales as
(SELECT [product_id], sum(sales) as product_sales
  FROM [master].[dbo].[Orders]
  
  GROUP BY [product_id]
  ),

  calc_sales as(
  SELECT [product_id], product_sales, SUM(product_sales) OVER(ORDER BY product_sales DESC rows between unbounded preceding and 0 preceding) as running_sales,
		0.8*SUM(product_sales) OVER () AS Total_Sales
  FROM product_sales)

  SELECT * FROM calc_sales
  WHERE running_sales <= Total_Sales