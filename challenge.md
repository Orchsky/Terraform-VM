# Attempt to code kv with existing code base - document any issues + solutions 
- Research / attempt to make the kv with the existing code base and document what was found / any issues + solutions.

- document and sync up and present info next class --> the weekend after (Nov. 26th / 27th)

- If possible try and find solution for this error: 
```│ Error: retrieving `contact` for KeyVault: keyvault.BaseClient#GetCertificateContacts: Failure sending request: StatusCode=0 Original Error: context deadline exceeded
│ 
│   with azurerm_key_vault.demo-kv,
│   on keyvault.tf line 3, in resource "azurerm_key_vault" "demo-kv":
│    3: resource "azurerm_key_vault" "demo-kv" {```