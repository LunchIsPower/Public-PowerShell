# ---------------------------------------------------------------------------- #
#                       PowerShell version 5.1 and above                       #
# ---------------------------------------------------------------------------- #
<# 
    This scipt works with new versions of powershell and doesn't require access to a GUI
#>
$User = Read-Host -Prompt 'Enter the Admin UserName : ' 
$PWord = Read-Host -Prompt 'Enter a Password : ' -AsSecureString
$description = 'Created local admin account via script'

$params = @{
    Name        = $User
    Password    = $PWord
    Description = $description
}
$NewUser  = New-LocalUser @params -PasswordNeverExpires
Add-LocalGroupMember -Group "Administrators" -Member $User
