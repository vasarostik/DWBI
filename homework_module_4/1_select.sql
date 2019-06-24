USE SalesOrders
GO

/*1*/
SELECT DISTINCT c.CustCity AS CustCities FROM dbo.Customers c

/*2*/
SELECT e.EmpFirstName,
	   e.EmpLastName, 
	   e.EmpPhoneNumber FROM dbo.Employees e

/*3*/
SELECT DISTINCT c.CategoryDescription FROM dbo.Products p 
	   JOIN dbo.Categories c ON c.CategoryID = p.CategoryID 

/*4*/
SELECT p.ProductName,
	   p.RetailPrice,
	   c.CategoryDescription FROM dbo.Products p 
	   JOIN dbo.Categories c ON c.CategoryID = p.CategoryID
WHERE p.ProductNumber IN (SELECT DISTINCT o.ProductNumber FROM dbo.Product_Vendors o) 

/*5*/
SELECT v.VendName FROM dbo.Vendors v
ORDER BY v.VendZipCode

/*6*/
SELECT e.EmpFirstName, 
	   e.EmpLastName, 
	   e.EmpPhoneNumber, 
	   e.EmployeeID 
	   FROM dbo.Employees e 
ORDER BY e.EmpLastName,e.EmpFirstName

/*7*/
SELECT v.VendName FROM dbo.Vendors v

/*8*/
SELECT DISTINCT CASE
					 WHEN c.CustState = 'CA' THEN 'California'
					 WHEN c.CustState = 'OR' THEN 'Oregon'
					 WHEN c.CustState = 'TX' THEN 'Texas'
					 WHEN c.CustState = 'WA' THEN 'Washington'
					 ELSE c.CustState
					 END
					 FROM dbo.Customers c

/*9*/
SELECT p.ProductName, 
	   p.RetailPrice FROM dbo.Products p

/*10*/
SELECT e.EmpAreaCode,
	   e.EmpCity,
	   e.EmpFirstName,
	   e.EmpLastName,
	   e.EmployeeID,
	   e.EmpPhoneNumber,
	   e.EmpState,
	   e.EmpStreetAddress,
	   e.EmpZipCode
	   FROM dbo.Employees e

/*11*/
SELECT v.VendCity, 
	   v.VendName FROM dbo.Vendors v

/*12*/
SELECT a.OrderNumber,
	   MAX(a.SlowVendorTime) as MaxDeliveryTime
	   FROM (SELECT o.OrderNumber,
					o.ProductNumber,
					MAX(p.DaysToDeliver) AS SlowVendorTime 
			 FROM dbo.Order_Details o JOIN dbo.Product_Vendors p ON p.ProductNumber = o.ProductNumber 
			 GROUP BY o.ProductNumber,o.OrderNumber) AS a
GROUP BY a.OrderNumber
ORDER BY a.OrderNumber

/*13*/
SELECT p.ProductNumber, 
	   p.QuantityOnHand * p.RetailPrice FROM dbo.Products p

/*14*/
SELECT a.OrderNumber,
	   MAX(a.SlowVendorTime)+DATEDIFF(DAY,o.OrderDate,o.ShipDate) as FullDeliveryTime
	   FROM (SELECT o.OrderNumber,
					o.ProductNumber,
					MAX(p.DaysToDeliver) AS SlowVendorTime 
			 FROM dbo.Order_Details o 
			 JOIN dbo.Product_Vendors p ON p.ProductNumber = o.ProductNumber 
			 GROUP BY o.ProductNumber,o.OrderNumber) AS a
JOIN dbo.Orders o ON o.OrderNumber = a.OrderNumber
GROUP BY a.OrderNumber,
		 o.OrderDate,
		 o.ShipDate
ORDER BY a.OrderNumber


/*1 additional*/
;WITH num AS (
	SELECT 1 number
	UNION ALL
	SELECT number + 1 FROM num
	WHERE number+1 <= 10000
)
SELECT * FROM num
OPTION (maxrecursion 10000)

/*2 additional*/
;WITH amount AS
( SELECT CAST('20190101' AS DATE) AS [Date], DATENAME(WEEKDAY,'20190101') AS [Day]
	UNION ALL
  SELECT DATEADD(DAY,1,a.[Date]),DATENAME(WEEKDAY,DATEADD(DAY,1,a.[Date])) FROM amount a
  WHERE a.Date<'20191231'
), sun AS
( SELECT * FROM amount a
	WHERE a.[Day] IN('Saturday','Sunday')
)

SELECT s.[Day],
	   COUNT(s.[Day]) AS 'Count in year' FROM sun s
GROUP BY s.[Day]
OPTION(maxrecursion 366)