/*
Exercise 1:

Objective:
Create a instance in openstack, with existing image, flavor, keypair, security-group and network resources.

Use terraform provider and resource block.


openstack command:

openstack server create --image  dea87f06-9fdc-410c-974f-470b057cfa2b \
                        --flavor 1 --key-name mykey --security-group default \
                        --nic net-id=db4a268a-465d-40d7-9db2-54b82d945bec \
                        vm1
*/


# Provider details 

provider "openstack" {
  user_name   = "demo"
  tenant_name = "demo"
  password    = "openstack123"
  auth_url    = "http://10.0.1.6/identity"
  region      = "RegionOne"
  domain_name = "default"
}

# Instance creation 

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
