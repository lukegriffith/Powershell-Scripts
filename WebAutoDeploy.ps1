Import-Module Pipeworks

# Obtaining VM cred from PipeWorks Database
$vmcred = Get-SecureSetting -Name AzureVM -Decrypted | select -ExpandProperty DecryptedData

Write-Output "connecting remote powershell session to <Azure VM URL>"
# Establishing PS Remoting session to Azure VM
$so = New-PsSessionOption -SkipCACheck -SkipCNCheck
$s = New-PSSession lgriffithweb.cloudapp.net -Credential $vmcred  -UseSSL -SessionOption $so

# Setting location to FTP folder and cleaning
Write-Output "Running clean up of Deploy folder"
Invoke-Command -Session $s -ScriptBlock {Import-Module WebAdministration;Set-Location C:\inetpub\ftproot\Deploy; Remove-Item *}

# Directory for upload
$folder="C:\Users\Luke\Desktop\FTPUpload"    

# Obtaining pipework secure credential
$ftpcred = Get-SecureSetting -Name ftp -Decrypted | select -ExpandProperty DecryptedData

# Declaring FTP variables
$ftp = "ftp://<Azure VM URL>" 
$user = $ftpcred.GetNetworkCredential().username
$pass = $ftpcred.GetNetworkCredential().password

$webclient = New-Object System.Net.WebClient 
 
$webclient.Credentials = New-Object System.Net.NetworkCredential($user,$pass)  

# Obtaining list of files for upload
foreach($item in (Get-ChildItem $folder)){ 
    Write-Output "Uploading $item..." 
    $uri = New-Object System.Uri($ftp+$item.Name) 
    $webclient.UploadFile($uri, $item.FullName) 

 } 

# Obtaing file hash to check itegirty of uploaded data
$localHash = Get-ChildItem $folder | Get-FileHash
$remoteHash = Invoke-Command -Session $s -ScriptBlock {cd C:\inetpub\ftproot\Deploy; Get-ChildItem | Get-FileHash} 

# Running integrity check
$a = $remoteHash + $localHash | select *, @{name='grouping';expression={$_.path.split("\")[-1]}} | group grouping
for ($i = 0; $i -lt $a.count; $i++) {if (!$a[$i].group[0].hash -eq $a[$i].group[1].hash) { Write-Error -Exception "AutoDeploy" -Message "source / dest filehash of $($a[$i].name) does not match after upload"; Write-Host "Continue? Y/N"; if (Read-Host -eq "N") {break} } else { Write-Output "File integrity check OK $($a[$i].name)" }} 

# Obtaining paramters site name, for app pool recycle
$iisSiteXml = [xml](Get-Content $folder\*.SetParameters.xml)
$siteName = $iisSiteXml.parameters.setParameter | Where-Object name -like "IIS Web Application Name" | select -ExpandProperty value
Write-Output "Site to deploy $siteName"

Invoke-Command -Session $s -ScriptBlock {&(Get-Item *.cmd).FullName /y; 
                                         Start-Sleep -Seconds 5; 
                                         get-website -Name $args.tostring() | Restart-WebAppPool;
                                         Remove-Item * } -ArgumentList $siteName 

Write-Output "Site Deploy completed"