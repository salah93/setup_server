provider "digitalocean" {
    token  = var.do_token
}

resource "digitalocean_loadbalancer" "website" {
    name                = "website"
    region              = var.region

    forwarding_rule {
        entry_port      = 80
        entry_protocol  = "http"

        target_port     = 80
        target_protocol = "http"
    }

    healthcheck {
        port            = 80
        protocol        = "http"
        path            = "/health"
    }

    droplet_tag        = "blue"
}


resource "digitalocean_firewall" "website" {
    depends_on                = [digitalocean_loadbalancer.website]
    name                      = "website"

    tags                      = ["website"]

    inbound_rule {
        protocol              = "tcp"
        port_range            = "22"
        source_tags           = ["sandbox"]
        source_addresses      = [var.access]
    }

    inbound_rule {
        protocol              = "tcp"
        port_range            = "80"
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
