
Providers & Plugin arch:
=========================

A provider is responsible for understanding API interactions and exposing resources. 

Terraform supports approx 100+ providers (aws, opestack, azure, google cloud, kuberenetes etc).

Early release(till 0.9), a single binary which includes all providers library. 

But 0.10 onwards, plugin architecture is introduced. providers are independent plugins.


Terraform Commands:
=====================

Below are the important(or minimum) commands to know,

1. terraform init

2. terraform validate

3. terraform plan

4. terraform apply

5. terraform show

6. terraform destroy

7. terraform output

8. terraform graph

9. terraform import

10. terraform refresh



The detailed commands are available in this link 

https://www.terraform.io/docs/commands/index.html



1.terraform init -  Initialization 
--------------------------------------------

Initialize a Terraform working directory, It Downloads the plugin required and initialize it.


a. Create a directory

```
mkdir ex1
```

b. copy the ex1 terraform stack file (from the examples) to this directory

```
cp ex2a.tf  ex1/.
```

c. Move in to the directory and perform terraform init.

```
cd ex1
ls
terraform init
```
you can see the output "provider plugin version, installation message etc."


d. check the plugin details

```
ls -asl
```
you can see .terraform folder folder will be available, and inside the plugin file will be present.

```
$ls .terraform/plugins/linux_amd64/
lock.json  terraform-provider-openstack_v1.3.0_x4
```

2. terraform validate
-------------------------------------

The terraform validate command is used to validate the syntax of the terraform files. Terraform performs a syntax check on all the terraform files in the directory, and will display an error if any of the files doesn't validate.


```
terraform validate
```




3.terraform plan
-------------------------------------

Generate and show an execution plan

This command verifies the stack file is correct (no syntax issue) and able to communicate with provider. 

Error will be thrown, If any error in the file declaration, communication with provider.

This is a preliminary step, before we apply our stack in the provider.


```
terraform plan
```


4.terraform apply
-------------------------------------
Builds the infrastructure

This command apply our stack to the provider infrastructure . This file creates the state file(terraform.tfstate) in the same folder.

```
terraform apply
```


5.terraform show
-------------------------------------
Inspect Terraform state or plan

This command displays your current state of the deployed stack. it reads the terraform state file and show the elements .

```
terraform show
```


6.terraform destroy
-------------------------------------
Destroy Terraform-managed infrastructure

This command destroys your deployed stack.  .

```
terraform destroy
```



*RULE:  Please be sure, you run the terraform command in the directory where you have the terraform  files.*


7.terraform output
-------------------------------------

display the output variables


8. terraform graph
-------------------------------------

Terraform builds a dependency graph from the Terraform configurations, and walks this graph to generate plans, refresh state, and more.

Reference:
https://www.terraform.io/docs/internals/graph.html


The terraform graph command is used to generate a visual representation of either a configuration or execution plan. The output is in the DOT format, which can be used by GraphViz to generate charts.


```
terraform graph | dot -Tsvg > graph.svg
```

open this graph.svg file in browser.



9. terraform import
-------------------------------------

To be updated



10. terraform refresh
-------------------------------------

The terraform refresh command is used to reconcile the state Terraform knows about (via its state file) with the real-world infrastructure. This can be used to detect any drift from the last-known state, and to update the state file.


```
terraform refresh
```





Simple Demo
-----------------



