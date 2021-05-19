
select
--'DBCC inputbuffer('+CONVERT(VARCHAR,SPID) + ')',
'kill '+CONVERT(VARCHAR,SPID) + '',
SPID
,(select [text] from fn_get_sql(sql_handle)) AS TextData
,sysdatabases.name
,sysprocesses.open_tran
,sysprocesses.physical_io
,*
from master.dbo.sysprocesses AS sysprocesses WITH(NOLOCK)
INNER JOIN master.dbo.sysdatabases AS sysdatabases WITH(NOLOCK)
      ON sysdatabases.dbid = sysprocesses.dbid
 
where 1=1
--and sysdatabases.name = 'master'
--and select [text] from fn_get_sql(sql_handle)) like '%'+ @TextParameter +'%'
--and blocked <> 0
--and sysprocesses.spid = 189
--and open_tran <> 0
--and sysprocesses.status in ( 'runnable', 'background','suspended')	--sleeping
--AND sysprocesses.spid  not in( 72, 70 , 105)
--and hostname <> 'COMPUTER-NAME'
--and lastwaittype = 'SOS_SCHEDULER_YIELD'
--order by cpu desc
--order by sysprocesses.SPID
order by sysprocesses.physical_io desc
 
--dbcc inputbuffer(7)
 
set nocount off

