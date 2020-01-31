variable "region" {
    description = "AWS Region"
    default = "us-east-1"
}

variable "key_name" {
    description = "key pair name"
}

variable "iam_profile" {
    description = "IAM role"
}

variable "ami" {
  description = "CoreOS AMI"
  default = "ami-000c6a6ff12707589"
}

variable "instance_type" {
  description = "Instance type"
  default = "t2.medium"
}

variable "subnet_id" {
  description = "Subnet ID"
  default = "subnet-e1b39bcf"
}

variable "instance_ips" {
  default = {
    "0" = "172.31.85.10"
    "1" = "172.31.85.20"
    "2" = "172.31.85.30"
    "3" = "172.31.85.40"
    "4" = "172.31.85.50"
    "5" = "172.31.85.60"
  }
}
