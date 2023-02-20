output "aws_lb_url" {
  value = module.alb.lb_dns_name
}
output "azure_lb_url" {
  value = azurerm_public_ip.pip.fqdn
}