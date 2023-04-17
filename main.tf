provider "aws" {
  shared_credentials_files = ["~/.aws/credentials"]
  shared_config_files      = ["~/.aws/config"]
  profile                  = var.aws_profile
  region                   = var.aws_region
}
