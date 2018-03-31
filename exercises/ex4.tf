/*
Exercise 4:

Objective:
Create a keypair, 
Create a security-group 
Create a network resources.
Create a instance in openstack, with existing image, flavor , keypair, secgroup, network


Use terraform provider and resource, variable, output block.


openstack command:

openstack keypair create
openstack network create
openstack subnet create
openstack security group create
openstack security  group rule create
openstack server create 
openstack floating ip create 
openstack floating ip set

*/



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

variable mysecgroup {
  default = "default"
}

variable privatenet {
  default = "db4a268a-465d-40d7-9db2-54b82d945bec"
}

resource "openstack_compute_keypair_v2" "mykey1" {
  name = "mykey1"
  public_key = "${file("testkey.pub")}"
}


resource "openstack_networking_secgroup_v2" "my_secgroup" {
  name = "my_secgroup"
  description = "Allow all"
}

resource "openstack_networking_secgroup_rule_v2" "rule1" {
  direction = "ingress"
  ethertype = "IPv4"
  security_group_id = "${openstack_networking_secgroup_v2.my_secgroup.id}"
}



resource "openstack_compute_instance_v2" "vm1" {
  name            = "vm1"
  image_id        = "${var.myimage}"
  flavor_id       = "${var.myflavor}"
  key_pair        = "${openstack_compute_keypair_v2.mykey1.name}"
  security_groups = ["${openstack_networking_secgroup_v2.my_secgroup.id}"]
  network {
    uuid = "${var.privatenet}"
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