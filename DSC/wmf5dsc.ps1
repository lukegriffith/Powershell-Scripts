set-location C:\temp

Configuration WMF5 
{

    Import-DscResource -ModuleName xWindowsUpdate

    Node 'srv' 
    {

        xHotfix KB3134759 
        {

            Id = 'KB3134759'
            Ensure = 'Present'
            Path = 'C:\temp\W2K12-KB3134759-x64.msu'
        }
    }

}

WMF5

Start-DscConfiguration -Path .\WMF5 -Wait -Verbose -CimSession (New-CimSession -ComputerName 'srv') 