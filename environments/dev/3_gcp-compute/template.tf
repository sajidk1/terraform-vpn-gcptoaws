data "template_file" "index" {
  template = "${file("index.php")}"

  vars {
    dbendpoint = "${local.dbendpoint}"
    dbuser     = "${local.dbuser}"
    dbpass     = "${local.dbpass}"
    dbname     = "${local.dbname}"
  }
}
