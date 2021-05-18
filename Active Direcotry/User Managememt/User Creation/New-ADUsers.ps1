##################################################################################################################################################################
##
##  New-ADUsers Script
## 
##  This is a powershell script written to create users from a CSV file.
##  You have the options to create a CSV file for groups to add for all users
##  or you can specify a user by username who you want to copy.
##
##  This script will setup a user with a email address, mailnickname, and have them ready
##  to use Office 365
## 
##  Note: This script will create users based on a csv with the following headers
##  Headers
##  =======
##  * firstname
##  * lastname
##  * description
##  * office
##  * destinationou 
##  * manager
##  * emaildomain
##  * usersuffix    #Usually the same as the email domain at most places (domain name)
##  * password
##  * mobile         #Optional
##  * officenumber   #Optional
##  * company        #Optional
##  * jobtitle       #Optional
##  * deprartment    #Optional
##  * employeeid     #Optional
##
##  Please ensure the csv file is formatted as such
##  
##  Example userlist.csv
##  ======================================================
##  firstname,lastname,description,destinationou,emaildomain,usersuffix,password
##  userfirstname,userlastname,userdescrtiion,"OU=Users,dc=domain,dc=local",emaildomain.com,domain.local,plaintextpassword
##
##
##
##  Example grouplist.csv
##  ======================================================
##  groupname
##  group1
##  group2
##  group3
##
##################################################################################################################################################################

param (
    [Parameter(Mandatory = $true, Position = 0, HelpMessage = "Please Specify the CSV to use for the User Creation")]
    [string]$UserListCSV,
    [Parameter(Mandatory = $true, Position = 1, HelpMessage = "Please Specify the domain name or domain controller you wish to use")]
    [string]$DomainController,
    [Parameter(Mandatory = $true, Position = 2, HelpMessage = "Please Specifiy the type of username you wish to create0")]
    [ValidateSet("First-Inital-LastName", "FirstName.LastName")]
    [string]$UserNameType,
    [string]$LogPath,
    [Parameter(Mandatory = $false)]
    [switch]$Help,
    [Parameter(Mandatory = $false, HelpMessage = "Please Specify the user account to copy Group Memeberships from", ParameterSetName = "CopyUser")]
    [string]$CopyUser,
    [Parameter(Mandatory = $false, HelpMessage = "Please Specify the CSV to use to add Groups to the User(S)", ParameterSetName = "GroupListCSV")]
    [string]$GroupListCSV

)
begin {  
    ########Imports CSV if fields are populated
    if (!($Help)) {
  
        #Gets the current date and formats it to Year Month Day Hour Minute format as a time stamp
        $time = (get-date).ToString("yyyyMMddhhmm")

        [string]$scriptname = $myInvocation.MyCommand
        [string]$scriptname

        #If the "-logpath" variblae isn't set, this sets the default path to C:\scripts\logs\scriptname-datetime.log0
        Write-Host "Default Log file is C:\scripts\log\$(($scriptname).Substring(0,(($scriptname).length-4)))-$($time).log"
        $LogPath = "C:\scripts\log\"

        #OutputPath
        $OutputPath = "$($LogPath)$(($scriptname).Substring(0,(($scriptname).length-4)))-OutPut-$($time).txt"
        
        $LogPath = "$($LogPath)$(($scriptname).Substring(0, (($scriptname).length - 4))) - $($time).log"
        
        #Checks if path exist if not creates the directory
        if (!(Test-Path $LogPath)) { New-Item $LogPath -ItemType Directory }

        #Logs all output to log path
        Start-Transcript $LogPath
        write-host "


        "
        write-host ([Environment]::UserDomainName + "\" + [Environment]::UserName) " Executed the script at $(get-date)`n`n"

        
        if ( Test-Path -Path $UserListCSV ) {
            Write-Verbose "Read content from file: $($UserListCSV)"
            $UserList = import-csv $UserListCSV
        }
        else {
            Write-Warning "This file path does NOT exist: $($UserListCSV)"
            Write-Warning "Please Specifiy the correct filename and try again"
            break;
        }      
        if ($GroupListCSV -ne $null) {
            if ( Test-Path -Path $GroupListCSV ) {
                Write-Verbose "Read content from file: $($GroupListCSV)"
                $GroupList = import-csv $GroupListCSV
            }
            else {
                Write-Warning "This file path does NOT exist: $($GroupListCSV)"
                Write-Warning "Please Specifiy the correct filename and try again"
                break;
            }  
        }
    }

}
Process {
    #If the "-help" Switch is Set Show help and will not run the script
    if ($Help) {
        Write-Host -ForegroundColor Yellow  `
            '         The New-ADUsers Fucntion will allow you to create Users in Active Directory from a CSV and logs the output
    
             The Below will just will create a user from CSV, copy all AD Group Memberships from the target user and it will create the sAMAccountName (username) First Initial Lastname
             example John Smith , the username will be jsmith
             Exmaples: ./New-ADUsers.ps1 -UserListCSV "C:\pathto\userlist.csv" -CopyUser username -DomainController domaincontrollername -UserNameType First-Inital-LastName
    
             The Below will just will create a user from CSV, copy all AD Group Memberships from the target user and it will create the sAMAccountName (username) First Name. Last Name
             example John Smith , the username will be john.smith
             Exmaples: ./New-ADUsers.ps1 -UserListCSV "C:\pathto\userlist.csv" -CopyUser username -DomainController domaincontrollername -UserNameType FirstName.LastName
    
             The Below will just will create a user from CSV, add all AD Group Memberships from the CSV Files user and it will create the sAMAccountName (username) First Name. Last Name
             example John Smith , the username will be john.smith
             Exmaples: ./New-ADUsers.ps1 -UserListCSV "C:\pathto\userlist.csv" -GroupListCSV C:\pathto\grouplist.csv -DomainController domaincontrollername -UserNameType FirstName.LastName
    
             If you want speficiy a custom log path use the "-LogPath" switch 
             Exmaples: ./New-ADUsers.ps1 -UserListCSV "C:\pathto\userlist.csv" -GroupListCSV C:\pathto\grouplist.csv -DomainController domaincontrollername -UserNameType FirstName.LastName -LogPath C:\logpath'
    
    }
    else {
            
    
        
        ###Define Varibales
        #Email Domain and suffix for UPN

        #Generates Empty Array for output
        $outputlist = @()
        

        
        ###Gets AD Groupps of user to copy
        $ADGroups = ((get-aduser $CopyUser -Properties *).Memberof | get-adgroup)

        foreach ($user in $UserList) {
            
            #Creates a list item to add to the $outputlist array
            $info = "" | select FirstName, LastName, UserName, Email, Office365Login, TempPassword, Manager, Mobile, OfficeNumber, Company, Jobtitle, Department, EmployeeId
            
            #Users Given Name (First Name)
            $UserFirstName = "$(($user.firstname.Substring(0,1)).toupper())$(($user.firstname.Substring(1)))"

            #Users Sur Name (Last Name)
            $UserLastName = "$(($user.lastname.Substring(0,1)).toupper())$(($user.lastname.Substring(1)))"

            #Display Name for the user
            $UserDisplayName = "$($UserFirstName) $($UserLastName)"

            #SamAccountName Generates First Initial and LastName User Name
            If ($UserNameType -eq "First-Inital-LastName") {
                $SamAccountName = "$(($user.firstname.Substring(0,1)).tolower())$($user.lastname.tolower())"
            }

            #SamAccountName Generates FirstName.LastName UserNAme
            If ($UserNameType -eq "FirstName.LastName") {
                $SamAccountName = "$($user.firstname.tolower()).$($user.lastname.tolower())"
            }
            #User Principal Name 
            if ($user.usersuffix.length -lt 1) {
                $upn = "$($SamAccountName)@$($user.emaildomain)"
            }
            else {
                $upn = "$($SamAccountName)@$($user.usersuffix)"
            }
            #O365 Email Address
            if ($user.usersuffix.length -lt 1) {
                $primaryemail = "SMTP:$($SamAccountName)@$($user.emaildomain)"
            }
            
            #O365 Email Address
            else {
                $primaryemail = "SMTP:$($upn)"
            }

            #Sets Password and Converts to Secure String
            $plaintext = $user.password
            $user
            $Password = (ConvertTo-SecureString $plaintext -AsPlainText -Force)
            
            #Checks if Manager Value Exist
            if ($user.manager.length -lt 2) { $Manager = $null }
            else { $Manager = $user.manager }

            #Checks if mobile number field was set
            if ($user.mobile.length -lt 2) { $Mobile = $null }
            else { $Mobile = $user.mobile }
            
            #Checks if Office Number field was set
            if ($user.officenumber.length -lt 2) { $OfficeNumber = $null }
            else { $OfficeNumber = $user.officenumber }

            #Checks if Office field was set
            if ($user.office.length -lt 2) { $Office = $null }
            else { $Office = $user.office }

            #Checks if Company field was set
            if ($user.company.length -lt 2) { $Company = $null }
            else { $Company = $user.company }            

            #Checks if jobtitle field was set
            if ($user.jobtitle.length -lt 2) { $JobTitle = $null }
            else { $JobTitle = $user.jobtitle }            


            #Checks if deprartment field was set
            if ($user.deprartment.length -lt 2) { $Deprartment = $null }
            else { $Deprartment = $user.deprartment }            
            

            #Checks if employeeid field was set
            if ($user.employeeid.length -lt 2) { $EmployeeId = $null }
            else { $EmployeeId = $user.employeeid }            

            #What Organization Unit you want the user to be in
            $DestinationOU = $user.destinationou
            
            #Creates Mail Nickname
            $MailNickName = "$($user.firstname.tolower())$($user.lastname.tolower())"

            #Sets users Description
            $Description = $user.description

            #IF $Manager is not $null do this 
            if ($Manager -ne $null) {
                #Command to create new users
                New-ADUser -Name $UserDisplayName -SamAccountName $SamAccountName -AccountPassword $Password -DisplayName $UserDisplayName -Enabled $True -GivenName $UserFirstName -Path $DestinationOU -Server $DomainController -Surname $UserLastName -UserPrincipalName $upn -Company $Company -EmailAddress $upn -Manager $Manager -Title $JobTitle -Department $Deprartment -MobilePhone $Mobile -OfficePhone $OfficeNumber -Office $Office -OtherAttributes  @{'proxyAddresses' = $primaryemail; 'mailnickname' = $MailNickName; 'employeeID' = $EmployeeId } -Description $Description -ChangePasswordAtLogon $true
            }
            #Creates User with out Assignning Manager
            else {
                New-ADUser -Name $UserDisplayName -SamAccountName $SamAccountName -AccountPassword $Password -DisplayName $UserDisplayName -Enabled $True -GivenName $UserFirstName -Path $DestinationOU -Server $DomainController -Surname $UserLastName -UserPrincipalName $upn -Company $Company -EmailAddress $upn -Title $JobTitle -Department $Deprartment -MobilePhone $Mobile -OfficePhone $OfficeNumber -Office $Office -OtherAttributes  @{'proxyAddresses' = $primaryemail; 'mailnickname' = $MailNickName; 'employeeID' = $EmployeeId } -Description $Description -ChangePasswordAtLogon $true
            }
            ###Adding user info to the list item
            $info.FirstName = $UserFirstName
            $info.LastName = $UserLastName
            $info.UserName = $SamAccountName
            $info.Email = $primaryemail
            $info.Office365Login = $primaryemail 
            $info.OfficeNumber = $OfficeNumber
            $info.Manager = $Manager 
            $info.Mobile = $Mobile
            $info.Company = $Company 
            $info.JobTitle = $JobTitle
            $info.Department = $Department
            $info.EmployeeId = $EmployeeId            
            $info.TempPassword = $user.password

            ##Adds teh list item to the $output array
            $outputlist += $info
            
            #Add user to groups
            if ($GroupListCSV -eq $null) {
                #Users -CopyUser to MIrror AD Groups from
                $ADGroups = (((get-aduser $samAccountName -Properties Memberof).Memberof) | get-adgroup).Name
                foreach ($group in $ADGroups) {
                    write-host "Adding $($SamAccountName) to $($group.name)"
                    Add-ADGroupMember $group -Members $SamAccountName
                }
            }
            else {
                #Pulls Groups from CSV File
                $ADGroups = $GroupList
                foreach ($group in $ADGroups) {
                    write-host "Adding $($SamAccountName) to $($group.name)"
                    Add-ADGroupMember $group -Members $SamAccountName
                }
            }
        }

    }
    Write-Host "Generating Output File "
    $outputlist | Export-Csv "$($OutputPath)" -NoTypeInformation -Force
        
}

end {
    if (!($Help)) { Stop-Transcript }
}