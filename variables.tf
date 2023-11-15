variable "cloud_id_var" {
  type    = string
  default = "take_cloud_id"
}

variable "folder_id_var" {
  type    = string
  default = "take_folder_id"
}

variable "service_account_key_file_var" {
  type    = string
  default = "/home/key/authorized_key.json"
}

variable "private_key_file_path" {
  type    = string
  default = "~/.ssh/id_rsa"
} 

variable "my_public_key" {
  type    = string
  default = "take_pub_key"
}
