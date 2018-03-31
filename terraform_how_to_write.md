Terraform configurations:
============================
Terraform uses text files to describe infrastructure and to set variables. These text files are called Terraform configurations and end in .tf.

Two formats are supported.

**1. JSON**

**2. Terraform format (More human readable, support comments) - Preferred.**

Terraform format ends in .tf and JSON format ends in .tf.json

Load all the files (.tf or .tf.json) present in the directory.


Configuration Syntax:
============================

Terraform syntax is called HashiCorp Configuration Language (HCL).

1.provider block
---------------------

This block contains Providers  configuration such as auth details, endpoint URLs, etc. 


```
provider "openstack" {
  user_name   = "demo"
  tenant_name = "demo"
  password    = "openstack123"
  auth_url    = "http://10.0.1.6/identity"
  region      = "RegionOne"
  domain_name = "default"
}

```

2.Variable
---------------------

```
variable image_id {
  type = "string"
  default = "dea87f06-9fdc-410c-974f-470b057cfa2b"
}
```

This variable can be referred as "${var.image_id}".



3.Resource
---------------------

Resources are a component of your infrastructure. It might be some low level /high level component. Example: In openstack terminology networks, security groups, instance, key-pair etc.

The resource block creates a resource of the given TYPE (first parameter) and NAME (second parameter). The combination of the type and name must be unique.

```
resource "openstack_compute_instance_v2" "vm1" {
  image_id = "${var.image_id}"
}

```

4.Output variable
---------------------

Outputs define values that will be highlighted to the user when Terraform applies. 

Example: Fixed IP and FloatingIP of the VM.


```
# output vm-ip variable 
output "vm-ip" {
	value = "${openstack_compute_instance_v2.vm1.network.0.fixed_ip_v4}"
}
```

5.data sources
---------------------

Data sources allow data to be fetched or computed for use elsewhere in Terraform configuration.

Example:  Read the file contents 

Providers are responsible in Terraform for defining and implementing data sources

```
data "template_file" "cloudscript" {
  template = "${file("cloudinit.yaml")}"
}

```


References:
---------------

1. https://www.terraform.io/docs/configuration/index.html

2. https://www.terraform.io/docs/providers/openstack/index.html
