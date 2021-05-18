#############################################################
##
## Install Bases Features for Windows Failover Cluster
## 
## The installs the Windows Feature Failover-Clustering
## 
#############################################################

Install-WindowsFeature Failover-Clustering -IncludeAllSubFeature -IncludeManagementTools

###Note: This will require a reboot

#Checks for Reboot and Reboots if needed
if ((Test-PendingReboot.ps1 -ComputerName $env:ComputerName).IsPendingReboot -eq $true) { Restart-Computer -Force }