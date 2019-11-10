resource "aws_vpc" "exp_kafka_vpc" {
  cidr_block           = var.vpc_cidr
  enable_dns_hostnames = true
  tags = merge(
    var.kafka_exp_tags,
    {
      "Name" = "PhiRo_Kafka_VPC_Experimental"
    }, {
    "CreatedAt" = timestamp(),
  }, {
    "ExpiresAt" = timeadd(timestamp(), "26280h")
  }
  )
}

resource "aws_subnet" "exp_kafka-private-subnet" {
  count = length(var.azs_subnets_private)
  cidr_block = "${var.azs_subnets_private[var.azs[count.index]]}${"0/24"}"
  vpc_id     = aws_vpc.exp_kafka_vpc.id
  tags = merge(
    var.kafka_exp_tags,
    {
      "Name" = format("PhiRo_Kafka_Subnet%d Private_Experimental", count.index )
    }, {
    "CreatedAt" = timestamp(),
  }, {
    "ExpiresAt" = timeadd(timestamp(), "26280h")
  }
  )
  availability_zone = var.azs[count.index]
}

resource "aws_subnet" "exp_kafka-public-subnet" {
  count = length(var.azs_subnets_public)
  cidr_block = "${var.azs_subnets_public[var.azs[count.index]]}${"0/24"}"
  vpc_id     = aws_vpc.exp_kafka_vpc.id
  tags = merge(
  var.kafka_exp_tags,
  {
    "Name" = format("PhiRo_Kafka_Subnet%d Public_Experimental", count.index )
  }, {
    "CreatedAt" = timestamp(),
  }, {
    "ExpiresAt" = timeadd(timestamp(), "26280h")
  }
  )
  availability_zone = var.azs[count.index]
}


resource "aws_eip" "kafka_ip_address" {
  count = length(aws_instance.bastion)
  instance = length(aws_instance.bastion) > 0? aws_instance.bastion[count.index].id : 0
  vpc      = true
  tags = merge(
    var.kafka_exp_tags,
    {
      "Name" = "PhiRo_Kafka_ElasticIP_Experimental_Bastion"
    }, {
    "CreatedAt" = timestamp(),
  }, {
    "ExpiresAt" = timeadd(timestamp(), "26280h")
  }
  )
}

resource "aws_internet_gateway" "kafka_cluster_internet_gateway" {
  vpc_id = aws_vpc.exp_kafka_vpc.id
  tags = merge(
    var.kafka_exp_tags,
    {
      "Name" = "PhiRo_Kafka_IGW_Experimental"
    }, {
    "CreatedAt" = timestamp(),
  }, {
    "ExpiresAt" = timeadd(timestamp(), "26280h")
  }
  )
}

resource "aws_default_route_table" "internet_router" {
  default_route_table_id = aws_vpc.exp_kafka_vpc.default_route_table_id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.kafka_cluster_internet_gateway.id
  }
  tags = merge(
    var.kafka_exp_tags,
    {
      "Name" = "PhiRo_Kafka Default_RouteTable_Experimental"
    }, {
    "CreatedAt" = timestamp(),
  }, {
    "ExpiresAt" = timeadd(timestamp(), "26280h")
  }
  )
}

