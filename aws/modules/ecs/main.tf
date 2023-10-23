resource "aws_ecs_cluster" "my_cluster" {
  name = "${var.projectname}-${var.environment}-ecs-cluster"

  tags = {
    Name        = "${var.projectname}-${var.environment}-ecs-cluster"
    Environment = var.environment
  }
}

locals {
  container_definitions = [
    {
      name  = "${var.projectname}-${var.environment}"
      # image = "${var.registry}/${var.projectname}-${var.environment}:latest"
      image                   = "docker.io/oostvoort/dojorps-dev:latest"
      portMappings = [
        for mapping in var.port_mappings : {
          containerPort = mapping.containerPort
          hostPort      = mapping.hostPort
        }
      ]
      logConfiguration = {
      logDriver = "awslogs"
      options = {
        awslogs-group         = aws_cloudwatch_log_group.my_log_group.name
        awslogs-region        = var.aws_region
        awslogs-stream-prefix = "my-prefix"
      }
    }
    }
  ]
}

resource "aws_ecs_task_definition" "my_task" {
  family                   = "${var.projectname}-${var.environment}-task"
  network_mode             = "awsvpc"
  requires_compatibilities = ["FARGATE"]
  cpu                      = var.cpu
  memory                   = var.memory
  execution_role_arn       = aws_iam_role.ecs_execution_role.arn
  container_definitions    = jsonencode(local.container_definitions)

}



resource "aws_ecs_service" "my_service" {
  name            = "${var.projectname}-${var.environment}-ecs-service"
  cluster         = aws_ecs_cluster.my_cluster.id
  launch_type     = "FARGATE"
  task_definition = aws_ecs_task_definition.my_task.arn
  desired_count   = var.desired_count

  network_configuration {
    subnets = var.vpc_subnets
    security_groups = [var.vpc_security_group]
    assign_public_ip = true
  }
}

resource "aws_cloudwatch_log_group" "my_log_group" {
  name = "/ecs/my-log-group"
}
resource "aws_iam_role" "ecs_execution_role" {
  name = "ecs_execution_role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Action = "sts:AssumeRole",
        Effect = "Allow",
        Principal = {
          Service = "ecs-tasks.amazonaws.com"
        }
      }
    ]
  })
}

resource "aws_iam_role_policy_attachment" "ecs_execution_role_policy_attach" {
  role       = aws_iam_role.ecs_execution_role.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonECSTaskExecutionRolePolicy"
}