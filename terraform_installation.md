How to Install Terraform:
=========================

I am using **Ubuntu 16.04.04 LTS** for this demonstration.


The terraform latest version is **Terraform 0.11.5**


1)Download the Terraform from the below link
----------------------------------------------

https://www.terraform.io/downloads.html


```
wget https://releases.hashicorp.com/terraform/0.11.5/terraform_0.11.5_linux_amd64.zip
```


2)unzip it
-----------------------

```
unzip terraform_0.11.5_linux_amd64.zip
```

3)Move the terraform binary in to bin path.
----------------------------------------------

```
sudo mv terraform /usr/bin/.
```

Thats all


4)Verification
-----------------------

```
terraform version
```


References:
-------------

1. https://www.terraform.io/downloads.html

2. https://www.terraform.io/intro/getting-started/install.html
