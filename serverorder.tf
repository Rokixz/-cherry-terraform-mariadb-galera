resource "cherryservers_project" "galera-cluster" {
    team_id = "${var.team_id}"
    name = "${var.project_name}"
}
resource "cherryservers_ssh" "api1-key" {
    name = "${var.ssh_key["name"]}"
    public_key = "${file("${var.ssh_key["public"]}")}"
}
resource "cherryservers_ip" "galera-ip-1" {
    project_id = "${cherryservers_project.galera-cluster.id}"
    region = "${var.region}"
    routed_to_hostname = "${var.hostname["1"]}"
}
resource "cherryservers_ip" "galera-ip-2" {
    project_id = "${cherryservers_project.galera-cluster.id}"
    region = "${var.region}"
    routed_to_hostname = "${var.hostname["2"]}"
}
resource "cherryservers_ip" "galera-ip-3" {
    project_id = "${cherryservers_project.galera-cluster.id}"
    region = "${var.region}"
    routed_to_hostname = "${var.hostname["3"]}"
}
data "template_file" "galera-conf-1" {
  template = "${file("./templates/galera.cnf.tmpl")}"
  vars = {
    name = "${var.hostname["1"]}"
    node_ip = "${cherryservers_ip.galera-ip-1.address}"
    cluster_ips = "${cherryservers_ip.galera-ip-1.address},${cherryservers_ip.galera-ip-2.address},${cherryservers_ip.galera-ip-3.address}"
  }
}
data "template_file" "galera-conf-2" {
  template = "${file("./templates/galera.cnf.tmpl")}"
  vars = {
    name = "${var.hostname["2"]}"
    node_ip = "${cherryservers_ip.galera-ip-2.address}"
    cluster_ips = "${cherryservers_ip.galera-ip-1.address},${cherryservers_ip.galera-ip-2.address},${cherryservers_ip.galera-ip-3.address}"
  }
}
data "template_file" "galera-conf-3" {
  template = "${file("./templates/galera.cnf.tmpl")}"
  vars = {
    name = "${var.hostname["3"]}"
    node_ip = "${cherryservers_ip.galera-ip-3.address}"
    cluster_ips = "${cherryservers_ip.galera-ip-1.address},${cherryservers_ip.galera-ip-2.address},${cherryservers_ip.galera-ip-3.address}"
  }
}
resource "cherryservers_server" "galera-server-1" {
    project_id = "${cherryservers_project.galera-cluster.id}"
    region = "${var.region}"
    hostname = "${var.hostname["1"]}"
    image = "${var.image}"
    plan_id = "${var.plan_id}"
    ssh_keys_ids = ["${cherryservers_ssh.api1-key.id}"]
    ip_addresses_ids = ["${cherryservers_ip.galera-ip-1.id}"]
    provisioner "remote-exec" {
    inline = ["apt-get install -y mariadb-server rsync"]
    connection {
      type = "ssh"
      user = "root"
      host = "${cherryservers_ip.galera-ip-1.address}"
      private_key = "${file(var.ssh_key["private"])}"
      timeout = "20m"
    }
 }
}
resource "cherryservers_server" "galera-server-2" {
    project_id = "${cherryservers_project.galera-cluster.id}"
    region = "${var.region}"
    hostname = "${var.hostname["2"]}"
    image = "${var.image}"
    plan_id = "${var.plan_id}"
    ssh_keys_ids = ["${cherryservers_ssh.api1-key.id}"]
    ip_addresses_ids = ["${cherryservers_ip.galera-ip-2.id}"]
    provisioner "remote-exec" {
    inline = ["apt-get install -y mariadb-server rsync"]
    connection {
      type = "ssh"
      user = "root"
      host = "${cherryservers_ip.galera-ip-2.address}"
      private_key = "${file(var.ssh_key["private"])}"
      timeout = "20m"
    }
 }
}
resource "cherryservers_server" "galera-server-3" {
    project_id = "${cherryservers_project.galera-cluster.id}"
    region = "${var.region}"
    hostname = "${var.hostname["3"]}"
    image = "${var.image}"
    plan_id = "${var.plan_id}"
    ssh_keys_ids = ["${cherryservers_ssh.api1-key.id}"]
    ip_addresses_ids = ["${cherryservers_ip.galera-ip-3.id}"]
    provisioner "remote-exec" {
    inline = ["apt-get install -y mariadb-server rsync"]
    connection {
      type = "ssh"
      user = "root"
      host = "${cherryservers_ip.galera-ip-3.address}"
      private_key = "${file(var.ssh_key["private"])}"
      timeout = "20m"
    }
 }
}
resource null_resource "prepare_config" {
  depends_on = [
    "cherryservers_server.galera-server-1",
    "cherryservers_server.galera-server-2",
    "cherryservers_server.galera-server-3"
  ]
    provisioner "remote-exec" {
    inline = [
      "systemctl stop mariadb.service",
      "cat > /etc/mysql/conf.d/galera.cnf <<EOL",
      "${data.template_file.galera-conf-1.rendered}",
      "EOL"]    
      connection {
      type = "ssh"
      user = "root"
      host = "${cherryservers_ip.galera-ip-1.address}"
      private_key = "${file(var.ssh_key["private"])}"
      timeout = "20m"
    }
    }
    provisioner "remote-exec" {
    inline = ["galera_new_cluster"]
    connection {
      type = "ssh"
      user = "root"
      host = "${cherryservers_ip.galera-ip-1.address}"
      private_key = "${file(var.ssh_key["private"])}"
      timeout = "20m"
    }
    }
    provisioner "remote-exec" {
    inline = [
      "systemctl stop mariadb.service",
      "cat > /etc/mysql/conf.d/galera.cnf <<EOL",
      "${data.template_file.galera-conf-2.rendered}",
      "EOL"]    
      connection {
      type = "ssh"
      user = "root"
      host = "${cherryservers_ip.galera-ip-2.address}"
      private_key = "${file(var.ssh_key["private"])}"
      timeout = "20m"
    }
  }
    provisioner "remote-exec" {
    inline = [
      "systemctl stop mariadb.service",
      "cat > /etc/mysql/conf.d/galera.cnf <<EOL",
      "${data.template_file.galera-conf-3.rendered}",
      "EOL"]    
      connection {
      type = "ssh"
      user = "root"
      host = "${cherryservers_ip.galera-ip-3.address}"
      private_key = "${file(var.ssh_key["private"])}"
      timeout = "20m"
    }
  }
      provisioner "remote-exec" {
    inline = ["systemctl start mariadb.service"]
    connection {
      type = "ssh"
      user = "root"
      host = "${cherryservers_ip.galera-ip-1.address}"
      private_key = "${file(var.ssh_key["private"])}"
      timeout = "20m"
    }
  }
    provisioner "remote-exec" {
    inline = ["systemctl start mariadb.service"]
    connection {
      type = "ssh"
      user = "root"
      host = "${cherryservers_ip.galera-ip-2.address}"
      private_key = "${file(var.ssh_key["private"])}"
      timeout = "20m"
    }
  }    
    provisioner "remote-exec" {
    inline = ["systemctl start mariadb.service"]
    connection {
      type = "ssh"
      user = "root"
      host = "${cherryservers_ip.galera-ip-3.address}"
      private_key = "${file(var.ssh_key["private"])}"
      timeout = "20m"
    }
    }
}