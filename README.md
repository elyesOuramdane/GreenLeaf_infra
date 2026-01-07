# GreenLeaf Infrastructure 🌿

Ce dépôt contient le code d'infrastructure (IaC) et de configuration pour le déploiement de la plateforme e-commerce **GreenLeaf** sur Amazon Web Services (AWS).

## 🎯 Objectif
Déployer une architecture scalable, sécurisée et hautement disponible pour héberger **Magento Open Source**. L'infrastructure est conçue pour supporter la croissance du trafic tout en optimisant les coûts.

## 🏗 Architecture
L'infrastructure est déployée sur **2 Zones de Disponibilité (Multi-AZ)** pour assurer la résilience.

### Composants Principaux
*   **Réseau (VPC)** : Cloisonnement strict avec sous-réseaux publics (Load Balancers) et privés (Applications & Données).
*   **Calcul (Compute)** : Groupe de serveurs web (Auto Scaling Group) derrière un Application Load Balancer (ALB).
*   **Base de Données** : Cluster MySQL managé (RDS) en configuration Multi-AZ.
*   **Stockage & Cache** : S3 pour les médias, CloudFront (CDN) pour la distribution globale, et OpenSearch pour le moteur de recherche.

## 🛠 Stack Technique
*   **Provisioning** : [Terraform](https://www.terraform.io/)
*   **Configuration** : [Ansible](https://www.ansible.com/)
*   **Cloud Provider** : AWS

## 🚀 Guide de Démarrage

### Pré-requis
*   AWS CLI configuré avec les accès appropriés.
*   Terraform (v1.0+)
*   Ansible

### Déploiement de l'Infrastructure
1.  **Initialiser Terraform :**
    ```bash
    cd terraform
    terraform init
    ```
2.  **Visualiser les changements :**
    ```bash
    terraform plan
    ```
3.  **Appliquer l'infrastructure :**
    ```bash
    terraform apply
    ```

### Configuration des Serveurs
Une fois l'infrastructure en place, Ansible est utilisé pour configurer les serveurs (Nginx, PHP, Magento) :
```bash
cd ansible
ansible-playbook -i inventory/aws_ec2.yml site.yml
```

## 📁 Structure du Projet
*   `/terraform` : Code Infrastructure as Code.
*   `/ansible` : Playbooks de configuration des serveurs.
*   `/docs` : Documentation technique et FinOps.

---
## 👥 Équipe Projet

*   **Inès Dhouibi**
*   **Robin Le Brozec**
*   **Achraf Chardoudi**
*   **Elyes Ouramdane**
*   **Kaoutar Jabri**
