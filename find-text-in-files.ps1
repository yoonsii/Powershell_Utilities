#########################################################################################
#  Author: KP - Yoonsi
#  Date: 03-10-2023 
#  Purpose: Search through a folder recursively for a string pattern. Show the filename
#  which contains the string and then each line that contains the string.
#
#########################################################################################

$Path = Read-Host -Prompt "Path"
$PatternToMatch = Read-Host -Prompt "Pattern to Match"

Get-Childitem -Path $Path -File -Recurse | Foreach-Object {
    $matches = Select-String -Path $_.Fullname -Pattern $PatternToMatch
    if ($matches) {
        Write-host "Found in $($_.FullName)"
        $matches | Foreach-Object {
            Write-Host $_.Line
        }
    }
}
