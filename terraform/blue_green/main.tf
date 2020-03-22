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
        "website",
        replace(var.release, ".", "-"),
        var.color
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
                -e release=${var.release} \
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
