resource "azurerm_service_plan" "asp" {
  name                = "${var.env}-${substr(each.value.os, 0, 3)}-${var.app_service_plan.name}"
  sku_name            = var.app_service_plan.sku_name
  resource_group_name = var.rg.name
  location            = var.rg.location
  os_type             = var.app_service_plan.os
}