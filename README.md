# multicloud
Example Terraform Deployment to multiple cloud providers.

# Overview
This lab demonstrates deploying static websites across two cloud providers using Terraform Cloud. It includes modules and resources for AWS and AzureRM providers, and deploys networking and compute instances that meet each cloud provider's requirements to maintain 99.99% uptime SLA.

# Features
This lab uses flat folder structure and DRY Terraform code, with AWS and Azure resources contained to separate files (`aws.tf` and `azure.tf`, respectively). Some folders are included as placeholders for future development.

The websites deployed use VM Images, built with Packer (not included in this code) as well as custom user-data deployments (for EC2).

In the interest of time and to prevent race conditions, the following configurations are in place which do not adhere to be practices:
### AWS EC2 instances are located in public subnets
- While private subnets are provided, inconsistent behavior was observed in testing that required the movement to public subnets due to time constraints.
- Additionally, the custom configuration on these instance is realized through post-deployment configuration (user-data) in the interest of time.

# Running this demo
To use this lab, you will need to perform the following steps:
1. Fork this repo and add to your Terraform Cloud as a VCS provider.
1. Provide the list of variables as HCL variables.

    **NOTE:** Add your own custom VM images, as the ones listed in this code are not publically available.
1. Add the following case-sensitive environmental variables for your cloud credentials into Terraform Cloud from your cloud providers.
    - ARM_CLIENT_ID
    - ARM_CLIENT_SECRET
    - ARM_SUBSCRIPTION_ID
    - ARM_TENANT_ID
    - AWS_ACCESS_KEY_ID
    - AWS_SECRET_ACCESS_KEY
    - For more details on where to find these attributes, see the relevant [AWS](https://registry.terraform.io/providers/hashicorp/aws/latest/docs#authentication-and-configuration) and [Azure](https://registry.terraform.io/providers/hashicorp/azuread/latest/docs/guides/service_principal_client_secret) documentation.
1. Begin your plan and apply runs to confirm functionality.
1. Cleanup resources with `terraform destroy` tasks.

## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 1.1.0 |
| <a name="requirement_aws"></a> [aws](#requirement\_aws) | >= 4.54.0 |
| <a name="requirement_azurerm"></a> [azurerm](#requirement\_azurerm) | ~> 3.43.0 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_aws"></a> [aws](#provider\_aws) | >= 4.54.0 |
| <a name="provider_azurerm"></a> [azurerm](#provider\_azurerm) | ~> 3.43.0 |

## Modules

| Name | Source | Version |
|------|--------|---------|
| AWS VPC | [terraform-aws-modules/vpc/aws](https://registry.terraform.io/modules/terraform-aws-modules/vpc/aws) | >= 3.19.0 |
| AWS Instance | [terraform-aws-modules/ec2-instance/aws](https://registry.terraform.io/modules/terraform-aws-modules/ec2-instance/aws) | >= 4.3.0 |
| AWS ALB | [terraform-aws-modules/alb/aws](https://registry.terraform.io/modules/terraform-aws-modules/alb/aws) | >=6.4.0 |
| Azure Linux Servers | [Azure/compute/azurerm](https://registry.terraform.io/modules/Azure/compute/azurerm/latest) | >= 5.1.0 |


## Resources

| Name | Type |
|------|------|
| [aws_security_group.sg](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/security_group) | resource |
| [aws_security_group_rule.public](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/security_group_rule) | resource |
| [aws_security_group_rule.private](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/security_group_rule) | resource |
| [azurerm_resource_group.rg01](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/resource_group) | resource |
| [azurerm_virtual_network.vnet](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/virtual_network) | resource |
| [azurerm_subnet.subnets](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/subnet) | resource |
| [azurerm_network_security_group.public](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/network_security_group) | resource |
| [azurerm_network_security_group.private](hhttps://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/network_security_group) | resource |
| [azurerm_network_security_rule.public](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/network_security_rule) | resource |
| [azurerm_network_security_rule.private](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/network_security_rule) | resource |
| [azurerm_public_ip.pip](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/public_ip) | resource |
| [azurerm_lb.public_lb](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/lb) | resource |
| [azurerm_lb_probe.public_lb](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/lb_probe) | resource |
| [azurerm_lb_rule.public_lb](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/lb_rule) | resource |
| [azurerm_lb_backend_address_pool.public_lb](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/lb_backend_address_pool) | resource |
| [random_password.azure](https://registry.terraform.io/providers/hashicorp/random/latest/docs/resources/password) | resource |

## Inputs

| Name | Description | Type | Default
|------|-------------|------|--------|
| env | Global environment tier for naming conventions | string | none |
| tags | Global tagging details | map | none |
| aws_load_balancer | AWS Load Balancer details | map | none |
| aws_private_rules | AWS Private Subnet rules | map | none |
| aws_public_rules | AWS Public Subnet rules | map | none |
| aws_region | AWS region | string | none |
| aws_security_groups | AWS Security Groups (Public and Private) details | map | none |
| instance | AWS EC2 details | map | none |
| vpc | AWS Virtual Private Cloud (Network) details | map | none |
| azure_load_balancer | Azure Load Balancer details | map | none |
| azure_linux_vms | Azure VM details | map | none |
| nsg | Azure Network Security Groups (Public and Private) | map | none |
| nsg_rules_private | Azure Private Subnet rules | map | none |
| nsg_rules_public | Azure Public Subnet rules | map | none |
| rg | Azure Resource Group details | map | none |
| subnets | Azure Subnet details | map | none |
| vnet | Azure Virtual Network details | map | none |

## Outputs

| Name | Description |
|------|-------------|
| aws_lb_url | AWS Load Balancer URL |
| azure_lb_url | Azure Load Balancer URL |