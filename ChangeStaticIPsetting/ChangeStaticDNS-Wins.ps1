
$computersInput = (Split-Path $MyInvocation.MyCommand.Path -Parent) + "\computers.txt"
$computers = get-content $computersInput

$computers
$DNSServers = '"10.1.1.1",”10.1.1.2","10.1.1.3"'
$winsServers = '"10.1.1.4","10.1.1.5"'
$DomainName ='mydomain.com'

ForEach($computer in $computers)
{
  try{
    $NICs = Get-WMIObject Win32_NetworkAdapterConfiguration -computername $computer |Where-Object{$_.IPEnabled -eq "TRUE"}
    Foreach($NIC in $NICs)
    {
      Write-Host "SUCCESS::The Computers NIC "  $NIC  " is starting Continuing."
      # $NIC.SetDNSServerSearchOrder($DNSServers)
      # $NIC.SetDynamicDNSRegistration(“TRUE”)
      # $NIC.SetWINSServer($winsServers)
      # $NIC.SetDNSDomain($DomainName)
    }
  }
  Catch [System.Management.Automation.RemoteException]{
    if ($_.Exception.InnerException.Message -like "*RPC server is unavailable.*") {
        Write-Error "Computer not responding." # $computer "Continuing to next computer."
    } else {
        Write-Error $_.Exception.Message 
    }
  }
}

