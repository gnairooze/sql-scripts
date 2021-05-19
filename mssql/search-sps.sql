declare @search nvarchar(200)
set @search = 'search-for'

select distinct
	o.name AS Object_Name,
	o.type_desc
from sys.sql_modules m
inner join sys.objects o
	on m.object_id = o.object_id
where m.definition Like '%' + @search + '%'
