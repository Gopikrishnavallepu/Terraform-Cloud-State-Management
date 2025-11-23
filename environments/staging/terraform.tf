terraform {
  cloud {
    organization = "Krish21tech"

    workspaces {
      name = "staging-workspace"
    }
  }

  required_version = "~> 1.14.0"
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 6.14.1"
    }
  }
}

# Point to root module
module "infrastructure" {
  source = "../../"

  # Load variables from terraform.tfvars
}
