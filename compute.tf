# AWS에서 제공하는 최신 Amazon Linux 2023 AMI ID를 SSM Parameter Store에서 조회
data "aws_ssm_parameter" "al2023_ami" {
  name = "/aws/service/ami-amazon-linux-latest/al2023-ami-kernel-default-x86_64"
}

# EC2 인스턴스를 어떤 설정으로 만들지 정의하는 Launch Template
resource "aws_launch_template" "app" {
  name_prefix   = "${local.name_prefix}-app-lt-"
  image_id      = data.aws_ssm_parameter.al2023_ami.value
  # 위에서 조회한 최신 Amazon Linux 2023 AMI 사용
  instance_type = var.instance_type

  vpc_security_group_ids = [aws_security_group.app.id]
  # 앱 서버용 보안 그룹 연결

  iam_instance_profile {
    name = aws_iam_instance_profile.ec2_profile.name
    # EC2가 AWS 리소스에 접근할 수 있도록 IAM 역할 연결
  }

  user_data = base64encode(file("${path.module}/user_data/app.sh"))
  # 인스턴스 최초 실행 시 app.sh 스크립트를 실행해 서버 초기 설정 수행

  metadata_options {
    http_endpoint = "enabled"
    http_tokens   = "required"
    # IMDSv2 토큰을 강제해서 메타데이터 접근 보안 강화
  }

  tag_specifications {
    resource_type = "instance"
    # Launch Template로 생성되는 EC2 인스턴스에 붙을 태그

    tags = {
      Name = "${local.name_prefix}-app"
    }
  }

  tags = {
    Name = "${local.name_prefix}-app-lt"
  }
}

# 앱 서버 EC2를 자동으로 생성/유지/확장하는 Auto Scaling Group
resource "aws_autoscaling_group" "app" {
  name             = "${local.name_prefix}-app-asg"
  min_size         = var.asg_min_size
  max_size         = var.asg_max_size
  desired_capacity = var.asg_desired_capacity
  # 최소/최대/희망 인스턴스 개수 설정
  vpc_zone_identifier = [
    aws_subnet.private_app_2a.id,
    aws_subnet.private_app_2c.id
  ]
  # 앱 서버는 외부에 직접 노출하지 않도록 private subnet들에 생성
  health_check_type         = "ELB"
  health_check_grace_period = 180
  # ELB(ALB) 기준으로 상태를 판단하고, 부팅 직후 180초는 검사 유예
  target_group_arns         = [aws_lb_target_group.app.arn]
  # 생성된 인스턴스를 ALB 타겟 그룹에 자동 등록

  launch_template {
    id      = aws_launch_template.app.id
    version = "$Latest"
    # 가장 최신 Launch Template 버전 기준으로 인스턴스 생성
  }

  tag {
    key                 = "Name"
    value               = "${local.name_prefix}-app"
    propagate_at_launch = true
    # ASG가 새로 만드는 인스턴스에도 Name 태그가 자동으로 붙도록 설정
  }

  depends_on = [aws_lb_target_group.app]
  # 타겟 그룹이 먼저 만들어진 뒤 ASG가 연결되도록 순서 명시
}
