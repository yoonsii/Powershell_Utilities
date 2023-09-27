#########################################################################################
#  Author: KP - Yoonsi
#  Date: 07-09-2023 
#  Purpose: Recursively searches through a folder and retrieves all photos and videos
#  Then sorts them in a destination folder depending on created date
#
#########################################################################################


# Define the Identify-Video function
function Identify-Video {
    param (
        $FilePath
    )

    #.mp4 .jpg .JPEG .MOV .JPG .PNG .mov .MP4 .GIF

    if ($FilePath.extension.toString() -eq ".jpg" -or $FilePath.extension.toString() -eq ".jpeg" -or $FilePath.extension.toString() -eq ".png") {
        Write-Host $FilePath.fullname
        $imagePath = $FilePath.fullname
        Write-Host "Image!!"
        Write-Host $FilePath.dateTaken

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
        #$year
        #$month

      # Copy-Item -Path $FilePath.fullname -Destination C:\New Folder\$year\$monthsFolders[[int]$month -1]
        $monthString = $monthsFolders[$month - 1]

        if ($dateTakenString -ne $null) {
            Write-host "Destination "  "$destinationPath\$year\$monthString"
            move-item -path $FilePath.fullname -destination "$destinationPath\$year\$monthString"
        } else {
            Write-host "No date taken so moving to misc"
            move-item -path $FilePath.fullname -destination "$destinationPath\Misc"
        }

    } 
    
    else 
    {
        Write-Host $FilePath.fullname
        Write-Host "Not image"
        # Specify the path to your file
        

        # Use the Get-Item cmdlet to get file information
        $file = get-item $FilePath.fullname
        Write-host $file.extension

        # Check if the file has media creation date metadata
        if ($file.Extension -match ".(mp4|avi|mkv|mp3|mov)$") {
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

          # Copy-Item -Path $FilePath.fullname -Destination C:\New Folder\$year\$monthsFolders[[int]$month -1]
          
             $year = $year -match '\d{4}' | Out-Null
            $year = $matches[0]         
          
            # Assuming $month contains the string "3"
            $month = $month -replace '[^\d]', '' # Remove non-numeric characters

            # Now, convert it to an integer 
            $monthInt = [int]$month

            # Use $monthInt for further operations
            $monthString = $monthsFolders[$monthInt - 1]

            if ($mediaCreatedDate -ne $null) {
                Write-host "Destinatisdsdffson11 " + "$destinationPath\$year\$monthString"
                Move-Item -Path $FilePath.fullname -Destination "$destinationPath\$year\$monthString"
            } else {
                Write-Host "Media Created Null moving to Misc"
                Move-Item -Path $FilePath.fullname -Destination "C:\Destination\Misc"
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


$monthsFolders = "01 - January", "02 - February", "03 - March", "04 - April", "05 - May", "06 - June", "07 - July", "08 - August", "09 - September", "10 - October", "11 - November", "12 - December"

$sourcePath = Read-Host -Prompt 'Enter Source Path. If left blank will default to C:\Source'
if ($sourcePath -eq "") 
{
    $sourcePath = "C:\Source"
}

$destinationPath = Read-Host -Prompt 'Enter Destination Path. If left blank will default to C:\Destination'
if ($destinationPath -eq "") 
{
    $destinationPath = "C:\Destination"
}

$debug = Read-Host -Prompt "Turn verbose on? (Y/N)"

$uniqueFlag = Read-Host -Prompt "Run extension scan only? (Y/N)"

#TO DO: Add regex checking to validate file path

$images = Get-Childitem -Path $sourcePath -Recurse 

if($uniqueFlag -eq "Y") {
    $images = Get-Childitem -Path $sourcePath -Recurse | foreach-object {$_.extension}
    $unique = $images | Select-Object -Unique
    $unique
    exit
}

Write-Host $unique

#write-host $images

foreach ($image in $images) {
   Identify-Video -FilePath $image
}


#createFolders
