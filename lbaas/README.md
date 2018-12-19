# Loadbalancer:

** Objective:**

Demonstrate the Openstack Load balancer functionality with stack.

**configuration**

Two Webservers in the backend
Loadbalancer(with Round robin algorithm)
Backend servers are member of this loadbalancer.
Floating IP/Public IP is associated to the loadbalancer.

**User Demo:**

http request to the FloatingIP of the loadbalancer. User gets the Response from the backend servers.


**Technical learning:**

load balancer resources


**openstack commands**

- neutron lbaas-loadbalancer-list
- neutron lbaas-listener-list
- neutron lbaas-pool-list
- neutron lbaas-member-list
- neutron lbaas-healthmonitor-list

Reference:
https://docs.openstack.org/mitaka/networking-guide/config-lbaas.html


**Terraform resources**

- openstack_lb_loadbalancer_v2
- openstack_lb_listener_v2
- openstack_lb_pool_v2
- openstack_lb_member_v2
- openstack_lb_monitor_v2

Reference:
https://www.terraform.io/docs/providers/openstack/r/lb_loadbalancer_v2.html






### Part1 - Create a backend servers 

Lets use the old stack .


### Part2 - Create a LBAAS resources


#### openstack_lb_loadbalancer_v2


```
resource "openstack_lb_loadbalancer_v2" "mylb" {
  name = "mylb"
  vip_subnet_id   = "${openstack_networking_subnet_v2.backend_subnet.id}"
  security_group_ids = ["${openstack_networking_secgroup_v2.my_secgroup.id}"]
}

```


#### openstack_lb_listener_v2


```
resource "openstack_lb_listener_v2" "mylistener" {
  name            = "mylistener"
  loadbalancer_id = "${openstack_lb_loadbalancer_v2.mylb.id}"
  protocol        = "HTTP"
  protocol_port   = "80"
}
```




#### openstack_lb_pool_v2


```
resource "openstack_lb_pool_v2" "mypool" {
  name            = "mypool"
  lb_method       = "ROUND_ROBIN"
  protocol        = "HTTP"
  listener_id     = "${openstack_lb_listener_v2.mylistener.id}"
}
```


#### openstack_lb_member_v2

Here we associate our backend servers to the lbaas.

```
resource "openstack_lb_member_v2" "member_1" {
  address         = "${element(openstack_compute_instance_v2.server.*.network.0.fixed_ip_v4, count.index)}"
  count           = "${var.instances["backend"]}"
  subnet_id       = "${openstack_networking_subnet_v2.backend_subnet.id}"
  protocol_port   = "80"
  pool_id         = "${openstack_lb_pool_v2.mypool.id}"
}
```

#### openstack_lb_monitor_v2



```
resource "openstack_lb_monitor_v2" "monitor_1" {
  pool_id         = "${openstack_lb_pool_v2.mypool.id}"
  type            = "PING"
  delay           = 10
  timeout         = 5
  max_retries     = 3
  url_path = "/index.html"
  expected_codes = "200"
  admin_state_up = "true"
}
```


#### Associate the floating ip to the LBAAS vip port:

```
resource "openstack_networking_floatingip_v2" "fip_vip" {
  pool = "public"
  port_id = "${openstack_lb_loadbalancer_v2.mylb.vip_port_id}"
}
```



### References:

1. https://docs.openstack.org/mitaka/networking-guide/config-lbaas.html
2. https://www.terraform.io/docs/providers/openstack/r/lb_loadbalancer_v2.html

