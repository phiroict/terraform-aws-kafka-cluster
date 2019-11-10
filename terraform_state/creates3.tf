resource "aws_s3_bucket" "state_bucket" {
  bucket = "terraform-states-repo"
  acl    = "private"

  tags = {
    Name        = "Terraform state bucket"
    Environment = "Prod"
  }
}

resource "aws_s3_bucket_object" "state_folder" {
  bucket = aws_s3_bucket.state_bucket.id
  acl    = "private"
  key    = "kafka-packer-terraform-aws/"
  source = "/dev/null"
}