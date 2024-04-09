// Creates a DNS zone to host the DNS Records for our domain
resource "azurerm_dns_zone" "dnszone" {
  name                = "example.com"
  resource_group_name = var.rg_name
  depends_on          = [azurerm_resource_group.rg]
}

// Creates an A record for the domain name
resource "azurerm_dns_a_record" "a_record" {
  name                = "@"
  zone_name           = azurerm_dns_zone.dnszone.name
  resource_group_name = var.rg_name
  ttl                 = 300
  records             = split(",", azurerm_app_service.app_service.outbound_ip_addresses)
  depends_on          = [azurerm_dns_zone.dnszone, azurerm_app_service.app_service]
}

// Creates a TXT record for the domain name
resource "azurerm_dns_txt_record" "asuid_txt_record" {
  name                = "asuid"
  zone_name           = azurerm_dns_zone.dnszone.name
  resource_group_name = azurerm_resource_group.rg.name
  ttl                 = 300
  record {
    value = "YOUR_ASUID_TXT_RECORD_VALUE"
  }
}

// Binds a custom domain to the Azure App Service.
resource "azurerm_app_service_custom_hostname_binding" "custom_domain" {
  hostname            = "example.com"
  app_service_name    = azurerm_app_service.app_service.name
  resource_group_name = azurerm_resource_group.rg.name
  depends_on          = [azurerm_dns_txt_record.asuid_txt_record]
}

// Creates a managed SSL certificate for the custom domain.
resource "azurerm_app_service_managed_certificate" "ssl_cert" {
  custom_hostname_binding_id = azurerm_app_service_custom_hostname_binding.custom_domain.id
}

// Binds the managed SSL certificate to the custom domain on the App Service, enabling HTTPS.
resource "azurerm_app_service_certificate_binding" "sslcert_binding" {
  hostname_binding_id = azurerm_app_service_custom_hostname_binding.custom_domain.id
  certificate_id      = azurerm_app_service_managed_certificate.ssl_cert.id
  ssl_state           = "SniEnabled"
}