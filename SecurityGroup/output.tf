output "security_group_id" {
  value       = aws_security_group.main.id
  description = "The ID of the security group"
}

output "security_group_arn" {
  value       = aws_security_group.main.arn
  description = "The ARN of the security group"
}

output "security_group_name" {
  value       = aws_security_group.main.name
  description = "The name of the security group"
}

output "security_group_vpc_id" {
  value       = aws_security_group.main.vpc_id
  description = "The VPC ID associated with the security group"
}

output "ingress_rules" {
  value       = { for k, v in aws_vpc_security_group_ingress_rule.ingress : k => v.id }
  description = "Map of ingress rule IDs"
}

output "egress_rules" {
  value       = { for k, v in aws_vpc_security_group_egress_rule.egress : k => v.id }
  description = "Map of egress rule IDs"
}
