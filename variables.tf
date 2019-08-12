# User Variables
variable "region" {
  default = "EU-East-1"
}
variable "image" {
  default = "Ubuntu 18.04 64bit"
}
variable "project_name" {
  default = "MariaDB-Galera"
}
variable "team_id" {
  default = "36043"
}
variable "plan_id" {
  default = "94"
}
variable "ssh_key" {
    type = "map"
    default = {
        "name"    = "api1"
        "public"  = "id_rsa.pub"
        "private" = "id_rsa"
    }
}
variable "hostname" {
    type = "map"
    default = {
        "1"  = "galera1.ispconfig.lt"
        "2"  = "galera2.ispconfig.lt"
        "3"  = "galera3.ispconfig.lt"
    }
}