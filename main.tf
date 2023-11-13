terraform {
  required_providers {
    yandex = {
        source = "yandex-cloud/yandex"
    }
  }
  required_version = ">= 0.13"
}

locals {
  folder_id = "b1g3p7mlsl60dog8mj4t"
  cloud_id = "b1gppsosmkmr6sm6ream"
}

provider "yandex" {
  cloud_id = local.cloud_id
  folder_id = local.folder_id
  service_account_key_file = "/home/key/authorized_key.json"

  
}