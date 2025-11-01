module "web_sg" {
  source = "../"
  
  aws_region     = var.aws_region
  sg_name        = var.sg_name
  sg_description = var.sg_description
  vpc_id         = var.vpc_id
  ingress_rules  = var.ingress_rules
  egress_rules   = var.egress_rules
  tags           = var.tags
}