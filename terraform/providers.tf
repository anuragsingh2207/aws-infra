terraform {
  provider "aws" {

    region = "ap-south-1"
  }


  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "5.16.1"

    }
  }
}
