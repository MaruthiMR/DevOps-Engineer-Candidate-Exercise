#!/bin/bash
sudo yum update -y
sudo yum install -y httpd
sudo systemctl start httpd
sudo systemctl enable httpd

cat <<EOF > /var/www/html/index.html
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>Hello Elsevier</title>
    <style>
        body {
            font-family: Arial, sans-serif;
            background-color: #f4f4f9;
            color: #333;
            display: flex;
            justify-content: center;
            align-items: center;
            height: 100vh;
            margin: 0;
        }
        h1 {
            font-size: 3em;
            color: #005eb8;
        }
    </style>
</head>
<body>
    <h1>Hello Elsevier</h1>
</body>
</html>
EOF

aws s3api put-object \
    --bucket maruthimr_devops_s3_bucket \
    --key /var/www/html/index.html \
    --body index.html

