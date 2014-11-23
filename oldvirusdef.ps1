#Script created by: Luke Griffith
#Call Ref: F0746130
#Declaring Variable

#Getting current cache files from usage.dat
$a = Get-Content C:\ProgramData\Symantec\Definitions\VirusDefs\usage.dat | Select-String -Pattern "[..]"
$b = $a[0].line
$c = $b.trimstart("[").trimend("]")
$d = $a[1].line
$e = $d.trimstart("[").trimend("]")

# Work on this foreach
$usage = @()
foreach ($var in $a) {
$use = $var.trimstart("[").trimend("]")
$useage += $use

}

#Getting current def from definfo.dat
$def = Get-Content C:\ProgramData\Symantec\Definitions\VirusDefs\definfo.dat
$curdef =  ($def[1]).trimstart("CurDefs=")

#Generating exlusion list
$exclude = "BinHub", "umcat_01.db", "definfo.dat", "Cat.DB", "TextHub", "usage.dat", "*.db*", "*.dat", "*.tmp", $curdef, $c, $e

#Creating log 
$file = get-childitem -path C:\ProgramData\Symantec\Definitions\VirusDefs -exclude $exclude
$date = get-date

if ($file -ne $null)
{
add-content D:\attenda\OldVirusDeflog.txt "`nDate: $date"
add-content D:\attenda\OldVirusDeflog.txt "`n$file"
}

#Executing Commands
get-childitem -path C:\ProgramData\Symantec\Definitions\VirusDefs -exclude $exclude | remove-item -recurse 