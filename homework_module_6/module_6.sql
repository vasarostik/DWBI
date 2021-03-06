USE labor_sql
GO

/*1 Написати команду, яка повертає список продуктів, складений в алфавітному порядку міст де вони знаходяться + порядковий номер деталі в списку */
SELECT p.productID, 
	   p.[name], 
	   p.city,
	   ROW_NUMBER() OVER (ORDER BY p.city) AS RowNum FROM dbo.Products p

/*2	Написати команду, яка повертає список продуктів, складений в алфавітному порядку міст де вони знаходяться + порядковий номер в межах одного міста (відсортований за іменем продукту) */
SELECT p.productID, 
	   p.[name], 
	   p.city,
	   ROW_NUMBER() OVER (PARTITION BY p.city ORDER BY p.[name]) AS RowNum FROM dbo.Products p

/*3	Використовуючи за основу попередній запит написати запит, який повертає міста з порядковим номером 1 */
SELECT * FROM 
	(SELECT p.productID, 
		    p.[name], 
		    p.city,
		    ROW_NUMBER() OVER (PARTITION BY p.city ORDER BY p.[name]) AS RowNum FROM dbo.Products p) AS a
WHERE a.RowNum = 1

/*4 Написати запит, який повертає список продуктів, деталей, їхні поставки,  загальну кількість поставок для кожного продукту і загальну кількість поставок для кожної деталі */
SELECT  s.productID,
		s.detailID,
		s.quantity,
		SUM(SUM(s.quantity)) OVER(PARTITION BY s.productID) AS all_quantity_per_prod,
		SUM(SUM(s.quantity)) OVER(PARTITION BY s.detailID) AS all_quantity_per_det FROM dbo.Supplies s 
		JOIN dbo.Products p ON p.productID = s.productID 
		JOIN dbo.Details d ON d.detailID = s.detailID
GROUP BY s.productID,
		 s.detailID,
		 s.quantity

/*5 Організувати посторінковий вивід інформації з таблиці поставок, відсортований за  постачальниками, вивести записи з 10 по 15 запис, додатково вивести порядковий номер стрічки і загальну кількість записів у таблиці поставок */
SELECT * FROM 
	(SELECT s.supplierID, 
		    s.detailID, 
		    s.productID,
		    s.quantity,
		    ROW_NUMBER() OVER (ORDER BY s.supplierID) AS rn,
		    COUNT(*) OVER () AS tot FROM dbo.Supplies s) AS a
WHERE a.rn BETWEEN 10 AND 15

/*6	Написати запит, що розраховує середню кількість елементів в поставці і виводить ті поставки, де кількість елементів менше середньої */
SELECT * FROM 
	(SELECT s.supplierID, 
		    s.detailID, 
		    s.productID,
		    s.quantity,
		    AVG(s.quantity) OVER () AS avg_qty FROM dbo.Supplies s) AS a
WHERE a.quantity < a.avg_qty