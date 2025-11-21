variable "ecs_appl_cluster_name" {
  description = "The name of the ECS application cluster"
  type        = string
}

variable "default_az" {
  description = "List of availability zones"
  type        = list(string)
}

variable "ecs_app_task_family" {
  description = "The family name of the ECS task definition"
  type        = string
}

variable "ecr_repository_url" {
  description = "The URL of the ECR repository"
  type        = string
}

variable "ecs_app_container_name" {
  description = "The name of the ECS application container"
  type        = string
}

variable "ecs_app_container_port" {
  description = "The port on which the ECS application container listens"
  type        = number
}

variable "ecs_execution_role_name" {
  description = "The name of the ECS execution role"
  type        = string
}

variable "default_vpc_name" {
  description = "The name of the default VPC"
  type        = string
}

variable "ecs_app_alb_name" {
  description = "The name of the ECS application ALB"
  type        = string
}

variable "ecs_app_alb_sg_name" {
  description = "The name of the ECS application ALB security group"
  type        = string
}

variable "ecs_app_alb_tg_name" {
  description = "The name of the ECS application ALB target group"
  type        = string
}

variable "ecs_app_service_name" {
  description = "The name of the ECS application service"
  type        = string
}

variable "ecs_app_task_name" {
  description = "The name of the ECS application task"
  type        = string
}