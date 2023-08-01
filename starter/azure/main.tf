data "azurerm_resource_group" "udacity" {
  name     = "Regroup_6jpdjjmIdOgXVafVXW8J"
}

resource "azurerm_container_group" "udacity" {
  name                = "udacity-continst"
  location            = data.azurerm_resource_group.udacity.location
  resource_group_name = data.azurerm_resource_group.udacity.name
  ip_address_type     = "Public"
  dns_name_label      = "udacity-brad-azure"
  os_type             = "Linux"

  container {
    name   = "azure-container-app"
    image  = "docker.io/tscotto5/azure_app:1.0"
    cpu    = "0.5"
    memory = "1.5"
    environment_variables = {
      "AWS_S3_BUCKET"       = "udacity-brad-aws-s3-bucket",
      "AWS_DYNAMO_INSTANCE" = "udacity-brad-aws-dynamodb"
    }
    ports {
      port     = 3000
      protocol = "TCP"
    }
  }
  tags = {
    environment = "udacity"
  }
}

####### Your Additions Will Start Here ######

resource "azurerm_service_plan" "brads_service_plan" {
  name                = "bradsudacityserviceplan"
  resource_group_name = data.azurerm_resource_group.brads_service_plan.name
  location            = data.azurerm_resource_group.brads_service_plan.location
  sku_name            = "P1v2"
  os_type             = "Windows"
}

resource "azurerm_windows_web_app" "brads_windows_web_app" {
  name                = "bradsudacitywindowswebapp"
  resource_group_name = data.azurerm_resource_group.brads_windows_web_app.name
  location            = data.azurerm_service_plan.brads_windows_web_app.location
  service_plan_id     = data.azurerm_service_plan.brads_windows_web_app.id

  site_config {}
}

resource "azurerm_storage_account" "brads_storage_account" {
  name                     = "bradsstorageaccount"
  resource_group_name      = data.azurerm_resource_group.brads_storage_account.name
  location                 = data.azurerm_resource_group.brads_storage_account.location
  account_tier             = "Standard"
  account_replication_type = "LRS"
}

resource "azurerm_sql_server" "brads_sql_server" {
  name                         = "bradssqlserver"
  resource_group_name          = data.azurerm_resource_group.brads_sql_server.name
  location                     = data.azurerm_resource_group.brads_sql_server.location
  version                      = "12.0"
  administrator_login          = "mradministrator"
  administrator_login_password = "thisIsDog11"

  tags = {
    environment = "production"
  }
}