#Terraform `provider` section is required since the `azurerm` provider update to 2.0+
provider "azurerm" {
  features {
  }
}

#Extract the connection from the normal yaml file to pass to the app container
data "external" "yaml" {
  program = [var.python_binary, "${path.module}/parseyaml.py"]
}

#Set up a personal resource group for the SE local to them
resource "azurerm_resource_group" "personal" {
  name     = "Sales-Engineer-${var.initials}"
  location = var.location
}

#Set up a container group 
resource "azurerm_container_group" "app" {
  name                = "${var.appname}-${var.initials}"
  location            = azurerm_resource_group.personal.location
  resource_group_name = azurerm_resource_group.personal.name
  ip_address_type     = "public"
  dns_name_label      = "${var.appname}-${var.initials}"
  os_type             = "linux"

  container {
    name   = "web"
    image  = "contrastsecuritydemo/railsgoat:1.0"
    cpu    = "1"
    memory = "1.5"
    ports {
      port     = 3000
      protocol = "TCP"
    }
    environment_variables = {
      CONTRAST__API__URL="${data.external.yaml.result.url}"
      CONTRAST__API__API_KEY="${data.external.yaml.result.api_key}"
      CONTRAST__API__SERVICE_KEY="${data.external.yaml.result.service_key}"
      CONTRAST__API__USER_NAME="${data.external.yaml.result.user_name}"
      CONTRAST__APPLICATION__NAME="${var.appname}"
      CONTRAST__APPLICATION__SESSION_METADATA="${var.session_metadata}"
      CONTRAST__SERVER__NAME="${var.servername}"
      CONTRAST__SERVER__ENVIRONMENT="${var.environment}"
      TEST="${var.run_automated_tests}"
    }
  }
}

