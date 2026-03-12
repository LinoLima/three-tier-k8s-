# ============================================================
# outputs.tf
# ============================================================

output "eks_cluster_name" {
  value = aws_eks_cluster.main.name
}

output "eks_cluster_endpoint" {
  value = aws_eks_cluster.main.endpoint
}

output "frontend_ecr_uri" {
  value = aws_ecr_repository.frontend.repository_url
}

output "backend_ecr_uri" {
  value = aws_ecr_repository.backend.repository_url
}

output "rds_endpoint" {
  value     = aws_db_instance.postgres.address
  sensitive = true
}

output "vpc_id" {
  value = aws_vpc.main.id
}

output "kubeconfig_command" {
  description = "Run this to configure kubectl"
  value       = "aws eks update-kubeconfig --region ${var.aws_region} --name ${aws_eks_cluster.main.name}"
}
