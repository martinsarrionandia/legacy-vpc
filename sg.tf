data "http" "my_current_ip_data" {
  url = "http://ipv4.icanhazip.com"
}

locals {
  my_current_ip = "${chomp(data.http.my_current_ip_data.response_body)}/32"
}

resource "aws_security_group" "legacy_mgmt" {
  name        = "Legacy Mgmt"
  description = "Allow legacy Management and Web"
  vpc_id      = aws_vpc.legacy.id
}

resource "aws_security_group_rule" "legacy_ssh" {
  security_group_id = aws_security_group.legacy_mgmt.id
  type              = "ingress"
  from_port         = 22
  to_port           = 22
  protocol          = "tcp"
  cidr_blocks       = [local.my_current_ip]
}


resource "aws_security_group_rule" "legacy_admin_https" {
  security_group_id = aws_security_group.legacy_mgmt.id
  type              = "ingress"
  from_port         = var.legacy_admin_https
  to_port           = var.legacy_admin_https
  protocol          = "tcp"
  cidr_blocks       = [local.my_current_ip]
}

resource "aws_security_group_rule" "outbound_all" {
  security_group_id = aws_security_group.legacy_mgmt.id
  type              = "egress"
  from_port         = 0
  to_port           = 0
  protocol          = "-1"
  cidr_blocks       = ["0.0.0.0/0"]
}

resource "aws_security_group" "legacy_ingress" {
  name        = "Legacy Ingress"
  description = "Allow Ingress traffic to instances"
  vpc_id      = aws_vpc.legacy.id
}

resource "aws_security_group_rule" "ingress_http" {
  security_group_id = aws_security_group.legacy_ingress.id
  type              = "ingress"
  from_port         = 80
  to_port           = 80
  protocol          = "tcp"
  cidr_blocks       = ["0.0.0.0/0"]
}

resource "aws_security_group_rule" "ingress_https" {
  security_group_id = aws_security_group.legacy_ingress.id
  type              = "ingress"
  from_port         = 443
  to_port           = 443
  protocol          = "tcp"
  cidr_blocks       = ["0.0.0.0/0"]
}

resource "aws_security_group_rule" "outbound_http" {
  # Allow Ambassador to ACME service
  security_group_id = aws_security_group.legacy_ingress.id
  type              = "egress"
  from_port         = 80
  to_port           = 80
  protocol          = "tcp"
  cidr_blocks       = ["0.0.0.0/0"]
}

resource "aws_security_group_rule" "outbound_https" {
  # Allow Ambassador to ACME service
  security_group_id = aws_security_group.legacy_ingress.id
  type              = "egress"
  from_port         = 443
  to_port           = 443
  protocol          = "tcp"
  cidr_blocks       = ["0.0.0.0/0"]
}

resource "aws_security_group_rule" "outbound_imap" {
  # Allow Roundcube to O365 SMTP Servers
  security_group_id = aws_security_group.legacy_ingress.id
  type              = "egress"
  from_port         = 993
  to_port           = 993
  protocol          = "tcp"
  cidr_blocks       = var.office_365_mail_ipv4
}

resource "aws_security_group_rule" "outbound_smtps" {
  # Allow Roundcube to O365 SMTP Servers
  security_group_id = aws_security_group.legacy_ingress.id
  type              = "egress"
  from_port         = 587
  to_port           = 587
  protocol          = "tcp"
  cidr_blocks       = var.office_365_mail_ipv4
}