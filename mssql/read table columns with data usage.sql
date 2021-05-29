use AdventureWorks2012
go

declare @schema varchar(100) = 'Production'
declare @table varchar(500) = 'Product'

declare @columns table ( id int identity(1,1), col_name varchar(50), col_type varchar(50), col_count int )

--add tables you want to read their columns in the parameter table @tables

insert @columns (col_name, col_type)
select distinct
	column_name = C.COLUMN_NAME,
	data_type = C.DATA_TYPE
from INFORMATION_SCHEMA.COLUMNS as C
where C.TABLE_SCHEMA = @schema
and C.TABLE_NAME = @table

declare @sql varchar(max)
declare @sql_column_string_template varchar(max) = '%col_name% = sum ( case when %col_name% is null then 0 when %col_name% = '''' then 0 else 1 end )'
declare @sql_column_template varchar(max) = '%col_name% = sum ( case when %col_name% is null then 0 else 1 end )'

set @sql = 'select '

declare @columns_count int

select @columns_count  = count(*) from @columns

declare @counter int, @column_name varchar(1000), @column_type varchar(50)

set @counter = 1

while @counter <= @columns_count
begin
	select @column_name = col_name, @column_type = col_type from @columns where id = @counter

	if @column_type = 'char' or @column_type = 'varchar' or @column_type = 'text' or @column_type = 'nchar' or @column_type = 'nvarchar' or @column_type = 'ntext'
	begin
		set @sql = @sql + REPLACE(@sql_column_string_template, '%col_name%', @column_name)
	end
	else
	begin
		set @sql = @sql + REPLACE(@sql_column_template, '%col_name%', @column_name)
	end

	if @counter <> @columns_count
	begin
		set @sql = @sql + ', '	
	end
	set @counter = @counter + 1
end

set @sql = @sql + ' from ' + @schema + '.' + @table + ' for xml auto,type'

declare @xml_result table (result xml)
insert @xml_result (result) 
exec ( @sql );

declare @result xml
select @result = result from @xml_result

update @columns
set col_count = x.v.value('.', 'VARCHAR(100)')
from @columns c
inner join @result.nodes('//@*') x(v)
	on c.col_name = cast(x.v.query('local-name(.)') as varchar(500))

select distinct
	table_schema = C.TABLE_SCHEMA,
	table_name = C.TABLE_NAME,
	column_name = C.COLUMN_NAME,
	ordinal_position = C.Ordinal_Position,
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
	collation_name = C.COLLATION_NAME,
	cols.col_count
from INFORMATION_SCHEMA.COLUMNS as C
inner join @columns cols
	on C.COLUMN_NAME = cols.col_name
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
where C.TABLE_SCHEMA = @schema
and C.TABLE_NAME = @table
order by 
	table_name, 
	ordinal_position

