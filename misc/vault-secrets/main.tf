terraform {
  backend "s3" {
    bucket = "terraform-b83"
    key    = "vault-secrets/state"
    region = "us-east-1"
  }
}


provider "vault" {
  address = "http://vault-internal.shpatil17.online:8200"
  token = var.vault_token
}

variable "vault_token" {}

resource "vault_mount" "ssh" {
  path        = "infra"
  type        = "kv"
  options     = { version = "2" }
  description = "Infra secrets"
}

resource "vault_generic_secret" "ssh" {
  path = "${vault_mount.ssh.path}/ssh"

  data_json = <<EOT
{
  "username":   "ec2-user",
  "password": "DevOps321"
}
EOT
}

resource "vault_mount" "roboshop-dev" {
  path        = "roboshop-dev"
  type        = "kv"
  options     = { version = "2" }
  description = "Roboshop Dev secrets"
}

resource "vault_generic_secret" "roboshop-dev-cart" {
  path = "${vault_mount.roboshop-dev.path}/cart"

  data_json = <<EOT
{
"REDIS_HOST":   "redis-dev.shpatil17.online",
"CATALOGUE_HOST": "catalogue-dev.shpatil17.online",
"CATALOGUE_PORT": "8080"
}
EOT
}

resource "vault_generic_secret" "roboshop-dev-catalogue" {
  path = "${vault_mount.roboshop-dev.path}/catalogue"

  data_json = <<EOT
{
"MONGO":   "true",
"MONGO_URL": "mongodb://mongodb-dev.shpatil17.online:27017/catalogue"
}
EOT
}

resource "vault_generic_secret" "roboshop-dev-frontend" {
  path = "${vault_mount.roboshop-dev.path}/frontend"

  data_json = <<EOT
{
"catalogue":   "http://catalogue-dev.shpatil17.online:8080/",
"user":   "http://user-dev.shpatil17.online:8080/",
"cart":   "http://cart-dev.shpatil17.online:8080/",
"shipping":   "http://shipping-dev.shpatil17.online:8080/",
"payment":   "http://payment-dev.shpatil17.online:8080/"
}
EOT
}

resource "vault_generic_secret" "roboshop-dev-payment" {
  path = "${vault_mount.roboshop-dev.path}/payment"

  data_json = <<EOT
{
"CART_HOST" : "cart-dev.shpatil17.online",
"CART_PORT" : 8080,
"USER_HOST" : "user-dev.shpatil17.online",
"USER_PORT" : 8080,
"AMQP_HOST" : "rabbitmq-dev.shpatil17.online",
"AMQP_USER" : "roboshop",
"AMQP_PASS" : "roboshop123"
}
EOT
}

resource "vault_generic_secret" "roboshop-dev-shipping" {
  path = "${vault_mount.roboshop-dev.path}/shipping"

  data_json = <<EOT
{
"CART_ENDPOINT" : "cart-dev.shpatil17.online:8080",
"DB_HOST" : "mysql-dev.shpatil17.online"
}
EOT
}

resource "vault_generic_secret" "roboshop-dev-user" {
  path = "${vault_mount.roboshop-dev.path}/user"

  data_json = <<EOT
{
"MONGO" : "true",
"REDIS_URL" : "redis://redis-dev.shpatil17.online:6379",
"MONGO_URL" : "mongodb://mongodb-dev.shpatil17.online:27017/users"
}
EOT
}