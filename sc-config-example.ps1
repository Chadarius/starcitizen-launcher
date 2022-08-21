# Rename this to sc-config.ps1
Write-Host "Star Citizen Launcher"
Write-Host "---------------------"

# Set path of Star Citizen
# Default path is
# $SCPath = "${env:ProgramFiles}\Roberts Space Industries"
$SCPath = "D:\Program Files\Roberts Space Industries"
Write-Host "Star Citizen Path is " $SCPath
Write-Host ""

# Stop Process list
# List out the EXE names of all the processes you want to stop
$StopProcessList = @(
    #"Discord"
    "steam"
    "steamwebhelper"
    "GreenShot"
    "RainMeter"
    "EpicGamesLauncher"
)

Write-Host "Processes to stop:"
Write-Host "------------------"
foreach ($process in $StopProcessList) {
    Write-Host "$process"
}
Write-Host ""

# Start Program List
# List out the ProgName, ProgPath, Progdir, and ProgArgs
# If you specify ProgName it will not try and launch the Program again.
# If you do not specify the ProgName it will launch the program again.
# Only ProgPath is required
$ProgList = @(
    #[PSCustomObject]@{ProgName = "exename"; ProgPath = "path\to\program\program.exe"; ProgDir = "path\to\program"; ProgArgs = "-Arg1=somearg"}
    [PSCustomObject]@{ProgName = "RSI Launcher"; ProgPath = "$SCPath\RSI Launcher\RSI Launcher.exe"; ProgDir = "$SCPath\RSI Launcher"}
    [PSCustomObject]@{ProgName = "joystick_gremlin"; ProgPath = "${env:ProgramFiles(x86)}\H2ik\Joystick Gremlin\joystick_gremlin.exe"; ProgDir = "${env:ProgramFiles(x86)}\H2ik\Joystick Gremlin"}
    [PSCustomObject]@{ProgName = "VoiceAttack"; ProgPath = "${env:ProgramFiles}\VoiceAttack\VoiceAttack.exe"; ProgDir = "${env:ProgramFiles}\VoiceAttack"}
    [PSCustomObject]@{ProgName = "opentrack"; ProgPath = "D:\Users\chada\nextcloud\Documents\star citizen\opentrack-2022.2.0-portable\install\opentrack.exe"; ProgDir = "D:\Users\chada\nextcloud\Documents\star citizen\opentrack-2022.2.0-portable\install"}
    [PSCustomObject]@{ProgDir = "${env:ProgramFiles}\Google\Chrome\Application"; ProgPath = "${env:ProgramFiles}\Google\Chrome\Application\chrome.exe"; ProgArgs ='https://studio.youtube.com/channel/UCAIcbgAh3PXpf2uIQcuLw7g --user-data-dir=D:\Users\chada\chrome2'}
    [PSCustomObject]@{ProgName = "obs64"; ProgPath = "D:\Users\chada\nextcloud\portable-apps\obs-studio star citizen\bin\64bit\obs64.exe"; ProgDir = "D:\Users\chada\nextcloud\portable-apps\obs-studio star citizen\bin\64bit"}
)
    # Old versions of Chrome could be installed in ${env:ProgramFiles(x86)}
    #[PSCustomObject]@{ProgDir = "${env:ProgramFiles(x86)}\Google\Chrome\Application"; ProgPath = "${env:ProgramFiles(x86)}\Google\Chrome\Application\chrome.exe"; ProgArgs ='https://studio.youtube.com/channel/UCAIcbgAh3PXpf2uIQcuLw7g --user-data-dir=D:\Users\chada\chrome2'}
    #[PSCustomObject]@{ProgName = "mumble"; ProgPath = "${env:ProgramFiles(x86)}\Mumble\client\mumble.exe"; ProgDir = "${env:ProgramFiles(x86)}\Mumble\client"}


# List ProgList Array
Write-Host "Program List to Launch"
Write-Host "----------------------"
foreach ( $ProgListNode in $ProgList ) {
    Write-Host "ProgPath:" $ProgListNode.ProgPath
    Write-Host "  ProgName:" $ProgListNode.ProgName
    Write-Host "  ProgDir:" $ProgListNode.ProgDir
    Write-Host "  ProgArgs:" $ProgListNode.ProgArgs
}
Write-Host ""

# Set Primary monitor if you have more than one
# This uses the free utility MultiMonitor
# https://www.nirsoft.net/utils/multi_monitor_tool.html
# Depending on your configuration your external monitor may not be "Display2".
# It could be almost any number. Use the utility to see which number you should use below.
# It works best if you find the "Monitor ID" using MultiMonitorTool
# Example:
#  My Scepter external monitor's Monitor ID is
#  MONITOR\SPT2401\{4d36e96e-e325-11ce-bfc1-08002be10318}\0006
#  This GUID is consistent no matter what stupid Display number Windows assigns
$PrimaryMonitor = "MONITOR\SPT2401\{4d36e96e-e325-11ce-bfc1-08002be10318}\0006"
Write-Host "Primary Monitor:"
Write-Host "----------------"
Write-Host $PrimaryMonitor
Write-Host ""

# Stop Services
$stopservicescmd = "-WindowStyle Minimized -file `"" + $scriptdir + "\$basefile-stopservices.ps1`""
Write-Host "Stop Services Command:" $stopservicescmd
Write-Host ""

# Stop Processes After closing RSI Launcher
$PostStopList = @(
    "VoiceAttack"
    "joystick_gremlin"
    "opentrack"
)

# Start processes after closing RSI Launcher
$PostProgList = @(
    #[PSCustomObject]@{ProgName = "exename"; ProgPath = "path\to\program\program.exe"; ProgDir = "path\to\program"; ProgArgs = "-Arg1=somearg"}
    [PSCustomObject]@{ProgName = "Greenshot"; ProgPath = "${env:ProgramFiles}\Greenshot\Greenshot.exe"; ProgDir = "${env:ProgramFiles}\Greenshot"}
)
