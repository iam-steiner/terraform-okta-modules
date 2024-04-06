terraform {
  required_providers {
    okta = {
      source  = "okta/okta"
      version = "~> 4.8.0"
    }

    github = {
      source  = "integrations/github"
      version = "~> 6.0"
    }
  }
  required_version = ">= 1.0, < 2.0"
}
