provider "digitalocean" {
    token  = var.do_token
}

resource "digitalocean_droplet" "sandbox" {
    # Obtain ssh-key ids via api https://developers.digitalocean.com/documentation/v2/#list-all-keys
    # Alternatively, use ssh fingerprint `ssh-keygen -E md5 -lf ~/.ssh/id_rsa.pub | awk '{print $2}'`
    ssh_keys           = var.ssh_keys
    image              = var.image
    region             = var.data_center
    size               = var.size
    name               = var.name

    connection {
        type        = "ssh"
        private_key = file(var.private_key)
        user        = "root"
        timeout     = "3m"
        host        = self.ipv4_address
    }

    provisioner "remote-exec" {
        inline = [#"dnf -y update",
                  "dnf install -y python2-dnf",
                 ]
    }

    provisioner "local-exec" {
        command = <<EOT
            ansible-playbook -i "${digitalocean_droplet.sandbox.ipv4_address}," --ssh-extra-args="-o UserKnownHostsFile=/dev/null -o StrictHostKeyChecking=no" $PLAYBOOK
            EOT

        working_dir = ".."
        environment = {
            PLAYBOOK = "playbook.yml"
        }
    }
}

output "sandbox-ip" {
    value = digitalocean_droplet.sandbox.ipv4_address
}

resource "digitalocean_droplet" "site" {
    # Obtain ssh-key ids via api https://developers.digitalocean.com/documentation/v2/#list-all-keys
    # Alternatively, use ssh fingerprint `ssh-keygen -E md5 -lf ~/.ssh/id_rsa.pub | awk '{print $2}'`
    ssh_keys           = var.ssh_keys
    image              = var.image
    region             = var.data_center
    size               = var.site-size
    name               = var.site-name

    connection {
        type        = "ssh"
        private_key = file(var.private_key)
        user        = "root"
        timeout     = "3m"
        host        = self.ipv4_address
    }

    provisioner "remote-exec" {
        inline = [#"dnf -y update",
                  "dnf install -y python2-dnf",
                 ]
    }

    provisioner "local-exec" {
        command = <<EOT
            ansible-playbook -i "${digitalocean_droplet.site.ipv4_address}," --ssh-extra-args="-o UserKnownHostsFile=/dev/null -o StrictHostKeyChecking=no" $PLAYBOOK
            EOT

        working_dir = ".."
        environment = {
            PLAYBOOK = "playbook.yml"
        }
    }
}

output "site-ip" {
    value = digitalocean_droplet.site.ipv4_address
}
