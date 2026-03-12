# ============================================================
# main.tf
# ============================================================

data "aws_caller_identity" "current" {}

# ── CloudWatch Log Groups ────────────────────────────────────
resource "aws_cloudwatch_log_group" "frontend" {
  name              = "/eks/${var.project_name}/frontend"
  retention_in_days = 7
}

resource "aws_cloudwatch_log_group" "backend" {
  name              = "/eks/${var.project_name}/backend"
  retention_in_days = 7
}
