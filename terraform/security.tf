resource "aws_security_group" "kafka_cluster_bastion" {
  vpc_id = aws_vpc.exp_kafka_vpc.id
  ingress {
    cidr_blocks = [
      var.ip_allow_access_ip4,
    ]
    protocol = "icmp"
    from_port = 8
    to_port = 0
  }

  ingress {
    # SSH for initial processing
    from_port = 22
    to_port = 22
    protocol = "tcp"

    # Please restrict your ingress to only necessary IPs and ports.
    # Opening to 0.0.0.0/0 can lead to security vulnerabilities.
    cidr_blocks = [
      var.ip_allow_access_ip4,
    ]
    description = "Access from origin"
  }

  ingress {
    # SSH for initial processing
    from_port = 22
    to_port = 22
    protocol = "tcp"

    # Please restrict your ingress to only necessary IPs and ports.
    # Opening to 0.0.0.0/0 can lead to security vulnerabilities.
    cidr_blocks = [
    for subnet in aws_subnet.exp_kafka-private-subnet:
    subnet.cidr_block
    ]

    description = "Allow subnet access"
  }
  egress {
    from_port = 0
    to_port = 0
    protocol = "-1"
    cidr_blocks = [
      "0.0.0.0/0",
    ]
    description = "No limits for outgoing traffic"
  }
}
resource "aws_security_group" "kafka_cluster" {
  name = "cluster_configuration"
  description = "Allow cluster configuration and communication"
  vpc_id = aws_vpc.exp_kafka_vpc.id

  ingress {
    cidr_blocks = [
      var.ip_allow_access_ip4,
      aws_vpc.exp_kafka_vpc.cidr_block
    ]
    protocol = "icmp"
    from_port = 8
    to_port = 0
  }

  ingress {
    # SSH for initial processing
    from_port = 22
    to_port = 22
    protocol = "tcp"

    # Please restrict your ingress to only necessary IPs and ports.
    # Opening to 0.0.0.0/0 can lead to security vulnerabilities.
    # Allow connections from the public subnet, which is where the bastion lives,
    cidr_blocks = [
    for subnet in aws_subnet.exp_kafka-public-subnet:
    subnet.cidr_block
    ]
    description = "Access from LIC or home address"
  }


  ingress {
    # Kafka access
    from_port = 9092
    to_port = 9092
    protocol = "tcp"

    # Please restrict your ingress to only necessary IPs and ports.
    # Opening to 0.0.0.0/0 can lead to security vulnerabilities.
    cidr_blocks = [
    for block in aws_subnet.exp_kafka-private-subnet:
    block.cidr_block
    ]
    description = "Kafka partition access"
  }

  ingress {
    # Zookeer access
    from_port = 2181
    to_port = 2181
    protocol = "tcp"

    # Please restrict your ingress to only necessary IPs and ports.
    # Opening to 0.0.0.0/0 can lead to security vulnerabilities.
    cidr_blocks = [
    for block in aws_subnet.exp_kafka-private-subnet:
    block.cidr_block
    ]
    description = "Zookeeper access"
  }


  ingress {
    # Kafka cluster leader communication
    from_port = 2888
    to_port = 2888
    protocol = "tcp"

    # Please restrict your ingress to only necessary IPs and ports.
    # Opening to 0.0.0.0/0 can lead to security vulnerabilities.
    cidr_blocks = [
    for block in aws_subnet.exp_kafka-private-subnet:
    block.cidr_block
    ]
    description = "Kafka leader communication"
  }
  ingress {
    # Kafka cluster leader communication
    from_port = 3888
    to_port = 3888
    protocol = "tcp"

    # Please restrict your ingress to only necessary IPs and ports.
    # Opening to 0.0.0.0/0 can lead to security vulnerabilities.
    cidr_blocks = [
    for block in aws_subnet.exp_kafka-private-subnet:
    block.cidr_block
    ]
    description = "Kafka leader communication"
  }
  egress {
    from_port = 0
    to_port = 0
    protocol = "-1"
    cidr_blocks = [
      "0.0.0.0/0",
    ]
    description = "No limits for outgoing traffic"
  }
  tags = merge(
  var.kafka_exp_tags,
  {
    "Name" = "PhiRo_Kafka_SecurityGroup_Experimental"
  },
  )
}

resource "aws_key_pair" "kafka-keypair" {
  public_key = var.aws_public_key
  key_name = "kafka-keypair"
}


