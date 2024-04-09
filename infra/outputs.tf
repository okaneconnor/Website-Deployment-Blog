output "website_dns_name" {
  value = "https://your-domain-name"
}

output "azure_client_id" {
  value = azuread_application.main_application.application_id
}

output "azure_tenant_id" {
  value = data.azuread_client_config.current.tenant_id
}

output "azure_subscription_id" {
  value = data.azurerm_subscription.current.subscription_id
}