locals {
  cluster_name                 = "k8s.rupgautam.me"
  master_autoscaling_group_ids = [aws_autoscaling_group.master-us-east-1a-masters-k8s-rupgautam-me.id]
  master_security_group_ids    = [aws_security_group.masters-k8s-rupgautam-me.id]
  masters_role_arn             = aws_iam_role.masters-k8s-rupgautam-me.arn
  masters_role_name            = aws_iam_role.masters-k8s-rupgautam-me.name
  node_autoscaling_group_ids   = [aws_autoscaling_group.nodes-k8s-rupgautam-me.id]
  node_security_group_ids      = [aws_security_group.nodes-k8s-rupgautam-me.id]
  node_subnet_ids              = [aws_subnet.us-east-1a-k8s-rupgautam-me.id]
  nodes_role_arn               = aws_iam_role.nodes-k8s-rupgautam-me.arn
  nodes_role_name              = aws_iam_role.nodes-k8s-rupgautam-me.name
  region                       = "us-east-1"
  route_table_public_id        = aws_route_table.k8s-rupgautam-me.id
  subnet_us-east-1a_id         = aws_subnet.us-east-1a-k8s-rupgautam-me.id
  vpc_cidr_block               = aws_vpc.k8s-rupgautam-me.cidr_block
  vpc_id                       = aws_vpc.k8s-rupgautam-me.id
}