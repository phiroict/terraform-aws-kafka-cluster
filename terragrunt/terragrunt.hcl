remote_state {
  backend = "s3"
  config = {
    bucket = "terraform-states-repo"
    key = "${path_relative_to_include()}/terraform.state"
    region = "ap-southeast-2"
    encrypt = true
  }
}

terraform  {

  source = "git@github.com:phiroict/kafka-packer-terraform-aws.git//terraform?ref=v0.8.1"
  extra_arguments "custom_vars" {
    commands = [
      "apply",
      "plan",
      "import",
      "push",
      "refresh"
    ]

    # With the get_terragrunt_dir() function, you can use relative paths!
    arguments = [
      "-var-file=secrets.tfvars.json"
    ]
  }
}

inputs = {
  base_kafka_image_ami = "ami-056df8555b0d63e37"
  base_zookeeper_image_ami = "ami-0bbab8485567e65bf"
  region = "ap-southeast-2"
  build_bastion = true
  kafka_cluster_name = "Kafka cluster"
  zookeeper_cluster_name = "Zookeeper cluster"
  kafka_cluster_size = 5
  zookeeper_cluster_size = 3
  kafka_instance_type = "m4.large"
  zookeeper_instance_type = "m4.large"
  kafka_exp_tags = {
    Author= "Philip Rodrigues"
    State= "Experimental"
    Department= "CloudOps"
    Description= "Experimental_kafka_cluster_instance"
    Type = "Kafka_Instance"
  }
  zookeeper_exp_tags = {
    Author= "Philip Rodrigues"
    State= "Experimental"
    Department= "CloudOps"
    Description= "Experimental_zookeeper_cluster_instance"
    Type = "Zookeeper_Instance"
  }
  ip_allow_access_ip4="118.148.93.26/32"
  ip_allow_access_ip6=""
  azs = ["ap-southeast-2a",
    "ap-southeast-2b",
    "ap-southeast-2c"]
  vpc_cidr = "10.201.0.0/16"
  azs_subnets_private = {
    "ap-southeast-2a"= "10.201.1."
    "ap-southeast-2b"= "10.201.2."
    "ap-southeast-2c"= "10.201.3."
  }
  azs_subnets_public = {
    "ap-southeast-2a"= "10.201.101."
    "ap-southeast-2b"= "10.201.102."
    "ap-southeast-2c"= "10.201.103."}
}