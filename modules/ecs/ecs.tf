resource "aws_ecs_cluster" "vjai-app-cluster" {
  name = var.ecs_appl_cluster_name

  setting {
    name  = "containerInsights"
    value = "enabled"
  }
}

resource "aws_ecs_task_definition" "vjai-app-task" {
  family                   = var.ecs_app_task_family
  requires_compatibilities = ["FARGATE"]
  network_mode             = "awsvpc"
  cpu                      = 256
  memory                   = 512
  execution_role_arn       = aws_iam_role.ecs_execution_role.arn

  container_definitions = jsonencode(
    [
      {
        name      = var.ecs_app_container_name
        image     = "${var.ecr_repository_url}:latest"
        essential = true
        portMappings = [
          {
            containerPort = var.ecs_app_container_port
            hostPort      = var.ecs_app_container_port
          }
        ]
      }
    ]
  )
}

resource "aws_default_vpc" "default_vpc" {
  tags = {
    Name = var.default_vpc_name
  }
}

resource "aws_default_subnet" "default_subnet_1" {
  availability_zone = var.default_az[0]
}

resource "aws_default_subnet" "default_subnet_2" {
  availability_zone = var.default_az[1]
}

resource "aws_iam_role" "ecs_execution_role" {
  name = var.ecs_execution_role_name

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Principal = {
          Service = "ecs-tasks.amazonaws.com"
        }
      }
    ]
  })
}

resource "aws_iam_role_policy_attachment" "ecs_execution_role_policy_attachment" {
  role       = aws_iam_role.ecs_execution_role.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonECSTaskExecutionRolePolicy"
}

resource "aws_alb" "ecs_app_alb" {
  name               = var.ecs_app_alb_name
  load_balancer_type = "application"
  subnets            = [aws_default_subnet.default_subnet_1.id, aws_default_subnet.default_subnet_2.id]

  security_groups = [aws_security_group.ecs_app_alb_sg.id]
}

resource "aws_security_group" "ecs_app_alb_sg" {
  name        = var.ecs_app_alb_sg_name
  description = "Security group for ECS application ALB"
  vpc_id      = aws_default_vpc.default_vpc.id

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 8000
    to_port     = 8000
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_alb_target_group" "ecs_app_alb_tg" {
  name        = var.ecs_app_alb_tg_name
  port        = var.ecs_app_container_port
  protocol    = "HTTP"
  target_type = "ip"
  vpc_id      = aws_default_vpc.default_vpc.id
}

resource "aws_alb_listener" "ecs_app_alb_listener" {
  load_balancer_arn = aws_alb.ecs_app_alb.arn
  port              = 80
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_alb_target_group.ecs_app_alb_tg.arn
  }
}

resource "aws_ecs_service" "vjai-app-service" {
  name            = var.ecs_app_service_name
  cluster         = aws_ecs_cluster.vjai-app-cluster.id
  task_definition = aws_ecs_task_definition.vjai-app-task.arn
  launch_type     = "FARGATE"
  desired_count   = 1

  network_configuration {
    subnets          = [aws_default_subnet.default_subnet_1.id, aws_default_subnet.default_subnet_2.id]
    security_groups  = [aws_security_group.ecs_app_alb_sg.id]
    assign_public_ip = true
  }

  load_balancer {
    target_group_arn = aws_alb_target_group.ecs_app_alb_tg.arn
    container_name   = var.ecs_app_container_name
    container_port   = var.ecs_app_container_port
  }

  depends_on = [aws_iam_role_policy_attachment.ecs_execution_role_policy_attachment]
}

resource "aws_security_group" "ecs_service_sg" {
  ingress {
    from_port       = 0
    to_port         = 0
    protocol        = "-1"
    security_groups = [aws_security_group.ecs_app_alb_sg.id]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}
