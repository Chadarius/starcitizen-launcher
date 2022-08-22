# Rename this file to sc-config.ps1

# Set path of Star Citizen
# Default path is
# $SCPath = "${env:ProgramFiles}\Roberts Space Industries"
$SCPath = "${env:ProgramFiles}\Roberts Space Industries"
Write-Host "Star Citizen Path is " $SCPath
Write-Host ""

# Stop Process list
# List out the EXE names of all the processes you want to stop
$StopProcessList = @(
    "steam"
    "steamwebhelper"
    "GreenShot"
    "RainMeter"
    "EpicGamesLauncher"
)

# Start Program List
# [PSCustomObject]@{ProgName = "exename"; ProgPath = "path\to\program\program.exe"; ProgDir = "path\to\program"; ProgArgs = "-Arg1=somearg"}
# If you specify ProgName it will not launch if the process is running already.
# If you do not specify the ProgName it will launch the program again.
# Required parameters: ProgPath, ProgDir
# Optional paramters: Progname, ProgArgs
$ProgList = @(
    #[PSCustomObject]@{ProgName = "exename"; ProgPath = "path\to\program\program.exe"; ProgDir = "path\to\program"; ProgArgs = "-Arg1=somearg"}
    [PSCustomObject]@{ProgName = "RSI Launcher"; ProgPath = "$SCPath\RSI Launcher\RSI Launcher.exe"; ProgDir = "$SCPath\RSI Launcher"}
 )
    # Old versions of Chrome could be installed in ${env:ProgramFiles(x86)}
    #[PSCustomObject]@{ProgDir = "${env:ProgramFiles(x86)}\Google\Chrome\Application"; ProgPath = "${env:ProgramFiles(x86)}\Google\Chrome\Application\chrome.exe"; ProgArgs ='https://studio.youtube.com/channel/UCAIcbgAh3PXpf2uIQcuLw7g --user-data-dir=D:\Users\chada\chrome2'}
    # Other examples of programs that I launch that can be added
    # Just add a new line in the $Proglist array between the {} above
    #[PSCustomObject]@{ProgName = "mumble"; ProgPath = "${env:ProgramFiles(x86)}\Mumble\client\mumble.exe"; ProgDir = "${env:ProgramFiles(x86)}\Mumble\client"}
    #[PSCustomObject]@{ProgName = "joystick_gremlin"; ProgPath = "${env:ProgramFiles(x86)}\H2ik\Joystick Gremlin\joystick_gremlin.exe"; ProgDir = "${env:ProgramFiles(x86)}\H2ik\Joystick Gremlin"}
    #[PSCustomObject]@{ProgName = "VoiceAttack"; ProgPath = "${env:ProgramFiles}\VoiceAttack\VoiceAttack.exe"; ProgDir = "${env:ProgramFiles}\VoiceAttack"}
    #[PSCustomObject]@{ProgName = "opentrack"; ProgPath = "D:\Users\chada\nextcloud\Documents\star citizen\opentrack-2022.2.0-portable\install\opentrack.exe"; ProgDir = "D:\Users\chada\nextcloud\Documents\star citizen\opentrack-2022.2.0-portable\install"}
    #[PSCustomObject]@{ProgDir = "${env:ProgramFiles}\Google\Chrome\Application"; ProgPath = "${env:ProgramFiles}\Google\Chrome\Application\chrome.exe"; ProgArgs ='https://studio.youtube.com/channel/UCAIcbgAh3PXpf2uIQcuLw7g --user-data-dir=D:\Users\chada\chrome2'}
    #[PSCustomObject]@{ProgName = "obs64"; ProgPath = "D:\Users\chada\nextcloud\portable-apps\obs-studio star citizen\bin\64bit\obs64.exe"; ProgDir = "D:\Users\chada\nextcloud\portable-apps\obs-studio star citizen\bin\64bit"}

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

# Stop Services command arguments
# This powershell script will run as a privileged admin user
$stopservicescmd = "-WindowStyle Minimized -file `"" + $scriptdir + "\$basefile-stopservices.ps1`""

# RegSettings Array
# Use at your own risk! Back up your registry!
$RegSettings = @(
    #[PSCustomObject]@{regpath = "HKLM:\Reg\Path\Here"; keyname = "keyname"; keyvalue = "keyvalue"; keytype = "type"} # keytypes (String, ExpandString, Binary, DWord, MultiString, QWord)
    # Set CPU Priority for Star Citizen
    # [HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Image File Execution Options\StarCitizen.exe\PerfOptions] 
    #"CpuPriorityClass"=3 (DWORD)
    [PSCustomObject]@{regpath = "HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Image File Execution Options\StarCitizen.exe\PerfOptions"; keyname = "CpuPriorityClass"; keyvalue = "3"; keytype = "DWord"}
)

# Stop Services List
# Any service listed here will be stopped
# The same services list will be restarted again after the RSI Launcher is closed
$StopServicesList = @(
    "spooler"               # Print spooler
    "icssvc"                # Hotspot
    "DiagTrack"             # Connected User Experience and Telemetry
    "WSearch"               # Windows Search
    "lfsvc"                 # Stop Geolocation Service
    "MapsBroker"            # Downloaded Maps Manager - Who even uses Microsoft Maps?
    #"wscsvc"               # Security Center
    #"DPS"                  # Diagnostic Policy Service
    #"iphlpsvc"             # IP Helper
    #"WbioSrvc"             # Windows Biometric Service
    #"PcaSvc"               # Program Compatibility Assistant Service
    #"TabletInputService"   # Touch Keyboard and Handwriting Service
    #"stisvc"               # Stop Window Image Aquisition service
    #"lmhosts"              # TCP/IP Netbios Helper
)

# Stop Admin Processes
# Stop any background programs that need admin privileges to shutdown
$StopAdminProcs = @(
    "MSIAfterburner"
    "rtss"
    "rtssHooksLoader64"
)

# Stop Processes After closing RSI Launcher
$PostStopList = @(
    "VoiceAttack"
    "joystick_gremlin"
    "opentrack"
)

# Start processes after closing RSI Launcher
# [PSCustomObject]@{ProgName = "exename"; ProgPath = "path\to\program\program.exe"; ProgDir = "path\to\program"; ProgArgs = "-Arg1=somearg"}
# If you specify ProgName it will not launch if the process is running already.
# If you do not specify the ProgName it will launch the program again.
# Required parameters: ProgPath, ProgDir
# Optional paramters: Progname, ProgArgs
$PostProgList = @(
    #[PSCustomObject]@{ProgName = "exename"; ProgPath = "path\to\program\program.exe"; ProgDir = "path\to\program"; ProgArgs = "-Arg1=somearg"}
    [PSCustomObject]@{ProgName = "Greenshot"; ProgPath = "${env:ProgramFiles}\Greenshot\Greenshot.exe"; ProgDir = "${env:ProgramFiles}\Greenshot"}
)
