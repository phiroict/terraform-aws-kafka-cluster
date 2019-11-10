output "bastion_ip" {
  value = "Bastion IP is ${aws_eip.kafka_ip_address[0].public_ip}"
}





