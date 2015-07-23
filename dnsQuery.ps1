param ($dns)
 
    while ($true) {
    
    [system.net.dns]::Resolve("$dns") | select @{name='HostName';expression={$_.hostname}}, @{name='AddressList';expression={$_.AddressList | foreach { "$_|"}}}, @{name='DateTime';expression={get-date}};
    Start-Sleep -Seconds 30
    }