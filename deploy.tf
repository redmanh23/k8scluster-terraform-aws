resource "aws_instance" "master01" {
  count                 = 1
  ami                   = "${var.ami}"
  instance_type         = "${var.instance_type}"
  subnet_id             = "${var.subnet_id}"
  availability_zone     = "us-east-1d"
  key_name              = "${var.key_name}"
  iam_instance_profile  = "swarmProvisioning"
  private_ip            = "${lookup(var.instance_ips, count.index)}"
  user_data             = "${file("clc/server1.ign")}"
  root_block_device {
  volume_type = "gp2"
  volume_size = 80
}
  ebs_block_device {
    device_name = "/dev/xvdb"
    volume_size = "100"
    volume_type = "gp2"
  }
  security_groups       = ["sg-0f5746b135027d69e","sg-4ff50933"]

  tags = {
    Name = "K8s Cluster ${count.index + 1}"
    "kubernetes.io/cluster/kubernetes" = "owned"
  }
}

resource "aws_instance" "master02" {
  count                 = 1
  ami                   = "${var.ami}"
  instance_type         = "${var.instance_type}"
  subnet_id             = "${var.subnet_id}"
  availability_zone     = "us-east-1d"
  key_name              = "${var.key_name}"
  iam_instance_profile  = "swarmProvisioning"
  private_ip            = "${lookup(var.instance_ips, count.index + 1)}"
  user_data             = "${file("clc/server2.ign")}"
  depends_on            = ["aws_instance.master01"]
  root_block_device {
  volume_type = "gp2"
  volume_size = 100
}
  ebs_block_device {
    device_name = "/dev/xvdb"
    volume_size = "100"
    volume_type = "gp2"
  }
  security_groups       = ["sg-0f5746b135027d69e","sg-4ff50933"]

tags = {
    Name = "K8s Cluster ${count.index + 2}"
    "kubernetes.io/cluster/kubernetes" = "owned"
  }
}

resource "aws_instance" "master03" {
  count                 = 1
  ami                   = "${var.ami}"
  instance_type         = "${var.instance_type}"
  subnet_id             = "${var.subnet_id}"
  availability_zone     = "us-east-1d"
  key_name              = "${var.key_name}"
  iam_instance_profile  = "swarmProvisioning"
  private_ip            = "${lookup(var.instance_ips, count.index + 2)}"
  user_data             = "${file("clc/server3.ign")}"
  depends_on            = ["aws_instance.master01"]
  root_block_device {
  volume_type = "gp2"
  volume_size = 100
}
  ebs_block_device {
    device_name = "/dev/xvdb"
    volume_size = "100"
    volume_type = "gp2"
  }
  security_groups       = ["sg-0f5746b135027d69e","sg-4ff50933"]

tags = {
    Name = "K8s Cluster ${count.index + 3}"
    "kubernetes.io/cluster/kubernetes" = "owned"
  }
}

resource "aws_instance" "worker01" {
  count                 = 1
  ami                   = "${var.ami}"
  instance_type         = "${var.instance_type}"
  subnet_id             = "${var.subnet_id}"
  availability_zone     = "us-east-1d"
  key_name              = "${var.key_name}"
  iam_instance_profile  = "swarmProvisioning"
  private_ip            = "${lookup(var.instance_ips, count.index + 3)}"
  user_data             = "${file("clc/server4.ign")}"
  depends_on            = ["aws_instance.master01"]
  root_block_device {
  volume_type = "gp2"
  volume_size = 100
}
  ebs_block_device {
    device_name = "/dev/xvdb"
    volume_size = "100"
    volume_type = "gp2"
  }
  security_groups       = ["sg-0f5746b135027d69e","sg-4ff50933"]

tags = {
    Name = "K8s Cluster ${count.index + 4}"
    "kubernetes.io/cluster/kubernetes" = "owned"
  }
}

resource "aws_instance" "worker03" {
  count                 = 1
  ami                   = "${var.ami}"
  instance_type         = "${var.instance_type}"
  subnet_id             = "${var.subnet_id}"
  availability_zone     = "us-east-1d"
  key_name              = "${var.key_name}"
  iam_instance_profile  = "swarmProvisioning"
  private_ip            = "${lookup(var.instance_ips, count.index + 3)}"
  user_data             = "${file("clc/server5.ign")}"
  depends_on            = ["aws_instance.master01"]
  root_block_device {
  volume_type = "gp2"
  volume_size = 100
}
  ebs_block_device {
    device_name = "/dev/xvdb"
    volume_size = "100"
    volume_type = "gp2"
  }
  security_groups       = ["sg-0f5746b135027d69e","sg-4ff50933"]

tags = {
    Name = "K8s Cluster ${count.index + 5}"
    "kubernetes.io/cluster/kubernetes" = "owned"
  }
}

resource "aws_instance" "worker03" {
  count                 = 1
  ami                   = "${var.ami}"
  instance_type         = "${var.instance_type}"
  subnet_id             = "${var.subnet_id}"
  availability_zone     = "us-east-1d"
  key_name              = "${var.key_name}"
  iam_instance_profile  = "swarmProvisioning"
  private_ip            = "${lookup(var.instance_ips, count.index + 3)}"
  user_data             = "${file("clc/server6.ign")}"
  depends_on            = ["aws_instance.master01"]
  root_block_device {
  volume_type = "gp2"
  volume_size = 100
}
  ebs_block_device {
    device_name = "/dev/xvdb"
    volume_size = "100"
    volume_type = "gp2"
  }
  security_groups       = ["sg-0f5746b135027d69e","sg-4ff50933"]

tags = {
    Name = "K8s Cluster ${count.index + 6}"
    "kubernetes.io/cluster/kubernetes" = "owned"
  }
}
