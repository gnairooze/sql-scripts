declare @db_name varchar(100)
set @db_name = 'db_name' 

select 
	db_name(L.resource_database_id) as DatabaseName, 
	L.request_session_id as SPID,
	L.request_reference_count,
	L.resource_type as LockedResource,
	L.request_mode as LockType, 
	O.name as LockedObjectName,
	P.object_id as LockedObjectId, 
	ST.text as SqlStatementText,
	ES.login_name as LoginName, 
	ES.host_name as HostName,
	TST.is_user_transaction as IsUserTransaction, 
	AT.name as TransactionName,
	CN.auth_scheme as AuthenticationMethod 
from sys.dm_tran_locks L 
inner join sys.dm_exec_sessions ES 
	on ES.session_id = L.request_session_id 
inner join sys.dm_exec_connections CN 
	on CN.session_id = ES.session_id
left join sys.partitions P 
	on P.hobt_id = L.resource_associated_entity_id 
left join sys.objects O 
	on O.object_id = P.object_id 
left join sys.dm_tran_session_transactions TST 
	on ES.session_id = TST.session_id 
left join sys.dm_tran_active_transactions AT 
	on TST.transaction_id = AT.transaction_id 
cross apply sys.dm_exec_sql_text(CN.most_recent_sql_handle) as ST 
where db_name(L.resource_database_id) = @db_name
order by
	L.request_session_id 
