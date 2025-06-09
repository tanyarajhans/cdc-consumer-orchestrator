variable "aws_region" {
  description = "AWS region"
  default     = "us-east-1"
}

variable "project_name" {
  default = "cdc-consumer"
}

variable "vpc_cidr" {
  description = "CIDR block for the VPC"
  default     = "10.0.0.0/16"
}

variable "public_subnets_cidr" {
  description = "List of public subnet CIDRs"
  type        = list(string)
  default     = ["10.0.1.0/24", "10.0.2.0/24"]
}

variable "consumer_services" {
  type    = list(string)
  default = ["consumer-1", "consumer-2"]
}

variable "desired_count" {
  default = "2"
}

variable "max_capacity" {
  description = "Maximum capacity for auto scaling"
  default     = 5
}

variable "min_capacity" {
  description = "Minimum capacity for auto scaling"
  default     = 1
}