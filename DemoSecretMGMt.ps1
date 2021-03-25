#Install-Module az -force
#Install-Module Microsoft.PowerShell.SecretManagement
#Install-Module Microsoft.PowerShell.SecretStore

Connect-AzAccount
$subId = (Get-AzSubscription).id
Select-AzSubscription $subId

$secretvalue = ConvertTo-SecureString 'XXXXXXXXXXXXX' -AsPlainText -Force
$secret = Set-AzKeyVaultSecret -VaultName 'AzureSecretKV' -Name 'SysAdminPW' -SecretValue $secretvalue
$secretvalue = ConvertTo-SecureString 'XXXXXXXXXXXXX' -AsPlainText -Force
$secret = Set-AzKeyVaultSecret -VaultName 'AzureSecretKV' -Name 'DAPW' -SecretValue $secretvalue

Register-SecretVault -Name AzKeyVault -ModuleName Az.KeyVault -VaultParameters @{ AZKVaultName = 'AzureSecretKV'; SubscriptionId = $subId }
Get-SecretInfo -Vault AzKeyVault

$mySecret
$ssPtr = [System.Runtime.InteropServices.Marshal]::SecureStringToBSTR($mySecret)
try {
   $secretValueText = [System.Runtime.InteropServices.Marshal]::PtrToStringBSTR($ssPtr)
} finally {
   [System.Runtime.InteropServices.Marshal]::ZeroFreeBSTR($ssPtr)
}
Write-Output $secretValueText

$ssPtr = [System.Runtime.InteropServices.Marshal]::SecureStringToBSTR($secret.SecretValue)
try {
   $secretValueText = [System.Runtime.InteropServices.Marshal]::PtrToStringBSTR($ssPtr)
} finally {
   [System.Runtime.InteropServices.Marshal]::ZeroFreeBSTR($ssPtr)
}