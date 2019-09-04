# A simple Terraform scenario of building MariaDB Galera Cluster in Cherry Servers environment

Requirmenets:

  - Terraform >= V11.*
  - Compiled or builder Terraform Cherry Servers provider plugin for your OS (get it from https://github.com/cherryservers/terraform-provider-cherryservers)
  - Shell.

# Getting started
  - Create an account and top up the credit in https://portal.cherryservers.com environment;
  - Prepare an empty and clean directory for the working environment;
  - Download the Terraform binary from the official website or repository;
  - Download or compile the terraform provider plugin from https://github.com/cherryservers/terraform-provider-cherryservers and put it into the working dir;
  - Generate either private and public keys into the working dir;
  - Clone this repository for terraform scripts and templates into the working dir.

# Installation
- Create the API token using the client's portal and export it into the environment variable:
```
export CHERRY_AUTH_TOKEN="4bdc0acb8f7af4bdc0acb8f7afe78522e6dae9b7e03b0e78522e6dae9b7e03b0"
```
alternitavely you can use the local variable in the script:
```
provider "cherryservers" {
  auth_token = "4bdc0acb8f7af4bdc0acb8f7afe78522e6dae9b7e03b0e78522e6dae9b7e03b0"
}
```
- Modify the variables in **variables.tf** and **templates/galera.cnf.tmpl** according your project and the needs;
- Initiate the terraform project:
```
terraform init
```
- Then review and plan your terraform project:
```
terraform plan
```
- If everything seems to be fine, apply the changes:
```
terraform apply
```
**As soon the process is finished, your MariaDB Galera cluster is ready for use.**
