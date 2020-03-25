##
## This script will be used to format my *.md files for my blog so that
## they can live inside of a nextjs application (or any other static site
## system that supports this format)
##
$files = get-childitem -path "." -Filter *.md

## the directory where the formatted files will be copied to
$output = "c:\users\ed\Desktop\posts\output\"

foreach($file in $files) { 
    $fileName = $file.Name
    $datePortion = $file.Name.Substring(0, 10)
    $fileLength = $fileName.Length;
    $fileNameWithNoDate = $file.Name.Substring(11, ($fileLength - 11))
    
    # We need to add the following line to each file so that it can be used
    # when building out the blog post:
    # date: "2014-12-22" 
    # This date field will then be used to show the date on the post
    $fileContent = Get-Content $file
    $fileContent[1] += [System.Environment]::NewLine + "date: `"$($datePortion)`""
    $fileContent | Set-Content $file

    # Now we need to create a new file name without the date portion
    # so that it's nicely formatted
    copy-item $file -Destination "$($output)$($fileNameWithNoDate)"
    Write-Output "Done with file $($fileName)"
}

