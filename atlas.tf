#################################################################
#          Terraform file depends on variables.tf               #
#################################################################

#################################################################
#          Terraform file depends on locals.tf                  #
#################################################################

# Some remaining variables are still hardcoded, such Atlas shape 
# details. There are only used once, and most likely they are 
# not required to change

#################################################################
##################### MONGODB ATLAS SECTION #####################
#################################################################

provider "mongodbatlas" {
  # variable are provided via ENV
  # public_key = ""
  # private_key  = ""
}

# Need a project
resource "mongodbatlas_project" "proj1" {
  name   = local.project_id
  org_id = var.atlas_organization_id
}

resource "mongodbatlas_privatelink_endpoint" "test" {
  project_id    = mongodbatlas_project.proj1.id
  provider_name = local.provider_name
  region        = local.provider_region
}

resource "mongodbatlas_privatelink_endpoint_service" "test" {
  project_id            = mongodbatlas_privatelink_endpoint.test.project_id
  private_link_id       = mongodbatlas_privatelink_endpoint.test.private_link_id
  endpoint_service_id   = azurerm_private_endpoint.atlas-group.id
  private_endpoint_ip_address = azurerm_private_endpoint.atlas-group.private_service_connection.0.private_ip_address
  provider_name = local.provider_name
}

# resource "mongodbatlas_cluster" "this" {
#  name                  = local.cluster_name
#  project_id            = mongodbatlas_project.proj1.id

#  replication_factor           = 3
#  # not allowed for version 4.2 clusters and above
#  # backup_enabled             = true
#  # provider_backup_enabled      = true
#  cloud_backup                 = true
#  auto_scaling_disk_gb_enabled = true
#  mongo_db_major_version       = "4.2"

#  provider_name               = local.provider_name
#  provider_instance_size_name = "M10"
#  # this provider specific, why?
#  provider_region_name        = local.region
# }


resource "mongodbatlas_advanced_cluster" "this" {
  name                  = local.cluster_name
  project_id            = mongodbatlas_project.proj1.id
  cluster_type          = "REPLICASET"
  backup_enabled        = false
  # mongo_db_major_version = "6.0"
  version_release_system = "CONTINUOUS"

  replication_specs {
    region_configs {
      electable_specs {
        instance_size = "M10"
        node_count    = 3
      }
      provider_name   = local.provider_name
      priority        = 7
      region_name     = local.region

      auto_scaling {
        compute_enabled = true
        compute_scale_down_enabled = true
        compute_min_instance_size = "M10"
        compute_max_instance_size = "M30"
        disk_gb_enabled = true
      }
    }
  }  
}



output "atlasclusterstring" {
   value = mongodbatlas_advanced_cluster.this.connection_strings[0].private_endpoint[0].srv_connection_string
}

# output "atlasclusterstring" {
#    value = mongodbatlas_cluster.this.connection_strings[0].private_endpoint[0].srv_connection_string
# }

# DATABASE USER
resource "mongodbatlas_database_user" "user1" {
  username           = local.admin_username
  password           = var.admin_password
  project_id         = mongodbatlas_project.proj1.id
  auth_database_name = "admin"

  roles {
    role_name     = "readWriteAnyDatabase"
    database_name = "admin"
  }
  labels {
    key   = "Name"
    value = local.admin_username
  }
  scopes {
    name = mongodbatlas_advanced_cluster.this.name
    type = "CLUSTER"
  }
}

output "user1" {
  value = mongodbatlas_database_user.user1.username
}
