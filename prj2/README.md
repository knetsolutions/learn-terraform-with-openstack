Terraform : Prj2:
==================

Objective:
   - Create multiple(configuration) Compute Instances and use separate cloudinit bootscript(some conditional logic) for Instances.
   - Use single openstack_compute_instance_v2 resource with count parameter(identical resource creation) to create multiple instaces.

Technical learning:
   - count parameter
   - conditional execution


Steps:
---------------
1. create a number of instances in vars.tf file

```
variable instances {
   type = "map"   
   
   default   {     
   backend = "2"   
   } 
 }
```
we created a map (python terminology - its dictionary) , this can be accessed as
vars.instances["backend"]  This variable will return the value 2.


2. In stack.tf, the openstack_compute_instance_v2 resource creation block,

specify the number of identical resources to be created as below,

```
  count = "${var.instances["backend"]}"
```
Here the count is 2.  it means index 0 and 1.



3. Access the index of the instance count.

```
 name = "myvm1_${count.index}"
```
we can get the index of the count using "count.index" attribute.


4. conditional execution:
Terraform supports the simple conditional execution to branch on the final value

The conditional syntax is the well-known ternary operation:

```
CONDITION ? TRUEVAL : FALSEVAL
```

our objective is simple run separate cloudinit for 1st server and separate one for second server. we use count.index to identify as below,


```
user_data = "${count.index > 0 ? "${data.template_cloudinit_config.init_script_2.rendered}" : "${data.template_cloudinit_config.init_script_1.rendered}"}" 

```


References:
---------------

1. https://www.terraform.io/docs/configuration/resources.html#count
2. https://www.terraform.io/docs/configuration/interpolation.html#conditionals
3. https://www.terraform.io/docs/configuration/resources.html#using-variables-with-count




