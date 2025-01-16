resource "aws_alb" "main" {
  name               = "main-alb"
  internal           = false
  load_balancer_type = "application"
  security_groups    = [aws_security_group.alb_sg.id]
  subnets            = [aws_subnet.public_1.id, aws_subnet.public_2.id]

  tags = {
    Name        = "main-alb"
    Environment = "dev"
  }
}

resource "aws_alb_listener" "http" {
  load_balancer_arn = aws_alb.main.arn
  port              = 4000
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.rds_tg.arn
  }
}

resource "aws_alb_listener" "http_redis" {
  load_balancer_arn = aws_alb.main.arn
  port              = 8000  # Використовуємо інший порт для Redis
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.redis_tg.arn
  }
}


resource "aws_lb_target_group" "rds_tg" {
  name        = "rds-target-group"
  port        = 4000
  protocol    = "HTTP"
  vpc_id      = aws_vpc.main.id
  target_type = "ip"

  health_check {
    path = "/test_connection/"
    matcher = "200-299"
  }

  tags = {
    Name = "rds-target-group"
  }
}

resource "aws_lb_target_group" "redis_tg" {
  name        = "redis-target-group"
  port        = 8000
  protocol    = "HTTP"
  vpc_id      = aws_vpc.main.id
  target_type = "ip"

  health_check {
    path = "/test_connection/"
    matcher = "200-299"
  }

  tags = {
    Name = "redis-target-group"
  }
}


