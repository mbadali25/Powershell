
#----------------------------------------------------------------------------------------------
# Script: Deploy-ScheduledTask.ps1
# Author: Matthew Badali
# Date: 04/21/2019 
# Comments:
#---------------------------------------------------------------------------------------------

### Parameters
Param(

    [Parameter(Mandatory = $true)] #Specify the Task Name

    [string]$TaskName,

    [Parameter(Mandatory = $true)] # Specify the Task Description
    [String]$TaskDescription,

    [string]$ComputerName = $env:COMPUTERNAME,

    [Parameter(Mandatory = $true)] # Specify the account to run the script
    [string]$User, 

    [Parameter(Mandatory = $true)]
    [string]$Password,

    [Parameter(Mandatory = $true)] #Specify Program to Run
    [string]$TaskAction,

    [Parameter(Mandatory = $true)] #Specify Program Arguments
    [string]$TaskActionArguement,

    [Parameter(Mandatory = $true)] #Sepcify Time to Run Task Example: 10:00
    [string]$TriggerTime,

    [Parameter(Mandatory = $true)] #Specify AM or PM
    [ValidateSet("AM", "PM")]
    [string]$TriggerTimeAMPM

) #end param
$TriggerSetTime = "$($TriggerTime)$($TriggerTimeAMPM)"

$Trigger = New-ScheduledTaskTrigger -At $TriggerSetTime –Daily # Specify the trigger settings
$Action = New-ScheduledTaskAction -Execute "$($TaskAction)" -Argument "$($TaskActionArguement)" # Specify what program to run and with its parameters
Register-ScheduledTask -TaskName "$($TaskName)" -Description "$($TaskName)" -Trigger $Trigger -User $User -Action $Action -RunLevel Highest -Password $Password -Force Register-ScheduledTask -TaskName "$($TaskName)" -Description "$($TaskName)" -Trigger $Trigger -User $User -Action $Action -RunLevel Highest -Password $Password -Force 


