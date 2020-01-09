#   Description:
# This script will use Windows package manager to bootstrap Chocolatey and
# install a list of packages. Script will also install Sysinternals Utilities
# into your default drive's root directory.

$packages = @(
    #"notepadplusplus.install"
    #"peazip.install"
    "7zip.install"
    #"aimp"
    #"audacity"
    #"autoit"
    #"classic-shell"
    #"filezilla"
    #"firefox"
    #"gimp"
    "git.install"
    #"google-chrome-x64"
    #"imgburn"
    #"keepass.install"
    #"paint.net"
    "putty"
    #"python"
    #"qbittorrent"
    #"speedcrunch"
    "sysinternals"
    #"thunderbird"
    #"vlc"
    "vim"
    #"windirstat"
    #"wireshark"
)

$Env:ChocolateyToolsLocation = ("$Env:ProgramFiles(x86)" + "\DevTools")
HKEY_LOCAL_MACHINE\
Set-ItemProperty "HKLM:\SYSTEM\CurrentControlSet\Control\Session Manager\Environment" "ChocolateyToolsLocation" $Env:ChocolateyToolsLocation

echo "Setting up Chocolatey software package manager"
Set-ExecutionPolicy Bypass -Scope Process -Force; iex ((New-Object System.Net.WebClient).DownloadString('https://chocolatey.org/install.ps1'))

echo "Setting up Full Chocolatey Install"
$chocopath = (Get-command choco)
& $chocopath "upgrade all -y"
choco install chocolatey-core.extension --force

echo "Creating daily task to automatically upgrade Chocolatey packages"
# adapted from https://blogs.technet.microsoft.com/heyscriptingguy/2013/11/23/using-scheduled-tasks-and-scheduled-jobs-in-powershell/
$ScheduledJob = @{
    Name = "Chocolatey Daily Upgrade"
    ScriptBlock = {choco upgrade all -y}
    Trigger = New-JobTrigger -Daily -at 2am
    ScheduledJobOption = New-ScheduledJobOption -RunElevated -MultipleInstancePolicy StopExisting -RequireNetwork
}
Register-ScheduledJob @ScheduledJob

echo "Installing Packages"
$packages | %{choco install $_ --force -y}

#echo "Installing Sysinternals Utilities to C:\Sysinternals"
#$download_uri = "https://download.sysinternals.com/files/SysinternalsSuite.zip"
#$wc = new-object net.webclient
#$wc.DownloadFile($download_uri, "/SysinternalsSuite.zip")
#Add-Type -AssemblyName "system.io.compression.filesystem"
#[io.compression.zipfile]::ExtractToDirectory("/SysinternalsSuite.zip", "/Sysinternals")
#echo "Removing zipfile"
#rm "/SysinternalsSuite.zip"
