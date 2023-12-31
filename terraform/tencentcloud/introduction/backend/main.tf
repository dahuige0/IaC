terraform {
  required_version = "> 0.13.0"
  required_providers {
    tencentcloud = {
      source = "tencentcloudstack/tencentcloud"
      version = "1.81.5"
    }
  }
}

# Configure the TencentCloud Provider
provider "tencentcloud" {
  region = "ap-guangzhou"
}

# Get availability zones
data "tencentcloud_availability_zones_by_product" "default" {
  product = "cvm"
}

# Get availability images
data "tencentcloud_images" "default" {
  image_type = ["PUBLIC_IMAGE"]
  os_name    = "ubuntu"
}

# Get availability instance types
data "tencentcloud_instance_types" "default" {
  # 机型族
  filter {
    name   = "instance-family"
    values = ["S5"]
  }

  cpu_core_count = 2
  memory_size    = 2
}

# Create a web server
resource "tencentcloud_instance" "web" {
  depends_on                 = [tencentcloud_security_group_lite_rule.default]
  instance_name              = "web server"
  availability_zone          = data.tencentcloud_availability_zones_by_product.default.zones.0.name
  image_id                   = data.tencentcloud_images.default.images.0.image_id
  instance_type              = data.tencentcloud_instance_types.default.instance_types.0.instance_type
  system_disk_type           = "CLOUD_PREMIUM"
  system_disk_size           = 50
  allocate_public_ip         = true
  internet_max_bandwidth_out = 20
  instance_charge_type       = "SPOTPAID"
  orderly_security_groups    = [tencentcloud_security_group.default.id]
  count                      = 1
}

# Create security group
resource "tencentcloud_security_group" "default" {
  name        = "web accessibility"
  description = "make it accessible for both production and stage ports"
}

# Create security group rule allow ssh request
resource "tencentcloud_security_group_lite_rule" "default" {
  security_group_id = tencentcloud_security_group.default.id
  ingress = [
    "ACCEPT#0.0.0.0/0#22#TCP",
    "ACCEPT#0.0.0.0/0#6443#TCP",
  ]

  egress = [
    "ACCEPT#0.0.0.0/0#ALL#ALL"
  ]
}


# COS
data "tencentcloud_user_info" "info" {}

locals {
  app_id = data.tencentcloud_user_info.info.app_id
}

resource "tencentcloud_cos_bucket" "terraform-state" {
  bucket               = "terraform-state-${local.app_id}"
  acl                  = "private"
  encryption_algorithm = "AES256"
}

#先使用local存储tfstate后，再定义远端存储，重新terraform init，把tfstate迁移至远端
# terraform {
#   backend "cos" {
#   region  = "ap-guangzhou"
#   bucket  = "terraform-state-1304571968"
#   prefix  = "terraform/state"
#   encrypt = true
#   }
