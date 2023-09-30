$computer = get-content .\computers.txt

$NICs = Get-WMIObject Win32_NetworkAdapterConfiguration -computername $computer |where{$_.IPEnabled -eq “TRUE”}

Foreach($NIC in $NICs)
   {
        Write-Host "SUCCESS::The Computer "  $NIC  " is starting Continuing."
        $DNSServers = "10.1.1.1",”10.1.1.2","10.1.1.3"
        $NIC.SetDNSServerSearchOrder($DNSServers)
        $NIC.SetDynamicDNSRegistration(“TRUE”)
        $NIC.SetWINSServer("10.1.1.4","10.1.1.5")
        $NIC.SetDNSDomain('mydomain.com')
      }
