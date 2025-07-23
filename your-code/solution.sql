

-- 1. Write a CTE that lists the names and quantities of products with a unit price greater than $50.

WITH totalquants AS (
	SELECT ProductID,SUM(Quantity) AS total_quantity
	FROM OrderDetails od 
	GROUP BY ProductID
)
SELECT p.ProductName, t.total_quantity, p.Unit AS Unit
FROM Products p 
JOIN totalquants t ON p.ProductID = t.ProductID
WHERE p.Price > 50;

-- 2. What are the top 5 most profitable products?

WITH totalquants AS (
	SELECT ProductID,SUM(Quantity) AS total_quantity
	FROM OrderDetails od 
	GROUP BY ProductID
)
SELECT p.ProductID, p.ProductName, t.total_quantity * p.Price AS Total_Revenue
FROM Products p 
JOIN totalquants t ON p.ProductID = t.ProductID
ORDER BY Total_Revenue DESC
LIMIT 5;



-- 3. Write a CTE that lists the top 5 categories by the number of products they have.
WITH cat_product_count AS (
    SELECT c.CategoryName, COUNT(p.ProductID) AS Product_Count
    FROM Products p
    JOIN Categories c ON p.CategoryID = c.CategoryID
    GROUP BY c.CategoryName
)
SELECT CategoryName, Product_Count
FROM cat_product_count
ORDER BY Product_Count DESC
LIMIT 5;

-- 4. Write a CTE that shows the average order quantity for each product category.
WITH avg_quant_cat AS (
	SELECT c.CategoryName ,AVG(od.Quantity) AS avg_order_quantity
	FROM OrderDetails od
	JOIN Products p ON od.ProductID = p.ProductID
	JOIN Categories c ON p.CategoryID = c.CategoryID
	GROUP BY c.CategoryName
)
SELECT CategoryName, avg_order_quantity
FROM avg_quant_cat
ORDER BY avg_order_quantity DESC;



-- 5. Create a CTE to calculate the average order amount for each customer.
WITH order_customer AS (
SELECT o.CustomerID, c.CustomerName, od.Quantity, p.Price
FROM Orders o 
JOIN OrderDetails od ON o.OrderID = od.OrderID
JOIN Customers c ON o.CustomerID = c.CustomerID
JOIN Products p ON p.ProductID = od.ProductID
GROUP BY o.CustomerID
)
SELECT CustomerID, CustomerName, AVG(Quantity * Price ) AS avg_amount
FROM order_customer
GROUP BY CustomerName
ORDER BY avg_amount DESC;



-- 6. 6. Sales Analysis with CTEs
-- Assume we have the Northwind database which contains tables like Orders, OrderDetails, and Products. Create a CTE that calculates the total sales for each product in the year 1997.
WITH product_orders AS (
	SELECT p.ProductName, od.Quantity, o.OrderDate 
	FROM Products p 
	JOIN OrderDetails od ON p.ProductID = od.ProductID
	JOIN Orders o ON od.OrderID = o.OrderID 
)
SELECT ProductName, SUM(Quantity) AS total_sales
FROM product_orders 
WHERE OrderDate LIKE '1997%'
GROUP BY ProductName
ORDER BY total_sales DESC;







