resource "aws_vpc" "ecs_vpc" {
  cidr_block = var.cidr_block
}

resource "aws_subnet" "ecs_public_subnet" {
  vpc_id                  = aws_vpc.ecs_vpc.id
  count                   = length(var.public_cidr_block)
  cidr_block              = element(var.public_cidr_block, count.index)
  availability_zone       = element(var.availability_zones, count.index)
  map_public_ip_on_launch = true
}

resource "aws_subnet" "ecs_private_subnet" {
  vpc_id            = aws_vpc.ecs_vpc.id
  count             = length(var.private_cidr_block)
  cidr_block        = element(var.private_cidr_block, count.index)
  availability_zone = element(var.availability_zones, count.index)
}

resource "aws_internet_gateway" "ecs_internet_gateway" {
  vpc_id = aws_vpc.ecs_vpc.id
}

resource "aws_route" "ecs_ia" {
  route_table_id         = aws_vpc.ecs_vpc.main_route_table_id
  destination_cidr_block = var.destination_cidr_block
  gateway_id             = aws_internet_gateway.ecs_internet_gateway.id
}

resource "aws_eip" "ecs_nat_eip" {
  count = length(var.public_cidr_block)
  vpc   = true
  depends_on = [
    aws_internet_gateway.ecs_internet_gateway
  ]
}

resource "aws_nat_gateway" "ecs_nat_gateway" {
  count         = length(var.public_cidr_block)
  subnet_id     = element(aws_subnet.ecs_public_subnet.*.id, count.index)
  allocation_id = element(aws_eip.ecs_nat_eip.*.id, count.index)
}

resource "aws_route_table" "ecs_private_rt" {
  count  = length(aws_nat_gateway.ecs_nat_gateway)
  vpc_id = aws_vpc.ecs_vpc.id

  route {
    cidr_block     = var.cidr_block_route_table
    nat_gateway_id = element(aws_nat_gateway.ecs_nat_gateway.*.id, count.index)
  }
}

resource "aws_route_table_association" "subnet_route_private" {
  count          = length(var.private_cidr_block)
  subnet_id      = element(aws_subnet.ecs_private_subnet.*.id, count.index)
  route_table_id = element(aws_route_table.ecs_private_rt.*.id, count.index)
}
