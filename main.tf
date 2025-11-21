terraform {
  required_version = "~>1.1"

#   backend "s3" {
#     bucket         = local.bucket_name
#     key            = "tf-loc/terraform.tfstate"
#     region         = "us-east-1"
#     dynamodb_table = local.dynamodb_table_name
#     encrypt        = true
#   }

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 6.0"
    }
  }
}

module "tf-state" {
  source = "./modules/tf-state"

  bucket_name         = local.bucket_name
  dynamodb_table_name = local.dynamodb_table_name
}

module "ecr_repo" {
  source = "./modules/ecr"

  ecr_repository_name = local.ecr_repository_name
}

module "ecsCluster" {
    source = "./modules/ecs"

    ecs_appl_cluster_name   = local.ecs_appl_cluster_name
    default_az              = local.default_az

    ecs_app_task_family     = local.ecs_app_task_family
    ecr_repository_url      = module.ecr_repo.ecr_repository_url
    ecs_app_container_name  = local.ecs_app_container_name
    ecs_app_container_port  = local.ecs_app_container_port
    ecs_app_task_name       = local.ecs_app_task_name
    ecs_execution_role_name = local.ecs_execution_role_name
    
    default_vpc_name        = local.default_vpc_name
    ecs_app_alb_name        = local.ecs_app_alb_name
    ecs_app_alb_sg_name     = local.ecs_app_alb_sg_name
    ecs_app_alb_tg_name     = local.ecs_app_alb_tg_name
    ecs_app_service_name    = local.ecs_app_service_name
}