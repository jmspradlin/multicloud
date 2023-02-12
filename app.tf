module "azure_app_service" {
    source = "./azure"
    count = var.asp_count

    rg  = {
        # results in concatenation like "dev-win-asp-rg01"
        name = "${var.env}-${substr(app_service_plan_os,0,3)}-asp-rg${format("%02d", count.index + 1)}" 
        location = var.rg_loc
    }
    app_service_plan = {
        os          = var.app_service_plan_os
        name        = "${var.env}-${substr(app_service_plan_os,0,3)}-asp${format("%02d", count.index + 1)}" 
        sku_name    = var.app_service_plan_sku_name
    }
    app_service = var.app_service
}