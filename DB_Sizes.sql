--select @@SERVERNAME + '\' + @@SERVICENAME

--SELECT UPPER(DB_NAME(database_id)) AS DatabaseName, size,
--		(SUM(size)*8)--/(1024*1024) AS decimal(10,2)) AS DBSizeGB

SELECT DB_NAME(database_id), *
FROM sys.master_files 
ORDER BY DB_NAME(database_id)
--GROUP BY database_id, size

--CAST((SUM(max_size)*8)/(1024.0) AS decimal(10,2)) AS DbSizeGb

SELECT UPPER(DB_NAME(database_id)) AS DatabaseName, type_desc AS FileType,
		(SUM(size)*8)/(1024)  AS DBSizeMB, --CAST((SUM(max_size)*8)/(1024.0) AS decimal(10,2)) AS MaxDBSizeMB,
		physical_name, state_desc, (SUM(max_size)
FROM sys.master_files
GROUP BY database_id, type_desc, physical_name, state_desc, max_size
ORDER BY DB_NAME(database_id), type_desc