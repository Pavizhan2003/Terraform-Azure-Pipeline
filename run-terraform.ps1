Set-Location "C:\Users\PavizhanS\Downloads\terraform-azure-pipeline"

@'
param (
    [Parameter(Mandatory=$true)][string]$Action,
    [Parameter(Mandatory=$true)][string]$BackendResourceGroup,
    [Parameter(Mandatory=$true)][string]$BackendStorageAccount,
    [Parameter(Mandatory=$true)][string]$BackendContainer,
    [Parameter(Mandatory=$true)][string]$BackendKey
);

$ErrorActionPreference = 'Stop';$tf = "C:\Tools\Terraform\terraform.exe";

# 1. Force Terraform to use Service Principal and ignore Azure CLI User auth
$env:ARM_USE_CLI         = "false";
$env:ARM_CLIENT_ID       =$env:servicePrincipalId;
$env:ARM_CLIENT_SECRET   =$env:servicePrincipalKey;
$env:ARM_TENANT_ID       =$env:tenantId;
$env:ARM_SUBSCRIPTION_ID = (az account show --query id -o tsv);

Write-Host "===> Terraform Environment Authenticated as Service Principal: $env:ARM_CLIENT_ID";

# 2. Initialize Terraform Backend
Write-Host "===> Initializing Terraform with remote Azure backend...";
& $tf init `
  -backend-config="resource_group_name=$BackendResourceGroup" `
  -backend-config="storage_account_name=$BackendStorageAccount" `
  -backend-config="container_name=$BackendContainer" `
  -backend-config="key=$BackendKey" `
  -backend-config="client_id=$env:ARM_CLIENT_ID" `
  -backend-config="client_secret=$env:ARM_CLIENT_SECRET" `
  -backend-config="tenant_id=$env:ARM_TENANT_ID" `
  -backend-config="subscription_id=$env:ARM_SUBSCRIPTION_ID";

# 3. Plan or Apply
if ($Action -eq "plan") {
    Write-Host "===> Validating syntax...";
    & $tf validate;

    Write-Host "===> Generating execution plan...";
    & $tf plan -out=tfplan;
}
elseif ($Action -eq "apply") {
    Write-Host "===> Executing terraform apply against plan artifact...";
    & $tf apply -input=false -auto-approve tfplan;
}
'@ | Set-Content -Path "run-terraform.ps1" -Encoding UTF8