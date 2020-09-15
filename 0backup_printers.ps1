#run this script on users machine logged in as themselves. It saves a file "networkprinters.bat" on the desktop to remap printers after migration
#reads contents of registry key that stores info about what network printers are mapped to current user
$printers1 = Get-childitem -Path HKCU:\printers\connections | select name
#saves desktop path of current user as variable
$DesktopPath = [Environment]::GetFolderPath("Desktop")
$filepath = $DesktopPath + "\networkprinters.bat"
#gleens and concatenates output of registry keyabove to create a batch script to readd printers  
$printers2 = $printers1 -replace '^(.*?)\,,'
#!!!IF NEW PRINT SERVERS OTHER THAN PRINT1 OR PRINT2 ARE ADDED ADD NAME TO OR STATEMENT BELOW EX '(?<=print1|print2|NEWNAME).*'
$printserver = $printers2 -replace '(?<=print1|print2).*'
$printers3 = $printers2 -replace '^(.*?)\,',"RunDll32.EXE printui.dll,PrintUIEntry /in /n \\print2\"
$printers4 = $printers3 -replace "}"
$printers5 = $printerserver + $printers4
Set-Content -path $filepath -value $printers5