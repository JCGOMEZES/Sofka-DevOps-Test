# ----------------------------------------------------------------------------------------------------------------------
# AWS Auto Scaling Group
# ----------------------------------------------------------------------------------------------------------------------
provider "aws" {
  region = "us-east-1"
  access_key = "AKIAT6HXS6FA42GOE343"
  secret_key = "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"
}
# LOCAL VARIABLES
locals {
  name_sufix = "tar"
  entity     = "The Automation Rules"
  creator    = "Terraform"
  az_prefix  = "us-east"
  service    = "imagenDocker"
  subnet_a   = "subnet-066e72b702bd0a46a"
  subnet_b   = "subnet-0125797a3800ec988"
  subnet_c   = "subnet-0248e948caf00b94a"
  vpc_id     = "vpc-050681a9e5ead62f1"
}

# LAUNCH TEMPLATE
resource "aws_launch_template" "asg-template-t2micro" {
  name_prefix            = "asg-${local.service}-t2micro"
  image_id               = "ami-007855ac798b5175e"
  instance_type          = "t2.micro"
  key_name               = "rockemsockem"
  user_data              = filebase64("${path.module}/user-data/bootstrap.sh")
  vpc_security_group_ids = [aws_security_group.sg_service.id]
}
# AUTO SCALING GROUP
resource "aws_autoscaling_group" "as-ubuntu" {
  vpc_zone_identifier = [local.subnet_a, local.subnet_b, local.subnet_c]
  desired_capacity    = 3
  max_size            = 3
  min_size            = 3

  launch_template {
    id      = aws_launch_template.asg-template-t2micro.id
    version = aws_launch_template.asg-template-t2micro.latest_version
  }

  tag {
    key                 = "Name"
    value               = "NODO-ASG"
    propagate_at_launch = true
  }
}
