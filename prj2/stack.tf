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
  name            = "myvm1_${count.index}"
  image_id        = "${var.myimage}"
  flavor_id       = "${var.myflavor}"
  key_pair        = "${var.mykey}"
  security_groups = ["${openstack_networking_secgroup_v2.my_secgroup.id}"]
  count = "${var.instances["backend"]}"

  network {
    uuid = "${openstack_networking_network_v2.client_net.id}"
  }

  #user_data = "${data.template_cloudinit_config.init_script_2.rendered}"
  #conditional execution of cloudinit script

  user_data = "${count.index > 0 ? "${data.template_cloudinit_config.init_script_2.rendered}" : "${data.template_cloudinit_config.init_script_1.rendered}"}" 

}



data "template_cloudinit_config" "init_script_1" {
  part {
    content_type = "text/cloud-config"
    content = "${file("cloudinit1.yaml")}"
  }
}

data "template_cloudinit_config" "init_script_2" {
  part {
    content_type = "text/cloud-config"
    content = "${file("cloudinit2.yaml")}"
  }
}



/*
resource "openstack_networking_floatingip_v2" "fip_1" {
  pool = "public"
}


resource "openstack_compute_floatingip_associate_v2" "fip_1" {
  floating_ip = "${openstack_networking_floatingip_v2.fip_1.address}"
  instance_id = "${openstack_compute_instance_v2.vm1.id}"
}
*/
