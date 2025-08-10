# Alternative PowerShell version with error handling
try {
    # Get wallpaper path - SIMPLIFIED
    $wallpaper = (Get-ItemProperty 'HKCU:\Control Panel\Desktop').WallPaper
    if (-not $wallpaper) {
        Write-Error "Wallpaper path not found."
        exit 1
    }
    else{
        Write-Host "Wallpaper path retrieved: $wallpaper " -ForegroundColor Green
    }
    
    # Define paths
    $magick = "C:\Program Files\ImageMagick-7.1.1-Q16-HDRI\magick.exe"
    $output = "C:\Users\timet\Documents\Rainmeter\Skins\Todoist\@Resources\Images\blurImage.jpg"
    
    # Build ImageMagick command with 16:10 centered crop
    $arguments = @($wallpaper, '-gravity', 'center', '-crop', '16:10+0+0', '-blur', '0x4', '+repage', $output)

    # Execute ImageMagick
    & $magick $arguments 
    if ($LASTEXITCODE -ne 0) {
        Write-Error "ImageMagick command failed with exit code $LASTEXITCODE"
        exit 1
    }
    else {
        Write-Host "wallpaper is cropped and blurred successfully." -ForegroundColor Green
    }



    # Get dimensions of the cropped image
    $identifyArgs = @('-format', '%w %h', $output)
    $dimensions = & $magick identify $identifyArgs
    $dimFile = "C:\Users\timet\Documents\Rainmeter\Skins\Todoist\@Resources\dimensions.txt"
    # Write only the dimensions in WxH format
    $dimensionsOnly = $dimensions.Trim() -replace '[^0-9 ]', ''
    $parts = $dimensionsOnly -split '\s+'
    if ($parts.Length -eq 2) {
        $dimString = "$($parts[0])x$($parts[1])"
        Set-Content -Path $dimFile -Value $dimString
    } else {
        Set-Content -Path $dimFile -Value $dimensionsOnly
    }
    Write-Host "ImageMagick processed the image and saved dimensions to $dimFile " -ForegroundColor Green

    # Launch Todoist
    $API_KEY = "c4726a7570b8c5f0aa36ba0718907a650a9eda53"
    $TASKSFILEPATH = "C:\Users\timet\Documents\Rainmeter\Skins\Todoist\@Resources"
    $TASKFILE = "todoistTasks.txt"
    & "./todoistArg.exe" $API_KEY $TASKSFILEPATH\$TASKFILE
    Write-Host "todoist tasks are retrieved " -ForegroundColor Green

    # Activate both skins with proper delays
    & "C:\Program Files\Rainmeter\Rainmeter.exe" "!ActivateConfig" "Todoist" "Todoist.ini"
    Start-Sleep -Seconds 2
    & "C:\Program Files\Rainmeter\Rainmeter.exe" "!ActivateConfig" "Todoist\Mail" "Mail.ini"
    Start-Sleep -Seconds 2
    Write-Host "Both skins activated" -ForegroundColor Green
    
    # Refresh both skins with proper syntax
    & "C:\Program Files\Rainmeter\Rainmeter.exe" "!Refresh" "Todoist\Main"
    Start-Sleep -Seconds 1
    & "C:\Program Files\Rainmeter\Rainmeter.exe" "!Refresh" "Todoist\Mail"
    Start-Sleep -Seconds 1
    & "C:\Program Files\Rainmeter\Rainmeter.exe" "!CommandMeasure" "MeasureLuaScript" "RefreshButton()" "Todoist\Main"
    & "C:\Program Files\Rainmeter\Rainmeter.exe" "!CommandMeasure" "MeasureLuaMailScript" "RefreshMailButton()" "Todoist\Mail"
    Write-Host "Both Todoist and Mail skins refreshed" -ForegroundColor Green

}
catch {
    Write-Error "Error occurred: $($_.Exception.Message)"
}

