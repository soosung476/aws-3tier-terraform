# 어떤 클라우드를 사용할지 provider를 정한다
provider "aws" {
  region = var.aws_region

  default_tags {
    tags = {
      Project     = local.project_name
      Environment = var.environment
      ManagedBy   = "Terraform"
    }
  }
}