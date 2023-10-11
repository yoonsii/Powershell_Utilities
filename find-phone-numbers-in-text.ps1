$path = read-host -prompt "Enter Path"
#Naive regex pattern but it works for now. See if you can tidy this up / make it more efficient
#TODO : Add support for 123456789 and generate a few additional formats

#Hard-Coded for ease of development
#$path = "C:\sandbox\phone\phone.txt"

foreach ($line in  (Get-Content -Path $path)){

    #Write-Host $line
    #Write-Host "`n"

    #\d{1,5}-\d{1,5}-\d{1,5}

    $matches = $line | Select-String -allmatches -pattern "\(?\d{1,5}\)?\.?\s?-?\d{1,5}-?\.?\d{1,5}"

        foreach ($match in $matches){
          write-host $match.Matches
        }
    


}
