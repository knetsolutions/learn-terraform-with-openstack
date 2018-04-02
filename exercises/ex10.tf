provider "openstack" {
  user_name   = "admin"
  tenant_name = "admin"
  password    = "openstack123"
  auth_url    = "http://10.0.1.6/identity"
  region      = "RegionOne"
  domain_name = "default"
}

resource "openstack_images_image_v2" "ubuntu" {
  name   = "ubuntu16"
  image_source_url = "https://cloud-images.ubuntu.com/xenial/current/xenial-server-cloudimg-amd64-disk1.img"
  container_format = "bare"
  disk_format = "qcow2"
  visibility = "public"
}


