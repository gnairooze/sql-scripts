use Logging
go

--add tables you want to read their columns in the parameter table @tables

declare @tables table
(
	name varchar(100)
)

insert @tables (name) values ('Category')
insert @tables (name) values ('Log')

select distinct
	table_name = C.TABLE_NAME,
	column_name = C.COLUMN_NAME,
	data_type = C.DATA_TYPE,
	max_length = C.CHARACTER_MAXIMUM_LENGTH,
		is_primary = case
		when KU.CONSTRAINT_NAME is not null then 1
		else 0
		end,
	is_required = case C.IS_NULLABLE
		when 'YES' then 0
		else 1
		end,
	collation_name = C.COLLATION_NAME
from INFORMATION_SCHEMA.COLUMNS as C
inner join @tables tabs
	on C.TABLE_NAME = tabs.name
left join INFORMATION_SCHEMA.TABLE_CONSTRAINTS as TC
	on C.TABLE_NAME = TC.TABLE_NAME
	and C.TABLE_SCHEMA = TC.TABLE_SCHEMA
	and C.TABLE_CATALOG = TC.TABLE_CATALOG
left join INFORMATION_SCHEMA.KEY_COLUMN_USAGE as KU
	on TC.CONSTRAINT_NAME = KU.CONSTRAINT_NAME 
	and C.COLUMN_NAME = KU.COLUMN_NAME
	and C.TABLE_NAME = KU.TABLE_NAME
	and C.TABLE_SCHEMA = KU.TABLE_SCHEMA
	and C.TABLE_CATALOG = KU.TABLE_CATALOG
	and TC.CONSTRAINT_TYPE = 'PRIMARY KEY'
order by 
	table_name, 
	column_name
