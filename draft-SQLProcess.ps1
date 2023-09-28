function Process-SQLstring {
    param (
        $SQLline
    )

    Write-Host $SQLline
}

$FileInput = Read-Host -Prompt "Enter a Path"

foreach ($line in Get-Content -Path $FileInput) {
    if ($line -match 'CREATE TABLE (\[[Dd][Bb][Oo]\]\.)?[A-Za-z]+\s*\(') {
         Write-Host 'TABLE'$line
    }

    if ($line -match 'CREATE VIEW (\[[Dd][Bb][Oo]\]\.)?[A-Za-z_]+ AS') {
         Write-Host 'VIEW'$line
    }

}
