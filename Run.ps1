Set-StrictMode -Version "Latest"
$ErrorActionPreference = "Stop"

$logFolderPath = "$env:UserProfile\Repository\Godot\VsyncStutterTest\MyLogOutput\$(Get-Date -Format "yyyy-MM-dd_HH-mm-ss")"
New-Item -ItemType "Directory" -Path $logFolderPath

$presentMonPath = "$env:UserProfile\Program\PresentMon-2.5.1-x64.exe"
if (Test-Path $presentMonPath) {
    $presentMonLogFilePath  = "$($logFolderPath)\PresentMon.csv"
    Start-Process `
        -FilePath $presentMonPath `
        -ArgumentList "--process_name `"VsyncStutterTest.exe`" --output_file `"$($presentMonLogFilePath)`"" `
        -Verb "RunAs"
}

$process = Start-Process -FilePath "$env:UserProfile\Repository\Godot\VsyncStutterTest\MyBuildOutput\VsyncStutterTest.exe" -PassThru

$process.PriorityClass = [System.Diagnostics.ProcessPriorityClass]::High
Write-Host "Launched with PID=$($process.Id)"
Wait-Process -Id $process.Id
