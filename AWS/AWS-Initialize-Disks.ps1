#################################################
## This is used in Windows EC2 UserData
## to provision new AWS Instnaces
##
##
## AWS Initialize Disk
## The below script will find all the drives
## that are not C:\ and it will initialize them.
##
## The it will tag the drives and assign drive 
## letters based on the tags
##
##
## It does require tags to be on the EBS Volumes
## Tags Required:
## - DriveLetter
## - DriveLabel
## 
## Example: 
## KeyName = DriveLetter Value = L
## KeyName = DriveLabel  Value = SQLTLOGS
##
## If the DriveLabel = "SQLTLOG","SYSTEMDB",
## "USERDB","SQLBACKUP","TEMPDB"
## 
## The fomart will format it in 64k blocks
## This is best practices for SQL
## 
## 
#################################################

##Getting the instance ID from the metadata
$InstanceId = (Invoke-WebRequest http://169.254.169.254/latest/meta-data/instance-id -UseBasicParsing).content

#Gets the volume IDs from the Instance
$volumeids = ((Get-EC2Instance -InstanceId $InstanceId).instances).BlockDeviceMappings.ebs.volumeid

#Gets the information about all the volumes
$volumes = (get-ec2volume -VolumeId $volumeids)

#Sets Tags to look for if the system is a SQL Server
$SQLLabels = "SQLTLOG", "SYSTEMDB", "USERDB", "SQLBACKUP", "TEMPDB"


foreach ($volume in $volumes) {

    $drivelabel = ($volume.tags | where { $_.key -eq "DriveLabel" }).Value
    $driveletter = ($volume.tags | where { $_.key -eq "DriveLetter" }).Value
    $adapterserialnumber = ($volume.VolumeId).Replace('-', '')
     
    if ($driveletter -ne "C") {
        #Standard Disk Allocation Size
        $allocationsize = "4096"

        #If the Drive Label Matches a SQL Label Format 
        #Sets the Alloaction size for format to standards
        if ($drivelabel.Contains("SQL") -or $drivelabel.Contains("USERDB") -or $drivelabel.Contains("SYSTEMDB") -or $drivelabel.Contains("TEMDB")) { $allocationsize = "65536" }
        
        $partition = (get-disk | where { $_.AdapterSerialNumber -eq $adapterserialnumber -and $_.Number -ne 0 })
        if ($partition.PartitionStyle -eq 'raw') {
            Initialize-Disk -Number $partition.Number -PartitionStyle GPT | New-Partition -DriveLetter $driveletter -UseMaximumSize  | Format-Volume -FileSystem NTFS -NewFileSystemLabel $drivelabel -Confirm:$false  -AllocationUnitSize $allocationsize
        }
        if ($partition.PartitionStyle -eq 'GPT') {
            (get-disk | where { $_.AdapterSerialNumber -eq $adapterserialnumber -and $_.Number -ne 0 }) | New-Partition -DriveLetter $driveletter -UseMaximumSize | Format-Volume -FileSystem NTFS -NewFileSystemLabel $drivelabel -Confirm:$false -AllocationUnitSize $allocationsize
        }
        
    }

    #Labeling C:\
    if ($driveletter -eq "C") {
        get-volume -DriveLetter C | Set-Volume -NewFileSystemLabel $drivelabel

    }
    
}