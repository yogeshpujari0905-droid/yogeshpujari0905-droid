# 📦 Project 04: Enterprise Azure Kubernetes Service (AKS) Landing Zone

> **Architect:** Yogesh Pujari (10+ Yrs Enterprise DevSecOps & Cloud Architect)  
> **Pattern:** Multi-Pool AKS Architecture with `for_each` over `map(object)` Node Pools

---

## 🎯 Architecture Overview
This module automates an enterprise-ready, hardened **Azure Kubernetes Service (AKS)** deployment complying with Microsoft Well-Architected and CIS Kubernetes benchmarks.

### Core Features:
* **System/User Node Isolation:** Isolates critical Kubernetes system components on dedicated taint-protected system pools while application and AI workloads run on dynamically scaled user node pools.
* **FinOps Spot Integration:** Supports high-density, cost-optimized GPU and batch compute pools using Azure Spot instances with automatic eviction handling.
* **Modern CNI Overlay:** Deploys Azure CNI Overlay networking to overcome legacy private subnet IP exhaustion challenges.
* **Zero-Trust Identity:** Native Azure Entra ID RBAC, OIDC Issuer, and Key Vault Secrets Provider CSI driver with automated secret rotation.

---

## 🚀 Quick Start

```bash
terraform init
terraform plan -var-file="terraform.tfvars.example"
terraform apply -var-file="terraform.tfvars.example" -auto-approve
```
