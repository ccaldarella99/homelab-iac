# Setting up your Raspi

IP: `192.168.88.99`

## Services
- Homarr
- Homepage
- Uptime-Kuma
- Beszel


## Ansible

### Install Home Assistant

*Install on the Dell Optiplex AKA C3PO*

Get the password for the user, setup the MAC Address in `deploy.ha` and run:

```
export PROXMOX_PW="your_password"
ansible-playbook -i ../inventory/hosts.ini deploy_ha.yml -K
```
