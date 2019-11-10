provider "aws" {
  region                  = var.region
  shared_credentials_file = "/home/phiro/.aws/credentials"
  profile                 = "default"
}

