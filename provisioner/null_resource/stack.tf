# Below resources in stack.tf file


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
  name            = "myvm1"
  image_id        = "${var.myimage}"
  flavor_id       = "${var.myflavor}"
  key_pair        = "${var.mykey}"
  security_groups = ["${var.mysg}"]
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




/*
The null_resource is a resource that allows you to configure provisioners that are not directly associated with a single existing resource.

Basically we want to use provisioner(execute someaction) independently not part of any existing resource.

Here we use Null resource to ping the floating ip (from local machine/provisioner) , the dependency of exeuction of Null rresource is completion of VM resource creation.
*/

resource "null_resource" "ping_floatingip" {

  depends_on = ["openstack_compute_instance_v2.vm1"]

  provisioner "local-exec" {
    command = "ping ${openstack_networking_floatingip_v2.fip_1.address} -c 10"
  }
}
