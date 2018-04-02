output "server-name" {
  value = "${openstack_compute_instance_v2.server1.name}"
}
output "server-private-ip" {
  value = "${openstack_compute_instance_v2.server1.network.0.fixed_ip_v4}"
}
output "server-floating-ip" {
  value = "${openstack_networking_floatingip_v2.fip_1.address}"
}

output "client1-name" {
  value = "${openstack_compute_instance_v2.client1.name}"
}
output "client1-private-ip" {
  value = "${openstack_compute_instance_v2.client1.network.0.fixed_ip_v4}"
}
output "client1-floating-ip" {
  value = "${openstack_networking_floatingip_v2.fip_2.address}"
}

output "client2-name" {
  value = "${openstack_compute_instance_v2.client2.name}"
}
output "client2-private-ip" {
  value = "${openstack_compute_instance_v2.client2.network.0.fixed_ip_v4}"
}


