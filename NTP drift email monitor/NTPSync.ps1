<#
Notes

1. Server list needs to be obtained in string fomat.
2. Secure string credentials need to be passed in.

#>

function Get-NTPDrift {

# Obtaining Reed Servers
$servers = <# 1. Obtain server list in string format #>

#Import Get-NtpTime.ps1

. 'Scr:\Client Specific\Reed\Get-NtpTime.ps1'


# Variables requierd for StdRegProv
$HKLM = 2147483650
$key = "SYSTEM\CurrentControlSet\Services\W32Time\Parameters"
$servervalue = "NtpServer"
$typevalue = "Type"

$finalOutput = @()

foreach ($server in $servers) {

    $testConnection = Test-Connection -ComputerName $server -Quiet -Count 1



    if ($testConnection) {

        $managedCred = <# 2. Get managed credentials #> 

        # Declaring StdRegProv WMI classes 
        $StdRegProvClass = Get-WmiObject -Class StdRegprov -Namespace root\default -List -ComputerName $server -Credential $managedCred

        $timeSync = $StdRegProvClass | Invoke-WmiMethod -Name GetStringValue -ArgumentList $HKLM, $key, $servervalue

        $timeSyncServerPrimary = ($timeSync.sValue -split " ")[0]
        
        $serverTimeRaw = Get-WmiObject -Class win32_operatingsystem -ComputerName $server -Credential $managedCred
        $serverTime = $serverTimeRaw.ConvertToDateTime($serverTimeRaw.Localdatetime)
        $serverTimeFormatted = get-date $serverTime

        
        try {
        $timeServerTime =  Get-NtpTime -Server $timeSyncServerPrimary -NoDns | select -ExpandProperty ntpTime
        }

        catch [Microsoft.PowerShell.Commands.WriteErrorException] {
        write-host "$timeSyncServerPrimary failed"
        }

        catch [System.Management.Automation.MethodInvocationException] {
        write-host "$timeSyncServerPrimary failed"
        }

        $TimeServerTimeFormatted = get-date $timeServerTime

        $timeSpan = New-TimeSpan -Start $serverTimeFormatted -End $TimeServerTimeFormatted | select Minutes, Seconds, Milliseconds

    }

        else {

    write-host "$server was unable to connect"}


    $output = New-Object -TypeName psobject
    $output | Add-Member -MemberType NoteProperty -Name Server -Value $null
    $output | Add-Member -MemberType NoteProperty -Name TimeServer -Value $null
    $output | Add-Member -MemberType NoteProperty -Name MinuteDelay -Value $null
    $output | Add-Member -MemberType NoteProperty -Name SecondDelay -Value $null
    $output | Add-Member -MemberType NoteProperty -Name MillisecondDelay -Value $null

    $output.Server = $server
    $output.TimeServer = $timeSyncServerPrimary
    $output.MinuteDelay = $timespan.Minutes
    $output.SecondDelay = $timespan.Seconds
    $output.MillisecondDelay = $timespan.Milliseconds

    $finalOutput += $output


}

return $finalOutput

}

