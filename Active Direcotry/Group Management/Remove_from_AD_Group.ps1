[CmdletBinding(DefaultParameterSetName='DefaultConfiguration')]
param (
    [Parameter( ValueFromPipeline=$true,
                ValueFromPipeLinebyPropertyName=$true,
                ParameterSetName="DefaultConfiguration",
                HelpMessage="List of User Name seperated by commas.")]
        [Alias("Users")]
        [string[]]$UserList,
        [Alias("Group")]
        [string]$ADGroupName,  
        [string]$logpath,
    [Parameter(Mandatory=$false)][switch]$help,
    
    [Parameter( ParameterSetName="UserCSV",
    HelpMessage="Name of the CSV Files with Users to remove.")] 
    [string]$UserCSV
    
)

begin{  
       if(!($help))
       {
        
        #Gets the current date and formats it to Year Month Day Hour Minute format as a time stamp
        $time=(get-date).ToString("yyyyMMddhhmm")

        [string]$scriptname=$myInvocation.MyCommand
        [string]$scriptname
        #If the "-logpath" variblae isn't set, this sets the default path to C:\scripts\logs\scriptname-datetime.log
        if (!($logpath))
        {
            Write-Host "Default Log file is C:\scripts\log\$( ($scriptname).Substring(0,(($scriptname).length-4)))-$($time).log"
            $logpath= "C:\scripts\log\$( ($scriptname).Substring(0,(($scriptname).length-4)))-$($time).log"
        }
        
        #Checks if path exist if not creates the directory
        if (!(Test-Path $logpath)) {New-Item $logpath -ItemType Directory}

        #Logs all output to log path
        Start-Transcript $logpath
        write-host "


        "

        write-host ([Environment]::UserDomainName + "\" + [Environment]::UserName) " Executed the script at $(get-date)`n`n"

        if ( $PsCmdlet.ParameterSetName -eq "UserCSV") {
        if ( Test-Path -Path "$UserCSV" ) {
            Write-Verbose "Read content from file: $($UserCSV)"
            $UserList = import-csv $UserCSV
        } else {
            Write-Warning "This file path does NOT exist: $($UserCSV)"
            Write-Warning "Please Specifiy the correct filename and try again"
            break;
                 }      
        }
       }
      }
Process{    

    #If the "-help" Switch is Set Show help and will not run the script
    if($help)
    {
        Write-Host -ForegroundColor Yellow  `
        '         The Remove_from_AD_Group Fucntion will allow you to remove Users to the AD Group and logs the output

         The Below will just remove a user to the specified AD Group.
         Exmaples: ./Remove_from_AD_Group.ps1 -UserList "username" -ADGroupName GroupName

         If you need to remove multiple users to the specified AD Group.
         Exmaples: ./Remove_from_AD_Group.ps1 -UserList "username1","username2" -ADGroupName "GroupName"
         
         If you need to add CSV User List to remove bulk users to the specified AD Group.
         Note: The csv first line "Header" must be username
         Exmaples: ./Remove_from_AD_Group.ps1 -UserCSV "C:\filepath\usercsv.csv" -ADGroupName "GroupName"

         If you want speficiy a custom log path use the "-logpath" switch 
         Exmaples: ./Remove_from_AD_Group.ps1 -UserList "username1","username2" -ADGroupName "GroupName" -logpath C:\somedirectory'

    }
    
    else
    {


        #Validate if Group  Exist
        Write-Host  "Checking if AD Group Exist"
        try
        {
            Get-ADGroup $ADGroupName | Out-Null
        }
        #Writes Friendly Error Message and exits script
        catch
        {
            Write-Host  "The specified group is invalid or doesn't exist please try again"
            Write-Host "Current Group $($ADGroupName)"
            break
        }

        #### Loops through each user in the UserList Array
        foreach($user in $UserList)
        {
          if ( $PsCmdlet.ParameterSetName -eq "UserCSV")
          {
              try
              { 
                #Checking if the user is already a part of that group
                    try
                    {
                        #Looking up Userinfo to check group membership
                        $userinfo=get-aduser $user.username
                    }
                    catch
                    {
                        Write-Host "The Username is invalid. Unable to lookup $($user.username)"
                        Write-Host "The Current UserName $($user.username)"      
                    }
                
                #Checking if the usser is aleady a member of the group if not remove them
                if ((Get-ADGroupMember -Identity $ADGroupName | where {$_.distinguishedname -eq $userinfo.distinguishedname}).count -eq 1) 
                {
                    Write-Host "The User is already a member of $($ADGroupName) skipping $($user.username)" -ForegroundColor Yellow
                }
                else { Remove-ADGroupMember -Identity $ADGroupNAme -Members $user.username -Verbose -Confirm:$false }
              }
              #If the Username is invalid it will output the invlaid username and continue
              catch
              {
                Write-Host "The Username is invalid. Unable to remove $($user.username) to the Group $($ADGroupNAme)"
                Write-Host "The Current UserName $($user.username)"           
              }
           }
        
            else
            {
              try
              {  
                try
                    {
                        #Looking up Userinfo to check group membership
                        $userinfo=get-aduser $user
                    }
                catch
                    {
                        Write-Host "The Username is invalid. Unable to lookup $($user)"
                        Write-Host "The Current UserName $($user)"      
                    }
                
                #Checking if the usser is aleady a member of the group if not remove them
                if ((Get-ADGroupMember -Identity $ADGroupName | where {$_.distinguishedname -eq $userinfo.distinguishedname}).count -eq 1) 
                {
                    Write-Host "The User is already a member of $($ADGroupName) skipping $($user)" -ForegroundColor Yellow
                }
                else { Remove-ADGroupMember -Identity $ADGroupNAme -Members $user -Verbose -Confirm:$false}
              }
              #If the Username is invalid it will output the invlaid username and continue
              catch
              {
                Write-Host "The Username is invalid. Unable to remove $($user) to the Group $($ADGroupNAme)"
                Write-Host "The Current UserName $($user)"           
              }
            }
        }
    }
}
end {
    if(!($help)) { Stop-Transcript }
    }

