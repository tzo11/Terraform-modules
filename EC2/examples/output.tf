output "instance_ids" {
  description = "Map of EC2 instance IDs keyed by instance number"
  value       = module.ec2_instances.instance_ids
}

output "private_ips" {
  description = "Map of private IP addresses keyed by instance number"
  value       = module.ec2_instances.private_ips
}

output "public_ips" {
  description = "Map of public IP addresses keyed by instance number"
  value       = module.ec2_instances.public_ips
}

output "instances" {
  description = "Complete instance details"
  value       = module.ec2_instances.instances
  sensitive   = true
}