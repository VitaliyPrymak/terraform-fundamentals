# Security Group для ALB
resource "aws_security_group" "alb_sg" {
  name        = "alb-sg"
  description = "Allow HTTP/HTTPS traffic to ALB"
  vpc_id      = aws_vpc.main.id

  # HTTP доступ (порт 80)
  ingress {
    from_port   = 4000
    to_port     = 4000
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"] # Дозволяємо весь трафік
  }


  ingress {
    from_port   = 8000
    to_port     = 8000
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]  # Дозволяємо весь трафік
  }

  # Вихідний трафік для ALB
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "alb-sg"
  }
}

# Security Group для Redis
resource "aws_security_group" "redis_sg" {
  name        = "redis-sg"
  description = "Security group for Redis cluster"
  vpc_id      = aws_vpc.main.id

 ingress {
    from_port   = 6379
    to_port     = 6379
    protocol    = "tcp"
    cidr_blocks = ["10.0.0.0/16"]

 }  

  # Вихідний трафік для Redis
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "redis-sg"
  }
}

# Security Group для RDS
resource "aws_security_group" "rds_sg" {
  name        = "rds-sg"
  description = "Security group for RDS"
  vpc_id      = aws_vpc.main.id

  # Доступ до RDS (порт 5432) з ECS та всього VPC
  ingress {
    from_port   = 5432
    to_port     = 5432
    protocol    = "tcp"
    cidr_blocks = ["10.0.0.0/16"]  # дозволяємо доступ всім ресурсам у VPC
  }


  # Вихідний трафік для RDS
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]  # дозволяємо вихідний трафік в інтернет
  }

  tags = {
    Name = "rds-sg"
  }
}

resource "aws_security_group" "backend_rds" {
  name        = "rds-backend"
  description = "Security group for RDS container"
  vpc_id      = aws_vpc.main.id

  # Доступ до RDS (порт 5432) з ECS та всього VPC
  ingress {
    from_port   = 4000
    to_port     = 4000
    protocol    = "tcp"
    cidr_blocks = ["10.0.0.0/16"]  # дозволяємо доступ всім ресурсам у VPC
    security_groups = [aws_security_group.alb_sg.id]
  }


  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]  # дозволяємо вихідний трафік в інтернет
  }

  tags = {
    Name = "rds-backend"
  }
}

resource "aws_security_group" "backend_redis" {
  name        = "redis-backend"
  description = "Security group for Redis container"
  vpc_id      = aws_vpc.main.id

 
  ingress {
    from_port   = 8000
    to_port     = 8000
    protocol    = "tcp"
    cidr_blocks = ["10.0.0.0/16"]  # дозволяємо доступ всім ресурсам у VPC
    security_groups = [aws_security_group.alb_sg.id]
  }


  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]  # дозволяємо вихідний трафік в інтернет
  }

  tags = {
    Name = "redis-backend"
  }
}