#======================================================================
#Script Name: MonitoringScript.ps1
#Script Author: Phung, John
#Script Purpose: 
#Script Creation Date:	08/03/2018
#Script Last Modified Date:	08/06/2018
#Script Notes: 
#======================================================================

#CSV variables
$script:CSVpath = "\\ServerName\MonitorList.csv"
$script:CSVheader_IP = "IPAddress"
$script:CSVheader_HostName = "HostName"
$script:CSVheader_Campus = "Campus"
$script:CSVheader_Type = "Type"

#Email Addresses
$script:Email_From = ""
$script:Email_To = ""

#SMTP Server Details
$script:SMTPServer = "smtpservername"
$script:SMTPPort = "25"

function testConnection
{
    if (Test-Connection $Script:Target.("$script:CSVheader_IP") -Quiet -Count 2)
        {targetOnline}
    else
        {targetOffline}
}

function targetOnline
{
    Send-MailMessage -To $script:Email_To -From $script:Email_From -Subject "ONLINE - $script:Email_Subject" -Body $script:Email_Body -SmtpServer $script:SMTPServer -Port $script:SMTPPort
}

function targetOffline
{
    Send-MailMessage -To $script:Email_To -From $script:Email_From -Subject "OFFLINE - $script:Email_Subject" -Body $script:Email_Body -SmtpServer $script:SMTPServer -Port $script:SMTPPort -Priority High
}

$script:HostList = Import-Csv $script:CSVpath

foreach( $Script:Target in $script:HostList)
{
$script:Time = (Get-Date -Format F).ToString()
$script:HostName = $Script:Target.("$script:CSVheader_HostName")
$script:IP = $Script:Target.("$script:CSVheader_IP")
$script:Campus = $Script:Target.("$script:CSVheader_Campus")
$script:Type = $Script:Target.("$script:CSVheader_Type")
$script:Email_Subject = "$script:Campus - $script:HostName - $Script:Time"
$script:Email_Body = "$Script:Time - $script:HostName - $script:IP - $script:Campus - $script:Type"
testConnection   
}
