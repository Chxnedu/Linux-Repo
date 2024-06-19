# minikube commands

* minikube start (to start the cluster)

* minikube status (check the status of running cluster)

# kubectl commands
- **`kubectl cluster-info`** (used to get info about a cluster)
  
- **`kubectl run --image=image pod-name`** (used to create a pod)
  
- **`kubectl get nodes/pods/services/deployments`** (checking the status of those items)
-     "-o wide" flag to get more options
      "--namespace=dev" flag to set the namespace

- **`kubectl create`** (same as apply)
-     "-f filename" to specify the file you want to create... can be a pod definition file or deployment file
      deployment deploymentname --image=image (to create a deployment that will then create a pod)
      namespace my-namespace (to create your own namespace)

 *if you want to automatically create a yaml file using k8s, there are a few commands you could try;*
- **`kubectl create deployment --image=nginx nginx --dry-run=client -o yaml > nginx-deployment.yaml`**
-     the --dry-run flag is used to tell k8s not to run the deployment
      you can also add the --replicas=2 flag

- **`kubectl apply -f filename.yaml`** (create a deployment from a config file)
-     --namespace=my-namespace (using this flag creates a resource in a namespace)
      you can also add "namespace: my-namespace" in the config file under metadata

- **`kubectl describe pod podname`** (to show whats happening inside the pod)

- **`kubectl edit deployment deploymentname`** (you can use this to edit a deployment and do stuff like change the image)

- **`kubectl logs podname`** (for checking the logs of a pod)

- **`kubectl exec -it podname --bin/bash or sh`** (opening a terminal inside a pod)

- **`kubectl delete deployment deploymentname`** (delete a deployment which in turn deletes the pods and replicas)

- **`kubectl delete -f filename.yaml`** (to delete a deployment/service using the config file)

- **`kubectl get configmap -n my-namespace`** (to get a configmap in a particular namespace. can also be used for other resources)

- **`kubectl rollout status deployment/your-deployment-name`** (to check the status of your rollouts)

- **`kubectl rollout history deployment/your-deployment-name`** (to see your rollout history)

- **`kubectl rollout undo deployment/your-deployment-name`** (to rollback an update)

- **`kubectl config set-context $(kubectl config current-context) --namespace=dev`** (this command is used to change the default namespace)

- **`kubectl taint nodes node-name key=value:taint-effect`** (this is used to apply a taint to a node to prevent pods from being placed on it)
-     there are 3 taint effects; NoSchedule, PreferNoSchedule, NoExecute
      eg; `kubectl taint nodes node01 app=blue:NoSchedule` (this will taint the node with the key value pair "app=blue" and prevent any pod from being scheduled on it)
      tolerations for pods are added on the pod definition file (refer to documentation)
