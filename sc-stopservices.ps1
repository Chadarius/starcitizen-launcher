# sc-stop services
# Launch with admin rights
if (-Not ([Security.Principal.WindowsPrincipal] [Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole] 'Administrator')) {
    if ([int](Get-CimInstance -Class Win32_OperatingSystem | Select-Object -ExpandProperty BuildNumber) -ge 6000) {
     $CommandLine = "-WindowStyle Minimized -File `"" + $MyInvocation.MyCommand.Path + "`" " + $MyInvocation.UnboundArguments
     Start-Process -FilePath PowerShell.exe -Verb Runas -ArgumentList $CommandLine
     Exit
    }
   }

# Function to stop services
function StopService {
    [CmdletBinding()]
    param ($ServiceName)
    try {
        Write-Host "Stopping $ServiceName"
        Stop-Service -Name $ServiceName
    }
    catch {
        Write-Host "$ServiceName does not need to be stopped"
    }
    Stop-Service -Name $ServiceName
}

function StartService {
    param ($ServiceName)
    try {
        Write-Host "Starting $ServiceName"
        Start-Service -Name $ServiceName
    }
    catch {
        Write-Host "$ServiceName did not restart"
    }
}

function StopProcess {
    param (
        $ProcessName
    )
    try {
        Write-Host "Stopping $ProcessName"
        $ProcessRunning = Get-Process $ProcessName -ErrorAction SilentlyContinue
        if ($ProcessRunning) {
            Stop-Process -Name $ProcessName
        }        
    }
    catch {
        Write-Host "$ProcessName not found"
    }
}

function StartProg {
    param ($ProgName, $ProgPath, $ProgDir, $ProgArgs)
    $ProgRunning = Get-Process $ProgName -ErrorAction SilentlyContinue
    if (!$ProgRunning) {
        If (Test-Path -Path $ProgPath -PathType Leaf) {
            Start-Process -FilePath $ProgPath -WorkingDirectory $ProgDir
        }
    }
}

# stop the services
# Print Spooler
StopService -ServiceName "spooler"
# Windows Hotspot Service
StopService -ServiceName "icssvc"
# Stop Window Image Aquisition service
#StopService -ServiceName "stisvc"
#Stop Connected User Experience and Telemetry
StopService -ServiceName "DiagTrack"
# Stop Geolocation Service
# StopService -ServiceName "lfsvc"
# Windows Biometric Service
#StopService -ServiceName "WbioSrvc"
# Program Compatibility Assistant Service
#StopService -ServiceName "PcaSvc"
# Downloaded Maps Manager - Who even uses Microsoft Maps?
# StopService -ServiceName "MapsBroker"
# Touch Keyboard and Handwriting Service
#StopService -ServiceName "TabletInputService"
# Windows Search
StopService -ServiceName "WSearch"
# Security Center
#StopService -ServiceName "wscsvc"
# Diagnostic Policy Service
#StopService -ServiceName "DPS"
# IP Helper
#StopService -ServiceName "iphlpsvc"
# TCP/IP Netbios Helper
#StopService -ServiceName "lmhosts"

# Stop MSIAfterburner and Riva Tuner
# Then interfere with OBS Studio and are unstable with Star Citizen
# They also slow down FPS
StopProcess -ProcessName "MSIAfterburner"
StopProcess -ProcessName "rtss"
StopProcess -ProcessName "rtssHooksLoader64"

# Set CPU Priority for Star Citizen
# [HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Image File Execution Options\StarCitizen.exe\PerfOptions] 
#"CpuPriorityClass"=dword:PRIORITY
$regpath = 'HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Image File Execution Options\StarCitizen.exe\PerfOptions'
$keyname = 'CpuPriorityClass'
$keyvalue = '3'
# Create the key if it does not exist
If (-NOT (Test-Path $regpath)) {
    New-Item -Path $regpath -Force | Out-Null
  }  
# Set Value
New-ItemProperty -Path $regpath -Name $keyname -Value $keyvalue -PropertyType DWORD -Force


# Start Process Explorer
#StartProg -ProgName "procexp64" -ProgPath "D:\Users\chada\nextcloud\bin\procexp64.exe" -ProgDir "D:\Users\chada\nextcloud\bin"


# Set DNS for optimal speed - Cloudflair DNS servers
#Set-DNSClientServerAddress "Ethernet" -ServerAddresses ("1.1.1.1","192.168.0.8")
#Set-DNSClientServerAddress "Wi-Fi 2" -ServerAddresses ("1.1.1.1","192.168.0.8")



# Wait for RSI Launcher to be closed then start things back up again.
$launcherprocess = (Get-Process -Name "RSI Launcher" -ErrorAction SilentlyContinue)
try {
    Write-Host "Waiting for RSI Launcher to close"
    Get-Process $launcherprocess.ProcessName | Wait-Process
    Write-Host "$launcherprocess no longer running"
}
catch {
    Write-Host "RSI Launcher is not running"
}
finally {
    Write-Host "RSI Launcher is not running" 
}

# Set DNS back to DHCP DNS only
#Set-DNSClientServerAddress "Ethernet"-ResetServerAddresses
#Set-DNSClientServerAddress "Wi-Fi 2" -ResetServerAddresses

Write-host "Starting select system services again"
# Start Print Spooler
StartService -ServiceName "spooler"
# Windows Biometric Service
#StartService -ServiceName "WbioSrvc"
# Touch Keyboard and Handwriting Service
#StartService -ServiceName "TabletInputService"
# Windows Image Aquisition
#StartService -ServiceName "StiSvc"
# Windows Search
# StartService -ServiceName "WSearch"
# Security Center
#StartService -ServiceName "wscsvc"
# Geolocation Service
# StartService -ServiceName "lfsvc"
# Program Compatability Service
#StartService -ServiceName "PcaSvc"
# Diagnostic Policy Service
#StartService -ServiceName "DPS"
# IP Helper
#StartService -ServiceName "iphlpsvc"
# TCP/IP Netbios Helper
#StartService -ServiceName "lmhosts"


exit 0