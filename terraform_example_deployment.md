Terraform : Openstack Infra:
===============================

we will explain the complex infra deployment in openstack using Terraform.

We use ubuntu 16.04 image and flavor 2 for this deployment.


![Infrastructure Diagram](deployment1/infra.png?raw=true) 


Terraform files:
----------------------

**vars.tf**

**stack.tf**


**cloudinit.yaml**

**keys**


Deployment:
-----------

1. create a directory and place the files.

```
mkdir infra1
cd infra1
cp /home/suresh/learn-terraform-with-openstack/deployment/* .
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


5. Check the terraform resources

```
terraform show
```




Testing:
-----------

1. SSH to the instances
2. web requests to the server