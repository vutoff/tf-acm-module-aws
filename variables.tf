variable "main_vars" {
  type = "map"
}

variable "domain_name" {
  description = "The domain name for which the certificate will be issued."
  default     = ""
}

variable "system_name" {
  default = "certificates"
}

variable "public_zone_id" {
  description = "The domain zone id in which we should create the cname record for verification."
}

variable "subject_alternative_names" {
  type        = "list"
  default     = []
  description = "List of any additional CNAMEs to be added to the certificate."
}
