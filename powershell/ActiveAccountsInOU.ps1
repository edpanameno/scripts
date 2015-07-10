# File: ActiveAccountsInOU.ps1
# Date Created: 4/03/14
# Description:
# This script is used to get the list of active users in a
# specified ou.  The script filters outs accounts that were
# created 'x' number of months ago and also only looks for
# active accounts

$contractorsOU = "OU=Contractors,OU=Accounts,DC=test,DC=local"
$registryOU = "OU=Registry Nurses,OU=Accounts,DC=test,DC=local"

# This is six months from when I created this script. Note that I had
# to cast the date to a DateTime object or else this script would not
# run.
$sixMonthsAgo = [DateTime]"12/3/2014 12:00:00 AM"

# The info property is what you find in the notes tab of the account
# in active directory users and computer. The result of this command
# is outputted to a csv file.
Get-ADUser -SearchBase $contractorsOU -Filter 'whenCreated -gt $sixMonthsAgo -and enabled -eq $true' -Properties samAccountName,GivenName,Surname,Title,Department,company,enabled,whenCreated,description,info,accountExpires | 
           select samAccountName,GivenName,Surname,Title,company,Department,enabled,whenCreated,description,info, @{Name="Expiration Date";Expression={[DateTime]::FromFileTime($_."accountExpires")}} | 
           Export-Csv c:\users\panameno\desktop\registry.csv -NoTypeInformation
