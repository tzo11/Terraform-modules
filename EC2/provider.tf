terraform {
    required_version = ">=1.0"
    required_providers {
        aws = {
            source = "hashicorp/aws"
            version = "~> 5.0"
        }
    }
}

provider "aws" {
    region = var.aws_region
#We can also define profile if we are using them to deploy into AWS.
#    profile = var.profile

#Optionally we can also define any tag that must be there, example:

    default_tags {
        tags = {
            ManagedBy = "Terraform"
        }
    }
}