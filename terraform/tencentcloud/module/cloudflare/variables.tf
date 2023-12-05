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

variable "values" {
  description = "Array of record values"
  type        = list(string)
  default     = []
}
