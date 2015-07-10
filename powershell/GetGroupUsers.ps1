# The following script will get the list of users from the
# specified group name in the domain. It will retrieve the user's
# user id, email, givenname, surname, title and department
# and export them to the results.csv file.

$group_name = "Test Group"

Get-ADGroupMember -Identity $group_name | Get-ADUser -Properties samAccountName,mail,GivenName,Surname,title,Department
| select samAccountName,GivenName,Surname,mail,title,Department | Export-Csv C:\results\results.csv 
-NoTypeInformation
