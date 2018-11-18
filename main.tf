provider "aws" {}

data "aws_route53_zone" "current" {
  zone_id = "${var.public_zone_id}"
}

locals {
  common_name = "${replace(var.domain_name == "" ? data.aws_route53_zone.current.name : var.domain_name, "/\\.$$/", "")}"
}

resource "aws_acm_certificate" "acm_certificate" {
  domain_name               = "${local.common_name}"
  validation_method         = "DNS"
  subject_alternative_names = "${compact(var.subject_alternative_names)}"

  tags = "${merge(var.main_vars,
          map("system", var.system_name),
          map("Name", replace(local.common_name, "/^\\*/", "wildcard")),
          map("region", var.main_vars["region"])
          )}"
}

resource "aws_route53_record" "acm_certificate" {
  name    = "${aws_acm_certificate.acm_certificate.domain_validation_options.0.resource_record_name}"
  type    = "${aws_acm_certificate.acm_certificate.domain_validation_options.0.resource_record_type}"
  zone_id = "${var.public_zone_id}"
  records = ["${aws_acm_certificate.acm_certificate.domain_validation_options.0.resource_record_value}"]
  ttl     = 60
}

resource "aws_acm_certificate_validation" "acm_certificate" {
  certificate_arn         = "${aws_acm_certificate.acm_certificate.arn}"
  validation_record_fqdns = ["${aws_route53_record.acm_certificate.fqdn}"]
}
