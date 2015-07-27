configure wsusRegKey {

    param($wsusServer,$wsusPort,$nodes)

    $WindowsUpdatedword = "" | select Key,HashTable
    $WindowsUpdatedword.Key = "HKLM:\SOFTWARE\Policies\Microsoft\Windows\WindowsUpdate"
    $WindowsUpdatedword.HashTable =  @{"AcceptTrustedPublisherCerts"="00000001"
    "ElevateNonAdmins"="00000001 "
    "TargetGroupEnabled"="00000000"}

    $AUKeydword = "" | select Key,HashTable
    $AUKeydword.Key = "HKLM:\SOFTWARE\Policies\Microsoft\Windows\WindowsUpdate\AU"
    $AUKeydword.HashTable = @{"AUOptions"="00000004 "
    "AUPowerManagement"="00000001"
    "AutoInstallMinorUpdates"="00000001" 
    "DetectionFrequency"="0000000a"
    "DetectionFrequencyEnabled"="00000001" 
    "IncludeRecommendedUpdates"="00000001" 
    "NoAUAsDefaultShutdownOption"="00000001" 
    "NoAUShutdownOption"="00000001" 
    "NoAutoRebootWithLoggedOnUsers"="00000001" 
    "NoAutoUpdate"="00000000" 
    "RebootRelaunchTimeout"="0000000a" 
    "RebootRelaunchTimeoutEnabled"="00000001" 
    "RescheduleWaitTime"="0000000a" 
    "RescheduleWaitTimeEnabled"="00000001" 
    "ScheduledInstallDay"="00000000" 
    "ScheduledInstallTime"="00000003" 
    "UseWUServer"="00000001"}





    foreach ($n in $nodes) {

            node $n {

                    Registry WUServer {
                    
                        key = "HKLM:\SOFTWARE\Policies\Microsoft\Windows\WindowsUpdate"
                        ValueName = "WUServer"
                        ValueData = "http://$wsusServer`:$wsusPort"
                        ValueType = "String"
                        Ensure = "Present"
                        }
                    Registry WUStatusServer {
                    
                        key = "HKLM:\SOFTWARE\Policies\Microsoft\Windows\WindowsUpdate"
                        ValueName = "WUStatusServer"
                        ValueData = "http://$wsusServer`:$wsusPort"
                        ValueType = "String"
                        Ensure = "Present"
                        }
                    Registry TargetGroup {
                    
                        key = "HKLM:\SOFTWARE\Policies\Microsoft\Windows\WindowsUpdate"
                        ValueName = "TargetGroup"
                        ValueData = "workgroup"
                        ValueType = "String"
                        Ensure = "Present"
                        }
                    $WindowsUpdatedword.HashTable.GetEnumerator() | foreach {
                            Registry $_.key {    
                            
                                key = $WindowsUpdate.Key
                                ValuName = $_.key
                                ValueData = $_.value
                                ValueType = "Dword"
                                Ensure = "Present"

                                }
                        }

                    $AUKeydword.HashTable.GetEnumerator() | foreach {
                            Registry $_.key {    
                    
                                key = $AUKeydword.Key
                                ValuName = $_.key
                                ValueData = $_.value
                                ValueType = "Dword"
                                Ensure = "Present"

                                }

                        }


                    }


            }

}

