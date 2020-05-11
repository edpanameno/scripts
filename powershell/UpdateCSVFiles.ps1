﻿## This script iterates thru each csv file and add the NPI number
## as a new column to each csv file. The results of each operation 
## is then stored in the results folder.
###  powershell -ExecutionPolicy Bypass .\UpdateCSVFiles.ps1


$csvFiles = Get-ChildItem .\*.csv
$resultsFolder = "C:\Users\<user>\Desktop\source_dir\results\"
$count = 0

foreach($file in $csvFiles) {
    $fileInfo = Get-Item $file  
    $outputFilePath = "C:\Users\<user>\Desktop\source_dir\results\$($fileInfo.Name)"
   
    write-output "Processing file number $count - $($fileInfo.Name)"

    Import-Csv $file  | 
    Select-Object *,@{Name="NPI";Expression={$fileInfo.BaseName}} | 
    Export-Csv $outputFilePath -NoTypeInformation 
    $count++
 }
