Terraform Exercises:
=====================

In this series of exercises, 
we are going to learn, How to write our openstack infrastructure in terraform configurations.

Please download this repository to your machine.



Exercises1:
=====================
Objective:  Demonstrate the openstack resource(vm) creation in terraform. we covers **provider,resource and output block**  of terraform configuration in this exercise.

Launch the openstack server instance with existing available resources (keypair, network, flavor, image, security group).


Steps:
------------
1. Create a new directory and create the ex1.tf file 

```
mkdir ex1
cd ex1
vi ex1.tf
```

2. create the provider blocks in the file

https://www.terraform.io/docs/providers/openstack/index.html

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

3. create the resource block in the file
resource : instance (vm)

```
resource "openstack_compute_instance_v2" "vm1" {
  name            = "vm1"
  image_id        = "dea87f06-9fdc-410c-974f-470b057cfa2b"
  flavor_id       = "1"
  key_pair        = "mykey"
  security_groups = ["default"]
  network {
    uuid = "db4a268a-465d-40d7-9db2-54b82d945bec"
  }
}
```

4. Execute terraform init & plan

```
terraform init
terraform plan
```


5. Apply your infra

```
terraform apply
```

6. verify your infra

Check with openstack commands, or horizon dashboard


7. Check the terraform resource properties

```
terraform show
```


8. Create the output variable to display the VM attributes.

```
output "vm-name" {
  value = "${openstack_compute_instance_v2.vm1.name}"
}

output "vm-id" {
  value = "${openstack_compute_instance_v2.vm1.id}"
}

output "vm-ip" {
	value = "${openstack_compute_instance_v2.vm1.network.0.fixed_ip_v4}"
}

```

9. perform terraform plan and apply, to check the output.


10. destroy your infra

```
terraform destroy
```


11. Use environment(rc file) variable instead of provider block and repeat this exercise.


```
export OS_USERNAME=demo
export OS_PASSWORD=openstack123
export OS_REGION_NAME=RegionOne
export OS_TENANT_NAME=demo
export OS_USER_DOMAIN_ID=default
export OS_AUTH_URL=http://10.0.1.6/identity
```



Exercises2:
=====================


Objective:  Demonstrate the openstack resource creation(vm, floatingip, floating ip association) in terraform. we covers **resource, variable, output block**  of terraform configuration in this exercise.

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

4) Terraform Plan,apply and show

5) Add floating IP association  

6) Terraform plan , apply and show.


Referneces:
===============
1. https://www.terraform.io/docs/providers/openstack/index.html
2. https://www.terraform.io/docs/providers/openstack/r/compute_instance_v2.html
 

