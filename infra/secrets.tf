resource "github_actions_secret" "azure_client_secret" {
  repository      = "example-repo"
  secret_name     = "AZURE_CLIENT_SECRET"
  plaintext_value = azuread_application_password.client_secret.value
}

resource "github_actions_secret" "azure_client_id" {
  repository      = "example-repo"
  secret_name     = "AZURE_CLIENT_ID"
  plaintext_value = azuread_application.main_application.application_id
}

resource "github_actions_secret" "azure_tenant_id" {
  repository      = "example-repo"
  secret_name     = "AZURE_TENANT_ID"
  plaintext_value = data.azuread_client_config.current.tenant_id
}

resource "github_actions_secret" "azure_subscription_id" {
  repository      = "example-repo"
  secret_name     = "AZURE_SUBSCRIPTION_ID"
  plaintext_value = data.azurerm_subscription.current.subscription_id
}
          