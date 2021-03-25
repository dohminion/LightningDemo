#region System config
Get-LocalGroupMember -Group "Administrators"
Get-ADGroupMember SEC-ServerAdmins | Select-Object samaccountname
Get-LocalGroupMember -Group "Remote Desktop Users"

<#UAC policy config
User Account Control: Behavior of the elevation prompt for administrators in Admin Approval Mode:
- Prompt for Consent on the secure desktop

User Account Control: Behavior of the elevation prompt for standard users:
- Prompt for credentials on the secure desktop
#>
#endregion System Config

#region Manually Cut and Paste PW to run
$AdminCred = Get-Credential -UserName pkilab\SysAdmin
Start-Process powershell.exe -Credential $AdminCred -ArgumentList "Start-Process powershell.exe -Verb runAs"
#endregion

#region Pull Passwords from external system
$mySecret = Get-Secret -Vault AzKeyVault -Name DAPW
#build a Credential Object using the retreived password
$DACred = New-Object PSCredential "pkilab\MyLAdmin", $mySecret
$mySecret = $null
Start-Process powershell.exe -Credential $DACred -ArgumentList "Start-Process pwsh.exe -Verb runAs"
Start-Process powershell.exe -Credential $DACred -ArgumentList "Start-Process cmd.exe -Verb runAs"
#endregion

#Region Second Account
$mySecret = Get-Secret -Vault AzKeyVault -Name SysAdminPW
$AdminCred = New-Object PSCredential "pkilab\SysAdmin", $mySecret
$mySecret = $null
Start-Process powershell.exe -Credential $AdminCred -ArgumentList "Start-Process powershell.exe -Verb runAs"

#endregion

#region Tests to run in the other shells
$DC = (Get-ADDomainController).hostname
net use \\$DC\admin$
Enter-PSSession $DC

#endregion

 <# Command lines tools you may need
appwiz - Programs and Features
certlm.msc - Local Computer Certificate Store
compmgmt.msc - Computer Management
control - Control Panel
control smscfgrc - Configuration Manager Client (must use both to prevent prompting for PW)
devmgmt.msc - Device Manager
diskmgmt.msc - Disk Manger
dsa.msc - Active Directory Users and Computers
Eventvwr.msc - Event Viewer
Manage-bde - Bitlocker
Ncpa.cpl - Network Properties
Regedit - Registry Editor
ServerManager - For Server OS
Services.msc - System Services
Sysdm.cpl - Computer Properties
Taskmgr.exe - Task Manager

To Uninstall Software:
$myApp = Get-WmiObject -Class Win32_Product | Where-Object{$_.Name -like "Adobe*"}  
Review the variable
Write-output $myApp
Proceed with removal if the list is correct
$MyApp.Uninstall()

#>

#region Failures
#Can't type in the resutling window
Start-Process powershell.exe -Credential $AdminCred 

Get-ADUser SysAdmin
$FailCred1 = Get-Credential -UserName SysAdmin
Start-Process powershell.exe -Credential $FailCred1 -ArgumentList "Start-Process powershell.exe -Verb runAs"

$FailCred2 = Get-Credential -UserName SysAdmin@PKILab.local
Start-Process powershell.exe -Credential $FailCred2 -ArgumentList "Start-Process powershell.exe -Verb runAs"
#Must Use "domain\Account" to allow it to run

#endregion
