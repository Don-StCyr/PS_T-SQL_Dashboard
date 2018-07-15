-- CONFIG SETTINGS CHECK

-- select DB_NAME(database_id), * from sys.master_files order by DB_NAME(database_id)

select DB_NAME(database_id), 
	CASE 
		WHEN type_desc = 'LOG' THEN 'Log File'
		WHEN type_desc = 'Rows' THEN 'Data File' 
		END AS File_Type,
	(SUM(size)*8)/(1024) AS Size_MB, 
	CASE 
		WHEN max_size = 0 THEN (SUM(size)*8)/(1024) 
		WHEN max_size = -1 THEN '102400' 
		WHEN max_size = 268435456 THEN '14680064' 
		ELSE (SUM(CAST(max_size AS bigint))*8)/(1024) 
		END AS MaxSize_MB,
	CASE 
		WHEN is_percent_growth = 0 THEN (SUM(growth)*8)/(1024)
		WHEN is_percent_growth = 1 THEN growth 
		END AS Growth,
	CASE 
		WHEN is_percent_growth = 1 THEN 'percent'
		WHEN is_percent_growth = 0 THEN 'megabytes'
		END AS Growth_Type,
	CASE
		WHEN state = 0 THEN 'Online'
		WHEN state = 1 THEN 'Restoring'
		WHEN state = 0 THEN 'Recovering'
		WHEN state = 1 THEN 'Recovery_Pending'
		WHEN state = 0 THEN 'Suspect'
		WHEN state = 1 THEN 'Unused'
		WHEN state = 0 THEN 'Offline'
		WHEN state = 1 THEN 'Defunct'
		END AS State,
	CASE
		WHEN is_read_only = 0 THEN 'false'
		WHEN is_read_only = 1 THEN 'TRUE'
		END AS Read_Only
from sys.master_files
GROUP BY database_id, type_desc, max_size, growth, size, is_percent_growth, state, is_read_only
ORDER BY DB_NAME(database_id), type_desc, growth
