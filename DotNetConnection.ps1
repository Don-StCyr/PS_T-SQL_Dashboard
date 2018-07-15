## Dot Net Connection

$Datatable = New-Object System.Data.DataTable    
$Connection = New-Object System.Data.SQLClient.SQLConnection

$Connection.ConnectionString = "server=localhost;database=AdventureWorks2014;trusted_connection=true;"
$Connection.Open()
$Command = New-Object System.Data.SQLClient.SQLCommand
$Command.Connection = $Connection
$Command.CommandText = ##'select top 10 BusinessEntityID,PersonType,FirstName,LastName from person.Person'

'SELECT UPPER(DB_NAME(database_id)) AS DatabaseName, type_desc AS FileType,
		(SUM(size)*8)/(1024)  AS DBSizeMB, --CAST((SUM(max_size)*8)/(1024.0) AS decimal(10,2)) AS MaxDBSizeMB,
		physical_name, state_desc --, (SUM(max_size)
FROM sys.master_files
GROUP BY database_id, type_desc, physical_name, state_desc, max_size
ORDER BY DB_NAME(database_id), type_desc DESC'

$DataAdapter = new-object System.Data.SqlClient.SqlDataAdapter $Command
$Dataset = new-object System.Data.Dataset
$DataAdapter.Fill($Dataset)
$Connection.Close()
$Dataset.Tables[0] | Format-Table
## Select DatabaseName, DatabaseName, FileType, DBSizeMB, physical_name, state_desc

