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


#Note this will only backup the primary DHCP Server.
#Since we are running them as load balnaced that is fine.

Backup-DhcpServer -ComputerName $ComputerName -Path $Path
##########Clean  up backups older than 7 days##############

$days = "-7"
$daysback = (Get-Date).AddDays($days)
(Get-ChildItem -Path $Path -Recurse -force -ErrorAction SilentlyContinue | where { ($_.CreationTime -lt ($daysback) ) } ) | Remove-Item -Verbose -Force -Recurse -ErrorAction SilentlyContinue

###############################################################
