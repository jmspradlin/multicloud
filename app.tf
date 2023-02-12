resource "azurerm_resource_group" "rg01" {
  name     = "${var.env}-${var.rg.name}-01"
  location = var.rg.location
}

resource "azurerm_service_plan" "asp" {
  name                = "${var.env}-${var.app_service_plan.name}"
  sku_name            = var.app_service_plan.sku_name
  resource_group_name = azurerm_resource_group.rg01.name
  location            = azurerm_resource_group.rg01.location
  os_type             = var.app_service_plan.os
}

resource "azurerm_linux_web_app" "linux" {
  for_each = var.app_service_linux

  name                = "${var.env}-${each.key}"
  resource_group_name = azurerm_resource_group.rg01.name
  location            = azurerm_resource_group.rg01.location
  service_plan_id     = azurerm_service_plan.asp.id
  
  site_config {
    always_on           = false
  }
}