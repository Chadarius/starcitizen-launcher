# sc-stop services
# This scripts completes tasks that require admin privileges 
if (!([Security.Principal.WindowsPrincipal][Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)) {
    Start-Process PowerShell -WindowStyle Minimized -Verb RunAs "-NoProfile -ExecutionPolicy Bypass -Command `"cd '$pwd'; & '$PSCommandPath';`"";
    exit;
}

# Load config file
# rename sc-config-example.ps1 to sc-config.ps1 and configure settings
$basefile = (Get-Item $PSCommandPath ).BaseName
$basefile = $basefile.replace('-stopservices','')
$configfile = "$basefile-config.ps1" 

if (Test-Path -Path $configfile -PathType Leaf) {
    Write-Host "Configfile is: " $configfile
    . $PSScriptRoot\$configfile    
}
else {
    Write-Host "ERROR:"
    Write-Host "$configfile not found."
    Write-Host "Copy sc-config-example.ps1 to sc-config.ps1 and"
    Write-Host "edit appropriate settings"
    exit 1
}

Write-Host "Star Citizen Stop Services"
Write-Host "--------------------------"

function StopService {
    [CmdletBinding()]
    param ($ServiceName)
    try {
        Write-Host "Stopping $ServiceName"
        Stop-Service -Name $ServiceName -ErrorAction SilentlyContinue
    }
    catch {
        Write-Host "Stopping $ServiceName error or does not exist"
        $StartServiceError = $Error[0]
        Write-Host $StartServiceError
    }
}

function StartService {
    param ($ServiceName)
    try {
        Write-Host "Starting $ServiceName"
        Start-Service -Name $ServiceName -ErrorAction SilentlyContinue
    }
    catch {
        Write-Host "$ServiceName did not restart"
        $StartServiceError = $Error[0]
        Write-Host $StartServiceError
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
function CreateRegKey {
    param ($regpath, $keyname, $keyvalue, $keytype)
    # Create the key if it does not exist
    If (-NOT (Test-Path $regpath)) {
        Write-Host "Creating regpath: $regpath"
        New-Item -Path $regpath -Force | Out-Null
    }  
    # Set Value
    Write-Host "Configuring $keyname to $keyvalue as $keytype"
    New-ItemProperty -Path $regpath -Name $keyname -Value $keyvalue -PropertyType $keytype -Force
}

# Stop services
foreach ( $service in $StopServicesList ) {
    StopService $service
}

# Stop processes that require an admin to stop
foreach ( $process in $StopAdminProcs ) {
    StopProcess $process
}

# Modify Regisitry Settings
Write-Host "Modifying registry settings..."
If ($RegSettings) {
    foreach ( $RegEntry in $RegSettings) {
        CreateRegKey -regpath $RegEntry.regpath -keyname $RegEntry.keyname -keyvalue $RegEntry.keyvalue -keytype $RegEntry.keytype
    }
}

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

# Start Services after RSI Launcher is closed
foreach ( $service in $StopServicesList ) {
    StartService $service
}

exit 0
