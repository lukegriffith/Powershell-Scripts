Function DNSForwards {

          #Declaring input param
          param
          (
          [parameter(mandatory = $true)]
          [string]$userIn,
          [parameter(mandatory = $true)]
          [string]$passIn,
          [parameter(mandatory = $true)]
          [string]$serverIn
          )

                     #creating object to return to get-dnsforwards function                      
                     $finObject = New-Object PSObject
                     $finObject | add-member -MemberType NoteProperty -Name Server -Value $null
                     $finObject | add-member -MemberType NoteProperty -Name Name -Value $null
                     $finObject | add-member -MemberType NoteProperty -Name Forwarders -Value $null
                     $finObject | add-member -MemberType NoteProperty -name NotProcessed -Value $null
                                            
                     #Pulling server, and user credentials from the parameters
                     $user =  $userIn 
                     $password = $passIn 
                     $server = $serverIn 

                     #Converting to secure credentials
                     $secpassword = ConvertTo-SecureString -String $password -asPlainText -Force
                     $credential = New-Object System.Management.Automation.PSCredential($user, $secpassword)


                     #Querying WMI for DNS Forward
                     $dnsProps = "Name", "Forwarders"
                     $object = Get-WmiObject –Namespace “root\microsoftdns” –class MicrosoftDns_Server –Computer $server  –Credential $credential | Select-Object $dnsProps


                     #if WMI query was successful
                     if ($object) {   
                                 
                                 #Expanding WMI objects to strings           
                                 $Forwarders = $object | select -ExpandProperty Forwarders
                                 $objectName = $object | select -ExpandProperty Name 
                                 $objectForwarders = @()

                                #Multiple forwards being processed to an array 
                                foreach ($forward in $Forwarders) {
                                $objectForwarders += $forward
                                }

                                 #Adding strings to custom object 
                                 $finObject.Server = $server
                                 $finObject.Name = $objectName
                                 $finObject.Forwarders = $objectForwarders

                                 }

                    #if WMI query was unsuccessful 
                    if (!$object) {
                                 #Adding server to custom object
                                 $finObject.NotProcessed = $server

                                  }
           #Return completed object to get-dnsforwards function
           return $finObject



}

Function Get-DNSForwards {

            #Declaring param
            param
            (
               [parameter(mandatory = $true)]
               [string]$inputCSV,
               [parameter(mandatory = $true)]
               [string]$exportCSV,
               [parameter(mandatory = $false)]
               [switch]$retAttempt
            )

            #Importing CSV from paramaters
            $csv = import-csv -path $inputCSV

            #Declaring Array Variables 
            $outObject = @()
            [System.Collections.ArrayList]$outServer = @()

            #Processing each item from CSV file
            foreach ($line in $csv)  {
                                            #converts CSV content to variables
                                            $userIn = $line.user
                                            $passIn = $line.password
                                            $serverIn = $line.server

                                            #Runs DNSForwards function and binds to Variable, using variables as paramters
                                            $object = DNSForwards $userIn $passIn $serverIn

                                            #If DNSForwards was successful
                                            if ($object.Name)
                                            {
                                            #Adds object to $outObject Array
                                            $outObject += $object
                                            
                                            }

                                            #If DNSForwards was unsuccessful
                                            if ($object.NotProcessed)
                                            {
                                            #Adds object to $outServer Array
                                            $outServer += $object
                                            }
                                       }

     
            #If $outServer array contains servers, and user specified Retry Attempts, will process list. 
            if ($outServer.NotProcessed -ne $null -and $retAttempt -eq $true){
             
            #Process each server in $outServer.NotProcessed
            foreach ($server in $outServer.NotProcessed) {

            #Searches $csv variable for server name to obtain passin credentials 
            $passInVar = $csv | where {$_.server -eq $server}

            #Creates passin variables from parsed CSV
            $userIn = $passInVar.user
            $passIn = $passInVar.password
            $serverIn = $passInVar.server

            #runs DNSForwards and binds to variable $object
            $object = DNSForwards $userIn $passIn $serverIn

                                            #If successful, adds to array
                                            if ($object.Forwarders -ne $null)
                                            {
                                            
                                            $outObject += $object
											
                                            
                                            }

            }
            }




            #Exporting results to specified export path
            $outObject | select server, name, forwarders |  Export-Csv -path $exportCSV           

            #Returning failed servers to console
            return $outServer | select NotProcessed
}
            
$input = "C:\Users\lgriffith\Google Drive\Projects\Powershell Scripts\Working on\DNS Enumeration Tool\serverwork.csv"
$export = "C:\Users\lgriffith\Google Drive\Projects\Powershell Scripts\Working on\DNS Enumeration Tool\serveroutput.csv"

Get-DNSForwards -inputCSV  $input  -ExportCSV $export 
