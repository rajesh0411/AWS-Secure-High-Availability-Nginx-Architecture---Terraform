#################################################
# DATA SOURCE - LATEST AMAZON LINUX 2023 AMI
#################################################

data "aws_ami" "amazon_linux" {
  most_recent = true

  owners = ["amazon"]

  filter {
    name   = "name"
    values = ["al2023-ami-*-x86_64"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }
}

#################################################
# LAUNCH TEMPLATE
#################################################

resource "aws_launch_template" "nginx_template" {
  name_prefix   = "nginx-template-"
  image_id      = data.aws_ami.amazon_linux.id
  instance_type = "t3.micro"

  #################################################
  # IAM INSTANCE PROFILE
  #################################################

  iam_instance_profile {
    name = aws_iam_instance_profile.ec2_instance_profile.name
  }


  #################################################
  # USER DATA
  #################################################

  user_data = filebase64("userdata/nginx.sh")

  #################################################
  # DISABLE PUBLIC IP
  #################################################

  network_interfaces {
    associate_public_ip_address = false
    security_groups = [
      aws_security_group.ec2_sg.id
    ]
  }

  #################################################
  # ENABLE IMDSv2 ONLY
  #################################################

  metadata_options {
    http_endpoint = "enabled"
    http_tokens   = "required"
  }

  #################################################
  # EBS ENCRYPTION
  #################################################

  block_device_mappings {
    device_name = "/dev/xvda"

    ebs {
      volume_size           = 30
      volume_type           = "gp3"
      encrypted             = true
      delete_on_termination = true
    }
  }

  #################################################
  # TAGS
  #################################################

  tag_specifications {
    resource_type = "instance"

    tags = {
      Name = "nginx-server"
    }
  }

  tags = {
    Name = "nginx-launch-template"
  }
}