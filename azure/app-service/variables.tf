variable "env" {}
variable "rg" {
  description = "Attributes for the Azure resource group."
}

variable "app_service_plan" {
  description = "Attributes for the App Service Plan. Includes OS type, name, and sku name"
}

variable "app_service" {
  description = "Attributes for the App Service. Includes name and site configuration settings"
}