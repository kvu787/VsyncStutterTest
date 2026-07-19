Set-StrictMode -Version "Latest"
$ErrorActionPreference = "Stop"

$logFolderPath = "C:\Users\kevin\Repository\Godot\VsyncStutterTest\MyLogOutput\$(Get-Date -Format "yyyy-MM-dd_HH-mm-ss")"
New-Item -ItemType "Directory" -Path $logFolderPath

$presentMonLogFilePath  = "$($logFolderPath)\PresentMon.csv"
Start-Process `
  -FilePath "C:\Users\kevin\Program\PresentMon-2.5.1-x64.exe" `
  -ArgumentList "--process_name `"VsyncStutterTest.exe`" --output_file `"$($presentMonLogFilePath)`"" `
  -Verb "RunAs"

$process = `
    Start-Process `
        -FilePath "C:\Users\kevin\Repository\Godot\VsyncStutterTest\MyBuildOutput\VsyncStutterTest.exe" `
        -PassThru

$process.PriorityClass = [System.Diagnostics.ProcessPriorityClass]::High
Write-Host "Launched with PID=$($process.Id)"
Wait-Process -Id $process.Id
