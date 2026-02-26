job "mysql-poc-direct" {
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
        image = "mysql:8.0"
        ports = ["db"]
      }

      env {
        MYSQL_ROOT_PASSWORD = "TestPassword123!"
      }

      resources {
        cpu    = 1000
        memory = 1024
      }
    }
  }
}
