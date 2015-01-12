function gcred {

        param (

        [parameter(mandatory=$false)]
        [string]$user,
        [parameter(mandatory=$false)]
        [string]$pass
        
        )
        
        if ($user) { $username = $user}
        else {write-host "Enter Username:";$username = read-host}
        if ($pass) { $paassword = $pass } 
        else {write-host "Enter Password:";$password = read-host}

         $credential = New-Object System.Management.Automation.PSCredential($user, $pass)

         return $credential

        }

        gcred hello hello 