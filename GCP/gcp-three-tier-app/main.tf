provider "google" {
  project = "multicloud-450012"
  region  = "europe-west2"
}

# VPC Network
resource "google_compute_network" "vpc_network" {
  name                    = "tier3-vpc"
  auto_create_subnetworks = false
}

# Subnets
resource "google_compute_subnetwork" "frontend_subnet" {
  name          = "frontend-subnet"
  network       = google_compute_network.vpc_network.id
  ip_cidr_range = "10.10.1.0/24"
  region        = "europe-west2"
}

resource "google_compute_subnetwork" "backend_subnet" {
  name                     = "backend-subnet"
  network                  = google_compute_network.vpc_network.id
  ip_cidr_range            = "10.10.2.0/24"
  region                   = "europe-west2"
  private_ip_google_access = true
}

# Cloud NAT (Allows outbound internet for private VMs)
resource "google_compute_router" "nat_router" {
  name    = "nat-router"
  region  = "europe-west2"
  network = google_compute_network.vpc_network.id
}

resource "google_compute_router_nat" "cloud_nat" {
  name                               = "cloud-nat"
  router                             = google_compute_router.nat_router.name
  region                             = google_compute_router.nat_router.region
  nat_ip_allocate_option             = "AUTO_ONLY"
  source_subnetwork_ip_ranges_to_nat = "LIST_OF_SUBNETWORKS"
  subnetwork {
    name                    = google_compute_subnetwork.backend_subnet.id
    source_ip_ranges_to_nat = ["ALL_IP_RANGES"]
  }
}

# 🔥 Firewall Rules
resource "google_compute_firewall" "allow_http" {
  name    = "allow-http"
  network = google_compute_network.vpc_network.id

  allow {
    protocol = "tcp"
    ports    = ["80"]
  }

  source_ranges = ["0.0.0.0/0"]
}

resource "google_compute_firewall" "allow_internal" {
  name    = "allow-internal"
  network = google_compute_network.vpc_network.id

  allow {
    protocol = "tcp"
    ports    = ["80", "3306", "22"] # Allow SSH internally
  }

  source_ranges = ["10.10.0.0/16"]
}

resource "google_compute_firewall" "allow_ssh" {
  name    = "allow-ssh"
  network = google_compute_network.vpc_network.id

  allow {
    protocol = "tcp"
    ports    = ["22"]
  }

  source_ranges = ["0.0.0.0/0"]
}

# Instance Template for Frontend
resource "google_compute_instance_template" "frontend_template" {
  name         = "frontend-template"
  machine_type = "e2-micro"

  disk {
    source_image = "debian-cloud/debian-11"
    auto_delete  = true
    boot         = true
  }

  network_interface {
    subnetwork = google_compute_subnetwork.frontend_subnet.id
    access_config {}
  }

  metadata_startup_script = <<-EOT
    #!/bin/bash
    apt update -y
    apt install -y apache2
    echo "<h1>Frontend Web Server - Running</h1>" > /var/www/html/index.html
    systemctl start apache2
    systemctl enable apache2
  EOT
}

# Managed Instance Group for Frontend
resource "google_compute_region_instance_group_manager" "frontend_mig" {
  name               = "frontend-mig"
  base_instance_name = "frontend-instance"
  region             = "europe-west2"

  version {
    instance_template = google_compute_instance_template.frontend_template.id
  }

  target_size = 1
}

# Instance Template for Backend
resource "google_compute_instance_template" "backend_template" {
  name         = "backend-template"
  machine_type = "e2-medium"

  disk {
    source_image = "debian-cloud/debian-11"
    auto_delete  = true
    boot         = true
  }

  network_interface {
    subnetwork = google_compute_subnetwork.backend_subnet.id
  }

  metadata_startup_script = <<-EOT
    #!/bin/bash
    apt update -y
    apt install -y python3 mysql-client
    echo "Backend API Running" > /home/backend.log
  EOT
}

# Managed Instance Group for Backend
resource "google_compute_region_instance_group_manager" "backend_mig" {
  name               = "backend-mig"
  base_instance_name = "backend-instance"
  region             = "europe-west2"

  version {
    instance_template = google_compute_instance_template.backend_template.id
  }

  target_size = 1
}
# Reserve an IP range for Private Services Access
resource "google_compute_global_address" "private_ip_block" {
  name          = "google-managed-services"
  purpose       = "VPC_PEERING"
  address_type  = "INTERNAL"
  prefix_length = 16
  network       = google_compute_network.vpc_network.id
}

# Create a Private Services Access (PSA) connection
resource "google_service_networking_connection" "private_vpc_connection" {
  network                 = google_compute_network.vpc_network.id
  service                 = "servicenetworking.googleapis.com"
  reserved_peering_ranges = [google_compute_global_address.private_ip_block.name]
}

# Cloud SQL Database
resource "google_sql_database_instance" "db_instance" {
  name             = "mysql-instance"
  region           = "europe-west2"
  database_version = "MYSQL_8_0"

  settings {
    tier = "db-f1-micro"
    ip_configuration {
      ipv4_enabled    = false
      private_network = google_compute_network.vpc_network.id
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

# HTTP Health Check
resource "google_compute_health_check" "http_health_check" {
  name = "frontend-health-check"

  http_health_check {
    port = "80"
  }
}

# 🔄 Load Balancer (Regional)
resource "google_compute_backend_service" "frontend_backend" {
  name                  = "frontend-backend"
  health_checks         = [google_compute_health_check.http_health_check.id]
  load_balancing_scheme = "EXTERNAL"

  backend {
    group = google_compute_region_instance_group_manager.frontend_mig.instance_group
  }
}



resource "google_compute_url_map" "url_map" {
  name            = "frontend-url-map"
  default_service = google_compute_backend_service.frontend_backend.id
}

resource "google_compute_target_http_proxy" "http_proxy" {
  name    = "frontend-http-proxy"
  url_map = google_compute_url_map.url_map.id
}

resource "google_compute_global_forwarding_rule" "http_forwarding_rule" {
  name       = "frontend-http-rule"
  target     = google_compute_target_http_proxy.http_proxy.id
  port_range = "80"
}

# # ✅ Cloud DNS
# resource "google_dns_managed_zone" "dns_zone" {
#   name     = "lumlathomas-site-zone"
#   dns_name = "lumlathomas.site."
# }

# resource "google_dns_record_set" "dns_a_record" {
#   name         = "lumlathomas.site."
#   type         = "A"
#   ttl          = 300
#   managed_zone = google_dns_managed_zone.dns_zone.name

#   rrdatas = [google_compute_global_forwarding_rule.http_forwarding_rule.ip_address]
# }
