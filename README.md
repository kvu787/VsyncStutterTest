# Notes

* With gsync on, if you change low latency mode from off to ultra, the fps cap goes from unlimited to 1250
* Disable Nvidia battery boost
  * Nvidia battery boost is enabled by default
  * This means that when power cable is disconnected, games are capped to 30 fps
  * You should disable battery boost so that battery-only hardware behavior aligns better with plugged-in hardware behavior
  * The only way to disable battery boost is to install "NVIDIA App" from the microsoft store and disable it in there
* Using Legion Space to set the profile to "Performance + enable GPU OC" is ***required*** to avoid micro-jitter at 240 hz
  * To avoid issues, don't set Legion Space to automatically run at startup
  * Manually open Legion Space after booting into desktop
  * Then, set profile to Balance and then back to Performance to ensure that the profile is correctly applied
  * Conversely, set the profile to Quiet or Balance to reproduce and investigate micro-jitter

# NVCP profile setup

* Low Latency Mode = Ultra
* Max Frame Rate =
  * 240 FPS if internal limiter is disabled
  * Off if internal limiter is enabled
* Monitor Technology = G-SYNC
* Power management mode = Prefer maximum performance
* Preferred refresh rate = Application-controlled
* Vertical sync = On
* All other settings should remain on defaults

# Log path

C:\Users\k\AppData\Roaming\Godot\app_userdata\VsyncStutterTest

# Misc

```powershell
$scriptPath = "C:\Users\kevin\Repository\Godot\VsyncStutterTest\Split-File.ps1"
$logFilePath = "C:\Users\kevin\Repository\Godot\VsyncStutterTest\MyLogOutput\2026-07-19_01-56-45\PresentMon.csv"
& $scriptPath -FilePath $logFilePath -NumParts 24 -PadLength 2

$scriptPath = "C:\Users\kevin\Repository\Godot\VsyncStutterTest\Split-File.ps1"
$logFilePath = "C:\Users\kevin\Repository\Godot\VsyncStutterTest\MyLogOutput\2026-07-19_03-10-54\PresentMon.csv"
& $scriptPath -FilePath $logFilePath -NumParts 160 -PadLength 3
```

**PFV conformance**, meaning perfect frame delivery with VSync on, at a specified display refresh rate is the extent to which a system delivers one distinct frame for every display refresh while VSync is enabled.

* Each display refresh presents exactly one newly rendered frame.
* Frames are presented in their intended order, with no dropped, duplicated, or reordered frames.
* No frame misses its intended display refresh.
* No screen tearing occurs.

# NVIDIA Low Latency Mode testing

Monitor Technology = Fixed Refresh, Low Latency Mode = Off, Vertical Sync = Off:
consistent range
3000 to 3250

Monitor Technology = Fixed Refresh, Low Latency Mode = Off, Vertical Sync = On:
locked
240

Monitor Technology = Fixed Refresh, Low Latency Mode = On, Vertical Sync = Off:
consistent range
3000 to 3250

Monitor Technology = Fixed Refresh, Low Latency Mode = On, Vertical Sync = On
locked
240

Monitor Technology = Fixed Refresh, Low Latency Mode = Ultra, Vertical Sync = Off:
locked
1250

Monitor Technology = Fixed Refresh, Low Latency Mode = Ultra, Vertical Sync = On:
locked
240

Monitor Technology = G-SYNC, Low Latency Mode = Off, Vertical Sync = Off:
consistent range
2650 to 2750

Monitor Technology = G-SYNC, Low Latency Mode = Off, Vertical Sync = On:
locked
240

Monitor Technology = G-SYNC, Low Latency Mode = On, Vertical Sync = Off:
consistent range
2650 to 2750

Monitor Technology = G-SYNC, Low Latency Mode = On, Vertical Sync = On:
locked
240

Monitor Technology = G-SYNC, Low Latency Mode = Ultra, Vertical Sync = Off:
locked
1250

Monitor Technology = G-SYNC, Low Latency Mode = Ultra, Vertical Sync = On:
locked
225