# EC2가 다른 AWS 서비스에 접근할 때 사용할 IAM 역할
resource "aws_iam_role" "ec2_ssm_role" {
  name = "${local.name_prefix}-ec2-ssm-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Principal = {
          Service = "ec2.amazonaws.com"
          # EC2 서비스가 이 역할을 맡을 수 있도록 허용
        }
      }
    ]
  })

  tags = {
    Name = "${local.name_prefix}-ec2-ssm-role"
  }
}

# AWS가 미리 제공하는 SSM 정책을 역할에 연결
resource "aws_iam_role_policy_attachment" "ec2_ssm_core" {
  role       = aws_iam_role.ec2_ssm_role.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonSSMManagedInstanceCore"
  # Session Manager, Patch Manager 등 SSM 기능을 EC2에서 사용할 수 있게 해줌
}

# EC2에 IAM 역할을 붙이기 위해 필요한 Instance Profile
resource "aws_iam_instance_profile" "ec2_profile" {
  name = "${local.name_prefix}-ec2-instance-profile"
  role = aws_iam_role.ec2_ssm_role.name
}
