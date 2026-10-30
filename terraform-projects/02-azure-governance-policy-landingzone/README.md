# 🏛️ Project 02: Enterprise Azure CAF Governance & Policy as Code

> **Architect:** Yogesh Pujari (10+ Yrs Enterprise DevSecOps & Cloud Architect)  
> **Pattern:** Hierarchical Management Group Tree & Policy Initiatives via `for_each` over `map(object)`

---

## 🎯 Architecture Overview
This module provisions the foundational management hierarchy mandated by the **Microsoft Cloud Adoption Framework (CAF)**. It isolates enterprise platform services from application workload landing zones while assigning organization-wide compliance benchmarks (e.g., **CIS Azure Benchmark**) as code.

### Core Features:
* **Nested Management Group Hierarchy:** Creates platform tiers (`Identity`, `Management`, `Connectivity`) and workload tiers (`Corp`, `Online`, `Sandbox`) using declarative maps.
* **Automated Initiative Enforcement:** Deploys CIS and MCSB policy sets with system-assigned identities for automated remediation.
* **Blast Radius Isolation:** Decouples permissions and subscription boundaries to prevent noisy neighbor and privilege escalation incidents.

---

## 🚀 Quick Start

```bash
terraform init
terraform plan -var-file="terraform.tfvars.example"
terraform apply -var-file="terraform.tfvars.example" -auto-approve
```
