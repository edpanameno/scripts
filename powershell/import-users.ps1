## Script used to import users into Active Directory
## Note: The CSV file has the name of the OU that each
## user will be created in.

$users = Import-Csv -Delimiter "," -Path .\all-users.csv
$userCount = 1

foreach($user in $users) 
{
	$sam = $user.samAccountName 
	$firstName = $user.firstname 
	$lastName = $user.lastname 
	$displayName = $user.displayname 
	$title = $user.title 
	$department = $user.department 
	$company = $user.company 
	$email = $user.email 
	$ou = $user.ou 
	$upn = $sam + "@test.local" 
	$password = $user.password 

	New-ADUser -Name "$displayName" -DisplayName "$displayName" -SamAccountName $sam -UserPrincipalName $upn -GivenName "$firstName" -Surname "$lastName" -EmailAddress $email -Company $company -AccountPassword (ConvertTo-SecureString $password -AsPlainText -Force) -Path $ou -Enabled $true -Title $title -Department $department 
	Write-Host $userCount " User Created: " $firstName $lastName 
	$userCount++
}

