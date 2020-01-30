variable "region" {
    description = "AWS Region"
    default = "us-east-1"
}

variable "key_name" {
    description = "key pair name"
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
  default = "subnet-23d1806a"
}

variable "instance_ips" {
  default = {
    "0" = "10.50.1.201"
    "1" = "10.50.1.211"
    "2" = "10.50.1.221"
    "3" = "10.50.1.231"
  }
}
