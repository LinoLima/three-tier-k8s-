# ============================================================
# variables.tf
# ============================================================

variable "aws_region" {
  description = "AWS region"
  type        = string
  default     = "us-east-1"
}

variable "project_name" {
  description = "Project name prefix for all resources"
  type        = string
  default     = "three-tier-k8s"
}

variable "environment" {
  description = "Environment name"
  type        = string
  default     = "prod"
}

# ── Networking ──────────────────────────────────────────────

variable "vpc_cidr" {
  type    = string
  default = "172.16.0.0/16"
}

variable "public_subnet_cidrs" {
  type    = list(string)
  default = ["172.16.0.0/24", "172.16.1.0/24"]
}

variable "private_subnet_cidrs" {
  type    = list(string)
  default = ["172.16.2.0/24", "172.16.3.0/24"]
}

variable "db_subnet_cidrs" {
  type    = list(string)
  default = ["172.16.4.0/24", "172.16.5.0/24"]
}

variable "availability_zones" {
  type    = list(string)
  default = ["us-east-1a", "us-east-1b"]
}

# ── EKS ─────────────────────────────────────────────────────

variable "eks_cluster_version" {
  description = "Kubernetes version for EKS"
  type        = string
  default     = "1.29"
}

variable "node_instance_type" {
  description = "EC2 instance type for EKS worker nodes"
  type        = string
  default     = "t3.medium"
}

variable "node_desired_size" {
  type    = number
  default = 2
}

variable "node_min_size" {
  type    = number
  default = 2
}

variable "node_max_size" {
  type    = number
  default = 4
}

# ── ECR ─────────────────────────────────────────────────────

variable "frontend_image" {
  description = "Full ECR URI for frontend image"
  type        = string
  default     = "740525964121.dkr.ecr.us-east-1.amazonaws.com/three-tier-k8s-frontend:latest"
}

variable "backend_image" {
  description = "Full ECR URI for backend image"
  type        = string
  default     = "740525964121.dkr.ecr.us-east-1.amazonaws.com/three-tier-k8s-backend:lates"
}

# ── RDS ─────────────────────────────────────────────────────

variable "db_name" {
  type    = string
  default = "appdb"
}

variable "db_username" {
  type      = string
  default   = "dbadmin"
  sensitive = true
}

variable "db_password" {
  type      = string
  sensitive = true
}

variable "db_instance_class" {
  type    = string
  default = "db.t3.micro"
}
