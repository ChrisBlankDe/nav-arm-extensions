#CopyBlock from https://github.com/Microsoft/nav-arm-templates/blob/master/Install-VS2017Community.ps1
if (!(Test-Path function:Log)) {
  function Log([string]$line, [string]$color = "Gray") {
    ("<font color=""$color"">" + [DateTime]::Now.ToString([System.Globalization.DateTimeFormatInfo]::CurrentInfo.ShortTimePattern.replace(":mm",":mm:ss")) + " $line</font>") | Add-Content -Path "c:\demo\status.txt"
    Write-Host -ForegroundColor $color $line 
  }
}
#EndCopyBlock

function Add-VSCodeSetting {
  param
  (
    [String]
    [Parameter(Mandatory)]
    [ValidateNotNull()]
    $Name,
    [Object]
    [Parameter(Mandatory)]
    $Value
  )
  process
  {
    $SettingFile = "$env:APPDATA\Code\User\settings.json"
    New-Item -ItemType Directory -Force -Path (Split-Path -Path $SettingFile) | Out-Null
    if (-not (Test-Path -Path $SettingFile))
    {
      '{}' | Out-File -FilePath $SettingFile -Encoding utf8
    }
    get-content -Path $SettingFile -Raw | ConvertFrom-Json | Add-Member -MemberType NoteProperty -Name $name -Value $Value -Force -PassThru | ConvertTo-Json | Set-Content -Path $SettingFile
  }
}

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

Log "Install Git"
choco install git.install

Log "Install Fiddler"
choco install fiddler

Log "Install Postman"
choco install postman

Log "Install Sourcetree"
choco install sourcetree

Log "Install visualstudio2017community"
choco install visualstudio2017community 

Log "Install visualstudio2017-workload-netweb"
choco install visualstudio2017-workload-netweb

Log "Download Microsoft.RdlcDesigner"
$Url = "https://probitools.gallerycdn.vsassets.io/extensions/probitools/microsoftrdlcreportdesignerforvisualstudio-18001/14.2/1517419538388/238792/3/Microsoft.RdlcDesigner.vsix"
$Target = "C:\DOWNLOAD\Microsoft.RdlcDesigner.vsix"
(New-Object -TypeName System.Net.WebClient).DownloadFile($Url, $Target)

Log "Install Microsoft.RdlcDesigner"
$VsixInstaller = "C:\Program Files (x86)\Microsoft Visual Studio\2017\Community\Common7\IDE\VSIXInstaller"
$Arguments = "/quiet $Target"
Start-Process -FilePath $VsixInstaller -ArgumentList $Arguments -Wait

#Add VSCode Extensions
Log "Install VSCode Extension: Git Lens"
code --install-extension eamodio.gitlens
Log "Install VSCode Extension: CRS AL Language Extension"
code --install-extension waldo.crs-al-language-extension
Log "Install VSCode Extension: AL Code Outline"
code --install-extension andrzejzwierzchowski.al-code-outline
Log "Install VSCode Extension: AL Variable Helper"
code --install-extension rasmus.al-var-helper
Log "Install VSCode Extension: PowerShell"
code --install-extension ms-vscode.PowerShell
Log "Install VSCode Extension: vscode-icons"
code --install-extension vscode-icons-team.vscode-icons

Log "Set VSCode Settings"
Add-VSCodeSetting -Name "breadcrumbs.enabled" -Value $true
Add-VSCodeSetting -Name "workbench.iconTheme" -Value "vscode-icons"
Add-VSCodeSetting -Name "workbench.editor.highlightModifiedTabs" -Value $true
Add-VSCodeSetting -Name "editor.formatOnPaste" -Value $true
Add-VSCodeSetting -Name "editor.formatOnSave" -Value $true
Add-VSCodeSetting -Name "files.trimFinalNewlines" -Value $true
Add-VSCodeSetting -Name "al.browser" -Value "Firefox"
Add-VSCodeSetting -Name "CRS.DisableDefaultAlSnippets" -Value $true

Log "nav-arm-extensions finished. More Infos at https://github.com/ChrisBlankDe/nav-arm-extensions" -Color Green

