data "aws_availability_zones" "available" {
  state = "available"
}

data "aws_s3_bucket" "existing" {
  count  = 0 
  bucket = "${var.projectname}-${var.environment}-statefile"
}