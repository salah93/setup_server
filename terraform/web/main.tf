provider "digitalocean" {
    token  = var.do_token
}

data "digitalocean_droplet_snapshot" "website" {
    name_regex  = "sandbox-\\d*"
    region      = var.region
    most_recent = true
}

resource "digitalocean_droplet" "website" {
    count              = var.node_count
    name               = format("website-%s", count.index + 1)
    image              = data.digitalocean_droplet_snapshot.website.id
    region             = var.region
    size               = var.size
    ipv6               = true
    monitoring         = true
    ssh_keys           = var.ssh_keys
    private_networking = true
    tags = [
        "website"
    ]

    connection {
        type        = "ssh"
        private_key = file(var.private_key)
        user        = var.remote_user
        host        = self.ipv4_address
        timeout     = "3m"
    }

    provisioner "remote-exec" {
        inline = [
            "sudo rm -rf .ansible"
        ]
    }

    provisioner "local-exec" {
        command = <<EOT
            ansible-playbook \
                -u ${var.remote_user} \
                --vault-password-file ./.ansible-secret \
                --private-key=${var.private_key} \
                -i ${self.ipv4_address}, \
                --ssh-extra-args="-o UserKnownHostsFile=/dev/null -o StrictHostKeyChecking=no" \
                $PLAYBOOK
            EOT
        working_dir = "../../"
        environment = {
            PLAYBOOK = "web-playbook.yml"
        }
    }

}


resource "digitalocean_loadbalancer" "website" {
    depends_on          = [digitalocean_droplet.website]
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

    droplet_tag        = "website"
}


resource "digitalocean_firewall" "website" {
    depends_on                = [digitalocean_loadbalancer.website]
    name                      = "ssh-only"

    tags                      = ["website"]

    inbound_rule {
        protocol              = "tcp"
        port_range            = "22"
        source_tags           = ["sandbox"]
    }

    inbound_rule {
        protocol              = "tcp"
        port_range            = "80"
        source_tags           = ["website"]
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
