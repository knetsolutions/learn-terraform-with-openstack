# Terraform : Project2:
==================

**Objective:**

   I want to create multiple compute instances(identical configuration, except different cloudinit bootscripts - application provisioning ) and associate floating IPs.

![Infrastructure Diagram](deploy2.jpg?raw=true) 

**Technical learning:**

   - count parameter

   - element

   - conditional execution



### Part1 - Create Multiple compute Instances:



#### 1. create a number of instances in vars.tf file

```
variable instances {
   type = "map"   
   
   default   {     
   backend = "2"   
   } 
 }
```

we created a map (python terminology - its dictionary, sting keys to string values) , this can be accessed as  vars.instances["backend"]. This variable will return the value 2.

Reference :  https://www.terraform.io/docs/configuration/variables.html#maps




#### 2. In stack.tf, the openstack_compute_instance_v2 resource creation block,

specify the number of resources to be created as below,

```
  count = "${var.instances["backend"]}"
```

Here the count is 2.  it means index 0 and 1.

Reference: https://www.terraform.io/docs/configuration/resources.html#count


#### 3. Access the index of the instance count.

We populate the VM name from index count index.

```
 name = "myvm1_${count.index}"
```
we can get the index of the count using "count.index" attribute.


#### 4. conditional execution:

Terraform supports the simple conditional execution to branch on the final value


The conditional syntax is the well-known ternary operation:

```
CONDITION ? TRUEVAL : FALSEVAL
```


our objective is simply, run separate cloudinit for 1st server and separate one for second server. we use count.index to identify as below,


```
user_data = "${count.index > 0 ? "${data.template_cloudinit_config.init_script_2.rendered}" : "${data.template_cloudinit_config.init_script_1.rendered}"}" 

```

Reference: https://www.terraform.io/docs/configuration/interpolation.html#conditionals


### Part2 - Associate the Floatingips



#### 1. create a the 'n' number of floating ip resources (using count attribute)




```
resource "openstack_networking_floatingip_v2" "fip_1" {
  pool = "public"
  count = "${var.instances["backend"]}"
}
```

#### 2. Associate the floating ip  - using element() inbuilt funtion 

In earlier exercises, we use direct association of VM id and floating ip id as below,

```
resource "openstack_compute_floatingip_associate_v2" "fip_1" {
  floating_ip = "${openstack_networking_floatingip_v2.fip_1.address}"
  instance_id = "${openstack_compute_instance_v2.vm1.id}"
}

```

But in this stack/example, we cannot access the floatingip resource id and instance id as string. Because we have used count parameters. 

```
resource "openstack_networking_floatingip_v2" "fip_1" {
  pool = "public"
  count = "${var.instances["backend"]}"
}
```

Hence we created multiple resources(list) on same id, The ID contains the list of resources.

We can access this resources by

```
openstack_networking_floatingip_v2.fip_1.*.id
```

To access a single resource from the list of resources, **element** in-built function is used.

```
resource "openstack_compute_floatingip_associate_v2" "fip_1" {
  count = "${var.instances["backend"]}"
  floating_ip = "${element(openstack_networking_floatingip_v2.fip_1.*.address, count.index)}"
  instance_id = "${element(openstack_compute_instance_v2.vm1.*.id, count.index)}"
}
```


Reference:

https://www.terraform.io/docs/configuration/interpolation.html#element-list-index-






### References:


1. https://www.terraform.io/docs/configuration/resources.html#count
2. https://www.terraform.io/docs/configuration/interpolation.html#conditionals
3. https://www.terraform.io/docs/configuration/resources.html#using-variables-with-count

