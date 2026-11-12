SELECT *
FROM Orders$

--Task 1A(Customer segmentation by region)
SELECT TOP 10
	c.Region,
COUNT (DISTINCT o. [Customer ID]) AS Unique_Customer_Count
FROM [dbo].[orders$] o
JOIN [dbo].[customers$] c ON o.[Customer ID] = c.[Customer ID]
GROUP BY c.Region
ORDER BY Unique_Customer_Count DESC;


-- Task 1B: Analyze distribution & percentage reach across regions
SELECT 
    c.Region,
    COUNT(DISTINCT o.[Customer ID]) AS Region_Customer_Count,
    CAST(COUNT(DISTINCT o.[Customer ID]) * 100.0 / SUM(COUNT(DISTINCT o.[Customer ID])) OVER() AS DECIMAL(5,2)) AS Percentage_Of_Total_Reach
FROM [dbo].[Orders$] o
JOIN [dbo].[Customers$] c ON o.[Customer ID] = c.[Customer ID]
GROUP BY c.Region
ORDER BY Region_Customer_Count DESC;

-- Task 2A: Calculate how many customers have placed more than one order
WITH CustomerOrderCounts AS (
    SELECT 
        [Customer ID],
        COUNT(DISTINCT [Order ID]) AS Total_Orders
    FROM [dbo].[Orders$]
    GROUP BY [Customer ID]
)
SELECT 
    COUNT(*) AS Repeat_Customer_Count
FROM CustomerOrderCounts
WHERE Total_Orders > 1;

-- Task 2B: Identify the top 5 customers who have placed the most orders
SELECT TOP 5 
    o.[Customer ID],
    c.[Customer Name],
    COUNT(DISTINCT o.[Order ID]) AS Total_Orders_Placed
FROM [dbo].[Orders$] o
JOIN [dbo].[Customers$] c ON o.[Customer ID] = c.[Customer ID]
GROUP BY o.[Customer ID], c.[Customer Name]
ORDER BY Total_Orders_Placed DESC;

SELECT TOP 1 * FROM [dbo].[Orders$];
SELECT TOP 1 * FROM [dbo].[Sales$];

-- Task 3A: Find the top 10 customers who have spent the most
WITH NumberedOrders AS (
    SELECT *, 
           ROW_NUMBER() OVER (ORDER BY (SELECT NULL)) AS RowPos
    FROM [dbo].[Orders$]
),
NumberedSales AS (
    SELECT *, 
           ROW_NUMBER() OVER (ORDER BY (SELECT NULL)) AS RowPos
    FROM [dbo].[Sales$]
)
SELECT TOP 10 
    o.[Customer ID],
    c.[Customer Name],
    ROUND(SUM(s.Sales), 2) AS Total_Spend,
    ROUND(SUM(s.Profit), 2) AS Total_Profit_Contribution
FROM NumberedOrders o
JOIN [dbo].[Customers$] c ON o.[Customer ID] = c.[Customer ID]
JOIN NumberedSales s ON o.RowPos = s.RowPos -- Joins perfectly row-for-row
GROUP BY o.[Customer ID], c.[Customer Name]
ORDER BY Total_Spend DESC;

-- Task 3B: Analyze purchasing patterns of high-value customers
WITH NumberedOrders AS (
    SELECT *, ROW_NUMBER() OVER (ORDER BY (SELECT NULL)) AS RowPos
    FROM [dbo].[Orders$]
),
NumberedSales AS (
    SELECT *, ROW_NUMBER() OVER (ORDER BY (SELECT NULL)) AS RowPos
    FROM [dbo].[Sales$]
),
Top10Customers AS (
    SELECT TOP 10 o.[Customer ID]
    FROM NumberedOrders o
    JOIN NumberedSales s ON o.RowPos = s.RowPos
    GROUP BY o.[Customer ID]
    ORDER BY SUM(s.Sales) DESC
)
SELECT 
    o.[Customer ID],
    p.Category,
    COUNT(DISTINCT o.[Order ID]) AS Order_Count,
    ROUND(AVG(s.Sales), 2) AS Average_Order_Value,
    ROUND(SUM(s.Sales), 2) AS Category_Total_Spend
FROM NumberedOrders o
JOIN [dbo].[Produts$] p ON o.[Product ID] = p.[Product ID]
JOIN NumberedSales s ON o.RowPos = s.RowPos
WHERE o.[Customer ID] IN (SELECT [Customer ID] FROM Top10Customers)
GROUP BY o.[Customer ID], p.Category
ORDER BY o.[Customer ID], Category_Total_Spend DESC;

-- Task 4A: Determine the average number of purchases made per customer
WITH PurchasesPerCustomer AS (
    SELECT 
        [Customer ID],
        COUNT(DISTINCT [Order ID]) AS Total_Purchases
    FROM [dbo].[Orders$]
    GROUP BY [Customer ID]
)
SELECT 
    ROUND(AVG(CAST(Total_Purchases AS DECIMAL(10,2))), 2) AS Overall_Avg_Purchases_Per_Customer
FROM PurchasesPerCustomer;

-- Task 4B: Identify purchase frequency trends based on customer segments
WITH SegmentPurchases AS (
    SELECT 
        [Customer ID],
        Segment,
        COUNT(DISTINCT [Order ID]) AS Total_Purchases
    FROM [dbo].[Orders$]
    GROUP BY [Customer ID], Segment
)
SELECT 
    Segment,
    COUNT(DISTINCT [Customer ID]) AS Total_Customers_In_Segment,
    SUM(Total_Purchases) AS Total_Segment_Orders,
    ROUND(AVG(CAST(Total_Purchases AS DECIMAL(10,2))), 2) AS Avg_Purchases_Per_Customer
FROM SegmentPurchases
GROUP BY Segment
ORDER BY Avg_Purchases_Per_Customer DESC;

-- Task 5A: Analyze monthly sales to determine seasonal trends
WITH NumberedOrders AS (
    SELECT *, ROW_NUMBER() OVER (ORDER BY (SELECT NULL)) AS RowPos
    FROM [dbo].[Orders$]
),
NumberedSales AS (
    SELECT *, ROW_NUMBER() OVER (ORDER BY (SELECT NULL)) AS RowPos
    FROM [dbo].[Sales$]
)
SELECT 
    DATEPART(YEAR, o.[Order Date]) AS Order_Year,
    DATEPART(MONTH, o.[Order Date]) AS Order_Month,
    FORMAT(o.[Order Date], 'MMMM') AS Month_Name,
    COUNT(DISTINCT o.[Order ID]) AS Total_Orders,
    ROUND(SUM(s.Sales), 2) AS Total_Sales_Amount,
    ROUND(SUM(s.Profit), 2) AS Total_Profit
FROM NumberedOrders o
JOIN NumberedSales s ON o.RowPos = s.RowPos
GROUP BY DATEPART(YEAR, o.[Order Date]), DATEPART(MONTH, o.[Order Date]), FORMAT(o.[Order Date], 'MMMM')
ORDER BY Order_Year, Order_Month;