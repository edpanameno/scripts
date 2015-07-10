function Get-ByUserMail {

    [CmdletBinding()]
    param(
        [Parameter(Mandatory=$true)]
        [string]
        $FileName
    )
    
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
        
        try
        {            
            $result = Get-AdUser -Filter "(mail -eq '$($u.mail)')" `
                      -Properties samAccountName,GivenName,Surname,title,mail,department `
                      | select samAccountName,GivenName,Surname,title,mail,department -ErrorAction Stop

            if($result -eq $null)
            {
                # This will create a dummy object with some data that can
                # then be used to filter out accounts in an excel worksheet
                $UserInfo = [ordered]@{
                    'Username' = "$($u.samAccountName)";
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

                Write-Verbose "Account information found for $($u.Firstname) $($u.Lastname)."
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
