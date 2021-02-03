variable "hostname" { default="kubernetes-test" }

locals {
  ssh_authorized_key = file("${path.module}/resources/keys/kubernetes.pub")
}

terraform {
  required_providers {
    libvirt = {
      source  = "dmacvicar/libvirt"
      version = "0.6.3"
    }
  }
}

resource "random_id" "server" {
  byte_length = 8
}

data "ignition_user" "core" {
  name="core"
  home_dir = "/home/core"
  shell = "/bin/bash"
  ssh_authorized_keys = [ local.ssh_authorized_key ]
}

data "ignition_config" "example" {
  users = [
    data.ignition_user.core.rendered
  ]
}

resource "libvirt_ignition" "ignition" {
  name = "${var.hostname}.ign"
  content = data.ignition_config.example.rendered
}

module "kubernetes_vm" {
  source = "./modules/basic_vm"
  hostname = "${var.hostname}"
  ignition = libvirt_ignition.ignition.id
}
