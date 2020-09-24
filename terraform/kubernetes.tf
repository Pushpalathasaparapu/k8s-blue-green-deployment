provider "aws" {
  region = "us-east-1"
}

resource "aws_autoscaling_group" "master-us-east-1a-masters-k8s-rupgautam-me" {
  name                 = "master-us-east-1a.masters.k8s.rupgautam.me"
  launch_configuration = aws_launch_configuration.master-us-east-1a-masters-k8s-rupgautam-me.id
  max_size             = 1
  min_size             = 1
  vpc_zone_identifier  = [aws_subnet.us-east-1a-k8s-rupgautam-me.id]

  tag {
    key                 = "KubernetesCluster"
    value               = "k8s.rupgautam.me"
    propagate_at_launch = true
  }

  tag {
    key                 = "Name"
    value               = "master-us-east-1a.masters.k8s.rupgautam.me"
    propagate_at_launch = true
  }

  tag {
    key                 = "k8s.io/cluster-autoscaler/node-template/label/kops.k8s.io/instancegroup"
    value               = "master-us-east-1a"
    propagate_at_launch = true
  }

  tag {
    key                 = "k8s.io/role/master"
    value               = "1"
    propagate_at_launch = true
  }

  tag {
    key                 = "kops.k8s.io/instancegroup"
    value               = "master-us-east-1a"
    propagate_at_launch = true
  }

  metrics_granularity = "1Minute"
  enabled_metrics     = ["GroupDesiredCapacity", "GroupInServiceInstances", "GroupMaxSize", "GroupMinSize", "GroupPendingInstances", "GroupStandbyInstances", "GroupTerminatingInstances", "GroupTotalInstances"]
}

resource "aws_autoscaling_group" "nodes-k8s-rupgautam-me" {
  name                 = "nodes.k8s.rupgautam.me"
  launch_configuration = aws_launch_configuration.nodes-k8s-rupgautam-me.id
  max_size             = 2
  min_size             = 2
  vpc_zone_identifier  = [aws_subnet.us-east-1a-k8s-rupgautam-me.id]

  tag {
    key                 = "KubernetesCluster"
    value               = "k8s.rupgautam.me"
    propagate_at_launch = true
  }

  tag {
    key                 = "Name"
    value               = "nodes.k8s.rupgautam.me"
    propagate_at_launch = true
  }

  tag {
    key                 = "k8s.io/cluster-autoscaler/node-template/label/kops.k8s.io/instancegroup"
    value               = "nodes"
    propagate_at_launch = true
  }

  tag {
    key                 = "k8s.io/role/node"
    value               = "1"
    propagate_at_launch = true
  }

  tag {
    key                 = "kops.k8s.io/instancegroup"
    value               = "nodes"
    propagate_at_launch = true
  }

  metrics_granularity = "1Minute"
  enabled_metrics     = ["GroupDesiredCapacity", "GroupInServiceInstances", "GroupMaxSize", "GroupMinSize", "GroupPendingInstances", "GroupStandbyInstances", "GroupTerminatingInstances", "GroupTotalInstances"]
}

resource "aws_ebs_volume" "a-etcd-events-k8s-rupgautam-me" {
  availability_zone = "us-east-1a"
  size              = 20
  type              = "gp2"
  encrypted         = false

  tags = {
    KubernetesCluster                        = "k8s.rupgautam.me"
    Name                                     = "a.etcd-events.k8s.rupgautam.me"
    "k8s.io/etcd/events"                     = "a/a"
    "k8s.io/role/master"                     = "1"
    "kubernetes.io/cluster/k8s.rupgautam.me" = "owned"
  }
}

resource "aws_ebs_volume" "a-etcd-main-k8s-rupgautam-me" {
  availability_zone = "us-east-1a"
  size              = 20
  type              = "gp2"
  encrypted         = false

  tags = {
    KubernetesCluster                        = "k8s.rupgautam.me"
    Name                                     = "a.etcd-main.k8s.rupgautam.me"
    "k8s.io/etcd/main"                       = "a/a"
    "k8s.io/role/master"                     = "1"
    "kubernetes.io/cluster/k8s.rupgautam.me" = "owned"
  }
}

resource "aws_iam_instance_profile" "masters-k8s-rupgautam-me" {
  name = "masters.k8s.rupgautam.me"
  role = aws_iam_role.masters-k8s-rupgautam-me.name
}

resource "aws_iam_instance_profile" "nodes-k8s-rupgautam-me" {
  name = "nodes.k8s.rupgautam.me"
  role = aws_iam_role.nodes-k8s-rupgautam-me.name
}

resource "aws_iam_role" "masters-k8s-rupgautam-me" {
  name = "masters.k8s.rupgautam.me"
  assume_role_policy = file(
    "${path.module}/data/aws_iam_role_masters.k8s.rupgautam.me_policy",
  )
}

resource "aws_iam_role" "nodes-k8s-rupgautam-me" {
  name = "nodes.k8s.rupgautam.me"
  assume_role_policy = file(
    "${path.module}/data/aws_iam_role_nodes.k8s.rupgautam.me_policy",
  )
}

resource "aws_iam_role_policy" "masters-k8s-rupgautam-me" {
  name = "masters.k8s.rupgautam.me"
  role = aws_iam_role.masters-k8s-rupgautam-me.name
  policy = file(
    "${path.module}/data/aws_iam_role_policy_masters.k8s.rupgautam.me_policy",
  )
}

resource "aws_iam_role_policy" "nodes-k8s-rupgautam-me" {
  name = "nodes.k8s.rupgautam.me"
  role = aws_iam_role.nodes-k8s-rupgautam-me.name
  policy = file(
    "${path.module}/data/aws_iam_role_policy_nodes.k8s.rupgautam.me_policy",
  )
}

resource "aws_internet_gateway" "k8s-rupgautam-me" {
  vpc_id = aws_vpc.k8s-rupgautam-me.id

  tags = {
    KubernetesCluster                        = "k8s.rupgautam.me"
    Name                                     = "k8s.rupgautam.me"
    "kubernetes.io/cluster/k8s.rupgautam.me" = "owned"
  }
}

resource "aws_key_pair" "kubernetes-k8s-rupgautam-me-d00a6fa742f2550f0813dbe8b2aebd2c" {
  key_name = "kubernetes.k8s.rupgautam.me-d0:0a:6f:a7:42:f2:55:0f:08:13:db:e8:b2:ae:bd:2c"
  public_key = file(
    "${path.module}/data/aws_key_pair_kubernetes.k8s.rupgautam.me-d00a6fa742f2550f0813dbe8b2aebd2c_public_key",
  )
}

resource "aws_launch_configuration" "master-us-east-1a-masters-k8s-rupgautam-me" {
  name_prefix                 = "master-us-east-1a.masters.k8s.rupgautam.me-"
  image_id                    = "ami-0f62f8487dfae2dcb"
  instance_type               = "t3.medium"
  key_name                    = aws_key_pair.kubernetes-k8s-rupgautam-me-d00a6fa742f2550f0813dbe8b2aebd2c.id
  iam_instance_profile        = aws_iam_instance_profile.masters-k8s-rupgautam-me.id
  security_groups             = [aws_security_group.masters-k8s-rupgautam-me.id]
  associate_public_ip_address = true
  user_data = file(
    "${path.module}/data/aws_launch_configuration_master-us-east-1a.masters.k8s.rupgautam.me_user_data",
  )

  root_block_device {
    volume_type           = "gp2"
    volume_size           = 64
    delete_on_termination = true
  }

  lifecycle {
    create_before_destroy = true
  }

  enable_monitoring = false
}

resource "aws_launch_configuration" "nodes-k8s-rupgautam-me" {
  name_prefix                 = "nodes.k8s.rupgautam.me-"
  image_id                    = "ami-0f62f8487dfae2dcb"
  instance_type               = "t3.medium"
  key_name                    = aws_key_pair.kubernetes-k8s-rupgautam-me-d00a6fa742f2550f0813dbe8b2aebd2c.id
  iam_instance_profile        = aws_iam_instance_profile.nodes-k8s-rupgautam-me.id
  security_groups             = [aws_security_group.nodes-k8s-rupgautam-me.id]
  associate_public_ip_address = true
  user_data = file(
    "${path.module}/data/aws_launch_configuration_nodes.k8s.rupgautam.me_user_data",
  )

  root_block_device {
    volume_type           = "gp2"
    volume_size           = 128
    delete_on_termination = true
  }

  lifecycle {
    create_before_destroy = true
  }

  enable_monitoring = false
}

resource "aws_route" "route-0-0-0-0--0" {
  route_table_id         = aws_route_table.k8s-rupgautam-me.id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = aws_internet_gateway.k8s-rupgautam-me.id
}

resource "aws_route_table" "k8s-rupgautam-me" {
  vpc_id = aws_vpc.k8s-rupgautam-me.id

  tags = {
    KubernetesCluster                        = "k8s.rupgautam.me"
    Name                                     = "k8s.rupgautam.me"
    "kubernetes.io/cluster/k8s.rupgautam.me" = "owned"
    "kubernetes.io/kops/role"                = "public"
  }
}

resource "aws_route_table_association" "us-east-1a-k8s-rupgautam-me" {
  subnet_id      = aws_subnet.us-east-1a-k8s-rupgautam-me.id
  route_table_id = aws_route_table.k8s-rupgautam-me.id
}

resource "aws_security_group" "masters-k8s-rupgautam-me" {
  name        = "masters.k8s.rupgautam.me"
  vpc_id      = aws_vpc.k8s-rupgautam-me.id
  description = "Security group for masters"

  tags = {
    KubernetesCluster                        = "k8s.rupgautam.me"
    Name                                     = "masters.k8s.rupgautam.me"
    "kubernetes.io/cluster/k8s.rupgautam.me" = "owned"
  }
}

resource "aws_security_group" "nodes-k8s-rupgautam-me" {
  name        = "nodes.k8s.rupgautam.me"
  vpc_id      = aws_vpc.k8s-rupgautam-me.id
  description = "Security group for nodes"

  tags = {
    KubernetesCluster                        = "k8s.rupgautam.me"
    Name                                     = "nodes.k8s.rupgautam.me"
    "kubernetes.io/cluster/k8s.rupgautam.me" = "owned"
  }
}

resource "aws_security_group_rule" "all-master-to-master" {
  type                     = "ingress"
  security_group_id        = aws_security_group.masters-k8s-rupgautam-me.id
  source_security_group_id = aws_security_group.masters-k8s-rupgautam-me.id
  from_port                = 0
  to_port                  = 0
  protocol                 = "-1"
}

resource "aws_security_group_rule" "all-master-to-node" {
  type                     = "ingress"
  security_group_id        = aws_security_group.nodes-k8s-rupgautam-me.id
  source_security_group_id = aws_security_group.masters-k8s-rupgautam-me.id
  from_port                = 0
  to_port                  = 0
  protocol                 = "-1"
}

resource "aws_security_group_rule" "all-node-to-node" {
  type                     = "ingress"
  security_group_id        = aws_security_group.nodes-k8s-rupgautam-me.id
  source_security_group_id = aws_security_group.nodes-k8s-rupgautam-me.id
  from_port                = 0
  to_port                  = 0
  protocol                 = "-1"
}

resource "aws_security_group_rule" "https-external-to-master-0-0-0-0--0" {
  type              = "ingress"
  security_group_id = aws_security_group.masters-k8s-rupgautam-me.id
  from_port         = 443
  to_port           = 443
  protocol          = "tcp"
  cidr_blocks       = ["0.0.0.0/0"]
}

resource "aws_security_group_rule" "master-egress" {
  type              = "egress"
  security_group_id = aws_security_group.masters-k8s-rupgautam-me.id
  from_port         = 0
  to_port           = 0
  protocol          = "-1"
  cidr_blocks       = ["0.0.0.0/0"]
}

resource "aws_security_group_rule" "node-egress" {
  type              = "egress"
  security_group_id = aws_security_group.nodes-k8s-rupgautam-me.id
  from_port         = 0
  to_port           = 0
  protocol          = "-1"
  cidr_blocks       = ["0.0.0.0/0"]
}

resource "aws_security_group_rule" "node-to-master-protocol-ipip" {
  type                     = "ingress"
  security_group_id        = aws_security_group.masters-k8s-rupgautam-me.id
  source_security_group_id = aws_security_group.nodes-k8s-rupgautam-me.id
  from_port                = 0
  to_port                  = 65535
  protocol                 = "4"
}

resource "aws_security_group_rule" "node-to-master-tcp-1-2379" {
  type                     = "ingress"
  security_group_id        = aws_security_group.masters-k8s-rupgautam-me.id
  source_security_group_id = aws_security_group.nodes-k8s-rupgautam-me.id
  from_port                = 1
  to_port                  = 2379
  protocol                 = "tcp"
}

resource "aws_security_group_rule" "node-to-master-tcp-2382-4001" {
  type                     = "ingress"
  security_group_id        = aws_security_group.masters-k8s-rupgautam-me.id
  source_security_group_id = aws_security_group.nodes-k8s-rupgautam-me.id
  from_port                = 2382
  to_port                  = 4001
  protocol                 = "tcp"
}

resource "aws_security_group_rule" "node-to-master-tcp-4003-65535" {
  type                     = "ingress"
  security_group_id        = aws_security_group.masters-k8s-rupgautam-me.id
  source_security_group_id = aws_security_group.nodes-k8s-rupgautam-me.id
  from_port                = 4003
  to_port                  = 65535
  protocol                 = "tcp"
}

resource "aws_security_group_rule" "node-to-master-udp-1-65535" {
  type                     = "ingress"
  security_group_id        = aws_security_group.masters-k8s-rupgautam-me.id
  source_security_group_id = aws_security_group.nodes-k8s-rupgautam-me.id
  from_port                = 1
  to_port                  = 65535
  protocol                 = "udp"
}

resource "aws_security_group_rule" "ssh-external-to-master-0-0-0-0--0" {
  type              = "ingress"
  security_group_id = aws_security_group.masters-k8s-rupgautam-me.id
  from_port         = 22
  to_port           = 22
  protocol          = "tcp"
  cidr_blocks       = ["0.0.0.0/0"]
}

resource "aws_security_group_rule" "ssh-external-to-node-0-0-0-0--0" {
  type              = "ingress"
  security_group_id = aws_security_group.nodes-k8s-rupgautam-me.id
  from_port         = 22
  to_port           = 22
  protocol          = "tcp"
  cidr_blocks       = ["0.0.0.0/0"]
}

resource "aws_subnet" "us-east-1a-k8s-rupgautam-me" {
  vpc_id            = aws_vpc.k8s-rupgautam-me.id
  cidr_block        = "172.20.32.0/19"
  availability_zone = "us-east-1a"

  tags = {
    KubernetesCluster                        = "k8s.rupgautam.me"
    Name                                     = "us-east-1a.k8s.rupgautam.me"
    SubnetType                               = "Public"
    "kubernetes.io/cluster/k8s.rupgautam.me" = "owned"
    "kubernetes.io/role/elb"                 = "1"
  }
}

resource "aws_vpc" "k8s-rupgautam-me" {
  cidr_block           = "172.20.0.0/16"
  enable_dns_hostnames = true
  enable_dns_support   = true

  tags = {
    KubernetesCluster                        = "k8s.rupgautam.me"
    Name                                     = "k8s.rupgautam.me"
    "kubernetes.io/cluster/k8s.rupgautam.me" = "owned"
  }
}

resource "aws_vpc_dhcp_options" "k8s-rupgautam-me" {
  domain_name         = "ec2.internal"
  domain_name_servers = ["AmazonProvidedDNS"]

  tags = {
    KubernetesCluster                        = "k8s.rupgautam.me"
    Name                                     = "k8s.rupgautam.me"
    "kubernetes.io/cluster/k8s.rupgautam.me" = "owned"
  }
}

resource "aws_vpc_dhcp_options_association" "k8s-rupgautam-me" {
  vpc_id          = aws_vpc.k8s-rupgautam-me.id
  dhcp_options_id = aws_vpc_dhcp_options.k8s-rupgautam-me.id
}
