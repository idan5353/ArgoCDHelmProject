variable "aws_region" {
  default = "us-east-1"
}

variable "cluster_name" {
  description = "Name of the existing EKS cluster"
  type        = string
}

variable "project_name" {
  default = "eks-helm-demo"
}

variable "environment" {
  default = "dev"
}
