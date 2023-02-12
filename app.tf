module "azure_app_service" {
    source = "./azure"
    for_each = var.app_service_plan

    rg  = {
        # results in concatenation like "dev-win-asp01-rg"
        name = "${var.env}-${substr(each.value.os,0,3)}-${each.key}-rg" 
        location = var.rg_loc
    }
    app_service_plan = {
        os          = each.value.os
        # results in concatenation like "dev-win-asp01"
        name        = "${var.env}-${substr(each.value.os,0,3)}-${each.key}" 
        sku_name    = each.value.sku_name
    }
    app_service = var.app_service
}