module "security_group_temp" {
  source = "terraform-aws-modules/security-group/aws"

  name        = "test-sg"
  description = "test security group"
  vpc_id      = module.vpc.vpc_id

  ingress_with_cidr_blocks = [
    {
      from_port   = 0
      to_port     = 65535
      protocol    = "tcp"
      description = "allow temp all"
      cidr_blocks = "0.0.0.0/0"
    }
  ]

  egress_rules = ["all-all"]
}
