module "vpc" {
  source = "terraform-aws-modules/vpc/aws"

  name = "${var.env}-${var.vpc.name}"
  cidr = var.vpc.address_space

  azs             = ["us-east-2a", "us-east-2b", "us-east-2c"]
  public_subnets  = ["10.0.0.0/27", "10.0.0.32/27", "10.0.0.64/27"]
  private_subnets = ["10.0.1.0/27", "10.0.1.32/27", "10.0.1.64/27"]

  enable_nat_gateway     = true
  enable_vpn_gateway     = false
  create_egress_only_igw = false
  create_igw             = true
  tags                   = var.tags
}

resource "aws_security_group" "sg" {
  for_each = var.aws_security_groups

  name        = each.value.name
  description = each.value.description
  vpc_id      = module.vpc.vpc_id
  tags        = var.tags
}

resource "aws_security_group_rule" "public" {
  for_each = var.aws_public_rules

  type              = each.value.type
  from_port         = each.value.from_port
  to_port           = each.value.to_port
  protocol          = each.value.protocol
  security_group_id = aws_security_group.sg["public"].id
  cidr_blocks       = each.value.cidr_blocks
  ipv6_cidr_blocks  = each.value.type == "egress" ? each.value.ipv6_cidr_blocks : null
}

resource "aws_security_group_rule" "private" {
  for_each = var.aws_private_rules

  type              = each.value.type
  from_port         = each.value.from_port
  to_port           = each.value.to_port
  protocol          = each.value.protocol
  security_group_id = aws_security_group.sg["private"].id
  cidr_blocks       = each.value.cidr_blocks
  ipv6_cidr_blocks  = each.value.type == "egress" ? each.value.ipv6_cidr_blocks : null
}

module "aws_instance01" {
  for_each = var.instance
  source   = "terraform-aws-modules/ec2-instance/aws"
  version  = ">= 4.3.0"

  name                   = each.key
  ami                    = each.value.ami
  instance_type          = each.value.type
  monitoring             = true
  subnet_id              = module.vpc.private_subnets[each.value.subnet_id]
  vpc_security_group_ids = [aws_security_group.sg["private"].id]
  tags                   = var.tags
  depends_on             = [
    # module.vpc
    # aws_security_group.sg["private"],
    # aws_security_group.sg["public"],
    # aws_security_group_rule.public["ingress1"],
    # aws_security_group_rule.public["egress1"],
    # aws_security_group_rule.private["ingress80"],
    # aws_security_group_rule.private["ingress443"],
    # aws_security_group_rule.private["egress1"]

  ]
  user_data              = <<-EOF
#!/bin/bash
# update index.html
echo '<html><head><style>h1 {text-align:center;} img { max-width: 150px; } body {background-color:${each.value.color};}</style></head><body><h1>Hello ACME Corp on ${each.key}.</h1><br><br><h1>Powered by</h1><br><center><img src="${each.value.logo}"></center></body></html>' > /var/www/html/index.html
systemctl restart httpd
  EOF
}


module "alb" {
  source  = "terraform-aws-modules/alb/aws"
  version = ">=6.4.0"

  name                  = var.aws_load_balancer.name
  load_balancer_type    = var.aws_load_balancer.type
  vpc_id                = module.vpc.vpc_id
  subnets               = ["${module.vpc.public_subnets[0]}", "${module.vpc.public_subnets[1]}", "${module.vpc.public_subnets[2]}"]
  security_groups       = [aws_security_group.sg["public"].id]
  create_security_group = false
  target_groups = [
    {
      name_prefix      = "lab-"
      backend_protocol = "HTTP"
      backend_port     = 80
      target_type      = "instance"

      targets = [
        {
          target_id = module.aws_instance01["aws1"].id
          port      = 80
        },
        {
          target_id = module.aws_instance01["aws2"].id
          port      = 80
        },
        {
          target_id = module.aws_instance01["aws3"].id
          port      = 80
        },
      ]
    }
  ]
  http_tcp_listeners = [
    {
      port               = 80
      protocol           = "HTTP"
      target_group_index = 0
    }
  ]
  tags = var.tags
}