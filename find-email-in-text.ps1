#########################################################################################
#  Author: KP - Yoonsi
#  Date: 27-09-2023
#  Purpose: Search through a text file and use a regular expression to find any email 
#  addresses
#  Version: 1.0
#########################################################################################


$path = Read-Host -Prompt "Please enter a file path"
$text = Get-Content -Path $path -Raw
$matches = $text | Select-String -Pattern '\b[A-Za-z0-9._%+-]+@[A-Za-z0-9.-]+\.[A-Z|a-z]{2,7}\b' -AllMatches

$matches.Matches.Value




