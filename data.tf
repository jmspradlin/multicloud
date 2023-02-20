# data "template_file" "setup_site" {
#   for_each = var.azure_linux_vms
#   template = file("${path.module}/vm_script.tpl")
#   vars = {
#     color  = each.value.color
#     vmname = each.key
#     logo   = each.value.logo
#   }
# }