variable "tags" {}
variable "env" {}

# AWS Resources
variable "aws_region" {}
variable "vpc" {}
variable "instance" {}
variable "aws_load_balancer" {}
variable "aws_security_groups" {}
variable "aws_public_rules" {}
variable "aws_private_rules" {}

# Azure Resources
variable "rg" {}
variable "vnet" {}
variable "subnets" {}
variable "azure_load_balancer" {}
variable "azure_linux_vms" {}
variable "nsg" {}
variable "nsg_rules_public" {}
variable "nsg_rules_private" {}