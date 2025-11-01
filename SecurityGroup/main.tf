resource "aws_security_group" "main" {
  name        = var.sg_name
  description = var.sg_description
  vpc_id      = var.vpc_id
  
  tags = merge(
    var.tags,
    {
      Name = var.sg_name
    }
  )
}

# Ingress Rules
resource "aws_vpc_security_group_ingress_rule" "ingress" {
  for_each = var.ingress_rules
  
  security_group_id = aws_security_group.main.id
  
  description = each.value.description
  ip_protocol = each.value.protocol
  from_port   = each.value.from_port
  to_port     = each.value.to_port
  
  # Check if source is a CIDR block or security group ID
  cidr_ipv4              = can(regex("^\\d+\\.\\d+\\.\\d+\\.\\d+/\\d+$", each.value.source)) ? each.value.source : null
  referenced_security_group_id = !can(regex("^\\d+\\.\\d+\\.\\d+\\.\\d+/\\d+$", each.value.source)) && !can(regex("^:[a-f0-9]*$", each.value.source)) ? each.value.source : null
  
  tags = {
    Name = each.key
  }
}

# Egress Rules
resource "aws_vpc_security_group_egress_rule" "egress" {
  for_each = var.egress_rules
  
  security_group_id = aws_security_group.main.id
  
  description = each.value.description
  ip_protocol = each.value.protocol
  from_port   = each.value.from_port
  to_port     = each.value.to_port
  
  # Check if destination is a CIDR block or security group ID
  cidr_ipv4              = can(regex("^\\d+\\.\\d+\\.\\d+\\.\\d+/\\d+$", each.value.destination)) ? each.value.destination : null
  referenced_security_group_id = !can(regex("^\\d+\\.\\d+\\.\\d+\\.\\d+/\\d+$", each.value.destination)) && !can(regex("^:[a-f0-9]*$", each.value.destination)) ? each.value.destination : null
  
  tags = {
    Name = each.key
  }
}
