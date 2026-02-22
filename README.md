# 🚀 GitOps EKS Platform — Terraform + Helm + ArgoCD

A production-grade Kubernetes platform on AWS where a single `git push` 
automatically builds, packages, and deploys your application to EKS — 
fully automated from code to running container.

![CI/CD](https://github.com/idan5353/ArgoCDHelmProject/actions/workflows/ci-cd.yaml/badge.svg)

---

## 📐 Architecture
![diagram](https://github.com/user-attachments/assets/1a29c3c8-33df-4820-9a56-9ed788e18c8f)

Developer
↓ git push
GitHub Actions CI/CD
├── docker build + push → Amazon ECR (tagged with git SHA)
└── updates image tag in helm/my-app/values.yaml
↓
ArgoCD detects Git change
↓
helm upgrade on EKS
↓
New pods roll out automatically

text

---

## 🛠️ Tech Stack

| Layer              | Technology                    | Purpose                                      |
|--------------------|-------------------------------|----------------------------------------------|
| Infrastructure     | Terraform                     | VPC, EKS cluster, IAM, IRSA roles            |
| Container Registry | Amazon ECR                    | Docker image storage (tagged by git SHA)     |
| App Packaging      | Helm                          | Kubernetes manifest templating               |
| GitOps Engine      | ArgoCD                        | Auto-syncs cluster state from Git            |
| CI/CD Pipeline     | GitHub Actions                | Build, push, update tag, trigger sync        |
| Monitoring         | Prometheus + Grafana          | Cluster and app metrics + dashboards         |
| Load Balancing     | AWS Load Balancer Controller  | Provisions NLB for external traffic          |
| App Runtime        | Node.js (Express)             | Simple REST API with health endpoint         |

---![argocdpic](https://github.com/user-attachments/assets/3595ce6e-57e8-4289-b37a-658904150698)
![monitoring](https://github.com/user-attachments/assets/2ca520a3-090c-465b-b42d-0c031b7e1648)
![cicd](https://github.com/user-attachments/assets/9b04f7ff-de9b-40a5-b0a4-77f45e56ca57)


## ⚙️ How It Works

### 1. Infrastructure (One-Time Setup)
Terraform provisions the entire AWS infrastructure in two stages:

```bash
# Stage 1 — VPC + EKS cluster + IRSA
cd terraform/1-infra
terraform init && terraform apply

# Stage 2 — Helm releases (ArgoCD, Prometheus, AWS LBC)
cd terraform/2-helm
terraform init && terraform apply -var="cluster_name=eks-helm-demo-eks"
2. GitOps Flow (Every Deploy)
Every push to main that touches app/ or helm/ triggers:

text
Job 1: Build Docker image → push to ECR (tagged with git SHA)
Job 2: Update image tag in values.yaml → commit back to Git
Job 3: Annotate ArgoCD app → triggers immediate sync
3. Auto-Healing
ArgoCD's selfHeal: true means any manual kubectl change is
automatically reverted within 3 minutes to match Git state.

🚀 Quick Start
Prerequisites
AWS CLI configured (aws configure)

Terraform >= 1.5.0

kubectl

Helm >= 3.0

Docker

Deploy
bash
# 1. Clone the repo
git clone https://github.com/idan5353/ArgoCDHelmProject.git
cd ArgoCDHelmProject

# 2. Provision infrastructure
cd terraform/1-infra
terraform init
terraform apply -auto-approve

# 3. Update kubeconfig
aws eks update-kubeconfig --region us-east-1 --name eks-helm-demo-eks

# 4. Install Helm releases
cd ../2-helm
terraform init
terraform apply -var="cluster_name=eks-helm-demo-eks" -auto-approve

# 5. Apply ArgoCD manifests
kubectl apply -f argocd/project.yaml
kubectl apply -f argocd/app.yaml
Add GitHub Secrets
Go to Settings → Secrets → Actions and add:

Secret	Description
AWS_ACCESS_KEY_ID	AWS IAM access key
AWS_SECRET_ACCESS_KEY	AWS IAM secret key
ARGOCD_PASSWORD	ArgoCD admin password
📊 Monitoring
Access Grafana dashboards:

bash
kubectl port-forward svc/kube-prometheus-stack-grafana -n monitoring 3000:80
Open http://localhost:3000 — login with admin / admin123

Pre-loaded dashboards:

Kubernetes Cluster Overview — node CPU, memory, pod count

Node Exporter Full — per-node disk, network, CPU

Namespace Resources — per-namespace resource usage

🔑 Key DevOps Concepts
Infrastructure as Code — full AWS setup reproducible with terraform apply

GitOps — Git is the single source of truth for cluster state

Immutable Deployments — every deploy uses a unique git SHA image tag

Least Privilege — IRSA scopes IAM permissions to individual pods

Auto-Healing — ArgoCD reverts drift automatically

Horizontal Scaling — HPA scales pods on CPU metrics automatically

Separation of Concerns — infra, app, and GitOps config in clear layers

🧹 Teardown
bash
# Remove Helm releases first
cd terraform/2-helm
terraform destroy -auto-approve

# Then destroy infrastructure
cd ../1-infra
terraform destroy -auto-approve
👤 Author
Idan Uziel
DevOps Engineer
GitHub
