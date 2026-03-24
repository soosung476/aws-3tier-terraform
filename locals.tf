locals {
  project_name = var.project_name

  name_prefix = "${var.project_name}-${var.environment}"

  az_2a = "${var.aws_region}a"
  az_2c = "${var.aws_region}c"
}