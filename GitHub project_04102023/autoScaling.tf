module "asg" {
  depends_on = [
    module.alb, module.private
  ]
  source                 = "terraform-aws-modules/autoscaling/aws"
  version                = "6.9.0"
  name                   = "${var.Name}-asg"
  min_size               = 2
  desired_capacity       = 2
  max_size               = 4
  vpc_zone_identifier    = module.vpc.private_subnets
  create_launch_template = true
  scaling_policies = {
    asgPolicy = {
      policy_type = "TargetTrackingScaling"
      target_tracking_configuration = {
        predefined_metric_specification = {
          predefined_metric_type = "ASGAverageCPUUtilization"
        }
        target_value = 60
      }
    }
  }
  launch_template_name        = "${var.Name}-lt"
  image_id                    = var.ami
  instance_type               = var.ec2InstanceType
  create_iam_instance_profile = true
  iam_role_name               = "ec2ssm"
  iam_role_policies = {
    AmazonSSMManagedInstanceCore = var.ssmPolicy
  }
  tag_specifications = [{
    resource_type = "instance"
    tags = {
      "Name"  = "${var.Name}-ec2"
      "Owner" = var.Owner
    }
  }]
  security_groups = [
    module.ec2Sg.security_group_id
  ]
  tags = {
    "Name"  = "${var.Name}-lt"
    "Owner" = var.Owner
  }
  target_group_arns = module.alb.target_group_arns
  user_data         = base64encode(templatefile("nginx.tftpl", { db_address = module.private.route53_record_name["nishitaRds CNAME"] }))
}

output "dns" {
  value = module.private
}