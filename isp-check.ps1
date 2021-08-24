## Bryton Herdes 
## 8.23.2021
##
## set route of 8.8.8.8/32 (internet destination) to eth gw, used for ping testing
## Check for successful ping to internet destination via eth network gw
##
## 1. If successful, set metric of ethernet adapter to 25 
## 2. If failure, set metric of ethernet adapter to 60 (less preferred to wifi)
## Run every X seconds...
##
## Goal: Deal with ISP drop-outs by switching to cell hotspot over WiFi

## Before running, on PC set the following: route add 8.8.8.8 mask 255.255.255.255 192.168.88.1 (or substitute 192.168.88.1 with your gateway address)

$ethernetAdapter = get-netadapter -Name Ethernet | select -exp ifIndex

$temp = 0
# Start infinite loop of checks
while ($true) {
    $resultv4 = Test-Connection 8.8.8.8 -quiet -count 1
    if ($resultv4 -eq "True") {
         Set-netipinterface -InterfaceIndex $ethernetAdapter -InterfaceMetric 25
		 if (temp -eq 1) {
			powershell -WindowStyle hidden -Command "& {[System.Reflection.Assembly]::LoadWithPartialName('System.Windows.Forms'); [System.Windows.Forms.MessageBox]::Show('ISP is back up','WARNING')}"
		 }
         $temp = 0
    }
    else {
        Set-netipinterface -InterfaceIndex $ethernetAdapter -InterfaceMetric 100
        if ($temp -eq 0) {
            powershell -WindowStyle hidden -Command "& {[System.Reflection.Assembly]::LoadWithPartialName('System.Windows.Forms'); [System.Windows.Forms.MessageBox]::Show('ISP is down, switching to hotspot','WARNING')}"
        }
        $temp = 1
    }
}
