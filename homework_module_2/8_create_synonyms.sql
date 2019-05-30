USE education
GO

CREATE SYNONYM R_Vasylyk.Customer FOR RV_module_2.dbo.Customer
CREATE SYNONYM R_Vasylyk.OrderLine FOR RV_module_2.dbo.OrderLine
CREATE SYNONYM R_Vasylyk.Employer FOR RV_module_2.dbo.Employer
CREATE SYNONYM R_Vasylyk.EmployerLog FOR RV_module_2.dbo.EmployerLog


SELECT * FROM R_Vasylyk.Customer
SELECT * FROM R_Vasylyk.OrderLine
SELECT * FROM R_Vasylyk.Employer
SELECT * FROM R_Vasylyk.EmployerLog