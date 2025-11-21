output "task_definition_arn" {
  description = "ARN of the ECS task definition created in this module"
  value       = aws_ecs_task_definition.vjai-app-task.arn
}

output "ecs_cluster_id" {
  description = "ECS cluster id"
  value       = aws_ecs_cluster.vjai-app-cluster.id
}

output "ecs_service_arn" {
  description = "ECS service ARN"
  value       = aws_ecs_service.vjai-app-service.arn
}
