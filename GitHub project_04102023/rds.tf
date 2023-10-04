module "rds" {
  source  = "terraform-aws-modules/rds/aws"
  version = "5.6.0"

  identifier                = "${var.Name}-rds"
  db_name                   = var.dbName
  password                  = var.password
  username                  = var.userName
  port                      = 3306
  availability_zone         = data.aws_availability_zones.az.names[0]
  create_db_option_group    = false
  create_db_parameter_group = false
  create_random_password    = false
  skip_final_snapshot       = true
  instance_class            = var.dbSize
  allocated_storage         = 10
  max_allocated_storage     = 10
  storage_type              = var.dbStorageType
  storage_encrypted         = false
  publicly_accessible       = false
  engine                    = var.engine
  tags = {
    "Name"  = "RDS-${var.Name}"
    "Owner" = var.Owner
  }
  vpc_security_group_ids = [module.dbSg.security_group_id]
  create_db_subnet_group = true
  subnet_ids             = module.vpc.database_subnets
  # v
}
