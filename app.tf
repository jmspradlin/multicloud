resource "azurerm_resource_group" "rg01" {
  name     = var.rg.name
  location = var.rg.loc
}

module "azure_app_service_plan" {
  source   = "./azure/asp"
  for_each = var.app_service_plan

  env = var.env
  rg = azurerm_resource_group.rg01
  app_service_plan = {
    os = each.value.os
    # results in concatenation like "dev-win-asp01"
    name     = each.key
    sku_name = each.value.sku_name
  }
}

module "azure_app_service" {
  source   = "./azure/asp"
  for_each = var.app_service_plan.app_service

  env = var.env
  rg = azurerm_resource_group.rg01
  app_service_plan = module.app_service_plan
  app_service = var.app_service_plan.app_service
}