USE RV_module_2
GO

-- First pair of tables

CREATE TABLE dbo.Customer(
	customerID integer NOT NULL,
	firstName varchar(20) NOT NULL,
	lastName varchar(20) NOT NULL,
	age integer NOT NULL,
	email varchar(255),
	identityCode integer NOT NULL,
	additionalInfo text NULL,
	created bit NOT NULL,
	inserted_date datetime NOT NULL,
	updated_date datetime NOT NULL,
	constraint age_permission check (age >= 18),
	constraint id_code_unique unique (identityCode),
	constraint customer_pk primary key (customerID)
	)
GO

CREATE TABLE dbo.OrderLine(
	orderID integer NOT NULL,
	customerID integer NOT NULL,
	orderNumber integer NOT NULL,
	orderName varchar(20) NULL,
	orderHeaderID integer NOT NULL,
	stock integer NOT NULL,
	price integer NOT NULL,
	additionalInfo text,
	inserted_date datetime NOT NULL,
	updated_date datetime NOT NULL,
	constraint price_validation check (price >= 0),
	constraint orderNum_UQ unique (orderNumber),
	constraint orderID_PK primary key (orderID),
	constraint cutromerID_FK foreign key (customerID)
	references dbo.Customer(customerID)
	)
GO

-- Second pair of tables

CREATE TABLE dbo.Employer(
	employerID integer NOT NULL,
	companyName varchar(20) NOT NULL,
	companyType varchar(20) NOT NULL,
	city varchar(20) NOT NULL,
	phoneNum integer NOT NULL,
	email varchar(255) NULL,
	workersAmount integer NOT NULL,
	created bit NOT NULL,
	additionalInfo varchar(255) NULL,
	inserted_date datetime NOT NULL,
	constraint workers_enough_existence check (workersAmount >= 10),
	constraint companyName_UQ unique (companyName),
	constraint employer_pk primary key (employerID)
	)
GO

CREATE TABLE dbo.EmployerLog(
	employerID integer NOT NULL,
	companyName varchar(20) NOT NULL,
	companyType varchar(20) NOT NULL,
	city varchar(20) NOT NULL,
	phoneNum integer NOT NULL,
	email varchar(255) NULL,
	workersAmount integer NOT NULL,
	created bit NOT NULL,
	additionalInfo varchar(255) NULL,
	inserted_date datetime NOT NULL,
	type_of_operation varchar(20) NULL,
	date_of_operation datetime NULL,
	)
GO