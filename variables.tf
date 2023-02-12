variable "env" {}
variable "rg" {
  default = {
    location = "northcentralus"
  }
}

# App Service Plan
variable "app_service_plan" {}

variable "app_service_plan_sku" {
  default = "F1"
}
variable "app_service" {}