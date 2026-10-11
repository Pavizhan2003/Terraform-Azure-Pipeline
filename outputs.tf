output "resource_group_name" {
  description = "Provisioned resource group name"
  value       = azurerm_resource_group.rg.name
}

output "vnet_id" {
  description = "ID of the created virtual network"
  value       = azurerm_virtual_network.vnet.id
}

output "subnet_id" {
  description = "ID of the workload subnet"
  value       = azurerm_subnet.subnet.id
}

output "storage_account_name" {
  description = "Name of the storage account created by Terraform"
  value       = azurerm_storage_account.app_storage.name
}