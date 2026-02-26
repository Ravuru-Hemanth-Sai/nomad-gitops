job "[[ .mysql_job_name ]]" {
  datacenters = ["dc1"]
  type        = "service"

  group "db" {
    # Persistent storage on your RHEL machine
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
        # This variable will be pulled from Nomad Ops
        MYSQL_ROOT_PASSWORD = "[[ .mysql_password ]]"
      }

      resources {
        cpu    = [[ .mysql_cpu ]]
        memory = [[ .mysql_memory ]]
      }
    }
  }
}
