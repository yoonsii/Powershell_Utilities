# Define the Identify-Video function
function Identify-Video {
    param (
        $FilePathee
    )

    #.mp4 .jpg .JPEG .MOV .JPG .PNG .mov .MP4 .GIF

    if ($FilePathee.extension.toString() -eq ".jpg" -or $FilePathee.extension.toString() -eq ".jpeg" -or $FilePathee.extension.toString() -eq ".png") {
        Write-Host $FilePathee.fullname
        $imagePath = $FilePathee.fullname
        Write-Host "Image!!"
        Write-Host $FilePathee.dateTaken

        # Load the image using System.Drawing.Bitmap
        $bitmap = New-Object System.Drawing.Bitmap($imagePath)

        # Access the "Date Taken" property from the image's properties
        $dateTaken = $bitmap.GetPropertyItem(36867).Value

        # Convert the date taken from bytes to a readable string
        $dateTakenString = [System.Text.Encoding]::ASCII.GetString($dateTaken)

        # Display the "Date Taken" value
        Write-Host "Date Taken: $dateTakenString"

        # Dispose of the Bitmap object to free resources
        $bitmap.Dispose()

        $splitdate = $dateTakenString -split ":"
        $year = $splitdate[0]
        $month = $splitdate[1]
        $year
        $month

      # Copy-Item -Path $FilePathee.fullname -Destination C:\New Folder\$year\$monthsFolders[[int]$month -1]
        $monthString = $monthsFolders[$month - 1]

        if ($dateTakenString -ne $null) {
            Write-host "Destination " + "C:\New Folder\$year\$monthString"
        }

    } 
    
    else 
    {
        Write-Host $FilePathee.fullname
        Write-Host "Not image"
        # Specify the path to your file
        

        # Use the Get-Item cmdlet to get file information
        $file = get-item $FilePathee.fullname
        Write-host $file.extension

        # Check if the file has media creation date metadata
        if ($file.Extension -match ".(mp4|avi|mkv|mp3)$") {
            # Use the Shell.Application COM object to access the metadata
            $shell = New-Object -ComObject Shell.Application
            $folder = $shell.Namespace($file.Directory.FullName)
            $item = $folder.ParseName($file.Name)

            # Get the media created date property (index 208)
            $mediaCreatedDate = $folder.GetDetailsOf($item, 208)

            # Display the media created date
            Write-Host "Media Created Date: $mediaCreatedDate"
            $splitdate = $mediaCreatedDate -split "/"
            $year = $splitdate[2] 
            $splityear = $year.toString() -split " "
            $month = $splitdate[0]
            $year
            $month

          # Copy-Item -Path $FilePathee.fullname -Destination C:\New Folder\$year\$monthsFolders[[int]$month -1]
          
             $year = $year -match '\d{4}' | Out-Null
            $year = $matches[0]         
          
            # Assuming $month contains the string "3"
            $month = $month -replace '[^\d]', '' # Remove non-numeric characters

            # Now, convert it to an integer 
            $monthInt = [int]$month

            # Use $monthInt for further operations
            $monthString = $monthsFolders[$monthInt - 1]

            if ($mediaCreatedDate -ne $null) {
                Write-host "Destination " + "C:\New Folder\$year\$monthString"
            }


        } else {
            Write-Host "Media created date metadata not found or file type not supported."
        }

    }
}

# Define the createFolders function
function createFolders {
    for ($i = 2023; $i -ge 2012; $i--) {
        New-item -ItemType directory -Path ".\$i\01 - January"
        New-item -ItemType directory -Path ".\$i\02 - February"
        New-item -ItemType directory -Path ".\$i\03 - March"
        New-item -ItemType directory -Path ".\$i\04 - April"
        New-item -ItemType directory -Path ".\$i\05 - May"
        New-item -ItemType directory -Path ".\$i\06 - June"
        New-item -ItemType directory -Path ".\$i\07 - July"
        New-item -ItemType directory -Path ".\$i\08 - August"
        New-item -ItemType directory -Path ".\$i\09 - September"
        New-item -ItemType directory -Path ".\$i\10 - October"
        New-item -ItemType directory -Path ".\$i\11 - November"
        New-item -ItemType directory -Path ".\$i\12 - December"
        write-host $i
    }
}

# Rest of your script below this point

$monthsFolders = "01 - January", "02 - February", "03 - March", "04 - April", "05 - May", "06 - June", "07 - July", "08 - August", "09 - September", "10 - October", "11 - November", "12 - December"

$sourcePath = "C:\source"
$images = Get-Childitem -Path $sourcePath -Recurse 
#$images = Get-Childitem -Path $sourcePath -Recurse | foreach-object {$_.extension}

$unique = $images | Select-Object -Unique

Write-Host $unique

#write-host $images

foreach ($image in $images) {
   Identify-Video -FilePathee $image
}


#createFolders
