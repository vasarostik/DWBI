USE RV_module_2
GO

-- Views
CREATE VIEW dbo.customerView
AS  
SELECT c.firstName, c.lastName, c.created, c.age  
FROM dbo.Customer c;
GO

CREATE VIEW dbo.orderView
AS  
SELECT o.customerID, o.orderName, o.stock, o.price
FROM dbo.OrderLine o;
GO

-- Views with check option
CREATE VIEW dbo.customerViewMod
AS  
SELECT c.customerID, c.firstName, c.lastName, c.age, c.email, c.identityCode, c.additionalInfo, c.created, inserted_date, updated_date 
FROM dbo.Customer c
WHERE c.created = '1'
WITH CHECK OPTION;
GO

CREATE VIEW dbo.orderViewMod
AS  
SELECT o.orderID, o.customerID, o.orderNumber, o.orderName, o.orderHeaderID, o.stock, o.price, o.additionalInfo, o.inserted_date, o.updated_date
FROM dbo.OrderLine o
WHERE o.orderHeaderID = '10000'
WITH CHECK OPTION;
GO