$group_name = "Test Group"

Get-ADGroupMember -Identity $group_name | Get-ADUser -Properties samAccountName,givenname,surname,title,
department,mail,lastlogon,created | select samAccountName,givenname,surname,title,department,mail,
@{l="lastLogon";e={[DateTime]::FromFileTime($_.lastLogon)}},created | 
Export-Csv C:\Users\panameno\Desktop\kmc-residents.csv -NoTypeInformation
