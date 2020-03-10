declare @db_name varchar(100)
set @db_name = 'db_name' 

select
	* 
from sys.dm_exec_requests 
cross apply sys.dm_exec_sql_text(dm_exec_requests.sql_handle)
where 1=1
and db_name(dm_exec_requests.database_id) = @db_name
and dm_exec_requests.session_id IN 
(
    select dm_exec_requests.blocking_session_id 
    from sys.dm_exec_requests 
    where  1=1
    and db_name(dm_exec_requests.database_id) = @db_name
    and dm_exec_requests.blocking_session_id <> 0
)
