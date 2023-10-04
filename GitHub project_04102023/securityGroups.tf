module "ec2Sg" {
  source  = "terraform-aws-modules/security-group/aws"
  version = "4.17.1"
  name    = "${var.userName}-ec2-sg"
  vpc_id  = module.vpc.vpc_id
  ingress_with_source_security_group_id = [{
    from_port                = 80
    to_port                  = 80
    protocol                 = "tcp"
    source_security_group_id = module.alb.security_group_id
    }
  ]
  egress_with_cidr_blocks = [{
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = "0.0.0.0/0"
  }]
}

module "dbSg" {
  source  = "terraform-aws-modules/security-group/aws"
  version = "4.17.1"
  name    = "nishita-ardeshna-db-sg"
  vpc_id  = module.vpc.vpc_id
  ingress_with_source_security_group_id = [{
    from_port                = 3306
    to_port                  = 3306
    protocol                 = "tcp"
    source_security_group_id = module.ec2Sg.security_group_id
    }
  ]
  egress_with_source_security_group_id = [{
    from_port                = 3306
    protocol                 = "tcp"
    to_port                  = 3306
    source_security_group_id = module.ec2Sg.security_group_id
  }]
}