## Refresh Webpages Every X Seconds
## https://stackoverflow.com/questions/25888915/refreshing-web-page-using-powershell

"Refreshing IE Windows every $interval seconds."
"Press any key to stop."
   $shell = New-Object -ComObject Shell.Application
   do {
       'Refreshing ALL HTML'
       $shell.Windows() | 
           Where-Object { $_.Document.url -like 'https://www.google*'} | 
           ForEach-Object { $_.Refresh() }
       Start-Sleep -Seconds 15
   } until ( [System.Console]::KeyAvailable )
   [System.Console]::ReadKey($true) | Out-Null

## As a Function

function Refresh-WebPages {
   param(
       $interval = 15
   )
   "Refreshing IE Windows every $interval seconds."
   "Press any key to stop."
   $shell = New-Object -ComObject Shell.Application
   do {
       'Refreshing ALL HTML'
       $shell.Windows() | 
           Where-Object { $_.Document.url } | ##-like 'https://www.google*'} | 
           ForEach-Object { $_.Refresh() }
       Start-Sleep -Seconds $interval
   } until ( [System.Console]::KeyAvailable )
   [System.Console]::ReadKey($true) | Out-Null
    }

## Must Also Call the Function
Refresh-WebPages