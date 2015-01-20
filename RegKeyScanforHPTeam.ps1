foreach ($server in $servers) {
 
$server
 
$credential = #########

$wmi = get-wmiobject -list "StdRegProv" -namespace root\default -computername $server -credential $credential

 

$hklm = 2147483650
$key = "SYSTEM\CurrentControlSet\Control\Class\{4D36E972-E325-11CE-BFC1-08002BE10318}"
$valueList = 'TxPathValidationEnabled', 'RxPathValidationTime', 'TeamType'

$SubKeys = ($wmi.EnumKey($hklm,$key)) | select -ExpandProperty sNames




$array = @()
$arrayFailed = @()

foreach ($value in $valueList) {



        $wmiObj = ($wmi.GetDWORDValue($hklm,$key,$value)) | select uValue, ReturnValue
               
        write-host "$($wmiObj.ReturnValue) for $value in $key"


            if ($wmiObj.ReturnValue -ne 0) {



            }

            if (($wmiObj.ReturnValue -eq 0) -and ($value -eq 'TxPathValidationEnabled' -and $wmiObj.uValue -eq 1) -or ($value -eq 'RxPathValidationTime' -and $wmiObj.uValue -eq 1) -or ($value -eq 'TeamType' -and $wmiObj.uValue -eq 11)) {


                $object = New-Object -TypeName psobject
                $object | Add-Member -MemberType NoteProperty -Name Key -Value $null
                $object | Add-Member -MemberType NoteProperty -Name Value -Value $null
                $object | Add-Member -MemberType NoteProperty -Name Server -Value $null


                $object.Key = $value
                $object.Value = $wmiObj | select -ExpandProperty uValue
                $object.Server = $server
                $object.Value
                $array += $object
               }

             if ($wmiObj.ReturnValue -ne 0) {

                $object = New-Object -TypeName psobject
                $object | Add-Member -MemberType NoteProperty -Name Key -Value $null
                $object | Add-Member -MemberType NoteProperty -Name ReturnValue -Value $null
                $object | Add-Member -MemberType NoteProperty -Name Server -Value $null

                $object.Key = $value
                $object.ReturnValue = $wmiObj | select -ExpandProperty ReturnValue
                $object.Server = $server
                $object.Value
                $arrayFailed += $object

            }







    foreach ($Skey in $SubKeys) {

        $keyUp = $key + "\$Skey"
        
        $wmiObj = ($wmi.GetDWORDValue($hklm,$keyUp,$value)) | select uValue, ReturnValue
               
        write-host "$($wmiObj.ReturnValue) for $value in $skey"


            if ($wmiObj.ReturnValue -ne 0) {



            }

            if (($wmiObj.ReturnValue -eq 0) -and ($value -eq 'TxPathValidationEnabled' -and $wmiObj.uValue -eq 1) -or ($value -eq 'RxPathValidationTime' -and $wmiObj.uValue -eq 1) -or ($value -eq 'TeamType' -and $wmiObj.uValue -eq 11)) {


                $object = New-Object -TypeName psobject
                $object | Add-Member -MemberType NoteProperty -Name Key -Value $null
                $object | Add-Member -MemberType NoteProperty -Name Value -Value $null
                $object | Add-Member -MemberType NoteProperty -Name Server -Value $null


                $object.Key = $value
                $object.Value = $wmiObj | select -ExpandProperty uValue
                $object.Server = $server
                $object.Value
                $array += $object

            } 

            if ($wmiObj.ReturnValue -ne 0) {

                $object = New-Object -TypeName psobject
                $object | Add-Member -MemberType NoteProperty -Name Key -Value $null
                $object | Add-Member -MemberType NoteProperty -Name ReturnValue -Value $null
                $object | Add-Member -MemberType NoteProperty -Name Server -Value $null

                $object.Key = $value
                $object.ReturnValue = $wmiObj | select -ExpandProperty ReturnValue
                $object.Server = $server
                $object.Value
                $arrayFailed += $object

            }



                
           

    }
}


}


$array2 = $arrayFailed | select Server | Group-Object


diff -ReferenceObject $array2 -DifferenceObject $array1 | Export-Csv -Path .\failed.csv
$array | export-csv -Path .\RegValues.csv

<# Paths

TxPathValidationEnabled  - eq 1 
RxPathValidationTime     - eq 1
TeamType      - eq b (11 in decimal)
#>


<#

$hklm = 2147483650
$key = 'SYSTEM\CurrentControlSet\Control\Class\{4D36E972-E325-11CE-BFC1-08002BE10318}\0008'
$valueList = 'TxPathValidationEnabled'

($wmi.GetDWORDValue($hklm,$key,$value))
#>