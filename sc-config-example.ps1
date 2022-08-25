# Rename this file to sc-config.ps1

# Set path of Star Citizen
# Default path is
# $SCPath = "${env:ProgramFiles}\Roberts Space Industries"
$SCPath = "${env:ProgramFiles}\Roberts Space Industries"
Write-Host "Star Citizen Path is " $SCPath
Write-Host ""

# Stop Process list
# List out the EXE names of all the processes you want to stop
# Open up Task Manager, use the Details tab and look for the process name.
# Don't add .exe to the process name. That is assumed
$StopProcessList = @(
    "steam"
    "steamwebhelper"
    "GreenShot"
    "RainMeter"
    "EpicGamesLauncher"
)

# Start Program List
# [PSCustomObject]@{ProgName = "exename"; ProgPath = "path\to\program\program.exe"; ProgDir = "path\to\program"; ProgArgs = '-Arg1=somearg'}
# If you specify ProgName it will not launch if the process is running already.
# If you do not specify the ProgName it will launch the program again.
# Required parameters: ProgPath, ProgDir
# Optional paramters: Progname, ProgArgs
# You must have at least the RSI Launcher in this list as per below
$ProgList = @(
    #[PSCustomObject]@{ProgName = "exename"; ProgPath = "path\to\program\program.exe"; ProgDir = "path\to\program"; ProgArgs = "-Arg1=somearg"}
    # Just add a new line in the $Proglist array between the {} above
    #[PSCustomObject]@{ProgName = "joystick_gremlin"; ProgPath = "${env:ProgramFiles(x86)}\H2ik\Joystick Gremlin\joystick_gremlin.exe"; ProgDir = "${env:ProgramFiles(x86)}\H2ik\Joystick Gremlin"}
    #[PSCustomObject]@{ProgName = "VoiceAttack"; ProgPath = "${env:ProgramFiles}\VoiceAttack\VoiceAttack.exe"; ProgDir = "${env:ProgramFiles}\VoiceAttack"}
    [PSCustomObject]@{ProgName = "RSI Launcher"; ProgPath = "$SCPath\RSI Launcher\RSI Launcher.exe"; ProgDir = "$SCPath\RSI Launcher"}
 
 )
 
# Set Primary monitor if you have more than one
# The script checks to see if you have more than one screen
# If you do not, it will not run the MultiMonitorTool command
# This uses the free utility MultiMonitor
# https://www.nirsoft.net/utils/multi_monitor_tool.html
# Depending on your configuration your external monitor may not be "Display2".
# It could be almost any number. Use the utility to see which number you should use below.
# It works best if you find the "Monitor ID" using MultiMonitorTool
# Example:
#  My Scepter external monitor's Monitor ID is
#  MONITOR\SPT2401\{4d36e96e-e325-11ce-bfc1-08002be10318}\0006
#  This GUID is consistent no matter what stupid Display number Windows assigns to it
$PrimaryMonitor = "MONITOR\SPT2401\{4d36e96e-e325-11ce-bfc1-08002be10318}\0006"

# Stop Services command arguments
# This powershell script will run as a privileged admin user
$stopservicescmd = "-WindowStyle Minimized -file `"" + $scriptdir + "\$basefile-stopservices.ps1`""

# RegSettings Array
# Use at your own risk! Back up your registry!
# You can leave this blank
$RegSettings = @(
    #[PSCustomObject]@{regpath = "HKLM:\Reg\Path\Here"; keyname = "keyname"; keyvalue = "keyvalue"; keytype = "type"} # keytypes (String, ExpandString, Binary, DWord, MultiString, QWord)
    # Set Higher CPU Priority for Star Citizen
    # [HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Image File Execution Options\StarCitizen.exe\PerfOptions] 
    #"CpuPriorityClass"=3 (DWORD)
    #[PSCustomObject]@{regpath = "HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Image File Execution Options\StarCitizen.exe\PerfOptions"; keyname = "CpuPriorityClass"; keyvalue = "3"; keytype = "DWord"}
)

# Stop Services List
# Any service listed here will be stopped
# The same services list will be restarted again after the RSI Launcher is closed
# You can leave this blank
$StopServicesList = @(
    #"spooler"               # Print spooler
    #"icssvc"                # Hotspot
    #"DiagTrack"             # Connected User Experience and Telemetry
    #"WSearch"               # Windows Search
    #"lfsvc"                 # Stop Geolocation Service
    #"MapsBroker"            # Downloaded Maps Manager - Who even uses Microsoft Maps?
    #"wscsvc"                # Security Center
    #"DPS"                   # Diagnostic Policy Service
    #"iphlpsvc"              # IP Helper
    #"WbioSrvc"              # Windows Biometric Service
    #"PcaSvc"                # Program Compatibility Assistant Service
    #"TabletInputService"    # Touch Keyboard and Handwriting Service
    #"stisvc"                # Stop Window Image Aquisition service
    #"lmhosts"               # TCP/IP Netbios Helper
)

# Stop Admin Processes
# Stop any background programs that need admin privileges to shutdown
# You can leave this blank
$StopAdminProcs = @(
    # "MSIAfterburner" # Slow FPS and OBS issues when MSIAfterburner is running
    # "rtss" # Slow FPS and OBS issues when Riva Tuner is running
    # "rtssHooksLoader64" # Slow FPS and OBS issues when Riva Tuner is running
)

# Stop Processes After closing RSI Launcher
# You can leave this blank
$PostStopList = @(
    # "VoiceAttack"
    # "joystick_gremlin"
    # "opentrack"
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
