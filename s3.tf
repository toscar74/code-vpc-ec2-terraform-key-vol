resource "aws_s3_bucket" "s3Buk" {
  bucket = "bucket-11110"

  tags = {
    Name        = "My Bucket"
    Environment = "Dev"
  }
}