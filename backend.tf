terraform {
  backend "s3" {
    bucket = "sarrionandia.co.uk"
    key    = "terraform-state/legacy/terraform.tfstate"
    region = "eu-west-1"
  }
}