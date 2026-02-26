job "[[ .mysql_job_name ]]" {
  datacenters = ["dc1"]
  type        = "service"

  group "db" {
    volume "mysql_data" {
      type      = "host"
      source    = "mysql_data" 
      read_only = false
    }

    task "mysql" {
      driver = "docker"

      volume_mount {
        volume      = "mysql_data"
        destination = "/var/lib/mysql"
      }

      config {
        image = "mysql:[[ .mysql_version ]]"
        ports = ["db"]
      }

      env {
        MYSQL_ROOT_PASSWORD = "[[ .mysql_password ]]"
      }

      resources {
        # Note: Do NOT use quotes here. 
        # Nomad Ops will replace [[ .mysql_cpu ]] with 1000 
        # resulting in cpu = 1000 (valid HCL)
        cpu    = [[ .mysql_cpu ]]
        memory = [[ .mysql_memory ]]
      }
    }
  }
}
