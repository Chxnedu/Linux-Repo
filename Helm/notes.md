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
  ```
  -f myvalues.yaml (to use your own values file)
  --debug --dry-run <chart-name> (to debug a chart)
  ```
  
- **`helm list -a`** (to list the charts running in your cluster)

- **`helm uninstall <release-name>`** (to uninstall a chart)

- **`helm create <chart-name>`** (to create a helm chart)

- **`helm upgrade <release-name> <chart-name>`** (to upgrade a helm chart after making changes)

- **`helm rollback <release-name> <revision-number>`** (to rollback to a particular revision)

- **`helm template <chart-name>`** (to validate your yaml file/template locally)

- **`helm lint <chart-name>`** (to find errors or misconfiguration)

- 

## Creating Helm Charts

the first step in creating a helm chart is to run
```bash
helm create <chart-name>
```
this will create a chat directory for you


