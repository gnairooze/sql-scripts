use Logging
go

--add tables you want to read their columns in the parameter table @tables

declare @tables table
(
	name varchar(100)
)

insert @tables (name) values ('Category')
insert @tables (name) values ('Log')

select
	Table_Name = so.Name,
	Column_Name = sc.Name,
	--sc.ColOrder,
	--sc.status,
	Is_Primary = case 
		when  (sc.status = 0x80) OR (sc.ColOrder = 1 and not sc.status = 0x80 ) then 1
		else 0
		end,
	[Type_Name] = st.name,
	[Length] = sc.length,
	[Is_Required] = case sc.isnullable
		when 0 then 1
		else 0
		end,
	[Is_Computed] = sc.iscomputed,
	[Collation] = sc.collation
from sysobjects so
inner join syscolumns sc
	on so.id=  sc.id
inner join systypes st
	on sc.xusertype = st.xusertype
inner join @tables tabs
	on so.Name = tabs.name
where 1=1
and so.xtype = 'U' --user table
order by
	Table_Name,
	Column_Name
