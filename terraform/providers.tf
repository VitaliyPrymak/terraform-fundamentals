# Provider for us-east-1 (your original region)
provider "aws" {
  region = "us-east-1"
}

# Provider for ap-southeast-1 (the region expected for this bucket)
provider "aws" {
  alias  = "us-east-1"
  region = "us-east-1"
}