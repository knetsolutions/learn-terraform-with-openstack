
resource "openstack_networking_secgroup_v2" "my_secgroup" {
  name = "my_secgroup"
  description = "Allow all"
}

resource "openstack_networking_secgroup_rule_v2" "rule1" {
  direction = "ingress"
  ethertype = "IPv4"
  security_group_id = "${openstack_networking_secgroup_v2.my_secgroup.id}"
}

resource "openstack_networking_network_v2" "backend_net" {
  name = "backend_net"
  admin_state_up = "true"
}

resource "openstack_networking_subnet_v2" "backend_subnet" {
  name = "backend_subnet"
  network_id = "${openstack_networking_network_v2.backend_net.id}"
  cidr = "10.10.10.0/24"
}


resource "openstack_networking_router_v2" "myrouter" {
  name = "myrouter"
  external_network_id = "${var.public_pool_id}"
}

resource "openstack_networking_router_interface_v2" "backend_net_itf" {
  router_id = "${openstack_networking_router_v2.myrouter.id}"
  subnet_id = "${openstack_networking_subnet_v2.backend_subnet.id}"
}


resource "openstack_compute_instance_v2" "server" {
  name            = "myvm1_${count.index}"
  image_id        = "${var.myimage}"
  flavor_id       = "${var.myflavor}"
  key_pair        = "${var.mykey}"
  security_groups = ["${openstack_networking_secgroup_v2.my_secgroup.id}"]
  count = "${var.instances["backend"]}"

  network {
    uuid = "${openstack_networking_network_v2.backend_net.id}"
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

Lbaas resources starts from here

*/


resource "openstack_lb_loadbalancer_v2" "mylb" {
  name = "mylb"
  vip_subnet_id   = "${openstack_networking_subnet_v2.backend_subnet.id}"
  security_group_ids = ["${openstack_networking_secgroup_v2.my_secgroup.id}"]
}


resource "openstack_lb_listener_v2" "mylistener" {
  name            = "mylistener"
  loadbalancer_id = "${openstack_lb_loadbalancer_v2.mylb.id}"
  protocol        = "HTTP"
  protocol_port   = "80"
}

resource "openstack_lb_pool_v2" "mypool" {
  name            = "mypool"
  lb_method       = "ROUND_ROBIN"
  protocol        = "HTTP"
  listener_id     = "${openstack_lb_listener_v2.mylistener.id}"
  #region          = "${var.region}"
}

resource "openstack_lb_member_v2" "member_1" {
  address         = "${element(openstack_compute_instance_v2.server.*.network.0.fixed_ip_v4, count.index)}"
  count           = "${var.instances["backend"]}"
  subnet_id       = "${openstack_networking_subnet_v2.backend_subnet.id}"
  protocol_port   = "80"
  pool_id         = "${openstack_lb_pool_v2.mypool.id}"
}

resource "openstack_lb_monitor_v2" "monitor_1" {
  pool_id         = "${openstack_lb_pool_v2.mypool.id}"
  type            = "PING"
  delay           = 10
  timeout         = 5
  max_retries     = 3
  url_path = "/index.html"
  expected_codes = "200"
  admin_state_up = "true"
}

resource "openstack_networking_floatingip_v2" "fip_vip" {
  pool = "public"
  port_id = "${openstack_lb_loadbalancer_v2.mylb.vip_port_id}"
}
