
resource "aws_instance" "kafka_instance_private_brokers" {
  count = var.kafka_cluster_size
  ami = var.base_kafka_image_ami
  instance_type = var.kafka_instance_type
  key_name = "kafka-keypair"
  vpc_security_group_ids = [
    aws_security_group.kafka_cluster.id,
  ]
  subnet_id = aws_subnet.exp_kafka-private-subnet[count.index % length(var.azs)].id

  tags = merge(
  var.kafka_exp_tags,
  {
    "Name" = format(
    "${var.kafka_cluster_name}${"_%d"}",
    count.index,
    )
  }, {
    "CreatedAt" = timestamp(),
  }, {
    "ExpiresAt" = timeadd(timestamp(), "26280h")
  }, {
    "AnsibleType": "Kafka"
  },
  {
    "AnsibleBrokerIDSequence": count.index+1
  }
  )
  depends_on = [
    aws_internet_gateway.kafka_cluster_internet_gateway,
    aws_key_pair.kafka-keypair,
  ]
}

resource "aws_instance" "zookeeper_instance_private_brokers" {
  count = var.zookeeper_cluster_size
  ami = var.base_zookeeper_image_ami
  instance_type = var.zookeeper_instance_type
  key_name = "kafka-keypair"
  vpc_security_group_ids = [
    aws_security_group.kafka_cluster.id,
  ]
  subnet_id = aws_subnet.exp_kafka-private-subnet[count.index % length(var.azs)].id

  tags = merge(
  var.zookeeper_exp_tags,
  {
    "Name" = format(
    "${var.zookeeper_cluster_name}${"_%d"}",
    count.index,
    )
  }, {
    "CreatedAt" = timestamp(),
  }, {
    "ExpiresAt" = timeadd(timestamp(), "26280h")
  }, {
    "AnsibleType": "Zookeeper"
  },
  {
    "AnsibleBrokerIDSequence": count.index+1
  }
  )
  depends_on = [
    aws_internet_gateway.kafka_cluster_internet_gateway,
    aws_key_pair.kafka-keypair,
  ]
}
