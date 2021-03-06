/****** HOMEWORK #3 (CTE)  ******/
use labor_sql
go

--1--
;with first_cte as (select * from dbo.[geography] g
				   where g.[name] like '%u%')
select * from first_cte f

--2--
;with first_cte as (select * from dbo.[geography] g
				    where g.[name] like '%u%'
					),
	  sec_cte as (select f.[name] from first_cte f)
select * from sec_cte

--3--
select * from dbo.geography


;with reg as (
select * from dbo.[geography] g
			  where g.region_id = 1)

select g.region_id as 'PlaceLevel',
		reg.* from reg inner join dbo.[geography] g on g.id=reg.id

--4--
with reg as(
	select g.region_id, g.id, g.name, Placelevel = -1 from dbo.geography g
	where g.name = 'Ivano-Frankivsk'
	union all
	select g1.region_id, g1.id, g1.name, r.Placelevel+1 from dbo.geography g1 
	join reg r on g1.region_id = r.id
)

select * from reg r
where r.Placelevel > -1

--5--
;with num as (
	select 1 number
	union all
	select number + 1 from num
	where number+1 <= 10000
)
select * from num
option (maxrecursion 10000)

--6--
;with num as (
	select 1 number
	union all
	select number + 1 from num
	where number+1 <= 100000
	)
select * from num
option (maxrecursion 0)

--7--
;with amount as
( select cast('20190101' as date) as [Date], datename(weekday,'20190101') as [Day]
	union all
  select dateadd(day,1,a.[Date]),datename(weekday,dateadd(day,1,a.[Date])) from amount a
  where a.Date<'20191231'
), sun as
( select * from amount a
	where a.[Day] in('Saturday','Sunday')
)

select s.[Day],
		count(s.[Day]) as 'Count in year' from sun s
group by s.[Day]
option(maxrecursion 366)

--8--
select distinct p.maker from dbo.product p
where p.type = 'pc' and p.maker not in(select distinct p1.maker from dbo.product p1
									   where p1.type = 'laptop')

--9--
select distinct p.maker from dbo.product p
where p.type = 'pc' and p.maker != all(select distinct p1.maker from dbo.product p1
										where p1.type = 'laptop')

--10--
select distinct p.maker from dbo.product p
where p.type = 'pc' and not p.maker = any(select distinct p1.maker from dbo.product p1
				where p1.type = 'laptop')

--11--
select distinct p.maker from dbo.product p
where p.type = 'pc' and p.maker in(select distinct p1.maker from dbo.product p1
				where p1.type = 'laptop')

--12--
select distinct p.maker from dbo.product p
where p.type = 'pc' and p.maker != all(select distinct p1.maker from dbo.product p1
				where p1.type = 'laptop' and p1.maker = p.maker) 
				select * from dbo.product
				order by 3
--! not finished !--

--13--
select distinct p.maker from dbo.product p
where p.type = 'pc' and p.maker = any(select distinct p1.maker from dbo.product p1
				where p1.type = 'laptop')

--14--
select distinct p2.maker from dbo.product p2
where p2.type = 'pc' and p2.maker != all(
select p.maker from dbo.product p where p.type = 'pc' and not p.model in (select distinct p.model from dbo.pc p ))

--15--
select c.country,
	   c.class from dbo.classes c
where c.country = all(select c1.country from dbo.classes c1 where c1.country = 'Ukraine')

--16--
select o.ship from dbo.outcomes o
where o.result = 'damaged' and  o.ship in (select o1.ship from dbo.outcomes o1
										   where o1.result = 'OK')

--17--
select distinct p2.maker from dbo.product p2
where p2.type = 'pc' and p2.maker != all( select distinct p.maker from dbo.product p
										  where p.type = 'pc' and not exists(
										  select distinct p1.model from dbo.pc p1 
										  where p.model=p1.model))

--18--
select distinct p.maker from dbo.product p
where p.type = 'printer'
intersect
select pr.maker from dbo.pc p join dbo.product pr on pr.model = p.model
where p.speed in (select max(p1.speed) from dbo.pc p1)

--19--
select distinct s.class from dbo.ships s inner join dbo.outcomes o on s.name = o.ship
where o.result = 'sunk'
union
select distinct s.class from dbo.ships s inner join dbo.outcomes o on s.class = o.ship 
where o.result = 'sunk'
--?--

--20--
select p.model,
	   p.price from dbo.printer p
where p.price = (select max(p1.price) from dbo.printer p1)

--21--
select pr.type,
	   l.model,
	   l.speed from dbo.laptop l join dbo.product pr on pr.model=l.model
where l.speed < all(select p.speed from dbo.pc p)

--22--
select pr.maker,
	   p.price from dbo.printer p join dbo.product pr on pr.model = p.model
where p.color='y' and p.price = (select min(a.price) from (select * from dbo.printer p where p.color = 'y') a)

--23--
select o.battle,
	   c.country,
	   count(s.name) as 'Num of Ships' from dbo.ships s 
			  join dbo.classes c on c.class = s.class 
			  join dbo.outcomes o on o.ship = s.name
group by c.country,o.battle
having count(s.name) > 1
order by 3		

--24--
select a.maker,
	   sum(a.PC) as PC,
	   sum(a.Laptop) as Laptop,
	   sum(a.Printer) as Printer from (select p.maker,
										(select count(*) from dbo.pc p1 where p.model=p1.model) as PC,
										(select count(*) from dbo.Laptop p1 where p.model=p1.model) as Laptop,
										(select count(*) from dbo.Printer p1 where p.model=p1.model) as Printer from dbo.product p) a
group by a.maker

--25--
select p.maker,
	   (select 
		case when count(pc.model)=0 then 'no'
		else concat('yes (',count(pc.model),')')
		end) a
	 from dbo.product p left join dbo.pc on p.model=pc.model
group by p.maker
order by 2 desc

--26--
--27--

--28--
select a.point,
	   a.date, 
	   case when COALESCE(o1.out,0)>COALESCE(a.sum,0) then 'once a day'
	   when COALESCE(o1.out,0)=COALESCE(a.sum,0) then 'both'
	   else 'more than once a day'
	   end
from (select o.point,o.date,sum(o.out) as [sum] from dbo.outcome o
			   group by o.point,o.date) a
full join dbo.outcome_o o1 on a.point=o1.point and a.date=o1.date

--29--
select p.maker,p.model,p.type,l.price from dbo.laptop l join dbo.product p on p.model = l.model
where p.maker = 'B'
union 
select p.maker,p.model,p.type,l.price from dbo.pc l join dbo.product p on p.model = l.model
where p.maker = 'B'
union 
select p.maker,p.model,p.type,l.price from dbo.printer l join dbo.product p on p.model = l.model
where p.maker = 'B'

--30--
select distinct s.class as Name ,s.class as Class from dbo.ships s
union
select o.ship, o.ship from dbo.outcomes o
where o.ship not in (select s.name from dbo.ships s)

--31--
select s.class from dbo.ships s
group by s.class
having count(s.class) = 1
union
select o.ship from dbo.outcomes o
where o.ship not in (select s.name from dbo.ships s)

--32--
select s.name from dbo.ships s
where s.launched < 1942
union
select o.ship from dbo.outcomes o join dbo.battles b on b.name = o.battle
where DATEPART(year,b.date) < 1942 