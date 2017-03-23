#!/bin/sh

VMname=$1
OSname=$VMname
CPU=$2
MemoryGB=$3
Hostname="pcsp-proto01.ad.proto.skp"
NetworkName1="175.126.56.X"
IPaddr1=$4
Subnet1="255.255.255.0"
Gateway1="175.126.56.1"
datastore="vsanDatastore"
OSCustomname="LINUX"
folder="1002350"
template="skp_centos7"

echo "Hello, world!"
ssh 175.126.56.212 << EOF
. 'C:\Program Files (x86)\VMware\Infrastructure\vSphere PowerCLI\Scripts\Initialize-PowerCLIEnvironment.ps1'
Connect-VIServer 10.0.250.11 -User administrator@vsphere.local -Password Skp1tksa++
#$label = "vSAN_10.200.210.X"
#$label = "Transport Zone_10.0.250.X"

Get-OSCustomizationSpec $OSCustomname |Get-OSCustomizationNicMapping | Set-OSCustomizationNicMapping -IpMode UseStaticIP -IpAddress $IPaddr1 -SubnetMask $Subnet1 -DefaultGateway $Gateway1
Get-OSCustomizationSpec $OSCustomname | Set-OSCustomizationSpec -NamingScheme Fixed -NamingPrefix $OSname
New-VM -Name $VMname -Template $template -vmhost $Hostname -Datastore $datastore -OSCustomizationSpec $OSCustomname -Location $folder
Set-VM -VM $VMname -NumCpu $CPU -MemoryGB $MemoryGB -Confirm:\$false
Get-VM $VMname | Get-NetworkAdapter -Name "Network adapter 1"  | Set-NetworkAdapter -NetworkName "$NetworkName1" -Confirm:\$false -StartConnected:\$true
Start-VM -VM $VMname  -Confirm:\$false
exit
