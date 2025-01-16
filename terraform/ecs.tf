resource "aws_ecs_cluster" "main" {
  name = "main-ecs-cluster"
}

resource "aws_ecs_task_definition" "backend_rds" {
  family                   = "backend-rds-task"
  network_mode             = "awsvpc"
  requires_compatibilities = ["FARGATE"]
  cpu                      = "256"
  memory                   = "512"

  execution_role_arn = aws_iam_role.ecs_task_execution.arn
  task_role_arn      = aws_iam_role.ecs_task_role.arn

  container_definitions = jsonencode([
    {
      name      = "rds-service"
      image     = "084375565192.dkr.ecr.us-east-1.amazonaws.com/backend-rds-dev:latest"
      essential = true
      portMappings = [
        {
          containerPort = 4000
          name          = "rds-port"
        }
      ]
      environment = [
        { name = "DB_HOST", value = "main-db.cxo842e6snwn.us-east-1.rds.amazonaws.com" },
        { name = "DB_PORT", value = "5432" },
        { name = "DB_USER", value = "myuser" },
        { name = "DB_PASSWORD", value = "mypassword" },
        { name = "DB_NAME", value = "mydatabase" },
        { name = "CORS_ALLOWED_ORIGINS", value = "http://main-alb-120902197.us-east-1.elb.amazonaws.com,http://d3og5nx79bswaf.cloudfront.net" }
      ]
      logConfiguration = {
        logDriver = "awslogs"
        options = {
          awslogs-group         = "/ecs/backend-rds"
          awslogs-region        = "us-east-1"
          awslogs-stream-prefix = "backend-rds"
        }
      }
    }
  ])
}

resource "aws_ecs_service" "backend_rds_service" {
  depends_on = [aws_lb_target_group.rds_tg, aws_alb.main]

  name            = "rds-service"
  cluster         = aws_ecs_cluster.main.id
  task_definition = aws_ecs_task_definition.backend_rds.arn
  launch_type     = "FARGATE"
  desired_count   = 1

  load_balancer {
    target_group_arn = aws_lb_target_group.rds_tg.arn
    container_name   = "rds-service"
    container_port   = 4000
  }

  network_configuration {
    subnets          = [aws_subnet.private_1.id, aws_subnet.private_2.id]
    security_groups  = [aws_security_group.backend_rds.id]
    assign_public_ip = false
  }
}

resource "aws_ecs_task_definition" "backend_redis" {
  family                   = "backend-redis-task"
  network_mode             = "awsvpc"
  requires_compatibilities = ["FARGATE"]
  cpu                      = "256"
  memory                   = "512"

  execution_role_arn = aws_iam_role.ecs_task_execution.arn
  task_role_arn      = aws_iam_role.ecs_task_role.arn

  container_definitions = jsonencode([
    {
      name      = "backend_redis"
      image     = "084375565192.dkr.ecr.us-east-1.amazonaws.com/backend-redis-dev:latest"
      essential = true
      portMappings = [
        {
          containerPort = 8000
          name          = "redis-port"
        }
      ]
      environment = [
        { name = "REDIS_HOST", value = "redis-cluster.soyfzn.0001.use1.cache.amazonaws.com" },
        { name = "REDIS_PORT", value = "6379" },
        { name = "CORS_ALLOWED_ORIGINS", value = "http://main-alb-120902197.us-east-1.elb.amazonaws.com,http://d3og5nx79bswaf.cloudfront.net" }
      ]
      logConfiguration = {
        logDriver = "awslogs"
        options = {
          awslogs-group         = "/ecs/backend-redis"
          awslogs-region        = "us-east-1"
          awslogs-stream-prefix = "ecs"
        }
      }
    }
  ])
}

resource "aws_ecs_service" "backend_redis_service" {
  depends_on = [aws_lb_target_group.redis_tg, aws_alb.main]

  name            = "redis-service"
  cluster         = aws_ecs_cluster.main.id
  task_definition = aws_ecs_task_definition.backend_redis.arn
  launch_type     = "FARGATE"
  desired_count   = 1

  load_balancer {
    target_group_arn = aws_lb_target_group.redis_tg.arn
    container_name   = "backend_redis"
    container_port   = 8000
  }

  network_configuration {
    subnets          = [aws_subnet.private_1.id, aws_subnet.private_2.id]
    security_groups  = [aws_security_group.backend_redis.id]
    assign_public_ip = false
  }

}
