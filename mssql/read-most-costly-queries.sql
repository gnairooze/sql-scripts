SELECT TOP 20
    qs.sql_handle,
    qs.execution_count,
    qs.total_worker_time AS Total_CPU,
    total_CPU_inSeconds = --Converted from microseconds
    qs.total_worker_time/1000000,
    average_CPU_inSeconds = --Converted from microseconds
    (qs.total_worker_time/1000000) / qs.execution_count,
    qs.total_elapsed_time,
    total_elapsed_time_inSeconds = --Converted from microseconds
    qs.total_elapsed_time/1000000,
	qs.total_rows,
	avarage_rows  = qs.total_rows / qs.execution_count,
	qs.total_used_threads,
	average_used_threads = qs.total_used_threads / qs.execution_count,
	qs.total_logical_reads,
	average_logical_reads = qs.total_logical_reads / qs.execution_count,
	qs.total_logical_writes,
	average_logical_writes = qs.total_logical_writes / qs.execution_count,
	qs.total_physical_reads,
	average_physical_reads = qs.total_physical_reads / qs.execution_count,
    st.text,
    qp.query_plan
FROM sys.dm_exec_query_stats AS qs
        CROSS APPLY sys.dm_exec_sql_text(qs.sql_handle) AS st
        CROSS apply sys.dm_exec_query_plan (qs.plan_handle) AS qp
ORDER BY 
	qs.total_worker_time desc
	--qs.total_rows desc
	--average_used_threads desc
	--qs.total_logical_writes desc
	--average_logical_writes desc
	--qs.total_physical_reads desc
	--average_physical_reads desc
