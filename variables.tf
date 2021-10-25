variable "availability_zone" {
  type        = string
  default     = "eu-west-2a"
  description = "The AZ you want to deploy the infrastructure. Only ONE AZ is created"
}

variable "legacy_subnet_cidr" {
  type        = string
  default     = "10.0.1.0/24"
  description = "This defines the VPC CIDR and only subnet"
}

variable "legacy_mgmt_ranges" {
  type        = list(string)
  default     = ["82.70.52.46/32"]
  description = "This defines from where you can SSH into your VPC"
}

variable "legacy_admin_https" {
  type        = string
  default     = "10000"
  description = "This defines a HTTPS managment port for Webmin"
}

variable "disk_image_file_bucket" {
  type        = string
  default     = "sarrionandia-legacy-vm-import"
  description = "The bucket where the migration script will store OVA files. This must match MIGRATE_S3_BUCKET in the migrate_esxi_guest.sh script because reasons..."
}

variable "office_365_mail_ipv4" {
  type = list(any)
  default = [
    "13.107.6.152/31", "13.107.18.10/31", "13.107.128.0/22", "23.103.160.0/20", "40.96.0.0/13", "40.104.0.0/15", "52.96.0.0/14", "131.253.33.215/32", "132.245.0.0/16", "150.171.32.0/22", "204.79.197.215/32",
  ]
  description = "A list of Office 365 servers. Used in an SG to permit IMAP/SMTP access"
}