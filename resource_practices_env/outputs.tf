
output "eks_cluster_endpoint" {
  value = module.eks.cluster-endpoint
}

output "eks_cluster_name" {
  value = module.eks.cluster-name
}

output "aws_region" {
  value = data.aws_region.current.name
}
