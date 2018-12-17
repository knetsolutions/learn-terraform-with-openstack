# output vm name variable 

output "vm-name" {
  value = "${openstack_compute_instance_v2.vm1.*.name}"
}

# output vm-id variable 

output "vm-id" {
  value = "${openstack_compute_instance_v2.vm1.*.id}"
}



# output vm-ip variable 

output "vm-ip" {
  value = "${openstack_compute_instance_v2.vm1.*.network.0.fixed_ip_v4}"
}

output "floating-ips" {
  value = "${openstack_networking_floatingip_v2.fip_1.*.address}"
}


