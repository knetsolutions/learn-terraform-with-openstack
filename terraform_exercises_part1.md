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

```

```

3. create the resource block in the file

```
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



9. perform terraform plan and apply, to check the output.


10. destroy your infra

```
terraform destroy
```


11. Use environment(rc file) variable instead of provider block and repeat this exercise.


Exercises2:
=====================


Objective:  Demonstrate the openstack resource creation(vm, floatingip, floating ip association) in terraform. we covers **resource, variable, output block**  of terraform configuration in this exercise.

Steps:
------------
1) In the Exercise1, Use variable block  to declare the image, flavor, key, security group, network. 

2) Terraform plan and apply

3) Add floating IP resource.

4) Terraform Plan,apply and show

5) Add floating IP association  

6) Terraform plan , apply and show.


Referneces:
===============
1. https://www.terraform.io/docs/providers/openstack/index.html
2. https://www.terraform.io/docs/providers/openstack/r/compute_instance_v2.html
 

