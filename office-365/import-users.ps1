## Script used to import users into Active Directory.
## These users are being imported into the CloudUsers OU
## as specified below in the '$ou' variable.

$users = Import-Csv -Delimiter "," -Path .\random-users.csv
$ou = "OU=CloudUsers,OU=Accounts,DC=test,DC=local"
$userCount = 1

foreach($user in $users) 
{
	$sam = $user.samAccountName 
	$firstName = $user.firstname 
	$lastName = $user.lastname 
	$displayName = $user.displayname 
	$title = $user.title 
	$phone = $user.phone 
	$department = $user.department 
	$company = $user.company 
	$email = $user.email 
	$upn = $sam + "@test.local" 
	$password = $user.password 

	New-ADUser -Name "$displayName" -DisplayName "$displayName" -SamAccountName $sam -UserPrincipalName $upn -GivenName "$firstName" -Surname "$lastName" -EmailAddress $email -Company $company -OfficePhone $phone -AccountPassword (ConvertTo-SecureString $password -AsPlainText -Force) -Path $ou -Enabled $true -Title $title -Department $department 
	Write-Host $userCount " User Created: " $firstName $lastName 
	$userCount++
}

