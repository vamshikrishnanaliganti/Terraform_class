provider "google" {
  project = "multicloud-450012"
  region  = "europe-west2"
}

# 🔹 VPC Network
resource "google_compute_network" "vpc_network" {
  name                    = "tier3-vpc"
  auto_create_subnetworks = false
}

# 🔹 Subnets for each tier
resource "google_compute_subnetwork" "frontend_subnet" {
  name          = "frontend-subnet"
  network       = google_compute_network.vpc_network.id
  ip_cidr_range = "10.10.1.0/24"
  region        = "europe-west2"
}

resource "google_compute_subnetwork" "backend_subnet" {
  name          = "backend-subnet"
  network       = google_compute_network.vpc_network.id
  ip_cidr_range = "10.10.2.0/24"
  region        = "europe-west2"
  private_ip_google_access = true
}

# 🔹 Firewall Rules
resource "google_compute_firewall" "allow_http" {
  name    = "allow-http"
  network = google_compute_network.vpc_network.id

  allow {
    protocol = "tcp"
    ports    = ["80"]
  }

  source_ranges = ["0.0.0.0/0"]
}

# 🔹 Instance Template for Frontend Web Server (Apache)
resource "google_compute_instance_template" "frontend_template" {
  name         = "frontend-template"
  machine_type = "e2-micro"

  disk {
    source_image = "projects/centos-cloud/global/images/family/centos-stream-9"
    auto_delete  = true
    boot         = true
  }

  network_interface {
    subnetwork = google_compute_subnetwork.frontend_subnet.id
  }

  metadata_startup_script = <<-EOT
    #!/bin/bash
    yum update -y
    yum install -y httpd
    echo "<h1>Frontend Web Server - Running</h1>" > /var/www/html/index.html
    systemctl start httpd
    systemctl enable httpd
  EOT
}

# 🔹 Regional Managed Instance Group for Frontend
resource "google_compute_region_instance_group_manager" "frontend_mig" {
  name               = "frontend-mig"
  base_instance_name = "frontend-instance"
  region             = "europe-west2"

  version {
    instance_template = google_compute_instance_template.frontend_template.id
  }

  target_size = 2
}

# 🔹 Load Balancer Backend Service
resource "google_compute_backend_service" "frontend_backend" {
  name          = "frontend-backend"
  health_checks = [google_compute_health_check.http_health_check.id]
  
  backend {
  group = google_compute_region_instance_group_manager.frontend_mig.instance_group
  }

}

# 🔹 HTTP Health Check
resource "google_compute_health_check" "http_health_check" {
  name = "frontend-health-check"

  http_health_check {
    port = "80"
  }
}

# 🔹 HTTP Load Balancer
resource "google_compute_global_forwarding_rule" "http_forwarding_rule" {
  name       = "frontend-http-rule"
  target     = google_compute_target_http_proxy.http_proxy.id
  port_range = "80"
}

resource "google_compute_target_http_proxy" "http_proxy" {
  name    = "frontend-http-proxy"
  url_map = google_compute_url_map.url_map.id
}

resource "google_compute_url_map" "url_map" {
  name            = "frontend-url-map"
  default_service = google_compute_backend_service.frontend_backend.id
}

# 🔹 Backend Application Server
resource "google_compute_instance" "backend_server" {
  name         = "backend-server"
  machine_type = "e2-medium"
  zone         = "europe-west2-a"

  boot_disk {
    initialize_params {
      image = "centos-cloud/centos-stream-9"
    }
  }

  network_interface {
    subnetwork = google_compute_subnetwork.backend_subnet.id
  }

  metadata_startup_script = <<-EOT
    #!/bin/bash
    yum update -y
    yum install -y python3
    echo "Backend API Running" > /home/backend.log
  EOT
}

# 🔹 Cloud SQL Database (MySQL)
resource "google_sql_database_instance" "db_instance" {
  name             = "mysql-instance"
  region           = "europe-west2"
  database_version = "MYSQL_8_0"

  settings {
    tier = "db-f1-micro"
    ip_configuration {
      ipv4_enabled = true
    }
  }
}

resource "google_sql_user" "db_user" {
  name     = "appuser"
  instance = google_sql_database_instance.db_instance.name
  password = "securepassword"
}

resource "google_sql_database" "app_db" {
  name     = "appdb"
  instance = google_sql_database_instance.db_instance.name
}
