data "aws_availability_zones" "available" {
  state = "available"
}

data "aws_s3_bucket" "existing" {
  bucket = "${var.projectname}-${var.environment}-statefile"
  depends_on = [aws_s3_bucket.new]
}