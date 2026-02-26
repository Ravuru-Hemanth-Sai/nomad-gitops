job "mysql-poc-direct" {
  datacenters = ["dc1"]
  type        = "service"

  group "db" {
    # 1. FIX: You must define the network ports here
    network {
      port "db" {
        static = 3306
      }
    }

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
        # This now refers to the 'db' port defined above
        ports = ["db"]
      }

      env {
        MYSQL_ROOT_PASSWORD = "TestPassword123!"
      }

      # 2. ADD: This makes the DB discoverable
      service {
        name = "mysql"
        port = "db"
        check {
          type     = "tcp"
          interval = "10s"
          timeout  = "2s"
        }
      }

      resources {
        cpu    = 1000
        memory = 1024
      }
    }
  }
}
