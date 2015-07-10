<#
    Date Created: 8/6/2014
    Description:  This script will be used to upload the txt file that will 
                  contain the list of users that will be uploaded 
                  bulk upload them. The script will look for files to 
                  upload in the 'upload_files' directory that have the following
                  format:
                  Name_oaNumber_ShortDate.txt
#>

# Mail Server Information
# The information you see below will be used to
# send out email notifications on the actions taken
# by this script.
$mailServer = ""
$mailServerUsername = "";
$mailServerUserPasswrd = ""

# Healthstream ftp site information
# Note: the ftpSite must end with a '/'
$ftpSite = ""
$ftpUsername = ""
$ftpUserpassword = ""

# SFTP Login Info
$ftpAddress = ""
$sftpUsername = ""
$sftpPassword = ""
$sshKey = ""


$hospitals = @("", "")
$oaNumber = ""
$shortDate = (Get-Date).ToString("yyyyMMdd")

# This is the directory where the files that will be uploaded will
# be stored. For the purposes of this script, this directory will
# be in the same physical location as the script
$uploadDirectory = -join((Get-Location).Path, "\upload_files\")

# This webClient object will be used to upload the file(s) 
# to the healthstream ftp site
$webClient = New-Object System.Net.WebClient
$webClient.Credentials = New-Object System.Net.NetworkCredential($ftpUsername, $ftpUserpassword)

# This array is going to be used to keep track of the files
# that were uploaded successfully. This is used after the script
# runs to generate a message that will be sent to the users
# who need to know if the upload was successful or not
$filesUploaded = @()

#$credentials = Get-Credential

foreach($file in (dir $uploadDirectory)) 
{
    foreach($hospital in $hospitals)
    {
        # Generating the name of the file that we are looking for so that
        # if it exists, we'll upload it to the ftp site. 
        # (i.e. Name_######_20140808.txt, etc.)
        $currentFile = -join($hospital,"_",$oaNumber,"_",$shortDate,".txt")

        if($file.Name -eq $currentFile)
        {    
            #Write-Host "$file.Name will be uploaded"        
            $fileToUpLoad = -join($uploadDirectory,$file)
            Write-Host "$fileToUpLoad will be uploaded"
            $uri = New-Object System.Uri($ftpSite + $file)
            $webClient.UploadFile($uri, $fileToUpLoad)
            $filesUploaded = $filesUploaded + "$file uploaded on $((Get-Date).ToString())"
            Write-Host "$file was uploaded"
                                   
            # Once the file has been uploaded successfully to the FTP Site
            # we will move it to the archived_files folder            
			# Check to see if this file already exists in the archived_files folder
            # and if it does, just add something extra to the end of this file.
            Move-Item $fileToUpLoad ((Get-Location).Path + "\archived_files\")   

            # We have to go on to the next Hospital
            continue
        }
    }
}

# TODO: Add some error checking to make sure that if the file fails
# to be uploaded an email will be sent out to the users.

# TODO: If the upload is successful, we have to notify healthstream 
# thru email that we have upladed the file. In addition, for completeness 
# sake we'll also notify some internal users to let the know that the file
# was successfully uploaded

# TODO: After files have been uploaded, they should be moved to a 
# archived folder so that the next time the script runs it will not 
# have to iterate thru alot of files.

# TODO: Do some sort of validation to make sure that only *.csv files
# are uploaded to the ftp site and no txt file.

# TODO: Add some Loggin logic so that you can see what happened each time
# the script ran (i.e. what was uploaded or not uploaded and who was notified)

# TODO: Add check to verify that you can login successfully into the ftp stie
# and also verify that you are able to get into the site itself (the site may 
# have issues or we may have issues getting out to the internet).

# TODO: Use @{} to use hash table to keep track of what has been uploaded
# or not.

