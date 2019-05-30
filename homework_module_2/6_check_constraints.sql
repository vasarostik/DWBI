USE RV_module_2
GO

-- Check PK constraint in Customer table --

/* We already have 100 rows in customer table(4_bulk_insert.sql), that is why there must be error,
   customerID - Primary key */

INSERT INTO dbo.customer(customerID, 
							firstName, 
							lastName, 
							age, 
							email, 
							identityCode, 
							additionalInfo, 
							created, 
							inserted_date, 
							updated_date)
VALUES('1','Rostyslav','Vasylyk','19','rost.vasylyk@gmail.com','1234','good','0','01/01/98 23:59:59.999','01/01/98 23:59:59.999')


-- Check UQ constraint in Customer table --

-- Unique value - identityCode
-- insert row with identityCode '1235'

INSERT INTO dbo.customer(customerID, 
							firstName, 
							lastName, 
							age, 
							email, 
							identityCode, 
							additionalInfo, 
							created, 
							inserted_date, 
							updated_date)
VALUES('101','Rostyslav','Vasylyk','19','rost.vasylyk@gmail.com','1235','good','0','01/01/98 23:59:59.999','01/01/98 23:59:59.999')

-- try again to insert row with identityCode '1235' - now there must be error

INSERT INTO dbo.customer(customerID, 
							firstName, 
							lastName, 
							age, 
							email, 
							identityCode, 
							additionalInfo, 
							created, 
							inserted_date, 
							updated_date)
VALUES('102','Rostyslav','Vasylyk','19','rost.vasylyk@gmail.com','1235','good','0','01/01/98 23:59:59.999','01/01/98 23:59:59.999')


-- Check CHECK constraint in Customer table --
-- check age >= 18

INSERT INTO dbo.customer(customerID, 
							firstName, 
							lastName, 
							age, 
							email, 
							identityCode, 
							additionalInfo, 
							created, 
							inserted_date, 
							updated_date)
VALUES('103','Rostyslav','Vasylyk','17','rost.vasylyk@gmail.com','123','good','0','01/01/98 23:59:59.999','01/01/98 23:59:59.999')


-- Check WITH CHECK constraint --
--WITH CHECK constraint catch (created -  not 1)--

INSERT INTO dbo.customerViewMod(customerID, 
									firstName, 
									lastName, 
									age, 
									email, 
									identityCode, 
									additionalInfo, 
									created, 
									inserted_date, 
									updated_date)
VALUES('104','Rostyslav','Vasylyk','19','rost.vasylyk@gmail.com','12345','good','0','01/01/98 23:59:59.999','01/01/98 23:59:59.999')

--WITH CHECK constraint catch (orderHeaderID - not 10000)--

INSERT INTO dbo.orderViewMod(orderID, 
								customerID, 
								orderNumber, 
								orderName, 
								orderHeaderID, 
								stock, 
								price, 
								additionalInfo, 
								inserted_date, 
								updated_date)
VALUES('105','100','31233','Vasylyk','19','12300','123456','good','01/01/98 23:59:59.999','01/01/98 23:59:59.999')





