Terraform Exercises:
=====================

In this series of exercises, 
we are going to learn, How to write our openstack infrastructure in terraform configurations.

Please download this repository to your machine.



Exercises1:
-----------

we launch the openstack server instance with existing available resources (keypair, network, flavor, image, security group).

we covers **provider and resource block**  of terraform configuration in this exercise.

1. Create a new directory and copy the ex1.tf file 

```
mkdir ex1
cd ex1
cp /home/suresh/learn-terraform-with-openstack/exercises/ex1.tf .
```

2. Execute terraform init & plan

```
terraform init
terraform plan
```


3. Apply your infra

```
terraform apply
```

4. verify your infra

Check with openstack commands, or horizon dashboard


5. Check the terraform resource properties

```
terraform show
```

6. destroy your infra

```
terraform destroy
```


Exercises2:
-----------
Lets incrementally add various stuffs in the exercise1. 
In this we will demonstrate the how to update/modify your existing infrastructure.


A)

Display (output) the VM ID, VM Name, VM Private IP using terraform output block.


B)

Create the Floating IP and associate with the VM.




Referneces:
===============
1. https://www.terraform.io/docs/providers/openstack/index.html

2. https://www.terraform.io/docs/providers/openstack/r/compute_instance_v2.html
 

