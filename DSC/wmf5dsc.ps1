$VerbosePreference = "Continue"

Set-Location -Path C:\temp

$cred = Get-Credential -Message "Enter credentals for srv"

$pss = New-PSSession -ComputerName srv -Credential $cred
$css = New-CimSession -ComputerName 'srv' -Credential $cred

Copy-Item -Path C:\Users\lukem\Downloads\Win8.1AndW2K12R2-KB3134758-x64.msu -Destination C:\temp -ToSession $pss 
Copy-Item -Path 'C:\Program Files\WindowsPowerShell\Modules\xWindowsUpdate' -Destination 'C:\Program Files\WindowsPowerShell\Modules\' -ToSession $pss


Configuration WMF5 
{

    Import-DscResource -ModuleName xWindowsUpdate

    Node 'localhost' 
    {

        xHotfix KB3134759 
        {

            Id = 'KB3134759'
            Ensure = 'Present'
            Path = 'C:\temp\Win8.1AndW2K12R2-KB3134758-x64.msu'
        }
    }

}

WMF5

Start-DscConfiguration -Path .\WMF5 -Wait -Verbose -CimSession $css