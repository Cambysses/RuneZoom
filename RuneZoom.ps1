# Variables
$MonitorID = "ACR0319LX2AA0024210_28_07DE_87^6F8C854534D327DB95D7BCD42DFDEE8C" # You can find this in regedit under HKCU\Control Panel\Desktop\PerMonitorSettings
$GPUID = "NVIDIA GeForce GTX 970" # You can find this with the PowerShell cmdlet Get-PnPDevice
$EXEPath = "C:\Users\Bill\jagexcache\jagexlauncher\bin\JagexLauncher.exe" # Location on your computer of JagexLauncher.exe


# Set scaling to 150%.
Set-ItemProperty -Path "HKCU:Control Panel\Desktop\PerMonitorSettings\$MonitorID" -Name "DpiValue" -Value 2

# Restart device driver.
Get-PnpDevice -FriendlyName $GPUID | Disable-PnpDevice -Confirm:$False
Get-PnpDevice -FriendlyName $GPUID | Enable-PnpDevice -Confirm:$False

# Launch game.
Start-Process -FilePath $EXEPath -ArgumentList "oldschool"

# Wait for game to exit.
while(Get-Process -Name "JagexLauncher" -ErrorAction SilentlyContinue)
{
    Start-Sleep 1
}

# Set scaling to 100%.
Set-ItemProperty -Path "HKCU:Control Panel\Desktop\PerMonitorSettings\$MonitorID" -Name "DpiValue" -Value 0

# Restart device driver.
Get-PnpDevice -FriendlyName $GPUID | Disable-PnpDevice -Confirm:$False
Get-PnpDevice -FriendlyName $GPUID | Enable-PnpDevice -Confirm:$False