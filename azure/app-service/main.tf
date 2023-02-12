resource "azurerm_linux_web_app" "linux" {
  count = var.app_service_plan.os == "Linux" ? 1 : 0

  name                = "${var.env}-${substr(each.value.os, 0, 3)}-app-${var.app_service.name}"
  resource_group_name = var.rg.name
  location            = var.rg.location
  service_plan_id     = var.app_service_plan.id

  site_config {}
}

resource "azurerm_windows_web_app" "windows" {
  count = var.app_service_plan.os == "Windows" ? 1 : 0

  name                = "${var.env}-${substr(each.value.os, 0, 3)}-app-${var.app_service.name}"
  resource_group_name = var.rg.name
  location            = var.rg.location
  service_plan_id     = var.app_service_plan.id

  site_config {}
}