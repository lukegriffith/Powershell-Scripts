
function Resolve-ArpTableReverseLookup {

    $out = arp -a
    $out = $out | select -Skip 3

    $out | ForEach {
        if ( $_ -match "\s+(?<IP>\S+)" ) { 
            $res = [system.net.dns]::Resolve($matches.ip)

            $res.AddressList | ForEach { 

                [pscustomobject]@{
                    HostName = $res.HostName
                    Address = $_
                }

            }
            
        } 
    }
}