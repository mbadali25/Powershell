# PowerShell Scheduled Task Deployment

Powershell Script to script deployment of Scheduled Task

Usage Example

```powershell
.\Deploy-Scheduled-Task.ps1 -TaskName "Task Name Here" -TaskDescription "Task Description Here" -User "Domain\User or User" -Password "User Account Password" -TriggerTime "Time to run" -TriggerTimeAMPM PM -TaskAction "Path to application" -TaskActionArguement "Task Argument"
```

Using Script to Run a Powershell Script

```powershell
.\Deploy-Scheduled-Task.ps1 -TaskName "Nightly NPS Backup for $($env:COMPUTERNAME)" -TaskDescription "Scheduled Task to Create Nightly NPS Backups" -User "domain\user" -Password "Password" -TriggerTime "11:00" -TriggerTimeAMPM PM -TaskAction "Powershell.exe" -TaskActionArguement "C:\script.ps1"
```

__Note:__ Right now this script is in the basics is configured only to setup task that run daily.
