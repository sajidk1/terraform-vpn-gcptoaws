# Providers
provider "google" {
  credentials = "${file("account.json")}"
  region      = "${var.gcpregion}"
  project     = "${var.gcpproject}"
}

provider "aws" {
  access_key = "${var.aws_access_key}"
  secret_key = "${var.aws_secret_key}"
  region     = "${var.aws_region}"
}
