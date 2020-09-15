#grabs admin credentials and saves as variable this way you can run the script from an unelevated shell
$adm = Get-Credential
#prompts for users account name
$user = Read-Host -prompt 'please input the user account name'
#outputs net user query and helps verify account name is correct
net user $user /domain
#prompts yes or no to reset password date
$yesno = Read-Host -prompt 'reset the timer for password expiraton? "y" for yes "n" for no'
if ($yesno -eq 'y'){ 
#saves output of get-user as varriable
$uservar = get-aduser $user -Properties pwdlastset
#changes pwdlast set property to current date
$uservar.pwdlastset = 0
Set-ADUser -Instance $uservar -Credential $adm
$uservar.pwdlastset = -1
Set-ADUser -instance $uservar -Credential $adm
#prints net user query again to verify expired date changes
net user $user /domain
pause
}
else{
exit
} 