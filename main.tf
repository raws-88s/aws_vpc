resource "aws_vpc" "main" {
  cidr_block       = var.vpc_cidr
  instance_tenancy = "default"
  enable_dns_hostnames = true

#roboshop-dev
  tags = local.vpc_final_tags
}

resource "aws_internet_gateway" "main" {
  vpc_id = aws_vpc.main.id # vpc association

  tags = local.igw_final_tags
}

#public subnet
resource "aws_subnet" "public" {
  count = length(var.public_subnet_cidrs)
  vpc_id     = aws_vpc.main.id
  cidr_block = var.public_subnet_cidrs[count.index]
  availability_zone = local.az_zones[count.index]
  map_public_ip_on_launch = true
  
  #roboshop-dev-public-us-east-1a
  tags = merge(
    local.common_tags,
    {
      Name = "${var.project}-${var.environment}-public-${local.az_zones[count.index]}"
    },
    var.public_subnet_tags
  )
}

#private subnet
resource "aws_subnet" "private" {
  vpc_id     = aws_vpc.main.id
  cidr_block = var.private_subnet_cidrs
  availability_zone = local.az_zones[count.index]
  
  #roboshop-dev-private-us-east-1a
  tags = merge(
    local.common_tags,
    {
      Name = "${var.project}-${var.environment}-private-${local.az_zones[count.index]}"
    },
    var.private_subnet_tags
  )
}
