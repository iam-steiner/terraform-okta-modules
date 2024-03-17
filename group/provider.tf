terraform {
  required_providers {
    okta = {
      source  = "okta/okta"
      version = "~> 4.8.0"
    }
  }
  required_version = ">= 1.0, < 2.0"
}