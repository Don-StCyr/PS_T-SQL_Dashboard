[reflection.assembly]::LoadWithPartialName("Microsoft.SqlServer.Smo")
##[reflection.assembly]::LoadWithPartialName("Microsoft.SqlServer.SqlWmiManagement")

$serverName = "RD-STCYR-VM\MSSQLSERVER"
$server = New-Object -typeName Microsoft.SqlServer.Management.Smo.Server -argumentList "$serverName"

$server.ConnectionContext.LoginSecure=$false;
$server.ConnectionContext.set_Login("username")
$securePassword = ConvertTo-SecureString 'password' -AsPlainText –Force
$server.ConnectionContext.set_SecurePassword($securePassword)
$database = "mdb"

$sqlquery = "SELECT DISTINCT z_INPRCO.last_name + `',`' + z_INPRCO.first_name as cust_name, org_name, z_INPRCO.summary, case [z_INPRCO].[type] when `'C`' then CAST`(CO.description as varchar`(5000`)`) else CAST`(IP.description as varchar`(5000`)`) end as `'desc`', con.pri_phone_number, con.alt_phone_number, email_address, z_INPRCO.location_name as loc_name, address_1, address_2, z_INPRCO.city, st.symbol as State_abv ,zip FROM z_INPRCO INNER JOIN ca_location loc on z_INPRCO.location_name = loc.location_name INNER JOIN ca_contact con on z_INPRCO.customer = con.contact_uuid INNER JOIN ca_state_province st on [loc].[state]=st.id LEFT JOIN call_req IP on z_INPRCO.ticket = IP.ref_num LEFT JOIN chg CO on z_INPRCO.ticket = CO.chg_ref_num WHERE ticket = $ticketnumber AND loc.inactive <>1"

$db = new-object ("Microsoft.sqlServer.Management.Smo.Database") ($server, "mdb")
$ds = $db.ExecuteWithResults($sqlquery)

#####
#####

# Load Smo and referenced assemblies.
[void][System.Reflection.Assembly]::LoadWithPartialName('Microsoft.SqlServer.ConnectionInfo');
[void][System.Reflection.Assembly]::LoadWithPartialName('Microsoft.SqlServer.Management.Sdk.Sfc');
[void][System.Reflection.Assembly]::LoadWithPartialName('Microsoft.SqlServer.SMO');
# Required for SQL Server 2008 (SMO 10.0).
[void][System.Reflection.Assembly]::LoadWithPartialName('Microsoft.SqlServer.SMOExtended');


$server =  New-Object Microsoft.SqlServer.Management.Smo.Server "RD-STCYR-VM";
$db = $server.Databases.Item("master");

[String] $sql = "SELECT * FROM [sys].[databases] ORDER BY [name];";
$result = $db.ExecuteWithResults($sql);
$table = $result.Tables[0];

$sql2 = "SELECT $dbs(dbid) AS DatabaseName FROM sys.files "
foreach ($dbs in $table)
{
    Write-Host $db.ExecuteWithResults($sql)
}
