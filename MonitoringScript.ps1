#======================================================================
#Script Name: MonitoringScript.ps1
#Script Author: Phung, John
#Script Purpose: 
#Script Creation Date:	08/03/2018
#Script Last Modified Date:	08/03/2018
#Script Notes: 
#======================================================================

#CSV variables
$script:CSVpath = "\\ServerName\MonitorList.csv"
$script:CSVheader_IP = "IPAddress"
$script:CSVheader_HostName = "HostName"
$script:CSVheader_Campus = "Campus"
$script:CSVheader_Type = "Type"
$script:HostList

#Email Addresses
$script:Email_From = ""
$script:Email_To = ""

#SMTP Server Details
$script:SMTPServer = "smtpservername"
$script:SMTPPort = "25"


function testConnection
{
    $script:Time = Get-Date
    if (Test-Connection $Script:Target.("IPAddress") -Quiet -Count 2)
        {targetOnline}
    else
        {targetOffline}
}

function targetOnline
{
    #Send-MailMessage -To $script:Email_To -From $script:Email_From -Subject "$Script:HostName is ONLINE - $script:Time" -SmtpServer $script:SMTPServer -Port $script:SMTPPort
}

function targetOffline
{
    Send-MailMessage -To $script:Email_To -From $script:Email_From -Subject "$Script:HostName is OFFLINE - $script:Time" -SmtpServer $script:SMTPServer -Port $script:SMTPPort
}

$script:HostList = Import-Csv $script:CSVpath

foreach($Script:Target in $script:HostList)
{
$Script:HostName = $Script:Target.("$script:CSVheader_HostName")
testConnection
}
