<#
.Synopsis
   Gets basic user information from Active Directory.
.DESCRIPTION
   Gets the user's med domain user id, first name, last name
   and title from active directory
.EXAMPLE
   Get-UserInfo -FileName c:\users.csv
#>

function Get-UserInfo {

    [CmdletBinding()]
    param(
        [Parameter(Mandatory=$true)]
        [string]
        $FileName
    )

    # Checking to see that the file exists in the file system. If
    # the following evaluates to False, then this function will exit
    # with an error message stating that the file was not found.
    if(Test-Path $FileName)
    {
        $users = Import-Csv $FileName
    }
    else
    {
        Write-Error "The file $FileName does not exist. Please type the path again"
        return
    }
        
    foreach($u in $users) 
    {
        # TODO: Add error checking for any users who may have two fields in the
        # first name field and also check to make sure that appropriate characters
        # are escaped so that the search can be done (i.e. the ' will need to be
        # escaped to \').
        try
        {            
            $result = Get-AdUser -Filter "((Givenname -eq '$($u.Firstname)') -and (sn -eq '$($u.Lastname)'))" `
                      -Properties samAccountName,GivenName,Surname,title,mail,department `
                      | select samAccountName,GivenName,Surname,title,mail,department -ErrorAction Stop

            # TODO: Need to account for results that yield more than one account

            # Before outputting the resutls, we have to check if anything was found
            # with the query above. If not, then the following if statement evalutes
            # to true and will output the information you see below.
            if($result -eq $null)
            {
                $UserInfo = [ordered]@{
                    'Username' = "not found";
                    'First Name' = $($u.Firstname);
                    'Last Name' = $($u.Lastname);
                    'Title' = "not found";
                    'Email' = "not found"
                    'Department' = "not found";
                }

                Write-Warning "No account information found for $($u.Firstname) $($u.Lastname)"
            }
            else
            {
                $UserInfo = [ordered]@{
                    'Username' = $result.samAccountname;
                    'First Name' = $result.GivenName;
                    'Last Name' = $result.Surname;
                    'Title' = $result.title;
                    'Email' = $result.mail;
                    'Department' = $result.department;
                }

                #Write-Verbose "Account information found for $($u.Firstname) $($u.Lastname)."
            }

            $obj = New-Object -TypeName psobject -Property $UserInfo
            Write-Output $obj
        }
        catch
        {
            Write-Verbose "Unable to find user $($u.FirstName) $($u.LastName)"
        }
    }
}
