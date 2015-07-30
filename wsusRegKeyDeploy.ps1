


# wsusRegKey  param($wsusServer,$wsusPort,$nodes)

$wsusPort = 8530
$wsusServer = "DevOps"
$nodes = "sql","sql2"

$nodes | % {  wsusRegKey -node $_ -wsusServer $wsusServer -wsusPort $wsusPort  -wsusGroup "SQL"  }

wsusRegKey -node "sql" -wsusServer $wsusServer -wsusPort $wsusPort  -wsusGroup "SQL"


$cred = Get-Credential
$cim = $nodes | % { New-CimSession -ComputerName $_ -Credential $cred }

$pss = $nodes | % { New-PSSession -ComputerName $_ -Credential $cred }


Start-DscConfiguration -CimSession $cim -Path .\wsusRegKey  -Wait -Verbose
Test-DscConfiguration -CimSession $cim -Verbose

$nodes = "baseiis"

$cred = Get-Credential
$cim = $nodes | % { New-CimSession -ComputerName $_ -Credential $cred }

$pss = $nodes | % { New-PSSession -ComputerName $_ -Credential $cred }


Start-DscConfiguration -CimSession $cim -Path .\wsusRegKey  -Wait -Verbose
Test-DscConfiguration -CimSession $cim -Verbose