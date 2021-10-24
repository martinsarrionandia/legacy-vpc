resource "aws_subnet" "legacy" {
  availability_zone = var.availability_zone
  vpc_id            = aws_vpc.legacy.id
  cidr_block        = "10.0.2.0/24"

  tags = {
    Name = "Legacy subnet"
  }
}

resource "aws_route_table" "legacy" {
  vpc_id = aws_vpc.legacy.id

  tags = {
    Name = "legacy route table"
  }
}

resource "aws_route_table_association" "legacy" {
  subnet_id      = aws_subnet.legacy.id
  route_table_id = aws_route_table.legacy.id
}

resource "aws_internet_gateway" "legacy" {
  vpc_id = aws_vpc.legacy.id

  tags = {
    Name = "Legacy VPC GW"
  }
}

resource "aws_route" "internet_route" {
  route_table_id         = aws_route_table.legacy.id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = aws_internet_gateway.legacy.id
}