USE RV_module_3
GO

CREATE TABLE dbo.Suppliers(
	supplier_id integer primary key,
	name varchar(20) null,
	rating integer null,
	city varchar(20) null)

CREATE TABLE dbo.Details(
	detail_id integer primary key,
	name varchar(20) null,
	color varchar(20) null,
	weight integer null,
	city varchar(20) null)

CREATE TABLE dbo.Products(
	product_id integer primary key,
	name varchar(20) null,
	city varchar(20) null)

CREATE TABLE dbo.Supplies(
	supplier_id integer foreign key references dbo.Suppliers(supplier_id) ON DELETE CASCADE,
	detail_id integer foreign key references dbo.Details(detail_id) ON DELETE CASCADE,
	product_id integer foreign key references dbo.Products(product_id) ON DELETE CASCADE,
	quantity integer null)


-- Insert --

--Suppliers--
INSERT INTO dbo.Suppliers VALUES(1,'Smith',20,'London')
INSERT INTO dbo.Suppliers VALUES(2,'Jonth',10,'Paris')
INSERT INTO dbo.Suppliers VALUES(3,'Blacke',30,'Paris')
INSERT INTO dbo.Suppliers VALUES(4,'Clarck',20,'London')
INSERT INTO dbo.Suppliers VALUES(5,'Adams',30,'Athens')

--Details--
INSERT INTO dbo.Details VALUES(1,'Screw','Red',12,'London')
INSERT INTO dbo.Details VALUES(2,'Bolt','Green',17,'Paris')
INSERT INTO dbo.Details VALUES(3,'Male-screw','Blue',17,'Roma')
INSERT INTO dbo.Details VALUES(4,'Male-screw','Red',14,'London')
INSERT INTO dbo.Details VALUES(5,'Whell','Blue',12,'Paris')
INSERT INTO dbo.Details VALUES(6,'Bloom','Red',19,'London')

--Products--
INSERT INTO dbo.Products VALUES(1,'HDD','Paris')
INSERT INTO dbo.Products VALUES(2,'Perforator','Roma')
INSERT INTO dbo.Products VALUES(3,'Reader','Athens')
INSERT INTO dbo.Products VALUES(4,'Printer','Athens')
INSERT INTO dbo.Products VALUES(5,'FDD','London')
INSERT INTO dbo.Products VALUES(6,'Terminal','Oslo')
INSERT INTO dbo.Products VALUES(7,'Ribbon','London')

--Supplies--
INSERT INTO dbo.Supplies VALUES(1,1,1,200)
INSERT INTO dbo.Supplies VALUES(1,1,4,700)
INSERT INTO dbo.Supplies VALUES(2,3,1,400)
INSERT INTO dbo.Supplies VALUES(2,3,2,200)
INSERT INTO dbo.Supplies VALUES(2,3,3,200)
INSERT INTO dbo.Supplies VALUES(2,3,4,500)
INSERT INTO dbo.Supplies VALUES(2,3,5,600)
INSERT INTO dbo.Supplies VALUES(2,3,6,400)
INSERT INTO dbo.Supplies VALUES(2,3,7,800)
INSERT INTO dbo.Supplies VALUES(2,5,2,1000)
INSERT INTO dbo.Supplies VALUES(3,3,1,200)
INSERT INTO dbo.Supplies VALUES(3,4,2,500)
INSERT INTO dbo.Supplies VALUES(4,6,3,300)
INSERT INTO dbo.Supplies VALUES(4,6,7,300)
INSERT INTO dbo.Supplies VALUES(5,2,2,200)
INSERT INTO dbo.Supplies VALUES(5,2,4,100)
INSERT INTO dbo.Supplies VALUES(5,5,5,500)
INSERT INTO dbo.Supplies VALUES(5,5,7,100)
INSERT INTO dbo.Supplies VALUES(5,6,2,200)
INSERT INTO dbo.Supplies VALUES(5,1,4,100)
INSERT INTO dbo.Supplies VALUES(5,3,4,200)
INSERT INTO dbo.Supplies VALUES(5,4,4,800)
INSERT INTO dbo.Supplies VALUES(5,5,4,400)
INSERT INTO dbo.Supplies VALUES(5,6,4,500)

-- First part: DML queries --

--1--
UPDATE dbo.Suppliers
SET rating += 10
WHERE rating < (SELECT s.rating FROM dbo.Suppliers s WHERE s.supplier_id = 4 )

--2--
SELECT DISTINCT s.product_id INTO dbo.London_product FROM dbo.Supplies s
WHERE s.product_id IN (SELECT p.product_id FROM dbo.Products p WHERE p.city = 'London')
OR s.supplier_id IN (SELECT s.supplier_id FROM dbo.Suppliers s WHERE s.city = 'London')

--3--
INSERT INTO dbo.Products VALUES(10,'Laptop','Lviv')

DELETE FROM dbo.Products 
WHERE product_id NOT IN (SELECT DISTINCT product_id FROM dbo.Supplies)

--5--
UPDATE dbo.Supplies
SET quantity = quantity * 1.1

SELECT * FROM dbo.Supplies
WHERE supplier_id in 
	(SELECT supplier_id FROM dbo.Supplies WHERE detail_id IN 
	(SELECT detail_id FROM Details WHERE color = 'Red'))

--6--
CREATE TABLE dbo.Color_City(
	color varchar(20) not null,
	city varchar(20) not null)
GO

CREATE OR ALTER TRIGGER trg_colcity
   ON  dbo.Color_City FOR INSERT 
AS 
BEGIN
	SET NOCOUNT ON;
	DELETE FROM dbo.Color_City WHERE color IN(SELECT inserted.color FROM inserted) and city IN(SELECT inserted.city FROM inserted)
	INSERT INTO dbo.Color_City SELECT * FROM inserted
END
GO

--7--
SELECT DISTINCT s.detail_id INTO dbo.London_details FROM dbo.Supplies s
WHERE s.product_id IN (SELECT p.product_id FROM dbo.Products p where p.city = 'London')
  OR s.supplier_id IN (SELECT s.supplier_id FROM dbo.Suppliers s where s.city = 'London')

--8--
INSERT INTO dbo.Suppliers VALUES (10,'White',null,'New York')
GO

--9--
DELETE FROM dbo.Products
WHERE city = 'Roma'

--10--
SELECT p.city FROM dbo.Products p
UNION
SELECT s.city FROM dbo.Suppliers s
UNION
SELECT d.city FROM dbo.Details d
ORDER BY 1 

SELECT DISTINCT s.city FROM dbo.Suppliers s

--11--
UPDATE dbo.Details
SET color = 'Yellow'
WHERE weight < 15 and color = 'Red'

--12--
SELECT p.product_id,p.city INTO dbo.Product_city FROM dbo.Products p
WHERE p.city LIKE '_[o]%'

--13--
UPDATE dbo.Suppliers
SET rating += 10
FROM dbo.Suppliers r
JOIN dbo.Supplies s
ON s.supplier_id = r.supplier_id and s.quantity > (SELECT avg(s.quantity) FROM dbo.Supplies s)

--14--
SELECT DISTINCT s.supplier_id INTO dbo.First_product FROM dbo.Supplies s
WHERE s.product_id = 1
ORDER BY 1

--15--
SELECT DISTINCT TOP 2 s.name INTO dbo.Two_suppliers FROM dbo.Suppliers s

-- Second part: MERGE --

--1--
CREATE TABLE dbo.tmp_Details(
	detail_id integer primary key,
	name varchar(20) null,
	color varchar(20) null,
	weight integer null,
	city varchar(20) null)

INSERT INTO tmp_Details (detail_id, name, color, weight, city) 
VALUES (1, 'Screw',         'Blue',     13, 'Osaka');
INSERT INTO tmp_Details (detail_id, name, color, weight, city) 
VALUES (2, 'Bolt',           'Pink', 12, 'Tokio');
INSERT INTO tmp_Details (detail_id, name, color, weight, city) 
VALUES (18, 'Whell-24', 'Red',   14, 'Lviv');
INSERT INTO tmp_Details (detail_id, name, color, weight, city) 
VALUES (19, 'Whell-28', 'Pink',     15, 'London');

--2--
MERGE dbo.Details as T
	USING (SELECT * FROM dbo.tmp_Details t) as S (detail_id, name, color, weight, city)
	ON (T.detail_id = S.detail_id)
WHEN MATCHED THEN
	UPDATE SET T.name = S.name,
			   T.color = S.color, 
			   T.weight = S.weight, 
			   T.city = S.city
WHEN  NOT MATCHED THEN
	INSERT (detail_id, name, color, weight, city) VALUES (S.detail_id, S.name, S.color, S.weight, S.city);

SELECT * FROM dbo.Details