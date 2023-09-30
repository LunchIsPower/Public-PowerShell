Import-Module ActiveDirectory
$ComputerList = import-csv -Delimiter "," -Path  '.inputs\DisableComputerList.csv'

$SourceDC = "domain.local"
Foreach ($Computer in $ComputerList)
{
    Get-ADComputer $Computer.Name -Server $SourceDC | Disable-ADAccount -Server $SourceDC
    $sourceComputer = Get-ADComputer $Computer.Name -Server $SourceDC -Properties Enabled
    Write-host "Computer " $sourceComputer.SAMAccountName " is Enabled equals " $sourceComputer.Enabled
}