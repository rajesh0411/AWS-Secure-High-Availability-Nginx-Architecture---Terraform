#################################################
# APPLICATION LOAD BALANCER TARGET GROUP
#################################################

resource "aws_lb_target_group" "nginx_tg" {
  name        = "nginx-target-group"
  port        = 80
  protocol    = "HTTP"
  target_type = "instance"
  vpc_id      = aws_vpc.main.id

  #################################################
  # HEALTH CHECK CONFIGURATION
  #################################################

  health_check {
    enabled             = true
    interval            = 30
    path                = "/"
    port                = "traffic-port"
    protocol            = "HTTP"
    timeout             = 5
    healthy_threshold   = 2
    unhealthy_threshold = 2
    matcher             = "200"
  }

  #################################################
  # TAGS
  #################################################

  tags = {
    Name = "nginx-target-group"
  }
}

#################################################
# APPLICATION LOAD BALANCER
#################################################

resource "aws_lb" "project_alb" {
  name               = "project-alb"
  internal           = false
  load_balancer_type = "application"

  #################################################
  # PUBLIC SUBNETS
  #################################################

  subnets = [
    aws_subnet.public_subnet_a.id,
    aws_subnet.public_subnet_b.id
  ]

  #################################################
  # SECURITY GROUP
  #################################################

  security_groups = [
    aws_security_group.alb_sg.id
  ]

  #################################################
  # DELETE PROTECTION
  #################################################

  enable_deletion_protection = false

  #################################################
  # TAGS
  #################################################

  tags = {
    Name = "project-alb"
  }
}

#################################################
# ALB LISTENER
#################################################

resource "aws_lb_listener" "http_listener" {
  load_balancer_arn = aws_lb.project_alb.arn
  port              = 80
  protocol          = "HTTP"

  #################################################
  # DEFAULT ACTION
  #################################################

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.nginx_tg.arn
  }
}