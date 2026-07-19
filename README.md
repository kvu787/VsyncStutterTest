C:\Users\kevin\AppData\Roaming\Godot\app_userdata\VsyncStutterTest

```powershell
$scriptPath = "C:\Users\kevin\Repository\Godot\VsyncStutterTest\Split-File.ps1"
$logFilePath = "C:\Users\kevin\Repository\Godot\VsyncStutterTest\MyLogOutput\2026-07-19_01-56-45\PresentMon.csv"
& $scriptPath -FilePath $logFilePath -NumParts 24 -PadLength 2

$scriptPath = "C:\Users\kevin\Repository\Godot\VsyncStutterTest\Split-File.ps1"
$logFilePath = "C:\Users\kevin\Repository\Godot\VsyncStutterTest\MyLogOutput\2026-07-19_03-10-54\PresentMon.csv"
& $scriptPath -FilePath $logFilePath -NumParts 160 -PadLength 3
```