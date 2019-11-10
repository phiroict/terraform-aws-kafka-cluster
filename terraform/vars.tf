variable "base_kafka_image_ami" {
  type = string
  default = "ami-056df8555b0d63e37"
  description = "This is the ami that is created by the packer process. Get this from the output of the process"
}

variable "base_zookeeper_image_ami" {
  type = string
  default = "ami-0bbab8485567e65bf"
  description = "This is the ami that is created by the packer process. Get this from the output of the process"
}

variable "region" {
  type = string
  default = "ap-southeast-2"
}

variable "kafka_instance_type" {
  type = string
  default = "m4.large"
}

variable "zookeeper_instance_type" {
  type = string
  default = "m4.large"
}

variable "kafka_exp_tags" {
  type = map(string)
  default = {
    Author = "Philip Rodrigues"
    State = "Experimental"
    Department = "CloudOps"
    Description = "Experimental_kafka_cluster_instance"
    Type = "Kafka_Instance"
  }
}

variable "zookeeper_exp_tags" {
  type = map(string)
  default = {
    Author = "Philip Rodrigues"
    State = "Experimental"
    Department = "CloudOps"
    Description = "Experimental_kafka_cluster_instance"
    Type = "Zookeeper_Instance"
  }
}

variable "ip_allow_access_ip4" {
  type = string
  default = "111.69.163.87/32"
  description = "Add initially your own ip4 address here"
}

variable "ip_allow_access_ip6" {
  type = string
  default = "2406:e002:58b4:db01:92b1:1cff:fe65:6c80/128"
  description = "Add initially your own ip6 address here"
}


variable "kafka_cluster_size" {
  type = number
  default = 3
  description = "Number of kafka instances to create"
}

variable "zookeeper_cluster_size" {
  type = number
  default = 3
  description = "Number of zookeeper instances to create"
}


variable "build_bastion" {
  type = bool
  default = true
  description = "Create a jumphost to get to the kafka instances"
}

variable "aws_public_key" {
  type = string
}

variable "azs" {
  type = list(string)
  default = [
    "ap-southeast-2a",
    "ap-southeast-2b",
    "ap-southeast-2c"]
}

variable "vpc_cidr" {
  type = string
  default = "10.201.0.0/16"
}

variable "azs_subnets_private" {
  type = map(string )
  default = {
    "ap-southeast-2a"= "10.201.1."
    "ap-southeast-2b"= "10.201.2."
    "ap-southeast-2c"= "10.201.3."
  }
}

variable "azs_subnets_public" {
  type = map(string )
  default = {
    "ap-southeast-2a"= "10.201.101."
    "ap-southeast-2b"= "10.201.102."
    "ap-southeast-2c"= "10.201.103."
  }
}

variable "kafka_cluster_name" {
  type = string
  default = "MyKafkaSet"
}

variable "zookeeper_cluster_name" {
  type = string
  default = "MyZookeeperSet"
}