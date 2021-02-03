#input variables
variable "ignition" { }
variable "hostname" { default="fedora-test" }
#variable boot_disk { default="libvirt_volume.fedora33-coreos-qcow2.id" }

locals {
  uid_hostname="${var.hostname}_${random_id.server.hex}"
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
#  keepers = {
#    # Generate a new id each time we switch to a new AMI id
#    ami_id = "${var.ami_id}"
#  }

  byte_length = 8
}

# Each VM should have 1 custom storage module.
# The storage should be unique to the VM and seperate
# from the image to build
resource "libvirt_volume" "storage" {
  name = "${local.uid_hostname}_storage.qcow2"
  pool = "default"
  format = "qcow2"
  size = 50000000000
}

resource "libvirt_volume" "fedora33-coreos-qcow2" {
  name = "${local.uid_hostname}_boot.qcow2"
  pool = "default"
  source = "./resources/images/fedora-coreos-33.20210104.2.0-qemu.x86_64.qcow2"
}

# Define KVM domain to create
resource "libvirt_domain" "test" {
  name   = "${local.uid_hostname}"
  memory = "1024"
  vcpu   = 1
  running = "true"
  coreos_ignition=var.ignition

  network_interface {
    network_name = "default"
    wait_for_lease = true
  }

  disk {
    volume_id = libvirt_volume.fedora33-coreos-qcow2.id
  }

  console {
    type = "pty"
    target_type = "serial"
    target_port = "0"
  }

  graphics {
    type = "spice"
    listen_type = "address"
    autoport = true
  }
}
