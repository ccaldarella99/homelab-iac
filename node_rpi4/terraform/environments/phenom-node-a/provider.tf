terraform {
  required_providers {
    proxmox = {
      source  = "bpg/proxmox"
      version = "0.66.1" # Using latest stable as of 2026
    }
  }
}

provider "proxmox" {
  endpoint = "https://192.168.88.201:8006/"
  api_token = "root@pam!token_name=your_token_secret" 
  insecure = true # Set to false if you have valid SSL
}
