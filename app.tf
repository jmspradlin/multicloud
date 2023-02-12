module "azure_app_service_windows" {
    source = "./azure"

    rg  = {
        name = "dev-win-asp-rg01"
        location = "northcentralus"
    }
    app_service_plan = {
        os = "Windows"
        name = "dev-win-asp01"
        sku_name = "F1"
    }
    app_service = {
        app01 = {
            name = "dev-win-app01"
        }
        app02 = {
            name = "dev-win-app02"
        }
    }
}