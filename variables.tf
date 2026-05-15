variable "aws_region" {
  default = "us-east-1"
}

variable "vpc_cidr" {
  default = "10.0.0.0/16"
}

variable "publicA_cidr" {
  default = "10.0.1.0/24"
}

variable "AZ1" {
    default = "us-east-1a"
}

variable "AZ2" {
    default = "us-east-1b"
}