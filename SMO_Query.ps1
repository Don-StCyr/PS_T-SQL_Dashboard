$srv = new-Object Microsoft.SqlServer.Management.Smo.Server("(local)")  
$db = New-Object Microsoft.SqlServer.Management.Smo.Database  
$db = $srv.Databases.Item("AdventureWorks2014")  
## $db.ExecuteNonQuery("CHECKPOINT")  
$ds = $db.ExecuteWithResults("SELECT * FROM Person.Address")  
Foreach ($t in $ds.Tables)  
{  
   Foreach ($r in $t.Rows)  
   {  
      Foreach ($c in $t.Columns)  
      {  
          Write-Host $c.ColumnName "=" $r.Item($c)  
      }  
   }  
} 

