# Below variables in vars.tf file

provider "openstack" {
  user_name   = "demo"
  tenant_name = "demo"
  password    = "openstack123"
  auth_url    = "http://10.0.1.4/identity"
  region      = "RegionOne"
  domain_name = "default"
}


variable myimage {
  default = "2e0794ad-eb68-49a2-82b7-94a6b197a5ce"
}

variable myflavor {
  default = "7"
}

variable public_pool_id {
  default = "88c7bdb2-a1e4-4c0e-8263-c6b4eccb8072"
}


variable mykey {
  default = "mykey"
}

variable instances {
   type = "map"   
   
   default   {     
   backend = "2"   
   } 
 }



