# THIS WILL ONLY WORK ON WINDOWS 10 #

# You can find this in regedit under HKCU\Control Panel\Desktop\PerMonitorSettings.
# This may not appear unless you have already modified your DPI scaling manually.
$MonitorID = "ACR0319LX2AA0024210_28_07DE_87^6F8C854534D327DB95D7BCD42DFDEE8C" 

# Location on your computer of JagexLauncher.exe
$LauncherPath = "C:\Users\Bill\jagexcache\jagexlauncher\bin\JagexLauncher.exe" 

function Get-VideoCard 
{    
    $VideoDevices = Get-PnpDevice -Class Display

    if ($VideoDevices.Count -gt 1)
    {
        return $VideoDevices[0].Name
    } 
    else
    {
        return $VideoDevices.Name 
    }
}

function Restart-VideoDriver
{
    param
    (
        [Parameter(Mandatory)][string]$GPUName
    )

    # Enables then disables GPU driver.
    Get-PnpDevice -FriendlyName $GPUName | Disable-PnpDevice -Confirm:$False
    Get-PnpDevice -FriendlyName $GPUName | Enable-PnpDevice -Confirm:$False
}

function Set-DPIScaling
{
    param
    (
        [Parameter(Mandatory)][string]$MonitorID,
        [Parameter(Mandatory)][int]$ScalingLevel
    )

    # The scaling integer can differ depending on monitor. 
    # For me, 0 is 100% and 2 is 150%. 
    # But you may need to play around with this.

    Set-ItemProperty -Path "HKCU:Control Panel\Desktop\PerMonitorSettings\$MonitorID" -Name "DpiValue" -Value $ScalingLevel
}

function Main
{
    # Gets video card name.
    $GPUName = Get-VideoCard

    # Set scaling to 150%.
    Set-DPIScaling -MonitorID $MonitorID -ScalingLevel 2
    Restart-VideoDriver -GPUID $GPUName

    # Launch game and wait until it is closed.
    Start-Process -FilePath $LauncherPath -ArgumentList "oldschool" -Wait

    # Set scaling to 100%.
    Set-DPIScaling -MonitorID $MonitorID -ScalingLevel 0
    Restart-VideoDriver -GPUID $GPUName
}

Main