# 💰 Project 05: Enterprise FinOps & High-Availability VM Scale Sets (VMSS)

> **Architect:** Yogesh Pujari (10+ Yrs Enterprise DevSecOps & Cloud Architect)  
> **Pattern:** Multi-AZ VMSS with Dynamic Metric Autoscale via `for_each` over `map(object)`

---

## 🎯 Architecture Overview
This module automates the provisioning of high-availability, zone-redundant Linux Virtual Machine Scale Sets (VMSS) coupled with aggressive FinOps automated autoscale triggers.

### Core Features:
* **Multi-Zone Redundancy:** Distributes VM instances across Availability Zones (`1`, `2`, `3`) to ensure high availability and SLA compliance.
* **FinOps Elasticity:** Configures metric triggers (`Percentage CPU`) that scale out during high peak demand and automatically scale in when CPU falls below threshold.
* **Automated OS Upgrades:** Configured with `Automatic` rolling upgrade modes and health probes for zero-downtime OS security patching.

---

## 🚀 Quick Start

```bash
terraform init
terraform plan -var-file="terraform.tfvars.example"
terraform apply -var-file="terraform.tfvars.example" -auto-approve
```
