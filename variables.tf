variable "env" {}
variable "rg_loc" {
  default = "northcentralus"
}

# App Service Plan
variable "app_service_plan" {
  default = {
    sku_name = "F1"
  }
}

# App Service
variable "app_service" {}

