# data "aws_acm_certificate" "certificate" {
#   domain   = var.domain
#   statuses = ["ISSUED"]
# }


module "alb" {
  source                = "terraform-aws-modules/alb/aws"
  version               = "8.4.0"
  name                  = "${var.Name}-alb"
  load_balancer_type    = var.lbType
  create_security_group = true
  security_group_name   = "${var.Name}-alb-sg"
  security_group_rules = [
    {
      type            = "ingress"
      cidr_blocks     = ["0.0.0.0/0"]
      description     = ""
      from_port       = 443
      prefix_list_ids = []
      protocol        = "tcp"
      to_port         = 443
    },
    {
      type            = "ingress"
      cidr_blocks     = ["0.0.0.0/0"]
      description     = ""
      from_port       = 80
      prefix_list_ids = []
      protocol        = "tcp"
      to_port         = 80
    },
    {
      type            = "egress"
      cidr_blocks     = ["0.0.0.0/0"]
      description     = ""
      from_port       = 443
      prefix_list_ids = []
      protocol        = "tcp"
      to_port         = 443
    },
    {
      type            = "egress"
      cidr_blocks     = ["0.0.0.0/0"]
      description     = ""
      from_port       = 80
      prefix_list_ids = []
      protocol        = "tcp"
      to_port         = 80
    }
  ]
  vpc_id          = module.vpc.vpc_id
  subnets         = module.vpc.public_subnets
  security_groups = [module.alb.security_group_id]
  target_groups = [
    {
      name             = "${var.Name}-alb-target-group"
      backend_port     = 80
      target_type      = "instance"
      backend_protocol = "HTTP"
      ip_address_type  = "ipv4"
      vpc_id           = module.vpc.vpc_id
      stickiness = {
        enabled = true
        type    = "lb_cookie"
      }
    }
  ]
  http_tcp_listeners = [{
    port        = 80
    protocol    = "HTTP"
    stickiness = {
      enabled = true
      type    = "lb_cookie"
    }
    target_group_index = 0
  }]
  # https_listeners = [{
  #   port               = 443
  #   protocol           = "HTTPS"
  #   certificate_arn    = data.aws_acm_certificate.certificate.arn
  #   target_group_index = 0
  #   ip_address_type    = "ipv4"
  #   stickiness = {
  #     enabled = true
  #     type    = "lb_cookie"
  #   }
  # }]
  enable_cross_zone_load_balancing = true
}