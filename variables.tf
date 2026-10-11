variable "resource_group_name" {
  type        = string
  description = "Name of the target resource group"
  default     = "rg-cicd-tf-lab"
}

variable "location" {
  type        = string
  description = "Azure region for deployment"
  default     = "centralindia"
}

variable "vnet_address_space" {
  type        = list(string)
  description = "Address space for the virtual network"
  default     = ["10.10.0.0/16"]
}

variable "subnet_prefixes" {
  type        = list(string)
  description = "Address prefix for the workload subnet"
  default     = ["10.10.1.0/24"]
}