Exercises2:
=====================

Objective:  Demonstrate the openstack resource creation(vm, floatingip, floating ip association) in terraform. 

we covers **resource, variable, output block**  of terraform configuration in this exercise.


Steps:
------------

1) In the Exercise1, 
   Use variable block  to declare the image, flavor, key, security group, network. 

```
variable myimage {
  default = "dea87f06-9fdc-410c-974f-470b057cfa2b"
}
```

2) Terraform plan and apply

3) Add floating IP resource.

```
resource "openstack_networking_floatingip_v2" "fip_1" {
  pool = "public"
}
```
4) Terraform Plan,apply and show

5) Add floating IP association  


```
resource "openstack_compute_floatingip_associate_v2" "fip_1" {
  floating_ip = "${openstack_networking_floatingip_v2.fip_1.address}"
  instance_id = "${openstack_compute_instance_v2.vm1.id}"
}

```

6) Terraform plan , apply and show.



Referneces:
===============
1. https://www.terraform.io/docs/providers/openstack/index.html