variable "key_name" {
  description = "Name of your EC2 key pair"
  type        = string
}

variable "vpc_id" {
  description = " default VPC ID"
  type        = string
  default     = "vpc-085e6ef3728c0c5ae"
}