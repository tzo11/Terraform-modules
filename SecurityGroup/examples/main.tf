module "web_sg" {
  source = "git@github.com:tzo11/Terraform-modules.git//SecurityGroup?ref=sg-v1.0.0"
  
  aws_region     = var.aws_region
  sg_name        = var.sg_name
  sg_description = var.sg_description
  vpc_id         = var.vpc_id
  ingress_rules  = var.ingress_rules
  egress_rules   = var.egress_rules
  tags           = var.tags
}