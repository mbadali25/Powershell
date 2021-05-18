
##Set the time Zone to Central Standard Time
set-timezone -Name "Central Standard Time"

#Disabled IE Enhanced Security Configuration (ESC)
$AdminKey = "HKLM:\SOFTWARE\Microsoft\Active Setup\Installed Components\{A509B1A7-37EF-4b3f-8CFC-4F3A74704073}"
$UserKey = "HKLM:\SOFTWARE\Microsoft\Active Setup\Installed Components\{A509B1A8-37EF-4b3f-8CFC-4F3A74704073}"
Set-ItemProperty -Path $AdminKey -Name "IsInstalled" -Value 0
Set-ItemProperty -Path $UserKey -Name "IsInstalled" -Value 0
Stop-Process -Name Explorer
Write-Host "IE Enhanced Security Configuration (ESC) has been disabled." -ForegroundColor Green
#### Setting PSGallery Powershell Repository to Trusted
Set-PSRepository -Name PSGallery -InstallationPolicy Trusted

#### Updates Powershell Nuget
#Checks to see if currnet verison matches the latest version out there
Install-PackageProvider -Name Nuget -Force 
If (!((get-packageprovider -Name Nuget).Version -eq (Find-PackageProvider -Name nuget).version)) { Install-PackageProvider -Name Nuget -Force }

#### Updates PowershellGet
#Checks to see if currnet verison matches the latest version out there
Install-PackageProvider -Name PowerShellGet -Force 
If (!((get-packageprovider -Name PowerShellGet).Version -eq (Find-PackageProvider -Name PowerShellGet).version)) { Install-PackageProvider -Name PowerShellGet -Force }

####Installing Chocolatey

Set-ExecutionPolicy Bypass -Scope Process -Force; [System.Net.ServicePointManager]::SecurityProtocol = [System.Net.ServicePointManager]::SecurityProtocol -bor 3072; iex ((New-Object System.Net.WebClient).DownloadString('https://chocolatey.org/install.ps1'))
    
###Installing Telnet-Clinet
Install-WindowsFeature Telnet-Client

###Installing RSAT-AD-Powershell
Install-WindowsFeature RSAT-AD-PowerShell

###Installl PSWindowsUpdate Powershell Module
Install-Module PSWindowsUpdate -Force

###Install Script Test-PendingReboot
Install-Script Test-PendingReboot -Force

#Updates Path Variables
$env:Path += ";C:\Program Files\WindowsPowerShell\Scripts"

###Enable PSRemoting
Enable-PSRemoting

#Disable Firewall
#Note: This will be re-enabled after domain join
#Needed for some base setup
Set-NetFirewallProfile -Profile Domain, Public, Private -Enabled False

###############################################################################################

#### Insert other items here ####

################################# End of the Script############################################
#Grabs the Instance ID from the AWS EC2 Instance
$InstanceId = (Invoke-WebRequest http://169.254.169.254/latest/meta-data/instance-id -UseBasicParsing).content

#Renames the Computer based off the tag key named "SeverName"
$computername = (Get-EC2Tag -Filter @{Name = "resource-id"; Value = $instanceid } | where { $_.key -eq "ServerName" }).Value
Rename-Computer $computername
Restart-Computer -Force
