use  sample_db
go

create table #sps
(
	id int identity(1,1),
	name varchar(300)
)

insert #sps (name) values ('schema.sp name 1')
insert #sps (name) values ('schema.sp name 2')


create table #result
(
	id int identity(1,1),
	sp_name varchar(300),
	[schema] varchar(100),
	[table] varchar(500),
	[column] varchar(500)

)

declare @counter int, @max int, @sp_name varchar(300)
set @counter = 1
select @max = max(id) from #sps

while @counter <= @max
begin
	select @sp_name = name from #sps where id = @counter

	insert #result
	(
		sp_name,
		[schema],
		[table],
		[column]
	)
	select
		@sp_name,
		[schema] = referenced_schema_name,
		[table] = referenced_entity_name,
		[column] = referenced_minor_name
	from sys.dm_sql_referenced_entities (@sp_name, 'OBJECT')
	where referenced_minor_id <> 0

	set @counter = @counter + 1
end

select
	*
from #result

drop table #sps, #result

