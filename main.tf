terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = ">= 3.0.0"
    }
  }

  required_version = ">= 1.1.0"
}

provider "azurerm" {
  features {}
 subscription_id = var.subscription_id
  client_id       = var.client_id
  client_secret   = var.client_secret
  tenant_id       = var.tenant_id
}

# Resource Group where the policy will be scoped
resource "azurerm_resource_group" "policy_rg" {
  name     = var.resource_group_name
  location = var.location
}

# Custom Policy Definition to deny public IP creation
resource "azurerm_policy_definition" "custom_policy" {
  name         = "deny-public-ip-creation"
  policy_type  = "Custom"
  mode         = "All"
  display_name = "Deny creation of public IP"
  description  = "This policy denies the creation of public IP addresses."

  policy_rule = <<POLICY
{
  "if": {
    "field": "type",
    "equals": "Microsoft.Network/publicIPAddresses"
  },
  "then": {
    "effect": "deny"
  }
}
POLICY

  metadata = <<METADATA
{
  "category": "Network"
}
METADATA
}

# Policy Assignment scoped to the Resource Group
resource "azurerm_resource_group_policy_assignment" "custom_assignment" {
  name                 = "deny-public-ip-assignment"
  resource_group_id    = azurerm_resource_group.policy_rg.id
  policy_definition_id = azurerm_policy_definition.custom_policy.id
  display_name         = "Deny Public IP Creation in RG"
  description          = "Assignment of custom policy to deny creation of Public IP addresses."
}
