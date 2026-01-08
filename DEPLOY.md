# Magento AWS Deployment Guide

This guide outlines the steps to deploy Magento 2.4.7-p3 on AWS from scratch using Terraform and Ansible.

## 🚀 Quick Start (Automated Workflow)

### 1. Pre-deployment Setup
Ensure your AWS CLI is configured and you have the required SSH key:
```bash
aws configure  # Configure your access keys and region (eu-west-1)
# Ensure your private key is at /root/.ssh/ansible_key
```

### 2. Infrastructure (Terraform)
Launch the AWS infrastructure. This step will also **automatically generate** the Ansible variables.
```bash
cd terraform/envs/dev
terraform init
terraform apply -auto-approve
```

### 3. Application (Ansible)
Provision the servers and install Magento. The inventory is dynamic, and variables are pre-filled by Terraform.
```bash
cd ../../../ansible
# Verify connectivity
ansible all -m ping
# Run the installation
ansible-playbook -i inventory/aws_ec2.yml playbooks/install_magento.yml
```

---

## 🛠️ What's Automated?

We have significantly simplified the process by automating several manual tasks:

| Feature | Description |
| :--- | :--- |
| **Variable Sync** | Terraform automatically writes `magento_db_host`, `magento_redis_host`, and `magento_opensearch_host` to `ansible/inventory/group_vars/all.yml`. |
| **MySQL Setup** | The Ansible playbook now automatically grants the required privileges to the database user on RDS. |
| **PHP 8.2 Patching** | A core patch is applied automatically to fix Magento's incompatibility with PHP 8.2 deprecation notices. |
| **System Tuning** | PHP `memory_limit`, Apache Vhosts, and system packages are configured without manual intervention. |
| **Swap Config**   | A 4GB swap file is automatically provisioned for deployment stability. |

---

## 🔗 Access Details
Once deployed, the site is accessible via the Load Balancer DNS name:
*   **Frontend**: `http://<alb-dns-name>/`
*   **Admin Mode**: The deployment uses **Production Mode** for maximum stability and speed.

## ⚠️ Maintenance & Troubleshooting
*   **Logs**: Check `/var/www/html/magento/var/log/` on any instance for application logs.
*   **Re-deploy**: If you change Terraform variables (like RDS password), re-run `terraform apply` and then `ansible-playbook` to sync changes.
