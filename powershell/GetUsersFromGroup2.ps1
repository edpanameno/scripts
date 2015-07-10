# Gets a list of users who are part of the specified
# Group name.
function Get-UsersFromGroup2 {
    
    [CmdletBinding()]
    param(
        [parameter(mandatory=$true)]
        [string]
        $groupName,
        [parameter(mandatory=$true)]
        [string]
        $exportToFile
    )

    # The following gets some basic user information from active directory.
    Get-ADGroupMember -Identity $groupName | Get-ADUser -Properties samAccountName,givenname,surname,title,
    department,mail,lastlogon,created | select samAccountName,givenname,surname,title,department,mail,
    @{l="lastLogon";e={[DateTime]::FromFileTime($_.lastLogon)}}, created | 
    Export-Csv $exportToFile -NoTypeInformation
}