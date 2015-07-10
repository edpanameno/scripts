# Gets the list of users who have expired accounts in the 
# desired OU.
#
Import-Module ActiveDirectory

# Load the Footprints Library. The dll file must be in the same directory
# that this script lives in for the following command to complete without
# any errors.
Add-Type -Path fplib.dll

$currentDate = (Get-Date).ToShortDateString()

# The OU where the expired users are located at
$ou = ""

# Footprints API and login credentials 
$footprintsUrl = ""
$footprintsUsername = ""
$footprintsPassword = ""

# Footprints ticket Information
$projectID = ""
$ticketTitle = "Expired Users - $currentDate"
$ticketStatus = "Open."
$ticketPriority = "5"
$submitedVia = "Email"

# Enter team name and the contact of the ticket
# which can be just the username from active directory
$teams = @("") 
$ticketContact = ""

# CTI and other required Footprints Fields
$ticketCategory = "System Access"
$ticketType = "Access Control"
$ticketItem = "Add/Install/Configure"
$ticketLocation = "No Location"
$ticketFloorRoom = "n/a"

# The following command searches for all expired accounts that live inside of the 
# Organizational Unit that is specified in the '$ou' variable. Note: the expiration 
# date was also one day more than what shows up in active directory that's why I 
# removed one day from the account expiration date field.
$expiredUsers = Search-ADAccount -AccountExpired -SearchBase $ou | Get-ADUser -Properties * | select @{l="Username";e={$_.samAccountName}},@{l="Name";e={$_.Surname + ', ' + $_.GivenName}},Title,@{l="Expiration Date";e={($_.AccountExpirationDate).AddDays(-1).ToString("MMMM dd, yyyy")}}

if($expiredUsers.Count -gt 0) 
{
	$outputTable = $expiredUsers | sort Name | fl | out-string 
	$description = New-Object System.Text.StringBuilder

	# The void keyword prevents any output from being shown
	# when the scripts runs
	[void]$description.AppendLine("See below for the users whose domain accounts have expired. Please disable their domain account and disable any other applications/resources that each user may have access to.")
	[void]$description.AppendLine("OU Path: $ou")
	[void]$description.AppendLine($outputTable)

	# Create Footprints Ticket	
	$fpTicket = New-Object FootprintsLib.FPTicket -ArgumentList $footprintsUrl,$footprintsUsername,$footprintsPassword

	$fpTicket.TicketInfo.projectID = $projectID
	$fpTicket.TicketInfo.title = $ticketTitle 
	$fpTicket.TicketInfo.priorityNumber = $ticketPriority 
	$fpTicket.TicketInfo.status = $ticketStatus
	$fpTicket.TicketInfo.selectContact = $ticketContact

	$fpTicket.ProjectInfo.Submitted__bVia = $submitedVia
	$fpTicket.ProjectInfo.Category = $ticketCategory 
	$fpTicket.ProjectInfo.Type = $ticketType 
	$fpTicket.ProjectInfo.Item = $ticketItem 
	$fpTicket.ProjectInfo.Location = $ticketLocation 
	$fpTicket.ProjectInfo.Floor__fRoom = $ticketFloorRoom 

	$fpTicket.TicketInfo.description = $description.ToString()
	$fpTicket.TicketInfo.assignees = $teams 

	# Footprints ticket notification settings
	# Properties with a value of 1 will get a email 
	# notification from the footprints system
	$fpTicket.MailInfo.assignees = "1"
	$fpTicket.MailInfo.contact = "1"
	$fpTicket.Mailinfo.permanentCCs = "0"

	$result = $fpTicket.CreateTicket()
	Write-Host "Ticket # $result was created successfully!!"
}
else 
{
	#Write-Host "No users were found! :("
}

