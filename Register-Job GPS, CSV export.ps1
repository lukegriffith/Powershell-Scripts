Register-ScheduledJob -scriptblock {

Get-Process | select * | sort workingset  | Export-Csv D:\Attenda\F0745239\gps$((Get-Date).ToString('MM-dd-yyyy')).csv -NoTypeInformation


} -Name "F0745239" -trigger (New-JobTrigger -Weekly -At 00:00 -DaysOfWeek Saturday) 


