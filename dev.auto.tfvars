# General resources
env = "dev"
aws_region ="us-east-2"
tags = {
  environment = "Dev"
  source      = "Terraform"
  department  = "Infrastructure"
  costCenter  = "IT"
}
# AWS resources
vpc = {
  name          = "lab01"
  address_space = "10.0.0.0/23"
}
instance = {
  aws1 = {
    ami       = "ami-0cc87e5027adcdca8"
    type      = "t2.large"
    key_name  = "testKey"
    subnet_id = "0"
    color     = "#B0E0E6"
    logo      = "https://upload.wikimedia.org/wikipedia/commons/thumb/9/93/Amazon_Web_Services_Logo.svg/1280px-Amazon_Web_Services_Logo.svg.png"
  }
  aws2 = {
    ami       = "ami-0cc87e5027adcdca8"
    type      = "t2.large"
    key_name  = "testKey"
    subnet_id = "1"
    color     = "#98FB98"
    logo      = "https://upload.wikimedia.org/wikipedia/commons/thumb/9/93/Amazon_Web_Services_Logo.svg/1280px-Amazon_Web_Services_Logo.svg.png"
  }
  aws3 = {
    ami       = "ami-0cc87e5027adcdca8"
    type      = "t2.large"
    key_name  = "testKey"
    subnet_id = "2"
    color     = "#F0EAD6"
    logo      = "https://upload.wikimedia.org/wikipedia/commons/thumb/9/93/Amazon_Web_Services_Logo.svg/1280px-Amazon_Web_Services_Logo.svg.png"
  }
}
aws_load_balancer = {
  name = "lab-alb"
  type = "application"
}
aws_security_groups = {
  public = {
    name        = "allow_public"
    description = "Allow inbound traffic on public subnets"
  }
  private = {
    name        = "allow_private"
    description = "Allow HTTP inbound traffic on private subnets"
  }
}
aws_public_rules = {
  ingress1 = {
    type        = "ingress"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  egress1 = {
    type             = "egress"
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }
}

aws_private_rules = {
  ingress80 = {
    type        = "ingress"
    from_port   = 80
    to_port     = 80
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
  ingress443 = {
    type        = "ingress"
    from_port   = 443
    to_port     = 443
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
  egress1 = {
    type             = "egress"
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }
}

# Azure resources
rg = {
  name     = "azure-tfc"
  location = "eastus2"
}

vnet = {
  name          = "lab01"
  address_space = "10.0.2.0/23"
  public_ip     = "loudtreelabstfc"
}
subnets = {
  frontend = {
    address_prefixes = ["10.0.2.0/27"]
  },
  zone1 = {
    address_prefixes = ["10.0.3.0/27"]
  },
  zone2 = {
    address_prefixes = ["10.0.3.32/27"]
  },
  zone3 = {
    address_prefixes = ["10.0.3.64/27"]
  },
}
azure_load_balancer = {
  name              = "loudtreelabtfc"
  backend_pool_name = "backendpool"
}
azure_linux_vms = {
  azure01 = {
    zone  = "zone1"
    os_id = ""
    size  = "Standard_D2s_v3"
    logo  = "https://en.wikipedia.org/wiki/Microsoft_Azure#/media/File:Microsoft_Azure.svg"
    color = "#008AD7"
  }
  azure02 = {
    zone  = "zone2"
    os_id = ""
    size  = "Standard_D2s_v3"
    logo  = "https://en.wikipedia.org/wiki/Microsoft_Azure#/media/File:Microsoft_Azure.svg"
    color = "#00A2ED"
  }
  azure03 = {
    zone  = "zone3"
    os_id = ""
    size  = "Standard_D2s_v3"
    logo  = "https://en.wikipedia.org/wiki/Microsoft_Azure#/media/File:Microsoft_Azure.svg"
    color = "#FAF9F6"
  }
}
nsg = {
  name = "testnsg01"
}
nsg_rules_public = {
  outbound1 = {
    priority                   = 100
    direction                  = "Outbound"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "*"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }
  inbound1 = {
    priority                   = 101
    direction                  = "Inbound"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "80"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }
  # inbound2 = {
  #   priority                   = 102
  #   direction                  = "Inbound"
  #   protocol                   = "Tcp"
  #   source_port_range          = "*"
  #   destination_port_range     = "*"
  #   source_address_prefix      = "66.169.181.135"
  #   destination_address_prefix = "*"
  # }
}
nsg_rules_private = {
  outbound1 = {
    priority                   = 100
    direction                  = "Outbound"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "*"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }
  inbound = {
    priority                   = 101
    direction                  = "Inbound"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "80"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }
}