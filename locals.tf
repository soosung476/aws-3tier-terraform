locals {
  project_name = var.project_name

  name_prefix = "${var.project_name}-${var.environment}"

  az_2a = "${var.aws_region}a"
  az_2c = "${var.aws_region}c"
}
locals {
  app_fqdn = var.record_name == "" ? var.domain_name : "${var.record_name}.${var.domain_name}"
}