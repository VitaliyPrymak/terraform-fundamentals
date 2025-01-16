output "vpc_id" {
  value = aws_vpc.main.id
}

output "redis_endpoint" {
  value = aws_elasticache_cluster.redis.cache_nodes[0].address
}

output "alb_url" {
  value = aws_alb.main.dns_name
}

output "rds_target_group_arn" {
  value = aws_lb_target_group.rds_tg.arn
}

output "redis_target_group_arn" {
  value = aws_lb_target_group.redis_tg.arn
}

output "rds_ecs_service_id" {
  value = aws_ecs_service.backend_rds_service.id
}

output "redis_ecs_service_id" {
  value = aws_ecs_service.backend_redis_service.id
}
