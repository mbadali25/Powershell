# Active Directory User Management

## User Creation

Script Name: New-ADUSers.ps1

The New-ADUsers Fucntion will allow you to create Users in Active Directory from a CSV and logs the output

The Below will just will create a user from CSV, copy all AD Group Memberships from the target user and it will create the sAMAccountName (username) First Initial Lastname.

__Example:__ John Smith , the username will be jsmith

Usage:
  
```powershell
./New-ADUsers.ps1 -UserListCSV "C:\pathto\userlist.csv" -CopyUser username -DomainController domaincontrollername -UserNameType >>First-Inital-LastName
```

The Below will just will create a user from CSV, copy all AD Group Memberships from the target user and it will create the sAMAccountName (username) FirstName.LastName

__Example:__ John Smith , the username will be john.smith

Usage:

```powershell
./New-ADUsers.ps1 -UserListCSV "C:\pathto\userlist.csv" -CopyUser username -DomainController domaincontrollername -UserNameType FirstName.LastName
```

The Below will just will create a user from CSV, add all AD Group Memberships from the CSV Files user and it will create the sAMAccountName (username) FirstName.LastName

__Example:__ John Smith , the username will be john.smith

Usage:

```powershell
./New-ADUsers.ps1 -UserListCSV "C:\pathto\userlist.csv" -GroupListCSV C:\pathto\grouplist.csv -DomainController domaincontrollername -UserNameType FirstName.LastName
```

If you want speficiy a custom log path use the "-LogPath" switch.

Usage:

```powershell
./New-ADUsers.ps1 -UserListCSV "C:\pathto\userlist.csv" -GroupListCSV C:\pathto\grouplist.csv -DomainController domaincontrollername -UserNameType FirstName.LastName -LogPath C:\logpath'
```
