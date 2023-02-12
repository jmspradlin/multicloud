resource azurerm_resource_group rg01 {
  name     = var.rg.name
  location = var.rg.loc
}

resource azurerm_service_plan linux {
    count               = var.app_service_plan.os = "Linux" ? 1 : 0

    name                = var.app_service_plan.name
    sku_name            = var.app_service_plan.sku_name

    resource_group_name = azurerm_resource_group.rg01.name
    location            = azurerm_resource_group.rg01.location
    os_type             = "Linux"
    
}

resource azurerm_linux_web_app linux {
    for_each            = var.app_service

    name                = each.value.name
    resource_group_name = azurerm_resource_group.rg01.name
    location            = azurerm_resource_group.rg01.location
    service_plan_id     = azurerm_service_plan.linux.id

    site_config {}
}

resource "azurerm_service_plan" "windows" {
    count               = var.app_service_plan.os = "Windows" ? 1 : 0

    name                = var.app_service_plan.name
    sku_name            = var.app_service_plan.sku_name

    resource_group_name = azurerm_resource_group.rg01.name
    location            = azurerm_resource_group.rg01.location
    
    os_type             = "Windows"
}

resource "azurerm_windows_web_app" "windows" {
    for_each            = var.app_service

    name                = each.value.name
    resource_group_name = azurerm_resource_group.example.name
    location            = azurerm_service_plan.example.location
    service_plan_id     = azurerm_service_plan.example.id

    site_config {}
}