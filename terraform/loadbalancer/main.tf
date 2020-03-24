provider "digitalocean" {
    token  = var.do_token
}


resource "digitalocean_certificate" "website" {
  name    = "website"
  type    = "lets_encrypt"
  domains = [var.domain]
}


resource "digitalocean_loadbalancer" "website" {
    name                   = "website"
    region                 = var.region
    droplet_tag            = "blue"
    redirect_http_to_https = true

    forwarding_rule {
        entry_port      = 80
        entry_protocol  = "http"

        target_port     = 80
        target_protocol = "http"
    }

    forwarding_rule {
        entry_port      = 443
        entry_protocol  = "https"

        target_port     = 80
        target_protocol = "http"

        certificate_id  = digitalocean_certificate.website.id
    }

    healthcheck {
        port            = 80
        protocol        = "http"
        path            = "/health"
    }
}


resource "digitalocean_firewall" "website" {
    depends_on                = [digitalocean_loadbalancer.website]
    name                      = "website"

    tags                      = ["website"]

    inbound_rule {
        protocol              = "tcp"
        port_range            = "22"
        source_tags           = ["jenkins"]
    }

    inbound_rule {
        protocol              = "tcp"
        port_range            = "80"
        source_tags           = ["jenkins"]
        source_load_balancer_uids = [digitalocean_loadbalancer.website.id]
    }

    outbound_rule {
        protocol              = "tcp"
        port_range            = "1-65535"
        destination_addresses = ["0.0.0.0/0", "::/0"]
    }

    outbound_rule {
        protocol              = "udp"
        port_range            = "1-65535"
        destination_addresses = ["0.0.0.0/0", "::/0"]
    }
}
