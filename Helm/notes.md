# Introduction

Helm is a package manager for kubernetes. It enables you to package your kubernetes applications into charts and manage them using simple commands.

# Installation 

To install helm on your machine, follow these steps;
```bash
curl -fsSL -o get_helm.sh https://raw.githubusercontent.com/helm/helm/main/scripts/get-helm-3
chmod 700 get_helm.sh
./get_helm.sh
helm -h
```

# Helm CLI Commands

- **`helm install <release-name> <chart>`** (to install a helm chart to your k8s cluster)
  ```
  -f myvalues.yaml (to use your own values file)
  --debug --dry-run <chart-name> (to debug a chart)
  ```

- **`helm get <chart>`** (to download the chart locally)
  
- **`helm list -a`** (to list the charts running in your cluster)

- **`helm uninstall <release-name>`** (to uninstall a chart)

- **`helm create <chart-name>`** (to create a helm chart)

- **`helm upgrade <release-name> <chart-name>`** (to upgrade a helm chart after making changes)

- **`helm rollback <release-name> <revision-number>`** (to rollback to a particular revision)

- **`helm template <chart-name>`** (to validate your yaml file/template locally)

- **`helm lint <chart-name>`** (to find errors or misconfiguration)

- **`helm repo list`** (to find repos installed on your machine)

- **`helm repo add <repo-name> <repo-url>`** (to add a remote repo like bitnami to your local repository)

# Creating Helm Charts

the first step in creating a helm chart is to run
```bash
helm create <chart-name>
```
this will create a chat directory for you

after the chart is created, edit the `Chart.yaml` file and use a version number you want

also go into the /template directory and make the necessary changes


# Helmfile

helmfile adds additional functionality to Helm by wrapping it in a declarative spec that allows you to compose several charts together to create a comprehensive deployment artifact for anything from a single application to your entire infrastructure stack.

## installing helmfile

run the following commands to install helmfile

```bash
curl -LO https://github.com/helmfile/helmfile/releases/download/v0.171.0/helmfile_0.171.0_linux_amd64.tar.gz
tar -xvf helmfile_0.171.0_linux_amd64.tar.gz
sudo mv helmfile /usr/local/bin
helmfile -h
```

## creating a simple helmfile

we will create a helmfile for a simple `helloworld` helm chart. first, create the helm chart using 
```bash
helm create helloworld
```

create a helmfile and paste the following contents
```bash
touch helmfile.yaml
cat <<EOT >> helmfile.yaml
---
releases:

  - name: helloworld-release
    chart: ./helloworld
    installed: true

EOT
```
install the helm chart with helmfile using 
```bash
helmfile sync
helm list
```
to uninstall the helm chart, change the `installed: true` to false in the helmfile and sync it.

## helm-git

look into the helm git repo [here](https://github.com/aslafy-z/helm-git).
it is used by helmfile to install a helm chart directly from github.

helmfile can also install multiple helm charts. just add another entry for a helm chart.

# helm repo

helm repo is a repository where we have a pre-built chart that is readily available. 
```bash
helm search hub <chart-name> # to search for a chart
helm search hub <chart-name> --max-col-width=0 # to output the full url of the chart
```

# helm hooks

hooks allow developers to intervene at certain points in a release's lifecycle. for example you can use hooks to; 
- Load a ConfigMap or Secret during install before any other charts are loaded.
- Execute a Job to back up a database before installing a new chart, and then execute a second job after the upgrade in order to restore data.
- Run a Job before deleting a release to gracefully take a service out of rotation before removing it.

there are different types of hooks; pre-install, post-install, etc. read the [Documentation](https://helm.sh/docs/topics/charts_hooks/) to find out more.

# helm tests

Read about helm tests [Here](https://helm.sh/docs/topics/chart_tests/)

