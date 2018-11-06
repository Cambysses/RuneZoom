# VARIABLES

# You can find this in regedit under HKCU\Control Panel\Desktop\PerMonitorSettings
$MonitorID = "ACR0319LX2AA0024210_28_07DE_87^6F8C854534D327DB95D7BCD42DFDEE8C" 

# You can find this with the PowerShell cmdlet Get-PnPDevice
$GPUID = "NVIDIA GeForce GTX 970"

# Location on your computer of JagexLauncher.exe
$EXEPath = "C:\Users\Bill\jagexcache\jagexlauncher\bin\JagexLauncher.exe" 

function Refresh-VideoDriver
{
    param
    (
        [Parameter(Mandatory)][string]$GPUID
    )

    # Enables then disables GPU driver.
    Get-PnpDevice -FriendlyName $GPUID | Disable-PnpDevice -Confirm:$False
    Get-PnpDevice -FriendlyName $GPUID | Enable-PnpDevice -Confirm:$False
}

function Adjust-DPIScaling
{
    param
    (
        [Parameter(Mandatory)][string]$MonitorID,
        [Parameter(Mandatory)][int]$ScalingLevel
    )

    <#
        Scaling levels:

        0 = 100%
        1 = 125%
        2 = 150%
        3 = 175%
    #>

    Set-ItemProperty -Path "HKCU:Control Panel\Desktop\PerMonitorSettings\$MonitorID" -Name "DpiValue" -Value $ScalingLevel
}

function Main
{
    # Set scaling to 150%.
    Adjust-DPIScaling -MonitorID $MonitorID -ScalingLevel 2

    # Restart device driver.
    Refresh-VideoDriver -GPUID $GPUID

    # Launch game.
    Start-Process -FilePath $EXEPath -ArgumentList "oldschool"
    Start-Sleep 1

    # Wait for game to exit.
    while(Get-Process -Name "JagexLauncher" -ErrorAction SilentlyContinue)
    {
        Start-Sleep 1
    }

    # Set scaling to 100%.
    Adjust-DPIScaling -MonitorID $MonitorID -ScalingLevel 0

    # Restart device driver.
    Refresh-VideoDriver -GPUID $GPUID
}

Main