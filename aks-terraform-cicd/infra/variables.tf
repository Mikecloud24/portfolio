variable "subscription_id" {
  description = "The Azure subscription ID"
  type        = string
  default     = ""   # Your Subscription or SP
  
}

variable "resource_group_location" {
  description = "The Azure region where the resources will be created"
  type        = string
  default     = "australiaeast"
}

variable "resource_group_name" {
  description = "The name of the resource group"
  type        = string
  default     = "ethagbedemo-rg"
}

variable "acr_name" {
  description = "The name of the Azure Container Registry"
  type        = string
  default     = "ethagbedemoacr"
}

variable "acr_sku" {
  description = "The SKU for the Azure Container Registry"
  type        = string
  default     = "Standard"
}
variable "aks_name" {
  description = "The name of the Azure Kubernetes Service"
  type        = string
  default     = "ethagbedemoaks"
}

variable "aks_dns_prefix" {
  description = "The DNS prefix for the AKS cluster"
  type        = string
  default     = "ethagbedemoaksdns"
}

variable "node_count" {
  description = "The number of nodes in the AKS cluster"
  type        = number
  default     = 2
}

variable "node_pool_name" {
  description = "The name of the node pool in the AKS cluster"
  type        = string
  default     = "myakspool01"

}

variable "node_vm_size" {
  description = "The size of the virtual machines in the AKS cluster"
  type        = string
  default     = "standard_a2_v2"
}

variable "aks_role_definition_name" {
  description = "The role definition name for the AKS role assignment"
  type        = string
  default     = "AcrPull"
}

variable "msi_id" {
  description = "The managed identity for the AKS cluster"
  type        = string
  default     = ""

}
variable "aks_identity_principal_id" {
  description = "The principal ID of the AKS cluster identity"
  type        = string
  default     = ""
}

variable "acr_scope" {
  description = "The scope of the ACR"
  type        = string
  default     = ""
}

variable "role_assignment_name" {
  description = "The name of the role assignment"
  type        = string
  default     = "AcrPullRoleAssignment"
}

variable "aks_role_assignment_name" {
  description = "The name of the AKS role assignment"
  type        = string
  default     = "AksRoleAssignment"
}
