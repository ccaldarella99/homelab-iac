variable "vlan_ids" {
  type = map(number)
  default = {
    infra      = 10
    media      = 20
    apps       = 30
    storage    = 40
    iot        = 50
    automation = 60
  }
}

variable "networks" {
  type = map(object({
    id      = number
    subnet  = string
    gateway = string
  }))
  default = {
    infra      = { id = 10, subnet = "10.10.10.0/24", gateway = "10.10.10.1" }
    media      = { id = 20, subnet = "10.20.20.0/24", gateway = "10.20.20.1" }
    apps       = { id = 30, subnet = "10.30.30.0/24", gateway = "10.30.30.1" }
    data       = { id = 40, subnet = "10.40.40.0/24", gateway = "10.40.40.1" }
    automation = { id = 60, subnet = "10.60.60.0/24", gateway = "10.60.60.1" }
  }
}

