resource "aws_instance" "my_instances" {
  for_each = toset([for i in range(var.instance_count) : tostring(i)])
  
  # Basic EC2 configuration
  ami                    = var.ami_id
  instance_type          = var.instance_type
  subnet_id              = var.subnet_ids[each.key]
  vpc_security_group_ids = var.security_group_ids
  iam_instance_profile   = var.iam_instance_profile
  
  # User data
  user_data            = var.user_data != "" ? var.user_data : null
  user_data_base64     = var.user_data_base64 != "" ? var.user_data_base64 : null
  
  # Root volume configuration
  root_block_device {
    volume_type           = var.root_volume_type
    volume_size           = var.root_volume_size
    delete_on_termination = true
    encrypted             = true
  }
  
  # Additional EBS volumes (dynamic block)
  dynamic "ebs_block_device" {
    for_each = var.additional_volumes
    content {
      device_name = "/dev/sd${chr(96 + index(keys(var.additional_volumes), ebs_block_device.key) + 1)}"
      volume_type           = ebs_block_device.value.type
      volume_size           = ebs_block_device.value.size
      delete_on_termination = ebs_block_device.value.delete_on_termination
      encrypted             = ebs_block_device.value.encrypted
    }
  }
  
  # Tags
  tags = merge(
    var.mandatory_tags,
    {
      Name = "${var.instance-prefix}-${each.value}"
    }
  )
}