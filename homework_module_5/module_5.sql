USE labor_sql
GO

/*------FIRST PART(nested queries)------*/

/*a Отримати номери виробів, для яких всі деталі постачає постачальник 3 */
SELECT s.productID FROM (SELECT DISTINCT s1.supplierID, 
										 s1.productID 
										 FROM dbo.Supplies s1) s
GROUP BY s.productID
HAVING COUNT(s.supplierID) = 1 AND s.productID IN (SELECT s2.productID FROM dbo.Supplies s2
												   WHERE s2.supplierID = 3)

/*b Отримати номера і прізвища постачальників, які постачають деталі для якого-небудь виробу з деталлю 1 в кількості більшій, ніж середній об’єм поставок деталі 1 для цього виробу */
SELECT s.supplierID, s.[name] FROM dbo.Suppliers s
WHERE s.supplierID IN
	(SELECT s.supplierID FROM dbo.Supplies s 
	 WHERE s.detailID = 1 AND s.quantity >
		(SELECT avg(s1.quantity) FROM dbo.Supplies s1
		 WHERE s1.detailID = 1
		 GROUP BY s1.productID
		 HAVING s.productID = s1.productID))

/*c Отримати повний список деталей для всіх виробів, які виготовляються в Лондоні */
SELECT d.detailID,
	   d.[name],
	   d.color,
	   d.[weight],
	   d.city FROM dbo.Details d WHERE d.detailID IN 
		(SELECT s.detailID FROM dbo.Supplies s WHERE s.productID IN 
			(SELECT p.productID FROM dbo.Products p WHERE p.city = 'London'))

/*d Показати номери і назви постачальників, що постачають принаймні одну червону деталь */
SELECT s.supplierID, s.name FROM dbo.Suppliers s WHERE s.supplierID IN
	(SELECT s.supplierID FROM dbo.Supplies s WHERE s.detailID IN
		(SELECT d.detailID FROM dbo.Details d WHERE d.color = 'Red') )

/*e Показати номери деталей, які використовуються принаймні в одному виробі, який поставляється постачальником 2 */
SELECT d.detailID FROM dbo.Details d WHERE d.detailID IN
	(SELECT s.detailID FROM dbo.Supplies s WHERE s.supplierID = 2)
/* without nested query */
SELECT DISTINCT s.detailID FROM dbo.Supplies s WHERE s.supplierID = 2

/*f Отримати номери виробів, для яких середній об’єм поставки деталей  більший за найбільший об’єм поставки будь-якої деталі для виробу 1 */
SELECT s.productID FROM dbo.Supplies s
GROUP by s.productID
HAVING avg(s.quantity) > (SELECT max(s.quantity) FROM dbo.Supplies s
						  WHERE s.productID = 1)

/*g Вибрати вироби, що ніколи не постачались (під-запит) */
SELECT p.productID, p.[name] FROM dbo.Products p WHERE p.productID NOT IN
	(SELECT s.productID FROM dbo.Supplies s)


/*--------------SECOND PART(CTE/Hierarchical queries)-------------*/

/*1 Написати довільний запит з двома СТЕ  (в одному є звертання до іншого)  */
;WITH first_cte AS (SELECT * FROM dbo.Suppliers g
				    WHERE g.city LIKE '%a%'
					),
	  sec_cte AS (SELECT f.city FROM first_cte f)
SELECT * FROM sec_cte

/*2 Обчислити за допомогою рекурсивної CTE факторіал від 10  та вивести у форматі таблиці з колонками Position та Value */
;WITH fact AS (
	SELECT 0 as n, 1 as f, 1 AS last
	UNION ALL
	SELECT n+1,(n+1)*f, f
	FROM fact
	WHERE n < 10)

SELECT f.n as Position, f.f as [Value] FROM fact f

/*3 Обчислити за допомогою рекурсивної CTE перші 20 елементів ряду Фібоначчі та вивести у форматі таблиці з колонками Position та Value */
;WITH fib AS (
    SELECT 0 AS n, 0 AS [current], 1 AS [last]
    UNION ALL
    SELECT n+1,[last]+[current], [current]
    FROM fib
    WHERE n<20)
SELECT f.n as Position, f.[current] as [Value] FROM fib f

/*4 Розділити вхідний період 2013-11-25 до 2014-03-05 на періоди по календарним місяцям за допомогою рекурсивної CTE та вивести у форматі таблиці з колонками StartDate та EndDate */
;WITH [range] AS
( SELECT CAST('20131125' AS date) AS [Date], EOMONTH(CAST('20131125' AS date)) AS [Day]
	 UNION ALL
  SELECT DATEADD(DAY,1,a.[Day]),
		 CASE 
			WHEN EOMONTH(DATEADD(MONTH,1,a.[Day])) > '20140305' THEN CAST('20140305' AS date)
		 ELSE EOMONTH(DATEADD(MONTH,1,a.[Day]))
		 END
		 FROM [range] a
  WHERE a.[Day]<'20140305'
)
SELECT r.[Date] as StartDate, r.[Day] as EndDate FROM [range] r

/*5 Розрахувати календар поточного місяця за допомогою рекурсивної CTE та вивести дні місяця у форматі таблиці з колонками.. */
DECLARE @month VARCHAR(5)='Aug'
SET DATEFIRST 1;
;WITH calendar
AS
(
SELECT number,
DATENAME(WEEK,CONVERT(datetime,'2019-'+ CONVERT(varchar(2),CASE @month  WHEN 'Jan' THEN 1 
																		WHEN 'Feb' THEN 2
																		WHEN 'Mar' THEN 3
																		WHEN 'Apr' THEN 4
																		WHEN 'May' THEN 5
																		WHEN 'Jun' THEN 6
																		WHEN 'Jul' THEN 7
																		WHEN 'Aug' THEN 8
																		WHEN 'Sep' THEN 9
																		WHEN 'Oct' THEN 10
																		WHEN 'Nov' THEN 11
																		WHEN 'Dec' THEN 12
																		END)+'-'+CONVERT(varchar(2),number))) as WEEK, 
DATENAME(DW,CONVERT(datetime,'2019-'+ CONVERT(varchar(2),CASE @month    WHEN 'Jan' THEN 1 
																		WHEN 'Feb' THEN 2
																		WHEN 'Mar' THEN 3
																		WHEN 'Apr' THEN 4
																		WHEN 'May' THEN 5
																		WHEN 'Jun' THEN 6
																		WHEN 'Jul' THEN 7
																		WHEN 'Aug' THEN 8
																		WHEN 'Sep' THEN 9
																		WHEN 'Oct' THEN 10
																		WHEN 'Nov' THEN 11
																		WHEN 'Dec' THEN 12
																		END)+'-'+CONVERT(varchar(2),number))) AS WEEKDAY
																		FROM MASTER..spt_values WHERE type='p' AND number BETWEEN 1 AND 
                                               
DATEPART(DAY,DATEADD(DW,-(DATEPART(DAY,DATEADD(MONTH,1,CONVERT(datetime,'2019-'+ CONVERT(varchar(2),CASE @month 
																										WHEN 'Jan' THEN 1 
																										WHEN 'Feb' THEN 2
																										WHEN 'Mar' THEN 3
																										WHEN 'Apr' THEN 4
																										WHEN 'May' THEN 5
																										WHEN 'Jun' THEN 6
																										WHEN 'Jul' THEN 7
																										WHEN 'Aug' THEN 8
																										WHEN 'Sep' THEN 9
																										WHEN 'Oct' THEN 10
																										WHEN 'Nov' THEN 11
																										WHEN 'Dec' THEN 12
																										END)+'-'+CONVERT(varchar(2),01))))),DATEADD(MONTH,1,CONVERT(datetime,'2011-'+ CONVERT(varchar(2),CASE @month
																										WHEN 'Jan' THEN 1 
																										WHEN 'Feb' THEN 2
																										WHEN 'Mar' THEN 3
																										WHEN 'Apr' THEN 4
																										WHEN 'May' THEN 5
																										WHEN 'Jun' THEN 6
																										WHEN 'Jul' then 7
																										WHEN 'Aug' THEN 8
																										WHEN 'Sep' THEN 9
																										WHEN 'Oct' THEN 10
																										WHEN 'Nov' THEN 11
																										WHEN 'Dec' THEN 12	
																										END)+'-'+CONVERT(varchar(2),1))))))
SELECT [Monday],[Tuesday],[Wednesday],[Thursday],[Friday],[Saturday],[Sunday]
FROM (SELECT * FROM calendar) a
PIVOT
(MAX(number) FOR WEEKDAY IN([Monday],[Tuesday],[Wednesday],[Thursday],[Friday],[Saturday],[Sunday])) b

/*6 Створити таблицю  geography  та занести в неї дані */
CREATE TABLE dbo.[geography]
(id INT NOT NULL PRIMARY KEY, NAME VARCHAR(20), region_id INT);

ALTER TABLE [geography]
       ADD CONSTRAINT R_GB
              FOREIGN KEY (region_id)
                             REFERENCES [geography]  (id);


insert into [geography] values (1, 'Ukraine', null);
insert into [geography] values (2, 'Lviv', 1);
insert into [geography] values (8, 'Brody', 2);
insert into [geography] values (18, 'Gayi', 8);
insert into [geography] values (9, 'Sambir', 2);
insert into [geography] values (17, 'St.Sambir', 9);
insert into [geography] values (10, 'Striy', 2);
insert into [geography] values (11, 'Drogobych', 2);
insert into [geography] values (15, 'Shidnytsja', 11);
insert into [geography] values (16, 'Truskavets', 11);
insert into [geography] values (12, 'Busk', 2);
insert into [geography] values (13, 'Olesko', 12);
insert into [geography] values (30, 'Lvivska st', 13);
insert into [geography] values (14, 'Verbljany', 12);
insert into [geography] values (3, 'Rivne', 1);
insert into [geography] values (19, 'Dubno', 3);
insert into [geography] values (31, 'Lvivska st', 19);
insert into [geography] values (20, 'Zdolbuniv', 3);
insert into [geography] values (4, 'Ivano-Frankivsk', 1);
insert into [geography] values (21, 'Galych', 4);
insert into [geography] values (32, 'Svobody st', 21);
insert into [geography] values (22, 'Kalush', 4);
insert into [geography] values (23, 'Dolyna', 4);
insert into [geography] values (5, 'Kiyv', 1);
insert into [geography] values (24, 'Boryspil', 5);
insert into [geography] values (25, 'Vasylkiv', 5);
insert into [geography] values (6, 'Sumy', 1);
insert into [geography] values (26, 'Shostka', 6);
insert into [geography] values (27, 'Trostjanets', 6);
insert into [geography] values (7, 'Crimea', 1);
insert into [geography] values (28, 'Yalta', 7);
insert into [geography] values (29, 'Sudack', 7);

/*7 Написати запит  який повертає регіони першого рівня */
;WITH reg AS (
SELECT * FROM dbo.[geography] g
			  WHERE g.region_id = 1)

SELECT g.region_id AS 'PlaceLevel',
		reg.* FROM reg INNER JOIN dbo.[geography] g ON g.id=reg.id

/*8 Написати запит який повертає під-дерево для конкретного регіону  (наприклад, Івано-Франківськ). */
;WITH reg AS(
	SELECT g.region_id, g.id, g.[name], Placelevel = -1 FROM dbo.[geography] g
	WHERE g.[name] = 'Ivano-Frankivsk'
	UNION ALL
	SELECT g1.region_id, g1.id, g1.[name], r.Placelevel+1 FROM dbo.[geography] g1 
	JOIN reg r ON g1.region_id = r.id)

SELECT * FROM reg r
WHERE r.Placelevel > -1

/*9 Написати запит котрий вертає повне дерево  від root ('Ukraine') і додаткову колонку, яка вказує на рівень в ієрархії */
;WITH reg AS(
	SELECT g.id, g.[name], Placelevel = 1 FROM dbo.[geography] g
	WHERE g.[name] = 'Ukraine'
	UNION ALL
	SELECT g1.id, g1.[name], r.Placelevel+1 FROM dbo.[geography] g1 
	JOIN reg r ON g1.region_id = r.id)

SELECT r.[name] AS [Name], r.Placelevel FROM reg r
WHERE r.Placelevel > 0

/*10 Написати запит який повертає дерево для регіону Lviv */
;WITH reg AS(
	SELECT g.region_id, g.id, g.[name], Placelevel = 1 FROM dbo.[geography] g
	WHERE g.[name] = 'Lviv'
	UNION ALL
	SELECT g1.region_id, g1.id, g1.[name], r.Placelevel+1 FROM dbo.[geography] g1 
	JOIN reg r ON g1.region_id = r.id)

SELECT r.[name] AS [Name], 
	   r.id, 
	   r.region_id, 
	   r.Placelevel 
	   FROM reg r
WHERE r.Placelevel > 0

/*11 Написати запит який повертає дерево зі шляхами для регіону Lviv */
WITH reg AS(
	SELECT  g.id, g.[name], Placelevel = 1, CAST('/Lviv' AS VARCHAR(255)) AS Placestart FROM dbo.[geography] g
	WHERE g.[name] = 'Lviv'
	UNION ALL
	SELECT  g1.id, g1.[name], r.Placelevel+1,CAST(r.Placestart+'/'+g1.[name] AS VARCHAR(255)) FROM dbo.[geography] g1 
	JOIN reg r ON g1.region_id = r.id)

SELECT r.[name] AS [Name], 
	   r.Placelevel, 
	   r.Placestart 
	   FROM reg r
WHERE r.Placelevel > 0

/*12 Написати запит, який повертає дерево  зі шляхами і довжиною шляхів для регіону Lviv */
WITH reg AS(
	SELECT  g.id, g.[name], Placelevel = 1, CAST('/Lviv' AS VARCHAR (255)) AS Placestart FROM dbo.[geography] g
	WHERE g.[name] = 'Lviv'
	UNION ALL
	SELECT  g1.id, g1.[name], r.Placelevel+1,CAST(r.Placestart+'/'+g1.[name] AS VARCHAR(255)) FROM dbo.[geography] g1 
	JOIN reg r ON g1.region_id = r.id)

SELECT r.[name] AS Region, 
	   'Lviv' AS center, 
	   r.Placelevel-1 AS pathlen, 
	   r.Placestart AS [path]
	   FROM reg r
WHERE r.Placelevel > 1


/*----------THIRD PART(UNION, UNION ALL, EXCEPT, INTERSECT)----------*/

/*1 Вибрати постачальників з Лондона або Парижу */
SELECT s.supplierID, s.[name], s.rating, s.city FROM dbo.Suppliers s WHERE s.city = 'London'
UNION
SELECT s.supplierID, s.[name], s.rating, s.city FROM dbo.Suppliers s WHERE s.city = 'Paris'

/*2 Вибрати всі міста, де є постачальники  і/або деталі (два запити – перший повертає міста з дублікатами, другий без дублікатів) . Міста у кожному запиті  відсортувати в алфавітному порядку */
SELECT s.city FROM dbo.Suppliers s
UNION all
SELECT d.city FROM dbo.Details d
ORDER BY city

SELECT s.city FROM dbo.Suppliers s
UNION 
SELECT d.city FROM dbo.Details d
ORDER BY city

/*3 Вибрати всіх постачальників за вийнятком тих, що постачають деталі з Лондона */
SELECT s.supplierID, s.[name], s.rating, s.city FROM dbo.Suppliers s
EXCEPT
SELECT s.supplierID, s.[name], s.rating, s.city FROM dbo.Suppliers s 
WHERE s.supplierID IN (SELECT s.supplierID FROM dbo.Supplies s JOIN dbo.Details d ON d.detailID = s.detailID AND d.city = 'London')

/*4 Знайти різницю між множиною продуктів, які знаходяться в Лондоні та Парижі  і множиною продуктів, які знаходяться в Парижі та Римі */
SELECT * FROM dbo.Products p WHERE ( p.city = 'London' OR p.city = 'Paris' ) AND  p.productID NOT IN (SELECT p.productID FROM dbo.Products p WHERE p.city = 'Paris' OR p.city = 'Roma')
UNION ALL
SELECT * FROM dbo.Products p WHERE ( p.city = 'Paris' OR p.city = 'Roma' ) AND p.productID NOT IN (SELECT p.productID FROM dbo.Products p WHERE  p.city = 'London' OR p.city = 'Paris' )

/*5 Вибрати поставки, що зробив постачальник з Лондона, а також поставки зелених деталей за виключенням поставлених виробів з Парижу (код постачальника, код деталі, код виробу) */
SELECT s.supplierID, s.detailID, s.productID FROM dbo.Supplies s 
WHERE s.supplierID IN (SELECT s.supplierID FROM dbo.Suppliers s WHERE s.city = 'London')
UNION
(SELECT s.supplierID, s.detailID, s.productID FROM dbo.Supplies s 
WHERE s.detailID IN (SELECT d.detailID FROM dbo.Details d WHERE d.color = 'Green')
EXCEPT 
SELECT s.supplierID, s.detailID, s.productID FROM dbo.Supplies s 
WHERE s.productID IN (SELECT p.productID FROM dbo.Products p WHERE p.city = 'Paris'))