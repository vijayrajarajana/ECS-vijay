resource "aws_ecr_repository" "vjai_ecr_repo" {
    name                 = var.ecr_repository_name
    image_tag_mutability = "MUTABLE"
    force_delete = true
    image_scanning_configuration {
        scan_on_push = true
    }
    lifecycle {
        prevent_destroy = false
  }
}
