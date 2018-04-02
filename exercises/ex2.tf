/*
Objective:
Create a instance in openstack, with existing image, flavor, keypair, security-group and network resources.
Create a floating IP, and associate with the VM.

Using output block to display the output of ID, name and fixed IP parameters.

*/


# Provider details 

provider "openstack" {
  user_name   = "demo"
  tenant_name = "demo"
  password    = "openstack123"
  auth_url    = "http://10.0.1.6/identity"
  region      = "RegionOne"
  domain_name = "default"
}



variable myimage {
  default = "dea87f06-9fdc-410c-974f-470b057cfa2b"
}

variable myflavor {
  default = "1"
}

variable mykey {
  default = "mykey"
}

variable mysecgroup {
  default = "default"
}



# Instance creation 

resource "openstack_compute_instance_v2" "vm1" {
  name            = "vm1"
  image_id        = "${var.myimage}"
  flavor_id       = "${var.myflavor}"
  key_pair        = "${var.mykey}"
  security_groups = ["${var.mysecgroup}"]
  network {
    uuid = "db4a268a-465d-40d7-9db2-54b82d945bec"
  }
}

resource "openstack_networking_floatingip_v2" "fip_1" {
  pool = "public"
}


resource "openstack_compute_floatingip_associate_v2" "fip_1" {
  floating_ip = "${openstack_networking_floatingip_v2.fip_1.address}"
  instance_id = "${openstack_compute_instance_v2.vm1.id}"
}


# output vm name variable 

output "vm-name" {
  value = "${openstack_compute_instance_v2.vm1.name}"
}

# output vm-id variable 

output "vm-id" {
  value = "${openstack_compute_instance_v2.vm1.id}"
}

# output vm-ip variable 

output "vm-ip" {
	value = "${openstack_compute_instance_v2.vm1.network.0.fixed_ip_v4}"
}

# output floating-ip variable 

output "vm-floating-ip" {
  value = "${openstack_networking_floatingip_v2.fip_1.address}"
}