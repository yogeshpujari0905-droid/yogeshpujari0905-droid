# 🌐 Project 01: Enterprise Azure CAF Hub-and-Spoke Network Architecture

> **Architect:** Yogesh Pujari (10+ Yrs Enterprise DevSecOps & Cloud Architect)  
> **Pattern:** Data-Driven Terraform with `for_each` over `map(object)` and Dynamic Blocks

---

## 🎯 Architecture Overview
This module automates the foundational networking topology recommended by the **Microsoft Cloud Adoption Framework (CAF)**. It utilizes zero hardcoded subnets or routes, allowing full enterprise topologies to be defined purely as structured metadata.

### Core Features:
* **Dynamic Multi-VNet Deployment:** `for_each` iterates over high-level VNets (Hub, Application Spokes, Shared Spokes).
* **Flattened Subnet Resolution:** Local map transforms nested VNet-to-Subnet hierarchies into flat deterministic keys (`${vnet_key}.${subnet_key}`) with dynamic service delegations.
* **Zero-Trust Egress Routing (UDR):** Route tables redirecting `0.0.0.0/0` outbound traffic through Azure Firewall Premium.
* **Automated Bi-Directional Peerings:** Evaluates non-hub keys dynamically and creates mutual peering links without manual intervention.

---

## 🚀 Quick Start

```bash
# 1. Initialize Terraform
terraform init

# 2. Review Execution Plan
terraform plan -var-file="terraform.tfvars.example"

# 3. Apply Infrastructure
terraform apply -var-file="terraform.tfvars.example" -auto-approve
```
