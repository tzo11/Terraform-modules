module "ec2_instances" {
  source = "git@github.com:tzo11/Terraform-modules.git//EC2?ref=ec2-v1.0.1"
  
  aws_region           = var.aws_region
  instance_count       = var.instance_count
  instance_type        = var.instance_type
  ami_id               = var.ami_id
  key_pair             = var.key_pair
  instance-prefix      = var.instance-prefix
  vpc_id               = var.vpc_id
  subnet_ids           = var.subnet_ids
  security_group_ids   = var.security_group_ids
  iam_instance_profile = var.iam_instance_profile
  root_volume_size     = var.root_volume_size
  root_volume_type     = var.root_volume_type
  additional_volumes   = var.additional_volumes
  placement_group      = var.placement_group
  user_data            = var.user_data
  user_data_base64     = var.user_data_base64
  mandatory_tags       = var.mandatory_tags
}