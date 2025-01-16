resource "aws_s3_bucket" "frontend" {
  provider = aws.us-east-1
  bucket = "mys3trfmnewbucket"
  acl    = "private" # Ensure it's private for CloudFront

  versioning {
    enabled = true
  }

  tags = {
    Name        = "Frontend Bucket"
    Environment = "Production"
  }
}

resource "aws_s3_bucket_policy" "frontend_policy" {
  bucket = aws_s3_bucket.frontend.id

  policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Sid       = "AllowCloudFrontAccess",
        Effect    = "Allow",
        Principal = {
          AWS = "arn:aws:iam::cloudfront:user/CloudFront Origin Access Identity ${aws_cloudfront_origin_access_identity.oai.id}"
        },
        Action    = ["s3:GetObject"],
        Resource  = [
          "${aws_s3_bucket.frontend.arn}/*" # Grant access to all objects in the bucket
        ]
      }
    ]
  })
}

resource "local_file" "config_json" {
  filename = "config.json"
  content  = <<EOF
  {
    "BACKEND_RDS_URL": "http://main-alb-120902197.us-east-1.elb.amazonaws.com:4000/test_connection/",
    "BACKEND_REDIS_URL": "http://main-alb-120902197.us-east-1.elb.amazonaws.com:8000/test_connection/"
  }
  EOF
}

resource "aws_s3_object" "config_json" {
  bucket       = "mys3trfmnewbucket" 
  key          = "config.json"        
  source       = local.local_file_config_json.filename
  content_type = "application/json"
  
}

locals {
  local_file_config_json = local_file.config_json
}

resource "aws_s3_object" "index_html" {
  bucket       = aws_s3_bucket.frontend.id
  key          = "index.html" # This will be the object key in the bucket
  source       = "../frontend/templates/index.html" # Correctly point to the file
  content_type = "text/html"
  
}
