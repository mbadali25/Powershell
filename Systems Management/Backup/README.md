# System Management Backup

## Script Usage

### NPS Backup Powershell for Server 2012 and up

Usage Example

```powershell
.\Backup-Nps.ps1 -BackupPath "Path"
```

Paths Accepted

- UNC
- Local Paths

```powershell
.\Backup-Nps.ps1 -BackupPath \\remotepath
```

This script will export the NPS Configuration to the desired path and put a date stamp on it.

Also it will check and remove files over than 7 days in the path.

### DNS Backup Powershell for Server 2012 and up

Usage Example

```powershell
.\BackupDNS.ps1 -BackupPath "Path"
```

Paths Accepted

- UNC
- Local Paths

```powershell
.\BackupDNS.ps1 -BackupPath \\remotepath
```

Backup Remote DNS Server Usages

```powershell
.\BackupDNS.ps1 -BackupPath \\remotepath -ComputerName RemoteComputer
```

__Note:__ By Default it will backup the local server it is running one.

This script will export the all the DNS Zones with a time stamp on it.

### DHCP Backup Powershell for Server 2016 and Up

Usage Example

```powershell
.\BackupDHCP.ps1 -BackupPath "Path"
```

Paths Accepted

- UNC
- Local Paths

```powershell
.\BackupDHCP.ps1 -BackupPath \\remotepath
```

Backup Remote DHCP Server Usages

```powershell
.\BackupDHCP.ps1 -BackupPath \\remotepath -ComputerName RemoteComputer
```

__Note:__ By Default it will backup the local server it is running one.

This script will export the all the DNS Zones with a time stamp on it.