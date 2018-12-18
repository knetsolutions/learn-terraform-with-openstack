/*


   Local provisioner exercise


*/



resource "openstack_networking_network_v2" "client_net" {
  name = "client_net"
  admin_state_up = "true"
}

resource "openstack_networking_subnet_v2" "client_subnet" {
  name = "client_subnet"
  network_id = "${openstack_networking_network_v2.client_net.id}"
  cidr = "10.10.10.0/24"
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
  key_pair        = "${var.mykey}"
  security_groups = ["${var.mysg}"]
  network {
    uuid = "${openstack_networking_network_v2.client_net.id}"
  }

  provisioner "local-exec" {
    command = "echo ${openstack_compute_instance_v2.vm1.network.0.fixed_ip_v4} >> vm_ips.txt"
  }
}


resource "openstack_networking_floatingip_v2" "fip_1" {
  pool = "public"
}


resource "openstack_compute_floatingip_associate_v2" "fip_1" {
  floating_ip = "${openstack_networking_floatingip_v2.fip_1.address}"
  instance_id = "${openstack_compute_instance_v2.vm1.id}"

  provisioner "local-exec" {
    command = "ping ${openstack_networking_floatingip_v2.fip_1.address} -c 25"
  }

}
