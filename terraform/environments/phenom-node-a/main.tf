# # PHENOM II (A) - MEGAMAN2 # # 
# 1. AdGuard Instance 1 (Primary) - LXC
resource "proxmox_virtual_environment_container" "adguard_primary" {
  node_name = "MEGAMAN2"
  vm_id     = 101
  tags      = ["network", "dns"]

  initialization {
    hostname = "adguard-01"
    ip_config {
      ipv4 {
        address = "192.168.88.15/24"
        gateway = "192.168.88.1"
      }
    }
  }

  cpu { cores = 1 }
  memory { dedicated = 512 }

  operating_system {
    template_file_id = "local:vztmpl/debian-12-standard_12.0-1_amd64.tar.zst"
    type             = "debian"
  }
}

# 2. MQTT and Node-Red (Separate LXCs recommended)
resource "proxmox_virtual_environment_container" "mqtt_broker" {
  node_name = "MEGAMAN2"
  vm_id     = 102
  initialization {
    hostname = "mqtt-01"
    ip_config { ipv4 { address = "192.168.88.16/24", gateway = "192.168.88.1" } }
  }
  cpu { cores = 1 }
  memory { dedicated = 256 }
  operating_system { template_file_id = "local:vztmpl/debian-12-standard_12.0-1_amd64.tar.zst", type = "debian" }
}

# 3. Docker VM (For RomM, Audiobookshelf, Calibre-Web)
resource "proxmox_virtual_environment_vm" "docker_host" {
  name      = "docker-media-host"
  node_name = "MEGAMAN2"
  vm_id     = 200

  cpu {
    cores = 2
    type  = "host" # Crucial for Phenom II instruction pass-through
  }

  memory {
    dedicated = 4096
  }

  network_device {
    bridge = "vmbr0"
  }

  disk {
    datastore_id = "local-lvm"
    size         = 50
  }
}

# 4. Home Assistant (VM)
resource "proxmox_virtual_environment_vm" "home_assistant" {
  name      = "hass-io"
  node_name = "MEGAMAN2"
  vm_id     = 201

  cpu { cores = 2, type = "host" }
  memory { dedicated = 4096 }

  operating_system { type = "l26" } # Linux Kernel 2.6+
  
  network_device {
    bridge  = "vmbr0"
    vlan_id = var.networks["apps"].id  # Drops HA directly into the Apps VLAN
  }

  initialization {
    ip_config {
      ipv4 {
        address = "10.30.30.10/24"              # Matching  10.x.x.x layout
        gateway = var.networks["apps"].gateway  # Mikrotik IP for this VLAN
      }
    }
  }
}



resource "proxmox_virtual_environment_vm" "docker_host" {
  name      = "docker-media-host"
  node_name = "phenom-a"
  vm_id     = 200
  
  clone {
    vm_id = 9000 
  }

  initialization {
    # Debian 13 Trixie uses predictable interface names by default (e.g., ens18)
    ip_config {
      ipv4 {
        address = "192.168.88.10/24"
        gateway = "192.168.88.1"
      }
    }
    
    user_account {
      keys     = ["ssh-rsa AAAAB3N..."] # Replace with your key
      username = "chops"
    }
    
    # Ensure standard packages for Ansible are present in the Trixie image
    user_data_file_id = "local:snippets/debian-trixie-init.yaml"
  }

  cpu {
    cores = 2
    type  = "host" # Essential for Phenom II
    flags = ["+sse3"] # Manual flag poke for Trixie's higher baseline requirements
  }
}


