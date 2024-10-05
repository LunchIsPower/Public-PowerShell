# ---------------------------------------------------------------------------- #
#                          Old Versions of PowerShell                          #
# ---------------------------------------------------------------------------- #
<# 
    To be used through powershell script without access to GUI and older versions of Powershell.
    Replace <admin-account> and <secure-password> with the desired username and password.
    This should be run as Administrator / password set to never expire / description can be changed as needed.
    This is less secure as the password is visable on teh screen and is stored throughout the session as plaintext.
    
    Notice this is useing a password in plain text hence the Remove-Item and clear-history so that the password isn't stored once the session is terminated.
 #>
# ----------------------------- setting variables ---------------------------- #
$addAdmin = "<admin-account>"
$password = "<secure-password>"
$description = 'Created local admin account via script'
# ----------------------------- Executing actions ---------------------------- #
$cn = [ADSI]"WinNT://$env:computername"
$user2 = $cn.Create("User",$addAdmin)
$user2.SetPassword($password)
$user2.setinfo()
$user2.description = $description
$user2.UserFlags.value = $user2.UserFlags.value -bor 0x10000
$user2.SetInfo()
$group2 = [ADSI]("WinNT://$env:computername/administrators,group")
$group2.add("WinNT://$addAdmin,user")
# --------------------- clears the history of the session -------------------- #
Remove-Item (Get-PSReadlineOption).HistorySavePath
Clear-History