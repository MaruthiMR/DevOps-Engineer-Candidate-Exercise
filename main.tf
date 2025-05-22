provider "aws" {
  region = "ap-south-1"
}

data "aws_subnets" "selected" {
  filter {
    name   = "vpc-id"
    values = [var.vpc_id]
  }
}

resource "aws_iam_role" "s3_role" {
  name = "EC2S3role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Action = "sts:AssumeRole",
        Effect = "Allow",
        Principal = {
          Service = "ec2.amazonaws.com"
        }
      }
    ]
  })
}

resource "aws_iam_role_policy_attachment" "s3_attach" {
  role       = aws_iam_role.s3_role.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonS3FullAccess"

}
resource "aws_iam_instance_profile" "s3_instance_profile" {
  name = "EC2s3Profile"
  role = aws_iam_role.s3_role.name
}



resource "aws_security_group" "web_sg" {
  name        = "web_sg"
  description = "Allow SSH and HTTP"
   vpc_id      = var.vpc_id

  ingress {
    description = "Allow SSH"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description = "Allow HTTP"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_instance" "web_server" {
  ami                    = "ami-03edbe403ec8522ed"  # Amazon Linux 2 in ap-south-1
  instance_type          = "t2.micro"
  subnet_id              = data.aws_subnets.selected.ids[0]
  vpc_security_group_ids = [aws_security_group.web_sg.id]
  monitoring = true  # This is for Enable detailed monitoring
  iam_instance_profile = aws_iam_instance_profile.s3_instance_profile.name
  key_name               = var.key_name
  user_data              = file("userdata.sh")

  tags = {
    Name = "Elsevier_Web_Server"
  }
}

resource "aws_s3_bucket" "my-bucket" {
  bucket = "maruthimrdevopss3bucket"

  tags = {
    Name        = "My bucket"
  }
}


