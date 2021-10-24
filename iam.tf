data "template_file" "sms_trust_policy" {
  template = file("${path.module}/templates/sms-trust-policy.json")
}

data "template_file" "sms_policy" {
  template = file("${path.module}/templates/sms-policy.json")
  vars = {
    disk_image_file_bucket = var.disk_image_file_bucket
  }
}


resource "aws_iam_policy" "sms_policy" {
  name   = "sms_import_policy"
  policy = data.template_file.sms_policy.rendered
}

#The role MUST be called vmimport
resource "aws_iam_role" "vmimport" {
  name               = "vmimport"
  assume_role_policy = data.template_file.sms_trust_policy.rendered
}

resource "aws_iam_role_policy_attachment" "sms_policy" {
  role       = aws_iam_role.vmimport.name
  policy_arn = aws_iam_policy.sms_policy.arn
}