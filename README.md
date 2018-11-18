# Module `acm`

## Table of Contents

* [Description](#description)
* [Usage](#usage)
  * [Input parameters](#input-parameters)
  * [Output attributes](#output-attributes)

## Description

The module will create create Amazon Issued certificate and verified with DNS records.
Since it supports creating certificates in different region and/or account you'll need to pass default provider too.

The following resources will be created:

* acm_certificate

* CNAME records for validation in Public DNS zone.

## Usage

Deploy in same region
```yaml
module "acm" {
  source          = "../../modules/aws/acm"
  main_vars       = "${var.main_vars}"
  domain_name     = "www.example.com"
  public_zone_id  = "${data.aws_route53_zone.public_domain.id}"

  providers = {
    aws = "aws"
  }
}
```

Deploy for Cloudfront
```yaml
provider "aws" {
  region = "us-east-1"
  alias  = us_east
}

module "acm" {
  source          = "../../modules/aws/acm"
  main_vars       = "${var.main_vars}"
  domain_name     = "www.example.com"
  public_zone_id  = "${data.aws_route53_zone.public_domain.id}"

  providers = {
    aws = "aws.us_east"
  }
}
```

Deploy with SANs:
```yaml
module "acm" {
  source                    = "../../modules/aws/acm"
  main_vars                 = "${var.main_vars}"
  domain_name               = "www.example.com"
  public_zone_id            = "${data.aws_route53_zone.public_domain.id}"
  subject_alternative_names = ["one.example.com", "two.example.com", "*.example.com"]

  providers = {
    aws = "aws"
  }
}
```

### Requirements
* **Variables**

The Route53 zone should be create as resource or provided with data for  `public_zone_id`:

You'll also need to pass some provider which will be used for provisioning the resources.

### Input parameters

* ***main_vars*** - Mapped variables (array) defining the basic application
  parameters. Defined in the global vars file.

* ***domain_name*** - Mapped variables (array) defining the basic network
  parameters. If not defined will create certificate for the same name as `public_zone_id`.

* ***public_zone_id*** - ID of the public DNS zone from Route53

* ***subject_alternative_names*** - Array of any additional SANs to put in the certificates (DNS type only).

* ***system_name*** - Name of the system to put as tag. By default it will be `certificates`

* ***providers*** - Map of providers to pass. Currently only the default one is supported.

### Output attributes

* Resources created with this module have the following output attributes:

  Attribute           | Description
  ---                 | ---
  certificate_arn | The ARN of the issued certificate


* Attribute usage:

  Attributes can be used as input varibles to other modules in the following
  format:

  ```sh
  ${module.<service_name>.<attribute_name>}
  ```
