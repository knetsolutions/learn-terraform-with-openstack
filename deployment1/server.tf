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
  public_key = "${file("mykey.pub")}"
}


resource "openstack_networking_network_v2" "server_net" {
  name = "server_net"
  admin_state_up = "true"
}

resource "openstack_networking_subnet_v2" "server_subnet" {
  name = "server_subnet"
  network_id = "${openstack_networking_network_v2.server_net.id}"
  cidr = "192.168.1.0/24"
}



resource "openstack_networking_router_v2" "internet_router" {
  name = "internet_router"
  external_network_id = "${var.public_pool_id}"
}


resource "openstack_networking_router_interface_v2" "server_net_itf" {
  router_id = "${openstack_networking_router_v2.internet_router.id}"
  subnet_id = "${openstack_networking_subnet_v2.server_subnet.id}"
}

data "template_cloudinit_config" "init_script" {
  part {
    content_type = "text/cloud-config"
    content = "${file("cloudinit.yaml")}"
  }
}


resource "openstack_compute_instance_v2" "server1" {
  name            = "server1"
  image_id        = "${var.serverimage}"
  flavor_id       = "${var.serverflavor}"
  key_pair        = "${openstack_compute_keypair_v2.mykey1.name}"
  security_groups = ["${openstack_networking_secgroup_v2.my_secgroup.id}"]
  network {
    uuid = "${openstack_networking_network_v2.server_net.id}"
  }
  user_data = "${data.template_cloudinit_config.init_script.rendered}"  
}



resource "openstack_networking_floatingip_v2" "fip_1" {
  pool = "public"
}


resource "openstack_compute_floatingip_associate_v2" "fip_1" {
  floating_ip = "${openstack_networking_floatingip_v2.fip_1.address}"
  instance_id = "${openstack_compute_instance_v2.server1.id}"
}

