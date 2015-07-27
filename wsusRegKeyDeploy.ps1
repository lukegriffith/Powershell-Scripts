


# wsusRegKey  param($wsusServer,$wsusPort,$nodes)

$wsusPort = 8503
$wsusServer = "DevOps"
$nodes = "baseiis","sql","WIN-MV1BTFP30G1"

wsusRegKey -wsusServer $wsusServer -wsusPort $wsusPort -nodes $nodes

$cred = Get-Credential
$cim = $nodes | % { New-CimSession -ComputerName $_ -Credential $cred }

$pss = $nodes | % { New-PSSession -ComputerName $_ -Credential $cred }


Start-DscConfiguration -CimSession $cim -Path .\wsusRegKey  -Wait -Verbose
Test-DscConfiguration -CimSession $cim -Verbose

Invoke-Command -Session $pss -ScriptBlock { get-service -Name *wuauserv* | Restart-Service -Verbose } 