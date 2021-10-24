variable "availability_zone" {
  type    = string
  default = "eu-west-2a"
}

variable "legacy_subnet_cidr" {
  type    = string
  default = "10.0.1.0/24"
}

variable "instance_key_name" {
  type    = string
  default = "sarrionandia-eu-w2"
}

variable "domain_name" {
  type    = string
  default = "sarrionandia.co.uk"
}

variable "legacy_mgmt_ranges" {
  type    = list(string)
  default = ["82.70.52.46/32"]
}

variable "legacy_admin_https" {
  type    = string
  default = "10000"
}

variable "disk_image_file_bucket" {
  type    = string
  default = "sarrionandia-legacy-vm-import"
}

variable "office_365_mail_ipv4" {
  type = list
  default = [
    "13.107.6.152/31", "13.107.18.10/31", "13.107.128.0/22", "23.103.160.0/20", "40.96.0.0/13", "40.104.0.0/15", "52.96.0.0/14", "131.253.33.215/32", "132.245.0.0/16", "150.171.32.0/22", "204.79.197.215/32",
  ]
}