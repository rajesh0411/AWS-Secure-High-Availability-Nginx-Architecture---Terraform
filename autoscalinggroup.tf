#################################################
# AUTO SCALING GROUP
#################################################

resource "aws_autoscaling_group" "project_asg" {
  name = "project-asg"

  #################################################
  # SUBNETS
  #################################################

  vpc_zone_identifier = [
    aws_subnet.private_subnet_a.id,
    aws_subnet.private_subnet_b.id
  ]

  #################################################
  # LAUNCH TEMPLATE
  #################################################

  launch_template {
    id      = aws_launch_template.nginx_template.id
    version = "$Latest"
  }

  #################################################
  # AUTO SCALING CONFIGURATION
  #################################################

  min_size         = 2
  max_size         = 4
  desired_capacity = 2

  #################################################
  # TARGET GROUP ATTACHMENT
  #################################################

  target_group_arns = [
    aws_lb_target_group.nginx_tg.arn
  ]

  #################################################
  # HEALTH CHECK CONFIGURATION
  #################################################

  health_check_type         = "ELB"
  health_check_grace_period = 300

  #################################################
  # INSTANCE REFRESH
  #################################################

  instance_refresh {
    strategy = "Rolling"

    preferences {
      min_healthy_percentage = 50
    }

   
  }

  #################################################
  # TAGS
  #################################################

  tag {
    key                 = "Name"
    value               = "nginx-asg-instance"
    propagate_at_launch = true
  }

  #################################################
  # DEPENDS ON
  #################################################

  depends_on = [
    aws_lb_listener.http_listener
  ]
}