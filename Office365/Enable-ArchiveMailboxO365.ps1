#### Enable Archive Mailbox office 365 ####
##
##
##
##
##
##
###########################################


##Set up Variables
$user="aluna"
$msExchRemoteRecipientType="3"
#Gets user info from AD
$userinfo = get-aduser $user
$msExchArchiveName = "$($userinfo.Name) Online Archive"
$msExchArchiveQuota = "104857600"
$msExchArchiveRelease = "94371840"
$msExchArchiveStatus ="1"

#Setting Attributes for user
Set-ADObject -Identity $userinfo.ObjectGUID -Replace @{msExchArchiveName=$msExchArchiveName;msExchArchiveQuota=$msExchArchiveQuota;msExchArchiveRelease=$msExchArchiveRelease;msExchRemoteRecipientType=$msExchRemoteRecipientType;msExchArchiveStatus=$msExchArchiveStatus;}


