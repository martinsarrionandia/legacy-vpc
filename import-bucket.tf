resource "aws_s3_bucket" "import_bucket" {
  bucket = var.disk_image_file_bucket
  acl    = "private"

  tags = {
    Name = "SMS Import Bucket"
  }
}

resource "aws_s3_bucket_public_access_block" "import_bucket_block" {
  bucket = aws_s3_bucket.import_bucket.id

  block_public_acls   = true
  block_public_policy = true
}