data "terraform_remote_state" "rds" {
  backend = "local"

  config {
    path = "${path.module}/../2_aws-rds/terraform.tfstate"
  }
}

locals {
  dbendpoint = "${data.terraform_remote_state.rds.dbendpoint}"
  dbuser     = "${data.terraform_remote_state.rds.dbuser}"
  dbpass     = "${data.terraform_remote_state.rds.dbpass}"
  dbname     = "${data.terraform_remote_state.rds.dbname}"
}
