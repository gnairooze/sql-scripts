
set @db_name = 'membership';

select
	table_name,
    column_name,
    is_nullable,
    data_type,
    character_maximum_length,
    character_octet_length,
    numeric_precision,
    character_set_name,
    column_type,
    column_key,
    extra
from information_schema.columns
where columns.table_schema = @db_name
order by
	table_name,
    column_name;
    
