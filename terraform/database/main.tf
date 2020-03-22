provider "digitalocean" {
    token  = var.do_token
}

resource "digitalocean_database_firewall" "site-fw" {
    cluster_id = digitalocean_database_cluster.site.id

    rule {
        type  = "tag"
        value = "website"
    }
    rule {
        type  = "tag"
        value = "sandbox"
    }
}

resource "digitalocean_database_db" "site" {
    name       = var.db_name
    cluster_id = digitalocean_database_cluster.site.id
}

resource "digitalocean_database_cluster" "site" {
    name       = "site"
    engine     = "mysql"
    version    = "8"
    size       = var.size
    node_count = var.node_count
    region     = var.region
}

output "database-user" {
    value = digitalocean_database_cluster.site.user
}

output "database-password" {
    value = digitalocean_database_cluster.site.password
}

output "database-host" {
    value = digitalocean_database_cluster.site.host
}

output "database-private-host" {
    value = digitalocean_database_cluster.site.private_host
}
