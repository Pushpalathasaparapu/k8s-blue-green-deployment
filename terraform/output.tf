output "cluster_name" {
  value = "k8s.rupgautam.me"
}

output "master_autoscaling_group_ids" {
  value = [aws_autoscaling_group.master-us-east-1a-masters-k8s-rupgautam-me.id]
}

output "master_security_group_ids" {
  value = [aws_security_group.masters-k8s-rupgautam-me.id]
}

output "masters_role_arn" {
  value = aws_iam_role.masters-k8s-rupgautam-me.arn
}

output "masters_role_name" {
  value = aws_iam_role.masters-k8s-rupgautam-me.name
}

output "node_autoscaling_group_ids" {
  value = [aws_autoscaling_group.nodes-k8s-rupgautam-me.id]
}

output "node_security_group_ids" {
  value = [aws_security_group.nodes-k8s-rupgautam-me.id]
}

output "node_subnet_ids" {
  value = [aws_subnet.us-east-1a-k8s-rupgautam-me.id]
}

output "nodes_role_arn" {
  value = aws_iam_role.nodes-k8s-rupgautam-me.arn
}

output "nodes_role_name" {
  value = aws_iam_role.nodes-k8s-rupgautam-me.name
}

output "region" {
  value = "us-east-1"
}

output "route_table_public_id" {
  value = aws_route_table.k8s-rupgautam-me.id
}

output "subnet_us-east-1a_id" {
  value = aws_subnet.us-east-1a-k8s-rupgautam-me.id
}

output "vpc_cidr_block" {
  value = aws_vpc.k8s-rupgautam-me.cidr_block
}

output "vpc_id" {
  value = aws_vpc.k8s-rupgautam-me.id
}