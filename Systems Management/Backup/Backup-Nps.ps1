param(
    [Parameter(Mandatory = $true,
        Position = 0,
        HelpMessage = "Please Specify Backup Path")]
    [string]$BackupPath
)

#Gets the local computer Name
$ComputerName = $env:COMPUTERNAME
#Pulls the date
$date = (get-date).ToString("yyyy-MM-dd")

###Test is the backup Path is valid

#Checking to see if $BackupPath ends with a \
#If it doesn't add \ to the end
if ($BackupPath.Substring($BackupPath.Length - 1) -ne "\") { $BackupPath = "$($BackupPath)\" }

#Adding Computer Name on backup path

$Path = "$($BackupPath)$($ComputerName)"
$backupfile = "$($Path)-$($date)-npsexport.xml"

###Validates if the backup path is valid and if so try to create a directory

try {
    if (!(Test-Path $Path)) { new-item $Path -ItemType Directory }    
}
catch {
    Write-Warning "This file path does NOT exist: $($Path) or lack the permissions to write to it."
    Write-Warning "Please Specifiy the correct path or resolve permission issues."
    break;
}


Export-NpsConfiguration -path $backupfile

##########Clean  up backups older than 7 days##############


$days = "-7"
$daysback = (Get-Date).AddDays($days)
(Get-ChildItem -Path $Path -Recurse -force -ErrorAction SilentlyContinue | where { ($_.CreationTime -lt $daysback ) } ) | Remove-Item -Verbose -Force -Recurse -ErrorAction SilentlyContinue
 

###############################################################
