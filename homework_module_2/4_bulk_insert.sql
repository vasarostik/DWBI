USE RV_module_2
GO

-- Bulk insert from csv file

bulk insert dbo.Customer
from 'C:\Users\...\customer.csv'
with (FIRSTROW = 2,fieldterminator = ',', rowterminator = '\n')
go

bulk insert dbo.orderLine
from 'C:\Users\...\order.csv'
with (FIRSTROW = 2,fieldterminator = ',', rowterminator = '\n')
go

bulk insert dbo.Employer
from 'C:\Users\...\employer.csv'
with (FIRSTROW = 2,fieldterminator = ',', rowterminator = '\n')
go

-- NOTICE that trigger don`t insert records to EmployerLog during bulk insert --