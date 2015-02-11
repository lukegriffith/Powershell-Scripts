<# 
** Variables exaplined.

$days - The number of days logs need to be kept. Set this number fo a minus figure. -8 is
8 days worth of logs saved.

$pathToRun - The directory path where the log files are stored 

$regExPattern - This is the regular expression that is used to identify the logs.

Regex Examples 

'.txt$' -- to arhive .txt files 
'.log$' --- to archie .log files

'(.txt$|.log$)' --- to archive .log or .txt files

Author: Luke Griffith
Incident: F0814960
Date Created: 11 February 2015 
#>

# ** Defining Variables 

$days = -8
$pathToRun = 'path'
$regExPattern = '[0-9][0-9]_[0-9][0-9]_[0-9][0-9]$'


# Obtaining archive Date
$dateToArchive = (get-date).addDays($days)

# Obtaining File List
$files = gci -Path $pathToRun

# Matching file output with Regular Expression
$FileMatches = $files | ? {$_.Name -match $regExPattern}

# Filtering output to files older than retention date specified
$filesToDelete = $FileMatches | ? {$_.LastWriteTime -le $dateToArchive}

# Removing files
Remove-Item $filesToDelete -Force
