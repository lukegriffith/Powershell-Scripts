configuration wsusRegKey {

    param($wsusServer,$wsusPort,$WsusGroup,$nodes)
    
    $WindowsUpdatedword = "" | select Key,HashTable
    $WindowsUpdatedword.Key = "HKLM:\SOFTWARE\Policies\Microsoft\Windows\WindowsUpdate"
    $WindowsUpdatedword.HashTable =  @{"AcceptTrustedPublisherCerts"="00000001"
                                        "ElevateNonAdmins"="00000001 "
                                        "TargetGroupEnabled"="00000001"}

    $AUKeyword = "" | select Key,HashTable
    $AUKeyword.Key = "HKLM:\SOFTWARE\Policies\Microsoft\Windows\WindowsUpdate\AU"
    $AUKeyword.HashTable = @{"AUOptions"="00000004 "
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


$i = 0 
foreach ($server in $nodes) {
    node $server {

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
                        ValueData = "$WsusGroup"
                        ValueType = "String"
                        Ensure = "Present"
                        }
        $WindowsUpdatedword.HashTable.GetEnumerator() | foreach {
                            Registry $i {    
                            
                                key = "HKLM:\SOFTWARE\Policies\Microsoft\Windows\WindowsUpdate"
                                ValueName = $_.key
                                ValueData = $_.value
                                ValueType = "Dword"
                                Ensure = "Present"

                                }
                                $i++
                        }
        $AUKeyword.HashTable.GetEnumerator() | foreach {
                            Registry $i {    
                    
                                key = "HKLM:\SOFTWARE\Policies\Microsoft\Windows\WindowsUpdate\AU"
                                ValueName = $_.key
                                ValueData = $_.value
                                ValueType = "Dword"
                                Ensure = "Present"

                                }
                                $i++

                        } 


        }
}

}
            




