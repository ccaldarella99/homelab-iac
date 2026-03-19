# Home-Lab: Infrastructure as Code

## Directory Guide
```
homelab-iac/
├── ansible/
│   ├── inventory/					# IPs for Phenom-A, Pi, and New VMs
│   ├── group_vars/					# Credentials & Trixie-specific tweaks
│   ├── playbooks/
│   │   ├── prepare_node.yml		# Run this BEFORE Terraform
│   │   └── setup_apps.yml			# Run this AFTER Terraform
│   └── roles/						# Modular app configs (AdGuard, HA, etc.)
├── terraform/
│   ├── modules/					# Reusable blocks (VM, LXC, Network)
│   ├── environments/
│   │   └── phenom-node-a/			# Specific config for your Phenom II
│   │       ├── main.tf				# Resource definitions
│   │       ├── provider.tf			# Proxmox API connection
│   │       ├── variables.tf		# Node-specific IPs/IDs
│   │       └── terraform.tfvars 	# Secrets (DON'T COMMIT TO GITHUB)
│   └── scripts/					# Helper scripts for TF
├── .gitignore						# IMPORTANT: Ignore .tfstate and secrets
└── README.md						# Your "Runbook"
```

## Starting from pi
```
cd /mnt/usb-data/services
git clone https://github.com/ccaldarella99/homelab-iac.git
cd homelab-iac
ansible-playbook -i inventory/hosts.ini playbooks/prepare_node.yml --ask-pass
```