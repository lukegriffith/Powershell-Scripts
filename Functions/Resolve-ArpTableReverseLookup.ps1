
function Resolve-ArpTableReverseLookup {

    $out = arp -a
    $out = $out | Select-Object -Skip 3

    $out | ForEach-Object -Process {
        if ( $_ -match "\s+(?<IP>\S+)" ) { 
            $res = [system.net.dns]::Resolve($matches.ip)

            $res.AddressList | ForEach-Object -Process { 

                [pscustomobject]@{
                    HostName = $res.HostName
                    Address = $_
                }

            }
            
        } 
    }
}