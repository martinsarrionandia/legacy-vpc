resource "aws_vpc" "legacy" {
  cidr_block = "10.0.2.0/24"

  tags = {
    Name = "Legacy VPC"
  }
}