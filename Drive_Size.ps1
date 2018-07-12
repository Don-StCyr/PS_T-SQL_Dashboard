## By Adam Bertram
## https://4sysops.com/archives/building-html-reports-in-powershell-with-convertto-html/

## Get-PSDrive | ConvertTo-Html | Out-File -FilePath C:\Temp\PSDrives.html
## Get-PSDrive | ConvertTo-Html -Property Name,Used,Provider,Root,CurrentLocation | Out-File -FilePath C:\Temp\PSDrives.html


$Header = @"
<style>
TABLE {border-width: 1px; border-style: solid; border-color: black; border-collapse: collapse;}
TH {border-width: 1px; padding: 3px; border-style: solid; border-color: black; background-color: #6495ED;}
TD {border-width: 1px; padding: 3px; border-style: solid; border-color: black;}
</style>
"@

####
Get-PSDrive -PSProvider FileSystem  | ConvertTo-Html -Property @{label="Drive";expression={($_.Name)}}, `
Root,@{label="Total Size";expression={[int]((($_.Used) + ($_.Free))/1GB)}}, `
@{label="Used (GB)";expression={[int]($_.Used/1GB)}},@{label="Free (GB)";expression={[int]($_.Free/1GB)}} -Head $Header | Out-File -FilePath C:\Temp\PSDrives.html
####