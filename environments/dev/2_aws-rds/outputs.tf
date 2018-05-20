output "dbendpoint" {
  value = "${aws_db_instance.db.address}"
}

output "dbport" {
  value = "${aws_db_instance.db.port}"
}

output "dbuser" {
  value = "${aws_db_instance.db.username}"
}

output "dbpass" {
  value = "${var.dbpass}"
}

output "dbname" {
  value = "${aws_db_instance.db.name}"
}
