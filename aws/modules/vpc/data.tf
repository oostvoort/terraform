data "aws_availability_zones" "available" {
  state = "available"
}

data "aws_s3_bucket" "existing" {
  count  = var.create_new_bucket ? 0 : 1
  bucket = "${var.projectname}-${var.environment}-statefile"
}