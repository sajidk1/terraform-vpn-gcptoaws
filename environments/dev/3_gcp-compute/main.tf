# Provider
provider "google" {
  credentials = "${file("account.json")}"
  region      = "${var.gcpregion}"
  project     = "${var.gcpproject}"
}

# Google compute instance
resource "google_compute_instance" "web" {
  name         = "web"
  machine_type = "n1-standard-1"
  zone         = "${var.gcpregion}-a"
  tags         = ["http-server"]      # Tag opens up http port to 0.0.0.0/0

  boot_disk {
    initialize_params {
      image = "debian-cloud/debian-8"
    }
  }

  network_interface {
    network = "default"

    access_config {
      // Ephemeral IP
    }
  }

  # Upload template index.php
  provisioner "file" {
    content     = "${data.template_file.index.rendered}"
    destination = "/tmp/index.php"

    connection {
      type        = "ssh"
      user        = "ubuntu"
      private_key = "${file("ssh.pem")}"
    }
  }

  # Install LAMP stack and fill in dummy values on DB
  provisioner "remote-exec" {
    inline = [
      "sudo apt-get update -y",
      "sudo apt-get install apache2 php5 php-pear php5-mysql mysql-client -y",
      "mysql -h ${local.dbendpoint} -u ${local.dbuser} -p${local.dbpass} ${local.dbname} -e \"CREATE TABLE Persons (FirstName VARCHAR(20), LastInitial VARCHAR(20));\"",
      "mysql -h ${local.dbendpoint} -u ${local.dbuser} -p${local.dbpass} ${local.dbname} -e \"INSERT INTO Persons (FirstName, LastInitial) VALUES('Sajid', 'K'), ('Adam', 'L'), ('Guy', 'E'), ('Andrew', 'M');\"",
      "sudo cp -f /tmp/index.php /var/www/html/index.php",
      "sudo rm -f /var/www/html/index.html",
      "sudo service apache2 restart",
    ]

    connection {
      type        = "ssh"
      user        = "ubuntu"
      private_key = "${file("ssh.pem")}"
    }
  }

  service_account {
    scopes = ["userinfo-email", "compute-ro", "storage-ro"]
  }
}
