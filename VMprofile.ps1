### PS Profile ######
# 1. Drive Mappings #
# 2. Functions      #
# 3. Alias          #
# 4. Misc           #
#####################

## 1. Drive Mappings
New-PSDrive -Name Scr -PSProvider Filesystem -Root "Z:\Projects\Powershell Scripts" | out-null
New-PSDrive -Name Py -PSProvider Filesystem -Root "Z:\Projects\Python" | out-null
New-PSDrive -Name Wrk -PSProvider Filesystem -Root "Z:\Projects\Work Projects" | out-null

## 2. Variables 
$env:PSModulePath = $env:PSModulePath + ";Scr:\Modules"

## 2. Modules
Import-Module MyModule

## 3. Alias
new-alias -name pscon -value Get-PowershellConnection
new-alias -name py -value C:\Python34\python.exe
new-alias -name vi -value "C:\Program Files (x86)\Vim\vim74\vim.exe"
new-alias -name vim -value "C:\Program Files (x86)\Vim\vim74\vim.exe"
new-alias -name wm -value "whatmask.exe"
new-alias -name gdc -value Get-DeviceConsole
new-alias -name lunch -value start-lunch
new-alias -name netbrain -value "C:\Program Files (x86)\NetBrain\Workstation Operator Edition\bin\NetBrainWorkbench.exe"

## 4. Misc
Write-Host "Profile Configuration Loaded"
write-host ("----" * 12)
write-host "Powershell - Scr: | Python - Py: | Work - Wrk: "
write-host ("----" * 12)
cd Scr:

