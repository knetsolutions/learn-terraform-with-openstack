# Loadbalancer:
==================

**Objective:**

Demonstrate the Openstack Load balancer functionality with stack.

configuration:    Two Webservers in the backend
                  Loadbalancer() with Round robin algorithm)
                  Backend servers are member of this loadbalancer.
                  Floating IP/Public IP is associated to the loadbalancer.

User Demo:

http request to the FloatingIP of the loadbalancer. User gets the Response from the backend servers.



**Technical learning:**

   - openstack load balancer resources

**openstack commands**

neutron lbaas-loadbalancer-list
neutron lbaas-listener-list
neutron lbaas-pool-list
neutron lbaas-member-list
neutron lbaas-healthmonitor-list

Reference:
https://docs.openstack.org/mitaka/networking-guide/config-lbaas.html


**Terraform resources**
openstack_lb_loadbalancer_v2
openstack_lb_listener_v2
openstack_lb_pool_v2
openstack_lb_member_v2
openstack_lb_monitor_v2

Reference:
https://www.terraform.io/docs/providers/openstack/r/lb_loadbalancer_v2.html






### Part1 - Create a backend servers 

Lets use the old stack .


### Part2 - Create a LBAAS resources
openstack_lb_loadbalancer_v2
openstack_lb_listener_v2
openstack_lb_pool_v2
openstack_lb_member_v2
openstack_lb_monitor_v2



### References:

1. https://docs.openstack.org/mitaka/networking-guide/config-lbaas.html
2. https://www.terraform.io/docs/providers/openstack/r/lb_loadbalancer_v2.html

