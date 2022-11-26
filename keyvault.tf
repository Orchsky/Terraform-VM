data "azurerm_client_config" "current" {}

data "external" "account_info" {
  program = [
    "az",
    "ad",
    "signed-in-user",
    "show",
    "--query",
    "{object_id:id}",
    "-o",
    "json",
  ]
}

output "user_object_id" {
  value = data.external.account_info.result.object_id
}


resource "azurerm_key_vault" "demo-kv" {
  name                        = "orchsky-kv"
  location                    = azurerm_resource_group.demo-rg.location
  resource_group_name         = azurerm_resource_group.demo-rg.name
  enabled_for_disk_encryption = true
  tenant_id                   = data.azurerm_client_config.current.tenant_id
  soft_delete_retention_days  = 7
  purge_protection_enabled    = false

  sku_name = "standard"

  timeouts {
    create = "60m"
    delete = "2h"
    read   = "1h"
  }
}

resource "azurerm_key_vault_access_policy" "example" {
  key_vault_id = azurerm_key_vault.demo-kv.id
  tenant_id    = data.external.account_info.result.tenant_id
  object_id    = data.external.account_info.result.object_id

  key_permissions = [
    "Create",
    "Decrypt",
    "Delete",
    "Encrypt",
    "Get",
    "Import",
    "List",
    "Purge",
    "Recover",
    "Restore",
    "Sign",
    "UnwrapKey",
    "Update",
    "Verify",
    "WrapKey",
  ]

  secret_permissions = [
    "Backup",
    "Delete",
    "Get",
    "List",
    "Purge",
    "Recover",
    "Restore",
    "Set",
  ]
}