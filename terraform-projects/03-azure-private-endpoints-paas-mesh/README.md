# 🔒 Project 03: Enterprise Zero-Trust Azure PaaS Private Endpoint Mesh

> **Architect:** Yogesh Pujari (10+ Yrs Enterprise DevSecOps & Cloud Architect)  
> **Pattern:** Automated Private Endpoints & Private DNS Zone Groups via `for_each` over `map(object)`

---

## 🎯 Architecture Overview
This module enforces absolute Zero-Trust network containment by terminating all public internet access to Azure PaaS services (Key Vaults, Storage Accounts, Databases). It automates the provisioning of Azure Private Endpoints into dedicated spoke subnets with auto-registration into central Hub Private DNS Zones.

### Core Features:
* **Zero Public IP Exposure:** Guarantees all PaaS resources communicate solely over RFC 1918 private IP addresses.
* **Dynamic DNS Zone Group Binding:** Automatically registers private A-records into centralized private DNS zones linked to Hub VNets.
* **Extensible Multi-PaaS Support:** Easily handles Key Vault (`vault`), Storage (`blob`, `dfs`, `file`), Azure SQL (`sqlServer`), and CosmosDB through uniform object definitions.

---

## 🚀 Quick Start

```bash
terraform init
terraform plan -var-file="terraform.tfvars.example"
terraform apply -var-file="terraform.tfvars.example" -auto-approve
```
