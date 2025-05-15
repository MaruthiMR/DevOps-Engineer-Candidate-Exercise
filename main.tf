provider "aws" {
  region = "ap-south-1"
}

data "aws_subnets" "selected" {
  filter {
    name   = "vpc-id"
    values = [var.vpc_id]
  }
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
  key_name               = var.key_name
  user_data              = file("userdata.sh")

  tags = {
    Name = "Elsevier_Web_Server"
  }
}
