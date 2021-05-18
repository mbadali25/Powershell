#############################################################################
##  Setups HTTPS WinRM Listener Based on 
##  Certificate Template OID
##
##  Note: We generated one here using a Internal CA but it can be self signed
##
##  Automation, Systems Management, Security
##
#############################################################################

### Variables
#Setting the OID of the certificate template I want to use that is installed on the local computer
$certificatetemplate = "1.3.6.1.4.1.311.21.8.4812330.14072069.6832779.4465403.15319181.206.5472071.152606"
New-Item -Path WSMan:\Localhost\Listener -Transport HTTPS -Address * -CertificateThumbprint ((cmd /c "certutil -store MY $($certificatetemplate) | findstr Hash(sha1):").Replace("Cert Hash(sha1):", "")).replace(" ", "") -Force
