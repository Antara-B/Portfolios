
Use Work;
SELECT * FROM Retail;

-- Task 1:Products with prices higher than the average price within their category 
SELECT Product_Name, Category, Price
FROM Retail
WHERE Price > (SELECT AVG(Price) FROM Retail AS R WHERE R.Category = Retail.Category)
ORDER BY Category, Price;

-- Task 2: Finding Categories with Highest Average Rating Across Products 
SELECT Category,
       Product_Name,
       Round(AVG(Rating),3) AS Avg_Rating
FROM Retail
GROUP BY CATEGORY,Product_Name
ORDER BY CATEGORY,Avg_Rating DESC;

-- Task 3: Find the most reviewed product in each warehouse 
WITH Product AS (
    SELECT Warehouse,Category,Product_Name,SUM(Reviews) as Most_Reviews,
           ROW_NUMBER() OVER (PARTITION BY Warehouse ORDER BY SUM(Reviews) DESC) AS RowNum
	FROM Retail	   
    GROUP BY Warehouse,Category,Product_Name   
)
SELECT Warehouse,Category,Product_Name,Most_Reviews
FROM Product
WHERE RowNum = 1;


-- Task 4: Find products that have higher-than-average prices within their category, along with their discount and supplier 
SELECT Product_Name, Category, Price, Discount, Supplier
FROM Retail
WHERE Price > (SELECT AVG(Price) FROM Retail AS R WHERE R.Category = Retail.Category);

-- Task 5: Query to find the top 2 products with the highest average rating in each category 
WITH Prod AS (
SELECT  Category,Product_Name,
        AVG(Rating) as Avg_Rating,
		ROW_NUMBER() OVER (PARTITION BY Category ORDER BY Avg(Rating) DESC) AS RatingRank
FROM Retail
GROUP BY Category,Product_Name )
SELECT Category,
       Product_Name,
       Avg_Rating FROM Prod
WHERE RatingRank <= 2

-- Task 6: Analysis Across All Return Policy Categories
SELECT RETURN_POLICY, COUNT(PRODUCT_ID) AS ProductCount,AVG(STOCK_QUANTITY) AS AvgStockQuantity,
       SUM(STOCK_QUANTITY) AS TotalStockQuantity,SUM(RATING * REVIEWS) / SUM(REVIEWS) AS WeightedAvgRating,
	   SUM(REVIEWS) AS TotalReviews,AVG(DISCOUNT) AS AvgDiscount_Percent,AVG(PRICE) AS AvgSellingPrice,
	   MAX(STOCK_QUANTITY) AS MaxStockQty
FROM Retail
GROUP BY RETURN_POLICY;