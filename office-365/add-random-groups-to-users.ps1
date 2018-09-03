# This script will be used to add random groups to 
# users in a Active Directory Domain. I used this script
# to add groups to the users in my test local domain that
# is synching up to my O365 developer tenant.

# Location of the Groups OU in the domain
$groupsOU = "OU=Groups,OU=Account - Resources,DC=test,DC=local";

# Location of the OU with all the users
$usersOU = "OU=CloudUsers,OU=Accounts,DC=test,DC=local";

$numberOfUsers = 1500;

$users = Get-ADUser -SearchBase $usersOU -Filter * -ResultSetSize $numberOfUsers

$users | foreach {
	$user = Get-AdUser -Identity $_
	
	# This will be used to specify how many random groups will be added to the user
	$randomCount = Get-Random -InputObject 11,12,15,20,25,30,32,40,44 -Count 1

	# Gets the random security groups that will be added to the user
	$groups = Get-ADGroup -SearchBase $groupsOU -filter {GroupCategory -eq "Security" } | Get-Random -Count $randomCount

	foreach($group in $groups) {
		Add-ADGroupMember $group -Members $user 
		write-host "Added $user to $group"
	}
}

