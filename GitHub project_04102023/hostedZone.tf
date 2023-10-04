data "aws_route53_zone" "private" {
  name         = var.hostedZoneName
  private_zone = true
}

# data "aws_route53_zone" "public" {
#   name         = var.hostedZoneName
#   private_zone = false
# }

# module "public" {
#   source  = "terraform-aws-modules/route53/aws//modules/records"
#   version = "~> 2.0"
#   zone_id = data.aws_route53_zone.public.id
#   records = [{
#     name    = var.publicRecordName
#     type    = "CNAME"
#     records = [module.alb.lb_dns_name]
#     ttl     = 5
#   }]
# }

module "private" {
  source  = "terraform-aws-modules/route53/aws//modules/records"
  version = "~> 2.0"
  zone_id = data.aws_route53_zone.private.id
  records = [{
    name    = var.privateRecordName
    type    = "CNAME"
    records = [module.rds.db_instance_address]
    ttl     = 5
  }]
}

resource "aws_route53_zone_association" "zoneAssociation" {
  zone_id = data.aws_route53_zone.private.id
  vpc_id  = module.vpc.vpc_id
}