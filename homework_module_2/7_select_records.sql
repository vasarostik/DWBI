USE RV_module_2
GO

SELECT * FROM dbo.Customer

SELECT * FROM dbo.OrderLine

SELECT * FROM dbo.Employer

SELECT * FROM dbo.EmployerLog

-- Select from EmployerLog with regard to type of operation --

-- insert --
INSERT INTO dbo.Employer (employerID, 
							companyName, 
							companyType,  
							city, 
							phoneNum,
							email,
							workersAmount,
							created,
							additionalInfo,
							inserted_date)
VALUES ('111','epam','recr','lviv','093','rost.vasylyk@gmail.com','11','1','asdewrf','01/01/98 23:59:59.999')

SELECT * FROM dbo.EmployerLog

-- update --
UPDATE dbo.Employer 
   SET city = 'Kyiv'
 WHERE employerID = '111'


SELECT * FROM dbo.EmployerLog

-- delete --
DELETE FROM dbo.Employer 
WHERE employerID = '111'

SELECT * FROM dbo.EmployerLog

