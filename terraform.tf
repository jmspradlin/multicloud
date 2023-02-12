terraform {
  cloud {
    organization = "loudtree"

    workspaces {
      name = "multicloud"
    }
  }

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "4.54.0"
    }
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 3.43.0"
    }
  }

  required_version = ">= 1.1.0"
}