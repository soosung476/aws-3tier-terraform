# 자주 사용하게 되는 입력값들은 variables에 저장한다. 
variable "aws_region" {
  description = "AWS region"
  type        = string
  default     = "ap-northeast-2"
}

variable "environment" {
  description = "Environment name"
  type        = string
  default     = "dev"
}

variable "project_name" {
  description = "Project name prefix"
  type        = string
  default     = "aws-3tier-tf"
}

variable "vpc_cidr" {
  description = "CIDR block for VPC"
  type        = string
  default     = "10.0.0.0/16"
}

variable "public_subnet_2a_cidr" {
  type    = string
  default = "10.0.1.0/24"
}

variable "public_subnet_2c_cidr" {
  type    = string
  default = "10.0.2.0/24"
}

variable "private_app_subnet_2a_cidr" {
  type    = string
  default = "10.0.11.0/24"
}

variable "private_app_subnet_2c_cidr" {
  type    = string
  default = "10.0.12.0/24"
}

variable "private_db_subnet_2a_cidr" {
  type    = string
  default = "10.0.21.0/24"
}

variable "private_db_subnet_2c_cidr" {
  type    = string
  default = "10.0.22.0/24"
}

variable "instance_type" {
  description = "EC2 instance type for app servers"
  type        = string
  default     = "t3.micro"
}

variable "asg_desired_capacity" {
  description = "Desired capacity for Auto Scaling Group"
  type        = number
  default     = 2
}

variable "asg_min_size" {
  description = "Minimum size for Auto Scaling Group"
  type        = number
  default     = 2
}

variable "asg_max_size" {
  description = "Maximum size for Auto Scaling Group"
  type        = number
  default     = 2
}

variable "db_instance_class" {
  description = "RDS instance class"
  type        = string
  default     = "db.t3.micro"
}

variable "db_allocated_storage" {
  description = "RDS allocated storage in GB"
  type        = number
  default     = 20
}

variable "db_name" {
  description = "Initial database name"
  type        = string
  default     = "appdb"
}

variable "db_username" {
  description = "Master username for RDS"
  type        = string
  default     = "admin"
}

variable "db_password" {
  description = "Master password for RDS"
  type        = string
  sensitive   = true
}

variable "db_multi_az" {
  description = "Whether to enable Multi-AZ for RDS"
  type        = bool
  default     = false
}

variable "domain_name" {
  description = "Root domain in Route 53, e.g. example.com"
  type        = string
}

variable "record_name" {
  description = "Subdomain label only. Use empty string for apex/root, or e.g. www/app"
  type        = string
  default     = ""
}

variable "certificate_domain" {
  description = "Exact ACM certificate domain to look up, e.g. example.com or *.example.com"
  type        = string
}

variable "alarm_evaluation_periods" {
  description = "Number of periods over which data is compared to the specified threshold"
  type        = number
  default     = 2
}

variable "alarm_period_seconds" {
  description = "Period in seconds over which the specified statistic is applied"
  type        = number
  default     = 60
}

variable "alb_target_response_time_threshold" {
  description = "ALB target response time threshold in seconds"
  type        = number
  default     = 1
}

variable "rds_cpu_threshold" {
  description = "RDS CPUUtilization alarm threshold"
  type        = number
  default     = 80
}

variable "rds_free_storage_threshold_bytes" {
  description = "RDS FreeStorageSpace alarm threshold in bytes"
  type        = number
  default     = 2147483648
}