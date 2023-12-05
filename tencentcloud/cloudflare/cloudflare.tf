terraform {
  required_providers {
    cloudflare = {
      source  = "cloudflare/cloudflare"
      version = "4.8.0"
    }
  }
}

provider "cloudflare" {
  api_token = var.cloudflare_api_key
}

data "cloudflare_zone" "this" {
  name = var.domain
}

# Create a record
resource "cloudflare_record" "example" {
  zone_id = data.cloudflare_zone.this.zone_id
  name    = "${var.prefix}.${var.domain}"
  value   = var.ip
  type    = "A"
  ttl     = 60
  allow_overwrite = true
}

variable "cloudflare_api_key" {
  default = ""
}

variable "domain" {
  default = ""
}

variable "prefix" {
  default = ""
}

variable "ip" {
  default = ""
}