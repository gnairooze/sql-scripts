declare @start int = 2019

declare @current int = year(getdate())
declare @result table (name int)

insert @result(name) values (@start)

while @start < @current
begin
	set @start = @start + 1

	insert @result(name) values (@start)
end

select
	*
from @result
