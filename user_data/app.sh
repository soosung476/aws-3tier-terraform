#!/bin/bash
set -e

dnf update -y
dnf install -y nginx

cat > /usr/share/nginx/html/index.html << EOF
<!DOCTYPE html>
<html>
<head>
  <meta charset="UTF-8">
  <title>AWS 3-Tier Terraform</title>
</head>
<body>
  <h1>AWS 3-Tier Terraform App Server</h1>
  <p>If you can see this page, the ALB -> ASG -> EC2 path is working.</p>
</body>
</html>
EOF

systemctl enable nginx
systemctl start nginx