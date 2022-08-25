# Star Citizen Launcher
# Beta v0.1
# csutton@chadarius.com
# Use at your own risk!
# See LICENSE file for MIT licensing

# Description:
# This will manage processes, manage services, set primary monitor, and launch Star Citizen
# Then it will monitor for the StarCitizen.exe and Launcher and
# relaunch any processes and services

Write-Host "Star Citizen Launcher"
Write-Host "---------------------"
# Set the current path of the script
$scriptdir = $PSScriptRoot
Write-Host "Scriptdir is " $scriptdir

# Load config file
# rename sc-config-example.ps1 to sc-config.ps1 and configure settings
$basefile = (Get-Item $PSCommandPath ).BaseName
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

Function StopProcess {
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
    Write-Host "ProgPath: $ProgPath"
    If ($ProgName) {$ProgRunning = Get-Process $ProgName -ErrorAction SilentlyContinue}

    # If the ProgName process is not running the launch
    # If $ProgName is nul it will always launch
    if (!$ProgRunning) {
        # If the path to the ProgPath exists then start the program
        If (Test-Path -Path $ProgPath -PathType Leaf) {
            Write-Host "Starting $ProgName..."
            If (!$ProgArgs) {Start-Process -FilePath $ProgPath -WorkingDirectory $ProgDir}
            If ($ProgArgs) {Start-Process -FilePath $ProgPath -WorkingDirectory $ProgDir -ArgumentList $ProgArgs}
        }
        else {
            Write-Host "Error: Path does not exist"
            Write-Host "ProgPath:" $ProgPath
            return 1
        }
    }
}

function SetPrimaryMonitor {
    # Set second monitor as primary if more than 1 display
    # This uses the free utility MultiMonitor
    # https://www.nirsoft.net/utils/multi_monitor_tool.html
    # Depending on your configuration your external monitor may not be "Display2".
    # It could be almost any number. Use the utility to see which number you should use below.
    # It works best if you find the Monitor ID using MultiMonitorTool
    # Example:
    #  My Scepter external monitor's Monitor ID is
    #  MONITOR\SPT2401\{4d36e96e-e325-11ce-bfc1-08002be10318}\0006
    #  This GUID is consistent no matter what stupid Display number Windows assigns
    param ($DisplayNum)
    $monitors = @(Get-CimInstance -Namespace root\wmi -ClassName WmiMonitorBasicDisplayParams | where-object { $_.Active }).Length
    Write-Host "There are" $monitors "display(s)"
    If ((Get-Command ".\MultiMonitorTool.exe" -ErrorAction SilentlyContinue) -eq $null) 
    { 
        Write-Host "ERROR: "
        Write-Host "Unable to find MultiMonitorTool.exe in your PATH"
        Write-Host "Please download MultiMonitorTool from"
        Write-Host "  https://www.nirsoft.net/utils/multi_monitor_tool.html"
        Write-Host ""
        exit 1
    }
    # Only do this if more than one monitor is detected
    If ($monitors -gt 1) {
        Write-Host "Multiple Displays - Switching primary montitor"
        Start-Process "MultiMonitorTool.exe" -ArgumentList "/SetPrimary $DisplayNum" -WorkingDirectory "$PSScriptRoot"
        Write-Host ""
    }
}

# Stop Processes Before Launch of Star Citizen
# Edit StopProcessList in sc-config.ps1
Write-Host "Stopping Procceses..."
foreach ($process in $StopProcessList) {
    StopProcess $process
}

# Clear Star Citizen Cache $SCPath\StarCitizen\LIVE\USER\Client\0\shaders\cache
#Remove-Item $SCPath"\StarCitizen\LIVE\USER\Client\0\shaders\cache\*" -Recurse

# Set the Primary monitor if more than 1 monitor is connected
SetPrimaryMonitor -DisplayNum $PrimaryMonitor

# Hide taskbar
&{$p='HKCU:SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\StuckRects3';$v=(Get-ItemProperty -Path $p).Settings;$v[8]=3;&Set-ItemProperty -Path $p -Name Settings -Value $v;&Stop-Process -f -ProcessName explorer}

# Start Programs
# StartProg -ProgName $ProgListNode.ProgName -ProgPath $ProgListNode.ProgPath -ProgDir $ProgListNode.ProgDir -ProgArgs $ProgListNode.ProgArgs
Write-Host "Starting Programs..."
foreach ( $ProgListNode in $ProgList ) {
    StartProg -ProgName $ProgListNode.ProgName -ProgPath $ProgListNode.ProgPath -ProgDir $ProgListNode.ProgDir -ProgArgs $ProgListNode.ProgArgs 
}

# Shutdown stuff with elevated user
# Stop Services
Write-host "Launching: PowerShell.exe" $stopservicescmd
Start-Process PowerShell.exe $stopservicescmd

# Wait for RSI Launcher and StarCitizen to be closed then start things back up again.
#Wait-Process -Name "RSI Launcher"
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

# $PostStopList After RSI Launcher is closed
Write-Host "Stopping Programs after closing RSI Launcher..."
foreach ($process in $PostStopList) {
    StopProcess $process
}

# Set first monitor as primary
SetPrimaryMonitor -DisplayNum 1

# Startup Select Background Programs again
Write-Host "Starting Programs after closing RSI Launcher Programs..."
foreach ( $ProgListNode in $PostProgList ) {
    StartProg -ProgName $ProgListNode.ProgName -ProgPath $ProgListNode.ProgPath -ProgDir $ProgListNode.ProgDir -ProgArgs $ProgListNode.ProgArgs 
}

# Show Taskbar
&{$p='HKCU:SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\StuckRects3';$v=(Get-ItemProperty -Path $p).Settings;$v[8]=2;&Set-ItemProperty -Path $p -Name Settings -Value $v;&Stop-Process -f -ProcessName explorer}

Write-host "Closing Star Citizen Launch"