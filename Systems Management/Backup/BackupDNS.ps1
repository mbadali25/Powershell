param(
    [Parameter(Mandatory = $true,
        Position = 0,
        HelpMessage = "Please Specify Backup Path")]
    [string]$BackupPath,
    [Parameter(Mandatory = $false,
        Position = 0,
        HelpMessage = "Please Specify Computer Name")]
    [string]$ComputerName = $env:COMPUTERNAME #Gets the local computer name if not specified
)


#Pulls the date
$date = (get-date).ToString("yyyy-MM-dd")

#Checking to see if $BackupPath ends with a \
#If it doesn't add \ to the end
if ($BackupPath.Substring($BackupPath.Length - 1) -ne "\") { $BackupPath = "$($BackupPath)\" }

#Adding Computer Name on backup path

$Path = "$($BackupPath)$($ComputerName)\$($date)"

###Validates if the backup path is valid and if so try to create a directory

try {
    if (!(Test-Path $Path)) { new-item $Path -ItemType Directory }    
}
catch {
    Write-Warning "This file path does NOT exist: $($Path) or lack the permissions to write to it."
    Write-Warning "Please Specifiy the correct path or resolve permission issues."
    break;
}


$exportpath = "$($Path)\ZoneTemp.csv"

# Pulls an environment variable to find the server name, queries it for a list of zones, filters only the primary ones, removes the quotes from the exported .csv file, and saves it to the specified folder.
Get-DNSServerZone -ComputerName $ComputerName | Where-Object { $_.ZoneType -eq "Primary" } | Select ZoneName | ConvertTo-CSV -NoTypeInformation | ForEach-Object { $_ -replace ‘"‘, "" } | Out-File $exportpath

# Imports the zone list
$ZoneList = Get-Content $exportpath

# Pulls the date variables in the appropriate formats
$Year = Get-date -Format yyyy
$Month = Get-Date -Format MM
$Day = Get-Date -Format dd

# Starts a loop for each line in the zone list
ForEach ($line in $ZoneList) {

    # Exports the zone info with the desired naming scheme
    $filename = "${line}_$Year-$Month-$Day.txt"
    $filename
    set-location $Path
    Export-DNSServerZone -Name $line -FileName $filename
    if ($ComputerName -eq $env:COMPUTERNAME) { $source = "C:\windows\system32\dns\$($filename)" }
    else { $source = "\\$ComputerName\C$\windows\system32\dns\$($filename)" }
    Move-Item $source $Path 
}
##########Clean  up backups older than 7 days##############


$days = "-7"
$daysback = (Get-Date).AddDays($days)
(Get-ChildItem -Path $Path -Recurse -force -ErrorAction SilentlyContinue | where { ($_.CreationTime -lt ($daysback) ) } ) | Remove-Item -Verbose -Force -Recurse -ErrorAction SilentlyContinue
 

###############################################################
