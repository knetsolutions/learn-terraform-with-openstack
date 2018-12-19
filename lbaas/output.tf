# output vm name variable 
output "vm-name" {
  value = "${openstack_compute_instance_v2.server.*.name}"
}

# output vm-id variable 

output "vm-id" {
  value = "${openstack_compute_instance_v2.server.*.id}"
}



# output vm-ip variable 

output "vm-ip" {
  value = "${openstack_compute_instance_v2.server.*.network.0.fixed_ip_v4}"
}



output "vip_ip" {
  value = "${openstack_networking_floatingip_v2.fip_vip.address}"
}

output "backends_ip" {
  value = ["${openstack_lb_member_v2.member_1.*.address}"]
}

