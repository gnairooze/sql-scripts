use master
go

select
	database_name = databases.name,
	database_state = databases.state,
	database_state_desc = databases.state_desc,
	databases.log_reuse_wait,
	databases.log_reuse_wait_desc,
	file_name = master_files.name,
	master_files.type_desc,
	file_state = master_files.state,
	file_state_desc = master_files.state_desc,
	file_size_mb = convert(decimal(18, 2), master_files.size * 8.0 / 1024)
from sys.databases
inner join sys.master_files
	on databases.database_id = master_files.database_id
order by 
	database_name,
	file_name




