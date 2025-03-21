# Introduction

Helm is a package manager for kubernetes. It enables you to package your kubernetes applications into charts and manage them using simple commands.

## Installation 

To install helm on your machine, follow these steps;
```bash
curl -fsSL -o get_helm.sh https://raw.githubusercontent.com/helm/helm/main/scripts/get-helm-3
chmod 700 get_helm.sh
./get_helm.sh
helm -h
```

## Helm CLI Commands

- **`helm install <release-name> <chart>`** (to install a helm chart to your k8s cluster)

