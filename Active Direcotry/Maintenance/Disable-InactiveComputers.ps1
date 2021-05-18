#############################################################################
##  Disabled Inactive Computers
##
##  Written by Matthew Badali
##
##  This script will go out there and find all expired user accounts.
##
##  This is great when working with end users to see what Acitve Directory 
##  Accounts are expired and unusabled.
##
##  Automation, Systems Management, Security
##
#############################################################################
[CmdletBinding(DefaultParameterSetName='DefaultConfiguration')]
Param(
    [Parameter(Mandatory=$true,Position=0,
    HelpMessage="Please Specified the Destination OU for Inactive Computer Accounts")]
     [string]$DestinationOU,
     [Parameter(Mandatory=$true,Position=1,
     HelpMessage="Please specify the search base for looking for Inactive Computer Accounts")]
     [string]$SeachBase,
     [Parameter(Mandatory=$false,Position=2)]
     [string]$DaysInactive=((Get-Date).Adddays(-270)),
     [switch]$WhatIf


)
##Setting Up Variables
$currentdate = (get-date).ToString('yyyy-MM-dd HH:mm:ss')

##Gets All Computers that are inactive
$computers = get-adcomputer -Filter {PasswordLastSet -lt $time -and Enabled -eq $true } -searchbase $SeachBase -Properties Name,OperatingSystem,SamAccountName,LastLogonDate,PasswordLastSet,DistinguishedName,IPV4Address

#Checks for the -Whatif Swich 
if ($WhatIf) 
{
    $outpath="C:\scripts\REPORTS\"
    #Creates Directory if it doesn't Exists
    if (!(Test-Path $outpath)) {New-Item $outpath -ItemType Directory}

    $filename="$($outpath)Inactive-Computers-$($currentdate).csv"
    
    #Exports list to CSV
    $computers | Export-Csv $filename -NoTypeInformation

    #Displays Output
    $computers | ft
}

if (!($WhatIf))
{

    ##Moves all Computers to New OU and Sets Status and Orginal OU in Description
    foreach ($computer in $computers)
    {
        $Description="[Disabled by Script] Inactive Computer Disabled on $($currentdate). OS: $($computer.OperatingSystem) LastLogin: $($computer.LastLogonDate) Original OU: $($computer.DistinguishedName) IP: $($computer.IPv4Address)"
    
        #Creates field for info Attribute
        $executionuser=([Environment]::UserDomainName + "\" + [Environment]::UserName)
        $scriptname=[Environment]::GetCommandLineArgs()[0]
        $info = "This was disabled by $($executionuser) from $($env:ComputerName) by script [Environment]::GetCommandLineArgs()[0]"

        #Disables Computer and Sets a new Description in Description Field


        Set-ADComputer $computer -Description $Description -Replace @{Info=$info}
        Set-ADComputer $computer -Enabled $false

        #Moves Disabled Computer to Disabled Computer OU
        Move-ADObject -Identity $computer -TargetPath $DestinationOU
    
    }
}