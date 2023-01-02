resource "aws_s3_bucket_acl" "private_acl" {
  bucket = aws_s3_bucket.import_bucket.id
  acl    = "private"
}

resource "aws_s3_bucket" "import_bucket" {
  bucket = var.disk_image_file_bucket

  tags = {
    Name = "SMS Import Bucket"
  }
}

resource "aws_s3_bucket_public_access_block" "import_bucket_block" {
  bucket = aws_s3_bucket.import_bucket.id

  block_public_acls   = true
  block_public_policy = true
}