$Path = "C:\sandbox"
$PatternToMatch = "Lorem"

Get-Childitem -Path $Path -Recurse | Foreach-Object {
    $matches = Select-String -Path $_.Fullname -Pattern $PatternToMatch
    if ($matches) {
        Write-host "Found in $($_.FullName)"
        $matches | Foreach-Object {
            Write-Host $_.Line
        }
    }
}
