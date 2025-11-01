output "instance_ids" {
  value       = { for k, v in aws_instance.my_instances : k => v.id }
  description = "Map of EC2 instance IDs"
}

output "private_ips" {
  value       = { for k, v in aws_instance.my_instances : k => v.private_ip }
  description = "Map of private IP addresses"
}

output "public_ips" {
  value       = { for k, v in aws_instance.my_instances : k => v.public_ip }
  description = "Map of public IP addresses (if assigned)"
}

output "primary_network_interface_id" {
  value       = { for k, v in aws_instance.my_instances : k => v.primary_network_interface_id }
  description = "Map of primary network interface IDs"
}

output "instances" {
  value       = aws_instance.my_instances
  description = "All instance details"
  sensitive   = false
}