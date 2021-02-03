terraform {
  required_providers {
    libvirt = {
      source  = "dmacvicar/libvirt"
      version = "0.6.3"
    }
  }
}

provider "libvirt" {
      uri = "qemu+ssh://server@fedora-server/system"
}


resource "libvirt_ignition" "ignition" {
  name = "example.ign"
  content = "resources/ignition/example.ign"
}

module "primary_vm" {
  source = "./modules/basic_vm"
  hostname = "my-vm"
  ignition = libvirt_ignition.ignition.id
}

module "secondary_vm" {
  source = "./modules/basic_vm"
  hostname = "my-other-vm"
  ignition = libvirt_ignition.ignition.id
}

module "kubernetes_env" {
  source = "./modules/kubernetes_env"
  hostname = "k8s"
}
