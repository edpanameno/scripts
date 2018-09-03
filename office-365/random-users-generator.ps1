# This script gets a specified random number of users from 
# the CSV file below and outputs it to a new csv file

$inputPath = ".\mock-users.csv";
$outPutFile = ".\random-users.csv";
$count = 1000;

$list = Import-Csv -Path $inputPath
$randomUsers = Get-Random -InputObject $list -Count $count | Export-Csv -Path $outputFile  -NoTypeInformation 

