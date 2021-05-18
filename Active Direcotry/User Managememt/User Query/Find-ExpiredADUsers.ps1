#############################################################################
##  Find all Expired User Accounts
##
##  Written by Matthew Badali
##
##  This script will go out there and find all expired user accounts.
##
##  This is great when working with end users to see what Acitve Directory 
##  Accounts are expired and unusabled.
##
##  Automation, Systems Management, Security
##
#############################################################################
[CmdletBinding(DefaultParameterSetName = 'DefaultConfiguration')]
Param( 
    [switch]$Email,
    [switch]$EmailAuth,
    [switch]$UseSSL

)
DynamicParam {
    $paramDictionary = New-Object -Type System.Management.Automation.RuntimeDefinedParameterDictionary
    $attributes = New-Object System.Management.Automation.ParameterAttribute
    $attributes.ParameterSetName = "__AllParameterSets"
    $attributes.Mandatory = $true
    $attributeCollection = New-Object -Type System.Collections.ObjectModel.Collection[System.Attribute]
    $attributeCollection.Add($attributes)
    #If "-Email" is used, then add the "SMTPServer," "SMTPPort", "FromEMail", "ToEMail" parameters
    if ($Email) {
        $dynParam1 = New-Object -Type System.Management.Automation.RuntimeDefinedParameter("SMTPServer", [String], $attributeCollection)   
        $paramDictionary.Add("SMTPServer", $dynParam1)
        $dynParam2 = New-Object -Type System.Management.Automation.RuntimeDefinedParameter("SMTPPort", [String], $attributeCollection)   
        $paramDictionary.Add("SMTPPort", $dynParam2)
        $dynParam3 = New-Object -Type System.Management.Automation.RuntimeDefinedParameter("FromEmail", [String], $attributeCollection)   
        $paramDictionary.Add("FromEmail", $dynParam3)
        $dynParam4 = New-Object -Type System.Management.Automation.RuntimeDefinedParameter("ToEmail", [String], $attributeCollection)   
        $paramDictionary.Add("ToEmail", $dynParam4)
        
    }
    #If "-EmailAuth" is used, then add the "SMTPServer," "SMTPPort", "FromEMail", "ToEMail" parameters
    if ($EmailAuth) {
        $dynParam5 = New-Object -Type System.Management.Automation.RuntimeDefinedParameter("EmailUser", [String], $attributeCollection)   
        $paramDictionary.Add("EmailUser", $dynParam5)
        $dynParam6 = New-Object -Type System.Management.Automation.RuntimeDefinedParameter("EmailPassword", [String], $attributeCollection)   
        $paramDictionary.Add("EmailPassword", $dynParam6)
     
    }
    return $paramDictionary
}
begin {


}
process {

    #Process Dynamic Paramters
    foreach ($key in $PSBoundParameters.keys) {
        Set-Variable -Name $key -Value $PSBoundParameters."$key" -Scope 0
    }

    #Formats the date as Year-Month-Day-HourMinute
    $date = (get-date).ToString('yyyy-MM-dd-hhmm')

    #Searches Active Directory for all expired users accounts that aren't disabled
    $Results = Search-ADAccount -Server $env:USERDNSDOMAIN -AccountExpired -UsersOnly  -ResultPageSize 200 -resultSetSize $null | Where-Object { $_.enabled -eq $true }

    $subject = "Expired User Accounts Report: $(date)"
    if ($Results.length -eq 0) { $body = "There are no Expired Active Directory Users as of $($date)"; Write-Host "There are no Expired Active Directory Users as of $($date)" }
    if ($Results.length -gt 1) { 
        #Output Results
        Write-Host "There are $($Results.length) Expired Active Directory Users as of $($date)`n`n"
        $Results | ft

        $body = "There are $($Results.length) Expired Active Directory Users as of $($date)"

        #Export the results to a file
        $Path = "C:\scripts\REPORTS\"

        #Test Path and Created Directory if it doesn't Exists
        if (!(Test-Path $Path)) { New-Item $Path -ItemType Directory }

        $file = "$($Path)ExpiredUsers-$($date).csv"

        #Outputs the results
        $Results | Export-Csv $file -NoTypeInformation
    }

    #Sends Email if -EMail Flag is set
    if ($Email) {
        #If the -UseSSL Flag is Enabled
    
        if ($UseSSL) {   
            #If the -Email Auth Flag is Enabled
            if ($EmailAuth) {
                $secpasswd = ConvertTo-SecureString $EmailPassword -AsPlainText -Force
                $cred = New-Object System.Management.Automation.PSCredential ($EmailUser, $secpasswd)

                #If there are Results
                if ($Results.length -gt 1) {
                    Send-MailMessage -From $FromEmail -To $ToEmail -Subject $subject -Body $body -SmtpServer $SMTPServer -Port $SMTPPort -Attachments $file -UseSsl -Credential $cred
                }
                else {
                    Send-MailMessage -From $FromEmail -To $ToEmail -Subject $subject -Body $body -SmtpServer $SMTPServer -Port $SMTPPort -UseSsl -Credential $cred
                }
            }
            #If the -Email Auth Flag isn't Enabled
            else {
                #If there are Results
                if ($Results.length -gt 1) {
                    Send-MailMessage -From $FromEmail -To $ToEmail -Subject $subject -Body $body -SmtpServer $SMTPServer -Port $SMTPPort -Attachments $file -UseSsl
                }
                else {
                    Send-MailMessage -From $FromEmail -To $ToEmail -Subject $subject -Body $body -SmtpServer $SMTPServer -Port $SMTPPort -UseSsl
                }
            }
        }

        #If the -UseSSL Flag isn't Enabled
        else {
            #If the -Email Auth Flag is Enabled
            if ($EmailAuth) {
                $secpasswd = ConvertTo-SecureString $EmailPassword -AsPlainText -Force
                $cred = New-Object System.Management.Automation.PSCredential ($EmailUser, $secpasswd)
                #If there are Results
                if ($Results.length -gt 1) {
                    Send-MailMessage -From $FromEmail -To $ToEmail -Subject $subject -Body $body -SmtpServer $SMTPServer -Port $SMTPPort -Attachments $file -Credential $cred
                }
                else {
                    Send-MailMessage -From $FromEmail -To $ToEmail -Subject $subject -Body $body -SmtpServer $SMTPServer -Port $SMTPPort -Credential $cred
                }
            }
        
            #If the -Email Auth Flag isn't Enabled
            else {
                #If there are Results
                if ($Results.length -gt 1) {
                    Send-MailMessage -From $FromEmail -To $ToEmail -Subject $subject -Body $body -SmtpServer $SMTPServer -Port $SMTPPort -Attachments $file 
                }
                else {
                    Send-MailMessage -From $FromEmail -To $ToEmail -Subject $subject -Body $body -SmtpServer $SMTPServer -Port $SMTPPort
                }

            }
        }

    }
}
end {}
