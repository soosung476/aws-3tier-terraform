# locals를 사용하는 이유
# 매번 resource를 작성할때 마다 aws-3tier-tf-dev-{}를 할 바에
# local.name_prefix 와 같이 한번에 가능하게끔 반복해서 재사용할 값들을 정의하고 싶을 때
# locals를 사용한다 참조할 때는 local.<name>으로 참조한다
locals {
  project_name = var.project_name

  name_prefix = "${var.project_name}-${var.environment}"

  az_2a = "${var.aws_region}a"
  az_2c = "${var.aws_region}c"
}
locals {
  app_fqdn = var.record_name == "" ? var.domain_name : "${var.record_name}.${var.domain_name}"
}