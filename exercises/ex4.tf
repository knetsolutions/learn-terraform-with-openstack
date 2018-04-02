# use ex3.tf and update this

data "template_cloudinit_config" "init_script" {
  part {
    content_type = "text/cloud-config"
    content = "${file("cloudinit.yaml")}"
  }
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
  user_data = "${data.template_cloudinit_config.init_script.rendered}"
}
