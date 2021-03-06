/****** HOMEWORK SQL (SELECT)  ******/
use labor_sql
go

--1--
select distinct p.maker, 
			    p.[type] from dbo.product p
where p.[type] = 'laptop'
order by p.maker

--2--
select l.model,
	   l.ram,
	   l.screen,
	   l.price from dbo.laptop l
where l.price > 1000

--3--
select * from dbo.printer p
where p.color = 'y'
order by p.price desc

--4--
select p.model,
	   p.speed,
	   p.hd,
	   p.cd,
	   p.price from dbo.pc p
where p.cd = '12x' or p.cd = '24x'
order by p.speed desc

--5--
select s.[name], 
	   s.class from dbo.ships s
order by s.[name]

--6--
select * from dbo.pc p
where p.speed >= 500 and p.price < 800
order by p.price desc

--7--
select * from dbo.printer p
where p.[type] != 'Matrix' and price < 300
order by p.[type] desc

--8--
select p.model, 
	   p.speed from dbo.pc p
where p.price between 400 and 600
order by p.hd

--9--
select l.model,
	   l.speed,
	   l.hd,
	   l.price from dbo.laptop l
where l.screen >= 12
order by l.price desc

--10--
select p.model,
	   p.[type],
	   p.price from dbo.printer p
where p.price < 300
order by p.[type] desc

--11--
select l.model,
	   l.ram,
	   l.price from dbo.laptop l
where l.ram = 64
order by l.screen

--12--
select p.model,
	   p.ram,
	   p.price from dbo.pc p
where p.ram > 64
order by p.hd

--13--
select p.model,
	   p.speed,
	   p.price from dbo.pc p
where p.speed between 500 and 750
order by p.hd desc

--14--
select * from dbo.outcome_o o
where o.[out] >=2000
order by o.[date] desc

--15--
select * from dbo.income_o o
where o.inc between 5000 and 10000
order by o.inc

--16--
select * from dbo.income i
where i.point = 1
order by i.inc

--17--
select * from dbo.outcome o
where o.point = 2
order by o.[out]

--18--
select * from dbo.classes s
where s.country = 'Japan'
order by s.[type] desc

--19--
select s.[name],
	   s.launched from dbo.ships s
where s.launched between 1920 and 1942
order by s.launched desc

--20--
select o.ship, 
	   o.battle from dbo.outcomes o
where o.battle = 'Guadalcanal' and o.result != 'sunk'
order by o.ship desc

--21--
select * from dbo.outcomes o
where o.result='sunk'
order by o.ship

--22--
select c.class, 
	   c.displacement from dbo.classes c
where c.displacement>=40000
order by c.type

--23--
select t.trip_no, 
	   t.town_from, 
	   t.town_to from dbo.trip t
where t.town_from = 'London' or t.town_to = 'London'
order by t.time_out

--24--
select t.trip_no,
	   t.plane,
	   t.town_from,
	   t.town_to from dbo.trip t
where t.plane = 'TU-134'
order by t.time_out desc

--25--
select t.trip_no,
	   t.plane,
	   t.town_from,
	   t.town_to from dbo.trip t
where t.plane != 'IL-86'
order by t.plane

--26--
select t.trip_no,
	   t.town_from,
	   t.town_to from dbo.trip t
where t.town_from != 'Rostov' and t.town_to !='Rostov'
order by t.plane

--27--
select * from dbo.pc p
where p.model LIKE '%[1]%%[1]%' -- regex

--28--
select * from dbo.outcome o
where(DATEPART(mm, o.[date]) = 03) --datepart()

--29--
select * from dbo.outcome_o o
where (DATEPART(dd, o.[date]) = 14)

--30--
select * from dbo.ships s
where s.[name] like 'w%n' -- w% means w at the beginning

--31--
select * from dbo.ships s
where s.[name] like '%[e]%%[e]%[^e]' --only 2 'e'

--32-- 
select s.[name],
	   s.launched from dbo.ships s
where s.[name] like '%[^a]'

--33--
select b.[name] from dbo.battles b
where b.[name] like '% %[^c]'

--34--
select * from dbo.trip t
where (DATEPART(hour, t.time_out)) between 12 and 17 

--35--
select * from dbo.trip t
where (DATEPART(hour, t.time_in)) between 17 and 23 

--36--
select * from dbo.trip t
where (DATEPART(hour, t.time_in)) between 21 and 23 
   or (DATEPART(hour, t.time_in)) between 00 and 10

--37--
select p.[date] from dbo.pass_in_trip p
where p.place like '1%'

--38--
select p.[date] from dbo.pass_in_trip p
where p.place like '[0-9]c'

--39--
select Lastname=SUBSTRING(p.[name],
                 CHARINDEX(' ', p.[name]) + 1,
                 LEN(p.[name]) - CHARINDEX(' ', p.[name])) 
				 from dbo.passenger p
where p.[name] like '% c%'

--40--
select  Lastname=SUBSTRING(p.[name],
                 CHARINDEX(' ', p.[name]) + 1,
                 LEN(p.[name]) - CHARINDEX(' ', p.[name])) 
				 from dbo.passenger p
where p.[name] not like '% [j]%'

--41--
select avg(l.price) as 'average price =' 
	   from dbo.laptop l

--42--
select case p.model
			when null then 'null'
			else 'model: '+p.model
	   end as M,
	   case p.price
			when null then 'null'
			else 'price: '+cast(p.price as varchar)
	   end as P
	   from pc p

--43--
Select cast(i.[date] as date) as [Date] from  dbo.Income i

--44--
select case o.result
			when 'sunk' then 'потоплений'
			when 'damaged' then 'пошкоджений'
			when 'OK' then 'цілий'
	   end	
	   from dbo.outcomes o

--45--
select LEFT(p.place, 1) as [row], 
	   substring(p.place,2,2) as seat from dbo.pass_in_trip p

--46--
select  concat(
		case t.town_from
			when null then 'null'
			else 'From     ' + t.town_from
		end, 
		'',
	    case t.town_to
			when null then 'null'
			else 'to    ' + t.town_to
		end) as Destination from dbo.trip t

--47--
select concat(left(t.trip_no,1),right(t.trip_no,1),
			  left(t.id_comp, 1),right(t.id_comp, 1),
			  left(t.plane,1),substring(t.plane,len(t.plane),len(t.plane)),
			  left(t.town_from,1),substring(t.town_from,len(t.town_from),len(t.town_from)),
			  left(t.town_to,1),substring(t.town_to,len(t.town_to),len(t.town_to)),
			  substring(cast(t.time_out as nvarchar),6,1),substring(cast(t.time_out as nvarchar),len(t.time_out)-2,1),
			  substring(cast(t.time_in as nvarchar),6,1),substring(cast(t.time_in as nvarchar),len(t.time_in)-2,1)
			  ) from dbo.trip t

--48--
select p.maker from dbo.product p
where p.[type] = 'pc'
group by p.maker,p.[type]
having count(p.maker)>1

--49--
select t.town_from, 
	   count(t.town_from) as departure ,
	   count(t.town_to) as arrive
	   from dbo.trip t
group by t.town_from

--50--
select p.[type],
	   count(p.[type]) as TypeCount from dbo.printer p
group by p.[type]

--51--
select a.model,
	   count(a.cd) as CountCD from (select distinct p.model, p.cd  from dbo.pc p) a
group by a.model

select a.cd,
	   count(a.model) as CountCD from (select distinct p.model, p.cd  from dbo.pc p) a
group by a.cd

--52--
select t.plane,
	   t.town_from,
	   t.town_to,
format(cast(t.time_in as datetime) - cast(t.time_out as datetime), 'HH:mm') 
from dbo.trip t

--53--
--for each day
select o.point,
	   o.[date],
	   sum(o.[out]) as [sum] from dbo.outcome o
group by o.point,o.[date]
order by o.point

--for all dates
select o.point,
	   sum(o.[out]) as [sum] from dbo.outcome o
group by o.point
order by o.point

--max and min for each point
select o.point,
	   max(o.[out]) as [sum] from dbo.outcome o
group by o.point
order by o.point

--54--
select a.trip_no, 
	   a.[Row], 
	   count(a.[Row]) as [RowCount]
	   from (select p.trip_no, SUBSTRING(p.place,1,1) as [Row] 
			 from dbo.pass_in_trip p) a
group by a.trip_no, a.[Row]
order by 1

--55--
select  Lastname=SUBSTRING(p.[name],
                 CHARINDEX(' ', p.[name]) + 1,
                 LEN(p.[name]) - CHARINDEX(' ', p.[name])) from dbo.passenger p
where p.name like '% [SBA]%'