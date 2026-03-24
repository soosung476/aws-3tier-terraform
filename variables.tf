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