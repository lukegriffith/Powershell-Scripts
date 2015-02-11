
function Get-IISlogs {

  <#
  .SYNOPSIS
  Takes IIS logs and presents them as a Powershell object that can be filtered with where-object and group-object
  .DESCRIPTION
  Takes IIS logs and presents them as a Powershell object that can be filtered with where-object and group-object
  .EXAMPLE
  $logfile = Get-IISlogs .\ex141221.log
  $logfile | where c-ip -eq "10.0.0.45"
  .EXAMPLE
  $logfile = Get-IISlogs .\ex141221.log
  $logfile | group-object c-ip | select name, count
  .EXAMPLE
  $csv = Get-IISlogs .\ex141221.log
  $csv | select c-ip | Group-Object c-ip | where name -Like "*.*" | select name, count | export-csv
  .PARAMETER Path
  Path to IIS log file
  .PARAMETER httpCode
  Specify an error code to search for
  #>

        param(
        [Parameter(Mandatory=$True,Position=1)]
        [string]$path,
        [Parameter(Mandatory=$false,Position=2)]
        [int]$httpCode
        )



$headers = "date", "time", "s_sitename", "s_computername", "s_ip" ,"cs_method", "cs_uri_stem", "cs_uri_query" ,"s_port", "cs_username", "c_ip" ,"cs_version" ,"cs(User_Agent)" ,"cs(Cookie)" ,"cs(Referer)" ,"cs_host", "sc_status", "sc_substatus", "sc_win32_status", "sc_bytes", "cs_bytes", "time_taken"



if (!$httpCode) {

Get-Content $path | Select-String '^[^#]' | ConvertFrom-Csv -Delimiter " " -Header $headers 

}

if ($httpCode) {

Get-Content $path | Select-String '^[^#]' | ConvertFrom-Csv -Delimiter " " -Header $headers | Where-Object {$_.sc_status -eq $httpCode}
}
}
