Terraform Exercises - Part3:
============================
Exercise3:
============================

In this exercise, we build our infra as below,

![Infrastructure Diagram](exercises/ex3.png?raw=true)

The following resources will be created.

1) Keypair

2) Security Groups and Rules

3) Network and Subnet

4) Router

5) Floating IP

6) Instance

we will use the Ubuntu Image and flavor.


we will use multiple  terraform files to build our infra.

variables will be stored in vars.tf file.

resources will be in stack.tf file.

output stuff will be in output.tf file



vars.tf
---------

1. create a vars.tf file and update the image, flavor, and  public pool id.


stack.tf
----------


**keypair:**


```
resource "openstack_compute_keypair_v2" "mykey1" {
  name = "mykey1"
  public_key = "${file("mykey.pub")}"
}

```

Note: mykey.pub , mykey (private key) file present in exercise folder. Please copy this file in to the folder.

 
 **Security Groups and Rules**

```
resource "openstack_networking_secgroup_v2" "my_secgroup" {
  name = "my_secgroup"
  description = "Allow all"
}

resource "openstack_networking_secgroup_rule_v2" "rule1" {
  direction = "ingress"
  ethertype = "IPv4"
  security_group_id = "${openstack_networking_secgroup_v2.my_secgroup.id}"
}
```

**Network and Subnet**

```
resource "openstack_networking_network_v2" "client_net" {
  name = "client_net"
  admin_state_up = "true"
}

resource "openstack_networking_subnet_v2" "client_subnet" {
  name = "client_subnet"
  network_id = "${openstack_networking_network_v2.client_net.id}"
  cidr = "172.1.1.0/24"
}

```

**Router**

```
resource "openstack_networking_router_v2" "myrouter" {
  name = "myrouter"
  external_gateway = "${var.public_pool_id}"
}

resource "openstack_networking_router_interface_v2" "client_net_itf" {
  router_id = "${openstack_networking_router_v2.myrouter.id}"
  subnet_id = "${openstack_networking_subnet_v2.client_subnet.id}"
}

```

**Floating IP**


```
resource "openstack_networking_floatingip_v2" "fip_1" {
  pool = "public"
}


resource "openstack_compute_floatingip_associate_v2" "fip_1" {
  floating_ip = "${openstack_networking_floatingip_v2.fip_1.address}"
  instance_id = "${openstack_compute_instance_v2.vm1.id}"
}

```

**Instance**
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
}

```


output.tf
----------

```

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


```


Execution
------------
```
terraform init
terraform plan
terraform apply
terraform destroy
```



References:
===============

1. https://www.terraform.io/docs/providers/openstack/index.html

