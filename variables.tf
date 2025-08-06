variable "subscription_id" {
  type = string
}

variable "location" {
  description = "Azure region for the resource group"
  type        = string
  default     = "East US"
}

variable "resource_group_name" {
  description = "Name of the resource group where the policy will be applied"
  type        = string
  default     = "rg-custom-policy"
}
