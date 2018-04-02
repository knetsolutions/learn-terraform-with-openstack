resource "openstack_networking_network_v2" "client_net" {
  name = "client_net"
  admin_state_up = "true"
}

resource "openstack_networking_subnet_v2" "client_subnet" {
  name = "client_subnet"
  network_id = "${openstack_networking_network_v2.client_net.id}"
  cidr = "172.1.1.0/24"
}

resource "openstack_networking_router_interface_v2" "client_net_itf" {
  router_id = "${openstack_networking_router_v2.internet_router.id}"
  subnet_id = "${openstack_networking_subnet_v2.client_subnet.id}"
}

resource "openstack_compute_instance_v2" "client1" {
  name            = "client1"
  image_id        = "${var.clientimage}"
  flavor_id       = "${var.clientflavor}"
  security_groups = ["${openstack_networking_secgroup_v2.my_secgroup.id}"]
  network {
    uuid = "${openstack_networking_network_v2.client_net.id}"
  }
}

resource "openstack_compute_instance_v2" "client2" {
  name            = "client2"
  image_id        = "${var.clientimage}"
  flavor_id       = "${var.clientflavor}"
  security_groups = ["${openstack_networking_secgroup_v2.my_secgroup.id}"]
  network {
    uuid = "${openstack_networking_network_v2.client_net.id}"
  }
}