# nav-arm-extensions
Extension for [ARM (Azure Resource Manager) templates for Microsoft Dynamics NAV](https://github.com/Microsoft/nav-arm-templates)

## How to Use
### Easy: UI
Go to http://aka.ms/getbcext. Its the same as http://aka.ms/getbc but with much more parameters. Read more about these way of deployment in [Freddys Blog](https://blogs.msdn.microsoft.com/freddyk/2017/11/03/1-800-getnav/).
Use the [RAW Path of the Extension Script](https://raw.githubusercontent.com/ChrisBlankDe/nav-arm-extensions/master/AdditionalAppsViaChoco.ps1) as "Final Setup Script Url"
### Like a Pro: The PowerShell Way
Same technology as above but more repeatable.
Workhop example:
```PowerShell
if(-not $Account){
  $Account = Connect-AzureRmAccount
}
$RgName = 'MyVmName'

$TemplateParameterObject = @{
  AcceptEula          = 'Yes' 
  vmName              = $RgName
  TimezoneId          = 'W. Europe Standard Time'
  RemoteDesktopAccess = '*'
  OperatingSystem     = 'Windows Server 2016'
  vmSize              = 'Standard_D2_v3'
  vmAdminUsername     = 'student'
  navAdminUsername    = 'student'
  adminPassword       = '**********'
  AssignPremiumPlan   = 'Yes'
  CreateTestUsers     = 'Yes'
  navDockerImage      = 'mcr.microsoft.com/businesscentral/onprem'
  RunWindowsUpdate    = 'No'
  FinalSetupScriptUrl = 'https://raw.githubusercontent.com/ChrisBlankDe/nav-arm-extensions/master/AdditionalAppsViaChoco.ps1'
  count               = 1
  offset              = 11
}

Get-AzureRmSubscription |  Out-GridView -Title "Select Subscription" -OutputMode Single | Set-AzureRmContext
$Null = New-AzureRmResourceGroup -Name $RgName -Location 'westeurope' 
New-AzureRmResourceGroupDeployment `
  -TemplateUri "https://raw.githubusercontent.com/Microsoft/nav-arm-templates/master/getnavworkshopvms.json" `
  -ResourceGroupName $RgName `
  -TemplateParameterObject $TemplateParameterObject `
  -Name ChrisBlankDeExample `
  -Mode Incremental
```
