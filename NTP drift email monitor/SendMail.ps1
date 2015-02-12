<#
Script checks for NTP drift over 30 seconds or 1 minute
This is amended in the where-object cmdlet on $objects
#>

. 'Scr:\Client Specific\Reed\NTPSync.ps1'

$object = Get-NTPDrift

$objects = $object | ? {$_.SecondDelay -ge 30 -or $_.MinuteDelay -ge 1}

if ($objects) {

$Outlook = New-Object -ComObject Outlook.Application
$Mail = $Outlook.CreateItem(0)
$Mail.To = "*****"
$Mail.Subject = "NTP Out Of Sync"
$Mail.Body = @()

$Mail.Body += 'the following servers are out of time with the NTP server'
$Mail.Body += ''

foreach ($item in $objects) {

$Mail.Body += 'Server: ' + $item.Server
$Mail.Body += 'TimeServer: ' + $item.TimeServer
$Mail.Body += 'Minute Delay: ' + $item.MinuteDelay
$Mail.Body += 'Second Delay: ' +  $item.SecondDelay
$Mail.Body += 'MillisecondDelay: ' + $item.MillisecondDelay
$Mail.Body += ''



}


$Mail.Send()

Write-EventLog -LogName Application -Source "NTP Script" -EntryType Information -EventId 1 -Message "Email was sent"

}

else {

Write-EventLog -LogName Application -Source "NTP Script" -EntryType Information -EventId 1 -Message "No issues were seen"

} 

