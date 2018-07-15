[reflection.assembly]::LoadWithPartialName("Microsoft.SqlServer.Smo")
##[reflection.assembly]::LoadWithPartialName("Microsoft.SqlServer.SqlWmiManagement")

$serverName = $env:computername + "\MSSQLSERVER"
$server = New-Object -typeName Microsoft.SqlServer.Management.Smo.Server -argumentList "$serverName"

$server.ConnectionContext.LoginSecure=$true;
## $server.ConnectionContext.LoginSecure=$false;
## $server.ConnectionContext.set_Login("username")
## $securePassword = ConvertTo-SecureString 'password' -AsPlainText –Force
## $server.ConnectionContext.set_SecurePassword($securePassword)
$database = "master"

$sqlquery = "SELECT name FROM sys.databases"

$db = new-object ("Microsoft.sqlServer.Management.Smo.Database") ($server, "master")
$ds = $db.ExecuteWithResults($sqlquery)

#####
#####

# Load Smo and referenced assemblies.
[void][System.Reflection.Assembly]::LoadWithPartialName('Microsoft.SqlServer.ConnectionInfo');
[void][System.Reflection.Assembly]::LoadWithPartialName('Microsoft.SqlServer.Management.Sdk.Sfc');
[void][System.Reflection.Assembly]::LoadWithPartialName('Microsoft.SqlServer.SMO');
# Required for SQL Server 2008 (SMO 10.0).
[void][System.Reflection.Assembly]::LoadWithPartialName('Microsoft.SqlServer.SMOExtended');

$serverName = $env:computername ## + "\MSSQLSERVER"
$server =  New-Object Microsoft.SqlServer.Management.Smo.Server $serverName; ##"RD-STCYR-VM";
$db = $server.Databases.Item("master");

## [String] $sql = "SELECT name FROM [sys].[databases] ORDER BY [name];";
[String] $sql = "SELECT UPPER(DB_NAME(database_id)) AS DatabaseName, type_desc AS FileType,
		(SUM(size)*8)/(1024)  AS DBSizeMB, --CAST((SUM(max_size)*8)/(1024.0) AS decimal(10,2)) AS MaxDBSizeMB,
		physical_name, state_desc, (SUM(max_size)
FROM sys.master_files
GROUP BY database_id, type_desc, physical_name, state_desc, max_size
ORDER BY DB_NAME(database_id), type_desc;";
$result = $db.ExecuteWithResults($sql);
$table = $result.Tables[0] | Select -ExpandProperty name
## ;

## $sql2 = "SELECT $dbs(dbid) AS DatabaseName FROM sys.files "
foreach ($dbs in $table)
{
    Write-Host "These are the databases: " + $dbs 
    ##$db.ExecuteWithResults($sql)
}

