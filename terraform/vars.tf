
variable "domain_name" {
    type = string
    description = "Domain name to use for Route53"
    default = "rupgautam.me"
}

variable "aws_region" {
    type = string
    description = "Default AWS region"
    default = "us-east-1"
}

variable "vpc_cidr_block" {
    default = "10.0.0.0/16"
}

variable "networks" {
  type = map(object({
    cidr_block        = string
    availability_zone = string
  }))
  default = {
    az1 = {
      cidr_block        = "10.0.0.0/24"
      availability_zone = "us-east-1a"
    }
    az2 = {
      cidr_block        = "10.0.1.0/24"
      availability_zone = "us-east-1b"
    }
    az3 = {
      cidr_block        = "10.0.2.0/24"
      availability_zone = "us-east-1c"
    }
  }
}
