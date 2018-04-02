Terraform Exercises - Part4:
============================

Exercise4:
-----------

In this exercise, we will use **data resource** block to define our cloudinit file (cloud-config, scripts) 

we will use exercise3 stack, and update the cloudinit scripts.


Define the cloudinit resource as below,

```
data "template_cloudinit_config" "init_script" {
  part {
    content_type = "text/cloud-config"
    content = "${file("cloudinit.yaml")}"
  }
}

```

Use the cloudinit resource in instance resource.

```
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

```



Other Methods
--------------

we can directly specify the shell commands in the user_data as below,


```
user_data = "#!/bin/bash\n\nscreen -d -m ping 8.8.8.8"

```


References:
===============

1. http://cloudinit.readthedocs.io/en/latest/topics/examples.html

2. https://www.terraform.io/docs/providers/template/d/cloudinit_config.html#

