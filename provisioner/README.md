# Provisioner


Provisioners are used to execute scripts on a local or remote machine as part of resource creation or destruction. 

Provisioners can be used to bootstrap a resource, cleanup before destroy, run configuration management, etc.

Provisioners are added directly to any resource.


Reference: 
https://www.terraform.io/docs/provisioners/index.html


## Types / classifications:

1. local-exec
2. remote-exec
3. file
4. connection block
5. null-resource
6. chef
7. habitat
8. salt-masterless


## 1.local-exec provisioner

The local-exec provisioner invokes a local executable after a resource is created. This invokes a process on the machine running Terraform, not on the resource.


It must be inside a resource.

syntax :

```
provisioner "local-exec" {
    command =  "shell command or executable"
  }

```

**Example:**

```
resource "openstack_compute_instance_v2" "vm1" {
  name            = "vm1"
  image_id        = "${var.myimage}"
  flavor_id       = "${var.myflavor}"
  key_pair        = "${var.mykey}"
  security_groups = ["${var.mysg}"]
  network {
    uuid = "${openstack_networking_network_v2.client_net.id}"
  }

  provisioner "local-exec" {
    command = "echo ${openstack_compute_instance_v2.vm1.network.0.fixed_ip_v4} >> vm_ips.txt"
  }
}

resource "openstack_compute_floatingip_associate_v2" "fip_1" {
  floating_ip = "${openstack_networking_floatingip_v2.fip_1.address}"
  instance_id = "${openstack_compute_instance_v2.vm1.id}"

  provisioner "local-exec" {
    command = "ping ${openstack_networking_floatingip_v2.fip_1.address} -c 25"
  }

}

```
Note: example is located in provisioner directory prov_ex1.tf  file.




## 2.remote-exec provisioner


The remote-exec provisioner invokes a script on a remote resource after it is created. This can be used to run a configuration management tool, bootstrap into a cluster, etc.

The remote-exec provisioner supports both ssh and winrm type connections.

Reference: https://www.terraform.io/docs/provisioners/remote-exec.html



**connection block** contains connecting information(ssh), used by provisioners.
Example:
```
    connection {
      type     = "ssh"
      user     = "cirros"
      password = "cubswin:)"
      host = "${openstack_networking_floatingip_v2.fip_1.address}"
    }
```


remote-exec provisioner supports two types of actions.

1. provides the inline commands to run in the remote machine
2. provides the script, which will be copied to remote machine and execute it.


**remote-exec provisioner - inline commands:**

```
provisioner "remote-exec" {
    inline = [
      "ping -c 4 8.8.8.8 > /tmp/results.txt"
    ]

    connection {
      type     = "ssh"
      user     = "cirros"
      password = "cubswin:)"
      host = "${openstack_networking_floatingip_v2.fip_1.address}"
    }
  }
```

**remote-exec provisioner - script:**

```
  provisioner "remote-exec" {
    script = "test.sh"

    connection {
      type     = "ssh"
      user     = "cirros"
      password = "cubswin:)"
      host = "${openstack_networking_floatingip_v2.fip_1.address}"
    }
  }
```

## 3. file provisioner


The file provisioner is used to copy files or directories from the machine executing Terraform to the newly created resource.

Reference: https://www.terraform.io/docs/provisioners/file.html


```
   provisioner "file" {
    source = "test.txt"
    destination = "/tmp/test.txt"

    connection {
      type     = "ssh"
      user     = "cirros"
      password = "cubswin:)"
      host = "${openstack_networking_floatingip_v2.fip_1.address}"
    }
  }
```


## 4. null resource

The null_resource is a resource that allows you to configure provisioners that are not directly associated with a single existing resource.

Basically we want to use provisioner(execute someaction) independently not part of any existing resource.

we can use "depends_on" attribute, to specify the dependency of the null resource.


```
resource "null_resource" "ping_floatingip" {

  depends_on = ["openstack_compute_instance_v2.vm1"]

  provisioner "local-exec" {
    command = "ping ${openstack_networking_floatingip_v2.fip_1.address} -c 10"
  }
}
```

Here we use Null resource to ping the floating ip (from local machine/provisioner) , the dependency of exeuction of Null rresource is completion of compute instance creation.

