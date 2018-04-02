
# Below variables in vars.tf file

variable myimage {
  default = "a73ae89d-271e-45ba-8417-ddd6373dc585"
}

variable myflavor {
  default = "d2"
}

variable public_pool_id {
  default = "74736280-83bc-4ffe-8228-cbe12c091b49"
}



# Below resources in stack.tf file

resource "openstack_networking_secgroup_v2" "my_secgroup" {
  name = "my_secgroup"
  description = "Allow all"
}

resource "openstack_networking_secgroup_rule_v2" "rule1" {
  direction = "ingress"
  ethertype = "IPv4"
  security_group_id = "${openstack_networking_secgroup_v2.my_secgroup.id}"
}


resource "openstack_compute_keypair_v2" "mykey1" {
  name = "mykey1"
  public_key = "${file("testkey.pub")}"
}


resource "openstack_networking_network_v2" "client_net" {
  name = "client_net"
  admin_state_up = "true"
}

resource "openstack_networking_subnet_v2" "client_subnet" {
  name = "client_subnet"
  network_id = "${openstack_networking_network_v2.client_net.id}"
  cidr = "172.1.1.0/24"
}


resource "openstack_networking_router_v2" "myrouter" {
  name = "myrouter"
  external_network_id = "${var.public_pool_id}"
}

resource "openstack_networking_router_interface_v2" "client_net_itf" {
  router_id = "${openstack_networking_router_v2.myrouter.id}"
  subnet_id = "${openstack_networking_subnet_v2.client_subnet.id}"
}


resource "openstack_compute_instance_v2" "vm1" {
  name            = "vm1"
  image_id        = "${var.myimage}"
  flavor_id       = "${var.myflavor}"
  key_pair        = "${openstack_compute_keypair_v2.mykey1.name}"
  security_groups = ["${openstack_networking_secgroup_v2.my_secgroup.id}"]
  network {
    uuid = "${openstack_networking_network_v2.client_net.id}"
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