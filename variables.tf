variable env {}

variable asp_count {}

variable rg_loc {
    default = "northcentralus"
}

# App Service Plan
variable app_service_plan_os {}
variable app_service_plan_sku_name {
    default = "F1"
}

variable app_service {}