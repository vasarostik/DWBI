/****** HOMEWORK SELECT(JOIN)  ******/
use labor_sql
go

--1--
select  pr.maker,
		pr.[type],
		p.speed,
		p.hd 
from dbo.pc p 
inner join dbo.product pr on p.model = pr.model
where p.hd <= 8
order by pr.maker,p.hd

--2--
select distinct pr.maker 
from dbo.pc p 
inner join dbo.product pr on p.model = pr.model
where p.speed >= 600

--3--
select distinct pr.maker 
from dbo.laptop l
inner join dbo.product pr on pr.model = l.model
where l.speed <= 500

--4--
select distinct l.model,
				l1.model,
				l1.hd,
				l1.ram
from dbo.laptop l,
	 dbo.laptop l1
where l.ram=l1.ram 
  and l.hd= l1.hd 
  and (l.model > l1.model or (l.model = l1.model  -- select if model > model1, but if we have the same models with diff characteristics
  and (l.speed != l1.speed or l.price != l1.price or l.screen != l1.screen))) -- then we suppose that theese models are not similar(not equal)

--5--
select distinct c.class,
				c1.country, 
				c1.[type],
				c1.class from dbo.classes c,dbo.classes c1
where c.[type] != c1.[type] and c.country = c1.country

--6--
select p.model,
	   pr.maker from dbo.product pr inner join dbo.pc p on p.model = pr.model
where p.price < 600

--7--
select p.model,
	   pr.maker from dbo.product pr inner join dbo.printer p on p.model = pr.model
where p.price > 300

--8--
select pr.maker,
	   pr.model as 'PC model',
	   p.price from dbo.product pr inner join dbo.pc p on p.model = pr.model
union all
select pr.maker,
	   pr.model as 'Laptop model',
	   p.price from dbo.product pr inner join dbo.laptop p on p.model = pr.model
order by pr.maker

--9--
select pr.maker,
	   pr.model,
	   p.price from dbo.product pr inner join dbo.pc p on p.model = pr.model
order by pr.maker

--10--
select pr.maker,
	   pr.[type],
	   l.model,
	   l.speed from dbo.product pr inner join dbo.laptop l on l.model = pr.model
where l.speed > 600

--11--
select c.class, 
	   c.displacement 
from dbo.classes c inner join dbo.ships s on s.class=c.class

--12--
select o.ship,
	   o.battle,
	   b.[date] from dbo.outcomes o inner join dbo.battles b 
on b.[name] = o.battle and o.result != 'sunk'
order by o.battle

--13--
select s.[name],
	   c.country from dbo.ships s inner join dbo.classes c on c.class = s.class
order by c.country

--14--
select distinct t.plane,
				c.[name] from dbo.company c inner join dbo.trip t 
on t.id_comp=c.id_comp and t.plane='Boeing'

--15--
select p.[name],
	   tr.[date] from dbo.pass_in_trip tr inner join dbo.passenger p on p.id_psg=tr.id_psg
order by p.[name]

--16--
select pc.model,
	   pc.speed,
	   pc.hd from dbo.pc inner join dbo.product p 
on pc.model = p.model and (pc.hd=10 or pc.hd=20) and p.maker = 'A'

--17--
select pvt.maker,
	   [pc], 
	   [laptop], 
	   [printer] from dbo.product p
pivot (count(p.model) for [type] 
in([pc],[laptop],[printer]))pvt

--18--
select pvt.[avg],
	   pvt.[11],
	   pvt.[12],
	   pvt.[14],
	   pvt.[15] 
from (select 'average' as 'avg', l.screen, l.price from dbo.laptop l) x
pivot (avg(x.price) for x.screen in([11],[12],[14],[15])) pvt

--19--
select p.maker, 
	   crs.* from dbo.product p
cross apply (select * from dbo.laptop l where l.model = p.model) crs

--20--
select * from dbo.laptop l 
	cross apply (select max(l2.price) as max_price from dbo.laptop l2 
	inner join dbo.product p on p.model = l2.model 
	where maker = (select p2.maker from dbo.product p2 
				    where p2.model= l.model)) crs
order by max_price

--21--
select * from dbo.laptop l
cross apply (select top 1 * from dbo.laptop l2 
where (l2.model = l.model and l2.code > l.code) or l2.model > l.model order by l2.model,l2.code) crs
order by l.model,l.code 

--22--
select * from dbo.laptop l
outer apply (select top 1 * from dbo.laptop l2 
where (l2.model = l.model and l2.code > l.code) or l2.model > l.model order by l2.model,l2.code) crs
order by l.model,l.code 

--23--
select crs.* from (select distinct p.[type] from dbo.product p) t
cross apply (select top 3 * from dbo.product p1 where t.[type] = p1.[type] order by p1.model) crs
order by t.[type]

--24--
select l.code, 
	   valuess.[name], 
	   valuess.[value] from dbo.laptop l
cross apply (values('speed', speed),
				   ('ram', ram),
				   ('hd', hd),
				   ('screen', screen)) valuess([name], [value]) --our new table
order by l.code, valuess.[name], valuess.[value]