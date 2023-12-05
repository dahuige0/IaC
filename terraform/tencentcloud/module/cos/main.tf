# COS
data "tencentcloud_user_info" "cos" {}



resource "tencentcloud_cos_bucket" "cos" {
  bucket = "${var.name}-${data.tencentcloud_user_info.cos.app_id}"
  acl    = "private"
  encryption_algorithm = "AES256"
}