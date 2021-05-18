[CmdletBinding(DefaultParameterSetName='DefaultConfiguration')]
param (
    [Parameter( Mandatory=$true,HelpMessage="Please Specify the AD Group to Search")]
    [string]$ADGroupName,  
    [Parameter(Mandatory=$false)][switch]$ExportCSV,
    [Parameter(Mandatory=$false)][switch]$help
)
DynamicParam
{
    $paramDictionary = New-Object -Type System.Management.Automation.RuntimeDefinedParameterDictionary
    $attributes = New-Object System.Management.Automation.ParameterAttribute
    $attributes.ParameterSetName = "__AllParameterSets"
    $attributes.Mandatory = $true
    $attributeCollection = New-Object -Type System.Collections.ObjectModel.Collection[System.Attribute]
    $attributeCollection.Add($attributes)
    #If "-ExportCSV" is used, then add the "ExportPath" parameter
    if ($ExportCSV)
    {
        $dynParam1 = New-Object -Type System.Management.Automation.RuntimeDefinedParameter("ExportPath", [String], $attributeCollection)   
        $paramDictionary.Add("ExportPath", $dynParam1)
     
    }
     return $paramDictionary
}
begin{}
Process{
    foreach($key in $PSBoundParameters.keys)
    {
        Set-Variable -Name $key -Value $PSBoundParameters."$key" -Scope 0
    }
    #If the "-help" Switch is Set Show help and do not run scripts
    if($help)
    {
        Write-Host -ForegroundColor Yellow -BackgroundColor Black `
        "The Query_AD_Groups Fucntion will allow you to Query AD Groups and display the results
         
         The Below will just output the results for the AD Group 
         Exmaples: ./Query_AD_Groups.ps1 -ADGroupName GroupName
         
         However to export to CSV you would perform the following
         Example: ./Query_AD_Groups.ps1 -ADGroupName GroupName -ExportCSV -ExportPath C:\somepathere"
        
    }
    else
    {
        #Creates Empty Array
        $array=@()

        ##Gets Current Date
        $date=(get-date).ToString('yyyy-MM-dd')

        ###Get AD Users based on ADGroupName Parameter
        try
        {
            $results = Get-ADGroupMember $ADGroupName | Get-AdUser | select Name,SamAccountName,Enabled
        }
        #If the Group isn't found it will output a friendly error message and exist the script
        catch
        {
            Write-Host "The specified group is invalid or doesn't exist please try again"
            Write-Host "Current Group $($ADGroupName)"
            break
        }
        #The will loop through each resuts creating a new list and adding it the array
            foreach ($user in $results) 
            {
            #Creating a Custom Variable with multiple Fields
            #Each result will populate the field
            $list = "" | Select Name,Username,EnabledUser,Group
            $list.Name = $user.Name
            $list.Username = $user.SamAccountName
            $list.EnabledUser = $user.Enabled
            $list.Group = $ADGroupName

            #Adding the Item to the Array
            $array+=$list
            }

        if ($ExportCSV -eq $false) 
        {
            #Dislays the members of the group
            $array
        }

        #If the "-ExportCSV" Switch is set 
        if ($ExportCSV -eq $true)
        {
            #Creating the File Name Based on the AD Group Name with the Current Date
            $FileName="$($ADGroupName)-$($date).csv"

            #Checks ExportPath for \ at the end and removes it if its there
            if (($ExportPath.substring($ExportPath.length-1,1)) -eq "\") {$ExportPath.substring(0,$ExportPath.length-1)}

            #Merging the File name with the Export Path
            $ExportFile="$($ExportPath)\$($FileName)"
            #Checks if $ExportPath Exist
            if(!(Test-Path $ExportPath)) 
            {
                #If The directory Doesn't Exists Create it and Write to host that it was created
                write-host "Directory $($ExportPath) Doesn't Exist Creating it" -ForegroundColor Yellow
                New-Item $ExportPath -ItemType Directory 
            }
            $array | Export-Csv $ExportFile -NoTypeInformation
        
            #Writing output with status 
            #The`n Characters Add a newling (Carriage Retrun)
            Write-Host -ForegroundColor Green "1n`nReport Has been exported to $($ExportFile)"
        }
    }
}
end {}

