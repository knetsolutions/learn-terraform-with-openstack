# Below variables in vars.tf file

provider "openstack" {
  user_name   = "demo"
  tenant_name = "demo"
  password    = "openstack123"
  auth_url    = "http://10.0.1.3/identity"
  region      = "RegionOne"
  domain_name = "default"
}


variable myimage {
  default = "cead651c-3cf4-424e-a7a4-722ceea5424f"
}

variable myflavor {
  default = "7"
}

variable public_pool_id {
  default = "8c56b2e0-7db7-46db-bf4e-8efec5b87737"
}


variable mykey {
  default = "testkey"
}

variable instances {
   type = "map"   
   
   default   {     
   backend = "2"   
   } 
 }



