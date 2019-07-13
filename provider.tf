provider "google" {
  project = var.project
  region  = var.region
}

provider "aws" {
  access_key = "${var.access_key}"
  secret_key = "${var.secret_key}"
  region     = "${var.region_aws}"
}

#===============================================
# Bucket for .tfstate files - remote save
#===============================================
terraform {
  backend "gcs" {
    bucket = "indigo-medium-242214-tf-state-prod"
    prefix = "test/zabbix-app"
  }
}
