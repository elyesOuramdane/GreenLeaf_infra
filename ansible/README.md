# Magento 2.4.7 Infrastructure Automation with Ansible

This directory contains the Ansible playbooks and configuration to automate the installation of Magento 2.4.7 on AWS EC2 instances.

## Architecture & Connection Method

Due to issues with the native `aws_ssm` connection plugin, we use **SSH over SSM** with a ProxyCommand. This allows Ansible to securely connect to private EC2 instances without a Bastion host or public SSH access.

### Key Components
1.  **SSH Key**: A local key `~/.ssh/ansible_key` is generated and its public part is injected into instances via Terraform `user_data`.
2.  **SSM Session Manager**: Used as a transport layer for the SSH connection.
3.  **Dynamic Inventory**: The `aws_ec2.yml` plugin fetches instance details, using the `instance-id` as the primary hostname.

## Prerequisites

Ensure your environment (e.g., Dev Container) has the following installed:
-   **Ansible** (>= 2.15)
-   **AWS CLI**
-   **AWS Session Manager Plugin**
-   **Python libraries**: `boto3`, `botocore`

## Setup & Configuration

### 1. SSH Key Generation
If not already present, generate the key:
```bash
ssh-keygen -t ed25519 -f ~/.ssh/ansible_key -N ""
```

### 2. Variables
Update `ansible/inventory/group_vars/all.yml` with your infrastructure endpoints (RDS, Redis, OpenSearch) and Magento credentials.

### 3. Connection Settings
Connection settings are defined in `ansible/inventory/group_vars/env_dev.yml`:
```yaml
ansible_connection: ssh
ansible_user: ec2-user
ansible_ssh_private_key_file: /root/.ssh/ansible_key
ansible_ssh_common_args: '-o ProxyCommand="aws ssm start-session --target %h --document-name AWS-StartSSHSession --parameters portNumber=%p --region eu-west-1" -o StrictHostKeyChecking=no -o UserKnownHostsFile=/dev/null'
```

## Running the Playbook

To install Magento on the dev environment:

```bash
cd ansible
ansible-playbook playbooks/install_magento.yml
```

## Troubleshooting & Important Fixes

-   **Disk Space**: Magento requires ~10GB. Instances must have at least 20GB EBS volumes (configured in Terraform).
-   **PHP Version**: Amazon Linux 2023 ships with PHP 8.4. Magento 2.4.7 officially supports up to 8.3. We use the `--ignore-platform-req=php` flag in Composer.
-   **Privilege Escalation**: We use `su -s /bin/bash apache -c` instead of `become_user: apache` to avoid common Ansible/SSM filesystem ACL issues.
-   **Database Privileges**: Ensure the RDS user has full privileges (CREATE, DROP, REFERENCES, etc.).
