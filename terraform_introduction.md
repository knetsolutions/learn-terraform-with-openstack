
What is Terraform?
=====================

Terraform is used to create, manage, and update infrastructure resources such as physical machines, VMs, network switches, containers, and more. Almost any infrastructure type can be represented as a resource in Terraform.

In Simple,

Terraform is a tool for 

 i)   building, 

ii)  changing, 

iii) versioning 

 your infrastructure.



Use Cases :
=====================

1. Deploying and Maintaining Multi-Tier Applications Infrastructure (DB, WEB, LOG, Load balancer, etc)

2. Software Demos

3. Disposable Environments

4. Multi cloud Support (cloud agnostic)


Provider
=========

Terraform can manage existing and popular service providers such as,

1) openstack

2) aws

3) google cloud

4) azure

5) kubernetes

6) DigitalOcean

7) .......etc......


https://www.terraform.io/docs/providers/index.html



Key Features
==============


Infrastructure as Code 
------------------------
a. Infrastructure is described using a high-level configuration syntax.
b. This allows versioning
c. infrastructure can be shared and re-used.



Execution Plans 
------------------------
Terraform planning step will evaluate and generates the execution plan. This shows what will be output ,when you apply this stack.



Paraller creation (Resource graph)
-----------------------------------

Parallelizes the creation and modification of any non-dependent resources


Change Automation 
------------------

Complex changesets can be applied to your infrastructure with minimal human interaction

Incremental changes of your existing infrastructure can be updated.





Configuration File
=====================

Configuration files describe to Terraform the components needed to run a single application or your entire datacenter.

As the configuration changes, Terraform is able to determine what changed and create incremental execution plans which can be applied.




References:
==============

https://www.terraform.io/


https://www.terraform.io/intro/use-cases.html


