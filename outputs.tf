#################################################
# APPLICATION LOAD BALANCER
#################################################

output "alb_dns_name" {
  description = "DNS name of the Application Load Balancer"
  value       = aws_lb.project_alb.dns_name
}

output "alb_url" {
  description = "HTTP URL to reach the application through the ALB"
  value       = "http://${aws_lb.project_alb.dns_name}"
}
