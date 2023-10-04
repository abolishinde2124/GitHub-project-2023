module "vpc" {
  source                 = "terraform-aws-modules/vpc/aws"
  version                = "3.19.0"
  name                   = "nishita-ardeshna-vpc"
  cidr                   = var.vpcCidr
  public_subnets         = var.public_subnets
  private_subnets        = var.private_subnets
  enable_nat_gateway     = true
  single_nat_gateway     = true
  one_nat_gateway_per_az = false
  public_subnet_names    = var.public_subnet_names
  private_subnet_names   = var.private_subnet_names
  database_subnet_names  = var.dbSgNames
  enable_dns_hostnames   = true
  enable_dns_support     = true
  public_route_table_tags = {
    "Name" = "nishita-ardeshna-public-rtb"
  }
  private_route_table_tags = {
    "Name" = "nishita-ardeshna-private-rtb"
  }
  database_route_table_tags = {
    "Name" = "nishita-ardeshna-db-rtb"
  }
  igw_tags = {
    "Name" = "nishita-ardeshna-igw"
  }
  nat_gateway_tags = {
    "Name" = "nishita-ardeshna-nat"
  }
  manage_default_route_table             = true
  manage_default_security_group          = false
  manage_default_vpc                     = false
  default_route_table_name               = "${var.Name}-Default-rtb"
  create_database_subnet_group           = true
  create_database_subnet_route_table     = true
  create_database_internet_gateway_route = false
  create_database_nat_gateway_route      = true
  database_subnets                       = var.privateDbSubnetCidr
  azs                                    = [data.aws_availability_zones.az.names[0], data.aws_availability_zones.az.names[1], data.aws_availability_zones.az.names[2]]
}

data "aws_availability_zones" "az" {

}