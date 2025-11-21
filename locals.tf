locals {
  bucket_name         = "vjai-bucket-192345"
  dynamodb_table_name = "vjai-tf-lock-table"

  ecr_repository_name = "vjai-ecrappl-repo"

  ecs_appl_cluster_name   = "vjai-ecs-app-cluster"
  default_az              = ["us-east-1a", "us-east-1b"]
  ecs_app_task_family     = "service"
  ecs_app_container_name  = "vjai-ecs-app-container"
  ecs_app_container_port  = 8000
  ecs_execution_role_name = "vjai-ecs-execution-role"
  default_vpc_name        = "vjai-default-vpc"
  ecs_app_alb_name        = "vjai-ecs-app-alb"
  ecs_app_alb_sg_name     = "vjai-ecs-app-alb-sg"
  ecs_app_alb_tg_name     = "vjai-ecs-app-alb-tg"
  ecs_app_service_name    = "vjai-ecs-app-service"
  ecs_app_task_name       = "vjai-ecs-app-task"
}   