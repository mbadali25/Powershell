###Disabled Inactive Computers###
##                             ## 
## Author:  Matthew Badali     ##
## Date: 1/28/2020             ##
#################################

##Setting Up Variables

#Moves Disabled Computers to this OU"
$DisabledOU="OU=DisabledComputers,OU=Computers,OU=IH,DC=corp,DC=invh,DC=com"
#Searches for Systems in this OU
$SearchOU="OU=Computers,OU=IH,DC=corp,DC=invh,DC=com"
#Sets Criteria for Systems inactive for 120 days or more
$DaysInactive = 270
$time = (Get-Date).Adddays(-($DaysInactive))
$currentdate = (get-date).ToString('yyyy-MM-dd HH:mm:ss')

##Gets All Computers that are inactive

$computers = get-adcomputer -Filter {PasswordLastSet -lt $time -and Enabled -eq $true } -searchbase $SearchOU -Properties Name,OperatingSystem,SamAccountName,LastLogonDate,PasswordLastSet,DistinguishedName,IPV4Address

##Moves all Computers to New OU and Sets Status and Orginal OU in Description

foreach ($computer in $computers)
{
    $Description="Inactive Computer Disabled on $($currentdate). OS: $($computer.OperatingSystem) LastLogin: $($computer.LastLogonDate) Original OU: $($computer.DistinguishedName) IP: $($computer.IPv4Address)"
    
    #Disables Computer and Sets a new Description in Description Field
    Set-ADComputer $computer -Description $Description 
    Set-ADComputer $computer -Enabled $false

    #Moves Disabled Computer to Disabled Computer OU
    Move-ADObject -Identity $computer -TargetPath $DisabledOU
    
}