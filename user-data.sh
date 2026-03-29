#!/bin/bash
dnf update -y
dnf install -y nginx
systemctl enable nginx
systemctl start nginx

cat <<EOF > /usr/share/nginx/html/index.html
<!DOCTYPE html>
<html>
<head>
    <title>Terraform Demo</title>
</head>
<body>
    <h1>Hello from Terraform!</h1>
    <p>This EC2 instance was provisioned with Terraform.</p>
</body>
</html>
EOF
git config --global user.email "mtlspirou@gmail.com"