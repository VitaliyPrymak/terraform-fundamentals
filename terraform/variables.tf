variable "frontend_bucket_name" {
  description = "mys3newbucketnametrfm"
}

variable "environment" {
  description = "Environment (e.g., dev, prod)"
  default     = "dev"
}

variable "alb_dns_name" {
  description = "main-alb-120902197.us-east-1.elb.amazonaws.com"
  type        = string
}