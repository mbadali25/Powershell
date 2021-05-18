# Active Directory User Queries

These scripts will allow you to search active directory for various users in different statuses.

## Scripts

### Find-ExpiredADUsers.ps1

Usage

>>__Sending Email Unauthenticated__

```powershell
.\Find-ExpiredADUsers.ps1 -Email -SMTPServer smtpserver -SMTPPort smtpport -FromEmail "fromemailaddress" -ToEmail "toemailaddres"
```

>>__Sending Email Unauthenticated with SSL__

```powershell
.\Find-ExpiredADUsers.ps1 -Email -SMTPServer smtpserver -SMTPPort smtpport -FromEmail "fromemailaddress" -ToEmail "toemailaddres" -UseSSL
```

>>__Sending Email Unauthenticated with Authentication__

```powershell
.\Find-ExpiredADUsers.ps1 -Email -SMTPServer smtpserver -SMTPPort smtpport -FromEmail "fromemailaddress" -ToEmail "toemailaddres" -UseSSL -EmailAuth -EmailUser emailusername -EmailPassword "emailpassword"
```

__Note:__ By Default this will drop the report if there is data at C:\scripts\REPORTS\ExpiredUsers-__currentdate__.csv

### Find-LockedOutUsers.ps1

Usage

>>__Sending Email Unauthenticated__

```powershell
.\Find-LockedOutUsers.ps1 -Email -SMTPServer smtpserver -SMTPPort smtpport -FromEmail "fromemailaddress" -ToEmail "toemailaddres"
```

>>__Sending Email Unauthenticated with SSL__

```powershell
.\Find-LockedOutUsers.ps1 -Email -SMTPServer smtpserver -SMTPPort smtpport -FromEmail "fromemailaddress" -ToEmail "toemailaddres" -UseSSL
```

>>__Sending Email Unauthenticated with Authentication__

```powershell
.\Find-LockedOutUsers.ps1 -Email -SMTPServer smtpserver -SMTPPort smtpport -FromEmail "fromemailaddress" -ToEmail "toemailaddres" -UseSSL -EmailAuth -EmailUser emailusername -EmailPassword "emailpassword"
```

__Note:__ By Default this will drop the report if there is data at C:\scripts\REPORTS\LockedOutUsers-__currentdate__.csv

### Find-ExpiredPasswordUsers.ps1

Usage

>>__Sending Email Unauthenticated__

```powershell
.\Find-ExpiredPasswordUsers.ps1 -Email -SMTPServer smtpserver -SMTPPort smtpport -FromEmail "fromemailaddress" -ToEmail "toemailaddres"
```

>>__Sending Email Unauthenticated with SSL__

```powershell
.\Find-ExpiredPasswordUsers.ps1 -Email -SMTPServer smtpserver -SMTPPort smtpport -FromEmail "fromemailaddress" -ToEmail "toemailaddres" -UseSSL
```

>>__Sending Email Unauthenticated with Authentication__

```powershell
.\Find-ExpiredPasswordUsers.ps1 -Email -SMTPServer smtpserver -SMTPPort smtpport -FromEmail "fromemailaddress" -ToEmail "toemailaddres" -UseSSL -EmailAuth -EmailUser emailusername -EmailPassword "emailpassword"
```

__Note:__ By Default this will drop the report if there is data at C:\scripts\REPORTS\ExpiredPasswordUsers-__currentdate__.csv
