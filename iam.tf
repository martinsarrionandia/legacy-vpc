resource "aws_iam_policy" "sms_policy" {
  name   = "sms_import_policy"
  policy = templatefile("${path.module}/templates/sms-policy.json", { disk_image_file_bucket = var.disk_image_file_bucket })
}

#The role MUST be called vmimport
resource "aws_iam_role" "vmimport" {
  name               = "vmimport"
  assume_role_policy = templatefile("${path.module}/templates/sms-trust-policy.json", {})
}

resource "aws_iam_role_policy_attachment" "sms_policy" {
  role       = aws_iam_role.vmimport.name
  policy_arn = aws_iam_policy.sms_policy.arn
}