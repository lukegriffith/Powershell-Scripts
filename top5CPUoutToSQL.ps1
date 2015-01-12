$gpsOut = gps | sort cpu -Descending | select id, CPU, WorkingSet, ProcessName -First 5 


$gpsOut | ForEach-Object {
$SQLQuery = "use transactions
go
insert into processes
Values ($($_.id),$($_.CPU),$($_.WorkingSet),'$($_.ProcessName)')
"
Invoke-Sqlcmd  $SQLQuery -Database transactions -ServerInstance SQL\SQLEXPRESS}