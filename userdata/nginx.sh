#!/bin/bash

#################################################
# SYSTEM UPDATE
#################################################

dnf update -y

#################################################
# INSTALL NGINX
#################################################

dnf install nginx -y

#################################################
# ENABLE & START NGINX
#################################################

systemctl enable nginx
systemctl start nginx

#################################################
# FETCH INSTANCE ID USING IMDSv2
#################################################

TOKEN=$(curl -X PUT "http://169.254.169.254/latest/api/token" \
-H "X-aws-ec2-metadata-token-ttl-seconds: 21600" -s)

INSTANCE_ID=$(curl -H "X-aws-ec2-metadata-token: $TOKEN" \
-s http://169.254.169.254/latest/meta-data/instance-id)

#################################################
# CREATE NGINX WEBPAGE
#################################################

cat <<EOF > /usr/share/nginx/html/index.html
<!DOCTYPE html>
<html>
<head>
    <title>AWS Secure HA Architecture</title>

    <style>
        body {
            background-color: #111827;
            color: white;
            font-family: Arial, sans-serif;
            text-align: center;
            padding-top: 100px;
        }

        .container {
            background-color: #1f2937;
            width: 60%;
            margin: auto;
            padding: 40px;
            border-radius: 10px;
            box-shadow: 0px 0px 10px rgba(255,255,255,0.1);
        }

        h1 {
            color: #60a5fa;
        }

        h2 {
            color: #fbbf24;
        }
    </style>
</head>

<body>

<div class="container">

<h1>Secure AWS High Availability Architecture</h1>

<h2>Served From EC2 Instance:</h2>

<h3>$INSTANCE_ID</h3>

<p>Nginx running behind Application Load Balancer</p>

</div>

</body>
</html>
EOF

#################################################
# RESTART NGINX
#################################################

systemctl restart nginx