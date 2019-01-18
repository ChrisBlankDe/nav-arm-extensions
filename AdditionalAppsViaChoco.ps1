#CopyBlock from https://github.com/Microsoft/nav-arm-templates/blob/master/Install-VS2017Community.ps1
if (!(Test-Path function:Log)) {
    function Log([string]$line, [string]$color = "Gray") {
        ("<font color=""$color"">" + [DateTime]::Now.ToString([System.Globalization.DateTimeFormatInfo]::CurrentInfo.ShortTimePattern.replace(":mm",":mm:ss")) + " $line</font>") | Add-Content -Path "c:\demo\status.txt"
        Write-Host -ForegroundColor $color $line 
    }
}
#EndCopyBlock

#Install Choco
Log "Install Choco"
Set-ExecutionPolicy Bypass -Scope Process -Force; iex ((New-Object System.Net.WebClient).DownloadString('https://chocolatey.org/install.ps1'))
choco feature enable -n allowGlobalConfirmation

Log "Install 7zip"
choco install 7zip.install

Log "Install notepadplusplus"
choco install notepadplusplus.install --x86

Log "Install multilingualapptoolkit"
choco install multilingualapptoolkit

Log "Install adobereader"
choco install adobereader

Log "Install firefox"
choco install firefox

Log "Install visualstudio2017community"
choco install visualstudio2017community 

Log "Install visualstudio2017-workload-netweb"
choco install visualstudio2017-workload-netweb

Log "Install Microsoft.RdlcDesigner"
$Url = "https://probitools.gallerycdn.vsassets.io/extensions/probitools/microsoftrdlcreportdesignerforvisualstudio-18001/14.2/1517419538388/238792/3/Microsoft.RdlcDesigner.vsix"
$target = "C:\DOWNLOAD\Microsoft.RdlcDesigner.vsix"
(New-Object System.Net.WebClient).DownloadFile($url, $target)
$VsixInstaller = "C:\Program Files (x86)\Microsoft Visual Studio 11.0\Common7\IDE\VSIXInstaller.exe"
$Arguments = "/quiet $target"
start-process $VsixInstaller $Arguments
Log "nav-arm-extensions finished" -Color Green
