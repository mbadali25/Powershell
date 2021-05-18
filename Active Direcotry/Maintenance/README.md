# Active Directory Mainentance

Scripts to help run and maintain Active Directory

## Disable-InactiveComputers.ps1

Usage

-DaysInactive default value is 270 (9 months)

```powershell
.\DisabledInactiveComputers.ps1 -DestinationOU "OU=DestinationOU,DC=domain,DC=local" -SeachBase "DC=domain,DC=local" -DaysInactive Days
```

Seeing possible results without execution

```powershell
.\DisabledInactiveComputers.ps1 -DestinationOU "OU=DestinationOU,DC=domain,DC=local" -SeachBase "DC=domain,DC=local" -DaysInactive Days -Whatif
```

__Note:__ By Default this will drop the report if the __-Whatif__ flag is set there is data at C:\scripts\REPORTS\Inactive-Computers-__currentdate__.csv

### Tagging

All Computers Disabled by this script have the following:

- Their description changed to [Disabled by Script] Inacitve Compujter Disabled on $currentdate.
- The __info__ attribute of the account tagged with
  - The username of the user who executed it
  - The computer it was run from
  - The script name
