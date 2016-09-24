## After I created a developer sharepoint site on my Office 365 account, 
## I was getting an error message in Visual Studio that Sideloading was 
## not enabled on the site. This script is used to eneabled the 
## Sideloading Feature on a Office 365 Developer Site. 
## 
## To run this, you will need to download the Powershell
## Sharepoint Online Management Shell tool using the following URL:
## https://www.microsoft.com/en-us/download/details.aspx?id=35588
##
## This script was found at the following site:
## http://www.superedge.net/2014/03/sideloading-of-apps-not-enabled-on-this.html 

$programFiles = [environment]::getfolderpath("programfiles")
add-type -Path $programFiles'\SharePoint Online Management Shell\Microsoft.Online.SharePoint.PowerShell\Microsoft.SharePoint.Client.dll'
Write-Host 'Ready to enable Sideloading'
$siteurl = Read-Host 'Site Url'
$username = Read-Host "User Name"
$password = Read-Host -AsSecureString 'Password'
 
$outfilepath = $siteurl -replace ':', '_' -replace '/', '_'
 
try
{
    [Microsoft.SharePoint.Client.ClientContext]$cc = New-Object Microsoft.SharePoint.Client.ClientContext($siteurl)
    [Microsoft.SharePoint.Client.SharePointOnlineCredentials]$spocreds = New-Object Microsoft.SharePoint.Client.SharePointOnlineCredentials($username, $password)
    $cc.Credentials = $spocreds
    $site = $cc.Site;

    $sideLoadingGuid = new-object System.Guid "AE3A1339-61F5-4f8f-81A7-ABD2DA956A7D"
    $site.Features.Add($sideLoadingGuid, $true, [Microsoft.SharePoint.Client.FeatureDefinitionScope]::None);
     
    $cc.ExecuteQuery();
     
    Write-Host -ForegroundColor Green 'SideLoading feature enabled on site' $siteurl
    #Activate the Developer Site feature
}
catch
{ 
    Write-Host -ForegroundColor Red 'Error encountered when trying to enable SideLoading feature' $siteurl, ':' $Error[0].ToString();
}
