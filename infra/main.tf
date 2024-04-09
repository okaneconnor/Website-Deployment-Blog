// Creates a resource group that we store all of our resources inside \\
resource "azurerm_resource_group" "rg" {
  name     = var.rg_name
  location = var.location
}

// Creates an App Service Plan \\
resource "azurerm_app_service_plan" "app_service_plan" {
  name                = "example-app-service-plan"
  location            = var.location
  resource_group_name = var.rg_name
  depends_on          = [azurerm_resource_group.rg]

  sku {
    tier = "Basic"
    size = "B1"
  }
}

// Create an App Service \\
resource "azurerm_app_service" "app_service" {
  name                = "example-app-service"
  location            = var.location
  resource_group_name = var.rg_name
  app_service_plan_id = azurerm_app_service_plan.app_service_plan.id
  depends_on          = [azurerm_resource_group.rg]
}

// Creates an application on Azure \\
resource "azuread_application" "main_application" {
  display_name = "example-application"
  owners       = [data.azuread_client_config.current.object_id]
}

// Creating the federated identity \\
resource "azuread_application_federated_identity_credential" "federated_id" {
  application_object_id = azuread_application.main_application.object_id
  display_name          = "GithubActionsFederatedCredential"
  description           = "Federated credential for GitHub Actions"
  audiences             = ["api://AzureADTokenExchange"]
  issuer                = "https://token.actions.githubusercontent.com"
  subject               = "repo:YourOrganization/YourRepository:ref:refs/heads/main"
}

// Create a service principal for the application \\
resource "azuread_service_principal" "sp" {
  application_id               = azuread_application.main_application.application_id
  app_role_assignment_required = false
  owners                       = [data.azuread_client_config.current.object_id]
}

// Generate a client secret for the service principal
resource "azuread_service_principal_password" "client_secret" {
  service_principal_id = azuread_service_principal.sp.id
  end_date_relative    = "8760h" # Set the expiration date (e.g., 1 year)
}

resource "azuread_application_password" "client_secret" {
  application_object_id = azuread_application.main_application.object_id
  end_date_relative     = "8760h" # Set the expiration date (e.g., 1 year)
}
