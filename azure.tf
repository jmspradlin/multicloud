resource "azurerm_resource_group" "rg01" {
  name     = "${var.env}-${var.rg.name}-01"
  location = var.rg.location
  tags     = var.tags
}

# Networking
# Vnet
resource "azurerm_virtual_network" "vnet" {
  name                = var.vnet.name
  resource_group_name = azurerm_resource_group.rg01.name
  location            = azurerm_resource_group.rg01.location
  address_space       = [var.vnet.address_space]
  tags                = var.tags
}
# Subnet
resource "azurerm_subnet" "subnets" {
  for_each = var.subnets

  name                 = each.key
  resource_group_name  = azurerm_resource_group.rg01.name
  virtual_network_name = azurerm_virtual_network.vnet.name
  address_prefixes     = each.value.address_prefixes
}

# Security Groups and Rules
resource "azurerm_network_security_group" "public" {
  name                = "${var.nsg.name}-public"
  resource_group_name = azurerm_resource_group.rg01.name
  location            = azurerm_resource_group.rg01.location
  tags                = var.tags
}
resource "azurerm_network_security_group" "private" {
  name                = "${var.nsg.name}-private"
  resource_group_name = azurerm_resource_group.rg01.name
  location            = azurerm_resource_group.rg01.location
  tags                = var.tags
}
resource "azurerm_network_security_rule" "public" {
  for_each = var.nsg_rules_public

  name                        = each.key
  priority                    = each.value.priority
  direction                   = each.value.direction
  access                      = "Allow"
  protocol                    = each.value.protocol
  source_port_range           = each.value.source_port_range
  destination_port_range      = each.value.destination_port_range
  source_address_prefix       = each.value.source_address_prefix
  destination_address_prefix  = each.value.destination_address_prefix
  resource_group_name         = azurerm_resource_group.rg01.name
  network_security_group_name = azurerm_network_security_group.public.name
}
resource "azurerm_network_security_rule" "private" {
  for_each = var.nsg_rules_private

  name                        = each.key
  priority                    = each.value.priority
  direction                   = each.value.direction
  access                      = "Allow"
  protocol                    = each.value.protocol
  source_port_range           = each.value.source_port_range
  destination_port_range      = each.value.destination_port_range
  source_address_prefix       = each.value.source_address_prefix
  destination_address_prefix  = each.value.destination_address_prefix
  resource_group_name         = azurerm_resource_group.rg01.name
  network_security_group_name = azurerm_network_security_group.private.name
}

# Public IP
resource "azurerm_public_ip" "pip" {
  #for_each 
  name                = var.vnet.public_ip
  resource_group_name = azurerm_resource_group.rg01.name
  location            = azurerm_resource_group.rg01.location
  allocation_method   = "Static"
  sku                 = "Standard"
  zones               = ["1", "2", "3"]
  domain_name_label   = "loudtreelabsazure"
  tags                = var.tags
}
# Load Balancer
resource "azurerm_lb" "public_lb" {
  name                = var.azure_load_balancer.name
  resource_group_name = azurerm_resource_group.rg01.name
  location            = azurerm_resource_group.rg01.location
  sku                 = "Standard"
  sku_tier            = "Regional"
  frontend_ip_configuration {
    name                 = "PublicIP"
    public_ip_address_id = azurerm_public_ip.pip.id
  }
  tags = var.tags
}
# LB Backend
# Probe
resource "azurerm_lb_probe" "public_lb" {
  loadbalancer_id = azurerm_lb.public_lb.id
  name            = "http-probe"
  port            = 80
}
# Load balancing rule
resource "azurerm_lb_rule" "public_lb" {
  loadbalancer_id                = azurerm_lb.public_lb.id
  name                           = "httpRule"
  protocol                       = "Tcp"
  frontend_port                  = 80
  backend_port                   = 80
  frontend_ip_configuration_name = "PublicIP"
  backend_address_pool_ids       = [azurerm_lb_backend_address_pool.public_lb.id]
  probe_id                       = azurerm_lb_probe.public_lb.id
}
# Backend Pool and Association
resource "azurerm_lb_backend_address_pool" "public_lb" {
  loadbalancer_id = azurerm_lb.public_lb.id
  name            = var.azure_load_balancer.backend_pool_name
}
resource "azurerm_network_interface_backend_address_pool_association" "backend" {
  for_each                = module.azure_linux_servers
  network_interface_id    = each.value.network_interface_ids[0]
  ip_configuration_name   = "${each.key}-ip-0"
  backend_address_pool_id = azurerm_lb_backend_address_pool.public_lb.id
}

# Compute
resource "random_password" "azure" {
  length           = 32
  special          = true
  override_special = "$%&*?"
}

module "azure_linux_servers" {
  for_each = var.azure_linux_vms
  source   = "Azure/compute/azurerm"

  resource_group_name = azurerm_resource_group.rg01.name
  location            = azurerm_resource_group.rg01.location
  vm_hostname         = each.key
  enable_ssh_key      = false
  vm_os_id            = each.value.os_id
  vm_size             = each.value.size
  admin_password      = random_password.azure.result

  # Networking
  vnet_subnet_id         = azurerm_subnet.subnets["${each.value.zone}"].id
  nb_public_ip           = 0
  network_security_group = azurerm_network_security_group.private

  # Data
  delete_data_disks_on_termination = true
  delete_os_disk_on_termination    = true
  remote_port                      = 80

  depends_on = [azurerm_resource_group.rg01]
  zone       = substr("${each.value.zone}", 4, 1)
  tags       = var.tags
}