output "vpc_id" {
  value = "${aws_vpc.k8s-vpc.id}"
}

data "aws_subnet_ids" "subnet_ids" {
  depends_on = [
    aws_subnet.subnets
  ]
  vpc_id = aws_vpc.k8s-vpc.id
}

output "subnet_ids" {
  value = data.aws_subnet_ids.subnet_ids.ids.*
}

output "networks" {
  value = var.networks
}