USE RV_module_2
GO

-- Triggers to the first pair of tables

-- Customer`s time update
CREATE TRIGGER trg_UpdateTimeCustomer
ON dbo.Customer
AFTER UPDATE
AS
    UPDATE dbo.Customer
    SET updated_date = GETDATE()
    WHERE customerID IN (SELECT DISTINCT customerID FROM Inserted);
GO

-- Order`s time update
CREATE TRIGGER trg_UpdateTimeOrder
ON dbo.OrderLine
AFTER UPDATE
AS
    UPDATE dbo.OrderLine
    SET updated_date = GETDATE()
    WHERE orderID IN (SELECT DISTINCT orderID FROM Inserted);
GO


-- Triggers to the second pair of tables

-- Add record to EmployerLog with INSERT status and date of insert
CREATE TRIGGER trg_InsertEmployerLog
ON dbo.Employer
AFTER INSERT
AS
BEGIN
    INSERT INTO dbo.EmployerLog (employerID, companyName, companyType,  city, phoneNum,email,workersAmount,created,additionalInfo,inserted_date,type_of_operation,date_of_operation)
		   SELECT  i.employerID, i.companyName, i.companyType,  i.city, i.phoneNum, i.email,i.workersAmount,i.created,i.additionalInfo,i.inserted_date,'INSERT',GETDATE()
		   FROM inserted i
END;
GO

-- Add record to EmployerLog with UPDATE status and date of update
CREATE TRIGGER trg_UpdateEmployerLog
ON dbo.Employer
AFTER UPDATE
AS
BEGIN
    INSERT INTO dbo.EmployerLog (employerID, companyName, companyType,  city, phoneNum,email,workersAmount,created,additionalInfo,inserted_date,type_of_operation,date_of_operation)
		   SELECT  i.employerID, i.companyName, i.companyType,  i.city, i.phoneNum, i.email,i.workersAmount,i.created,i.additionalInfo,i.inserted_date,'UPDATE',GETDATE()
		   FROM inserted i
END;
GO

-- Add record to EmployerLog with DELETE status and date of DELETE
CREATE TRIGGER trg_DeleteEmployerLog
ON dbo.Employer
AFTER DELETE
AS
BEGIN
    INSERT INTO dbo.EmployerLog (employerID, companyName, companyType,  city, phoneNum,email,workersAmount,created,additionalInfo,inserted_date,type_of_operation,date_of_operation)
		   SELECT  d.employerID, d.companyName, d.companyType,  d.city, d.phoneNum, d.email,d.workersAmount,d.created,d.additionalInfo,d.inserted_date,'DELETE',GETDATE()
		   FROM deleted d
END;
GO