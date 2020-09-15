#find replace "backup" and create your own UNC path 
#run script on your computer as administratior type in hostname at prompt.
$destination = "\\nas1\techmoves\samsa\"
$computername = read-host -prompt 'target machines DP number (or hostname)'

#List users in userprofile on target machine and size of all profiles excluding hidden folders in gigabytes
$userprofiles = Get-ChildItem \\$computername\c$\users -directory
write-output $userprofiles.fullname
"{0:N2} GB" -f ((Get-ChildItem \\$computername\c$\users -Recurse | Measure-Object -Property Length -Sum -ErrorAction Stop).Sum / 1GB)

#prompt for username to copy--if "all" coppies all
$username = read-host -prompt 'name of userprofile to copy if "all" coppies all'

#First the script copies Lotus Notes files needed to directory created called "lotus"
#Note if it's specific files beign coppied not directories you need to create the destination directory yourself
new-item -path \\nas1\techmoves\samsa\$computername\lotus -itemtype directory
Copy-Item -Path \\$computername\c$\Lotus\Notes\Data\bookmark.nsf -Destination \\nas1\techmoves\samsa\$computername\lotus\bookmark.nsf
Copy-Item -Path \\$computername\c$\Lotus\Notes\Data\bookmark.ntf -Destination \\nas1\techmoves\samsa\$computername\lotus\bookmark.ntf
Copy-Item -Path \\$computername\c$\Lotus\Notes\Data\desktop8.ndk -Destination \\nas1\techmoves\samsa\$computername\lotus\desktop8.ndk
Copy-Item -Path \\$computername\c$\Lotus\Notes\Data\*.id -Destination \\nas1\techmoves\samsa\$computername\lotus

#folders that will be coppied in C:\users does not copy all hidden files becuase -force is not used in copy command
#!this may not include some user files if they store files in locations other than their user profile!

$folder = "Desktop",
"Downloads",
"Favorites",
"Documents",
"Music",
"Pictures",
"Videos"

#logic flows: if you enter username="all" for $username varible coppies folder contents from all userprofiles if username ex) "richard.samsa" is specified only coppies that user folder
if ($username -eq 'all'){ 
foreach ($userprofile in $userprofiles){
    foreach ($f in $folder)
    {   
        $BackupSource = $userprofile.FullName  + "\" + $f
        $BackupDestination = $destination + $computername + "\" + $userprofile.Name + "\" + $f
        Copy-Item -verbose -recurse -Path  $BackupSource -Destination $BackupDestination
    }
        $Signature = $userprofile.FullName + "\AppData\Roaming\Microsoft\Signatures\"
        $Signaturebackup = "\\nas1\techmoves\samsa\" + $computername + "\" + $userprofile.Name + "\Appdata\Roaming\Microsoft\Signatures"
        Copy-Item -verbose -Recurse -Path $Signature -Destination $Signaturebackup

        $Chromedir = "\\nas1\techmoves\samsa\" + $computername + "\" + $userprofile.Name + "\Appdata\Local\Google\Chrome\User Data\default"
        new-item -type dir $Chromedir
        $Chrome = $userprofile.fullname + "\AppData\Local\Google\Chrome\User Data\Default\Bookmarks."
        $Chromebackup = "\\nas1\techmoves\samsa\" + $computername + "\" + $userprofile.name + "\Appdata\Local\Google\Chrome\User Data\Default"
        Copy-Item -verbose -Path $chrome -Destination $Chromebackup

        $ibm = $userprofile.FullName + "\AppData\local\ibm\notes\data\"
        $ibmbackup = "\\nas1\techmoves\samsa\" + $computername + "\" + $userprofile.Name + "\Appdata\local\ibm\data"
        Copy-Item -verbose -Recurse -Path $ibm -Destination $ibmbackup

        $sticky = $userprofile.FullName + "\AppData\roaming\microsoft\sticky` notes\"
        $stickybackup = "\\nas1\techmoves\samsa\" + $computername + "\" + $userprofile.Name + "\Appdata\roaming\microsoft\sticky` notes"
        Copy-Item -verbose -Recurse -Path $sticky -Destination $stickybackup
}
}
else{
    foreach ($f in $folder)
    {   
        $BackupSource = "\\" + $computername + "\c$\users\" + "$username" + "\" + $f
        $BackupDestination = $destination + $computername + "\" + $username + "\" + $f
        Copy-Item -verbose -recurse -Path $BackupSource -Destination $BackupDestination
        write-output $backupsource
    }
    
        $Signature = "\\" + $computername + "\c$\users\" + "$username" + "\AppData\Roaming\Microsoft\Signatures\"
        $Signaturebackup = "\\nas1\techmoves\samsa\" + $computername + "\" + "$username" + "\Appdata\Roaming\Microsoft\Signatures"
        Copy-Item -verbose -Recurse -Path $Signature -Destination $Signaturebackup

        new-item -type dir \\nas1\techmoves\samsa\$computername\$username\appdata\local\google\chrome\user` data\default
        $Chrome = "\\" + $computername + "\c$\users\" + "$username" + "\AppData\Local\Google\Chrome\User Data\Default\Bookmarks."
        $Chromebackup = "\\nas1\techmoves\samsa\" + $computername + "\" + "$username" + "\Appdata\Local\Google\Chrome\User Data\Default"
        Copy-Item -verbose -Path $chrome -Destination $Chromebackup

        $ibm = "\\" + $computername + "\c$\users\" + "$username" + "\AppData\local\ibm\notes\data\"
        $ibmbackup = "\\nas1\techmoves\samsa\" + $computername + "\" + "$username" + "\Appdata\local\ibm\data"
        Copy-Item -verbose -Recurse -Path $ibm -Destination $ibmbackup

        $sticky = "\\" + $computername + "\c$\users\" + "$username" + "\AppData\roaming\microsoft\sticky` notes\"
        $stickybackup = "\\nas1\techmoves\samsa\" + $computername + "\" + "$username" + "\Appdata\roaming\microsoft\sticky` notes"
        Copy-Item -verbose -Recurse -Path $sticky -Destination $stickybackup
    }