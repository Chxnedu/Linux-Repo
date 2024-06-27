# minikube commands

* minikube start (to start the cluster)

* minikube status (check the status of running cluster)

# kubectl commands
- **`kubectl cluster-info`** (used to get info about a cluster)
  
- **`kubectl run --image=image pod-name`** (used to create a pod)
  
- **`kubectl get nodes/pods/services/deployments`** (checking the status of those items)
-     "-o wide" flag to get more options
      "--namespace=dev" or "-n dev" flag to set the namespace
      "--all-namespaces" or "-A" flags to check in all the namespaces
      "--selector app=App1" flag to set the selector for filtering objects

- **`kubectl create`** (same as apply)
-     "-f filename" to specify the file you want to create. can be a pod definition file or deployment file
      "deployment deploymentname --image=image" to create a deployment that will then create a pod
      "namespace my-namespace" to create your own namespace

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

- **`kubectl label nodes <node-name> <key>=<value>`** (this is used to label a node to be used by a node selector)
  
- 


# notes
### pod definition file template
```
apiVersion: v1
kind: Pod
metadata:
  name: nginx
  labels:
    app: App1
    function: Frontend
spec:
  containers:
  - name: nginx
    image: nginx:1.14.2
    ports:
    - containerPort: 80
    resources:
      requests:
        memory: "1Gi"
        cpu: 1
      limits:
        memory: "2Gi"
        cpu: 2
  nodeSelector:
    size: large
  affinity:
    nodeAffinity:
      requiredDuringSchedulingIgnoredDuringExecution:
        nodeSelectorTerms:
        - matchExpressions:
          - key: size
            operator: In
            values:
            - large
```

### deployment file template
```
apiVersion: apps/v1
kind: Deployment
metadata:
  name: nginx-deployment
  labels:
    app: App1
    function: Frontend
spec:
  replicas: 3
  selector:
    matchLabels:
      app: nginx
  template:
    metadata:
      labels:
        app: App1
        function: Frontend
    spec:
      containers:
      - name: nginx
        image: nginx:1.14.2
        ports:
        - containerPort: 80
```

### service template
```
apiVersion: v1
kind: Service
metadata:
  name: my-service
spec:
  selector:
    app.kubernetes.io/name: MyApp
  ports:
    - protocol: TCP
      port: 80
      targetPort: 9376
```
ClusterIP is the default service type if you don't specify otherwise

### tolerations
these are applied to pods and allow the scheduler to schedule pods with matching taints
```
tolerations:
- key: "key1"
  operator: "Equal"
  value: "value1"
  effect: "NoSchedule"
```
to remove a taint from a node, use the same command used to add it but add a "-" at the end

### node selectors and affinity
to make sure that a pod is only deployed on a particular node, you can use a node selector.
add the `nodeSelector` parameter to the spec section of the definition file followed by the key-value pair used to identify the node

**node affinity** is similar to selector, but with more functionality. look in the pod spec template to see how to use.
the `value` parameter can contain a list of values, and the `operator` parameter has specific operators you can use. refer to [documentation](https://kubernetes.io/docs/concepts/scheduling-eviction/assign-pod-node/#affinity-and-anti-affinity)

node affinity can be paired with taints & tolerations to ensure that pods are placed on nodes you want them to be placed on.


### resource requirements and limits
you can set the required resources a pod needs using the `resources` parameter under each container.
you can also set a limit so that they don't use up resources past that limit. refer to the pod spec template to see how to use.

a **LimitRange** object can be created to set the default and max resources a pod can use. refer to [documentation](https://kubernetes.io/docs/tasks/administer-cluster/manage-resources/memory-default-namespace/) to know how to use.

**Resource Quotas** can be used to set hard limits at the namespace level for resource requirements. refer to [documentation](https://kubernetes.io/docs/concepts/policy/resource-quotas/)


### daemonsets
daemonsets are used to run a single pod on every node in a cluster. when a node is added to the cluster, the daemonset automatically deploys that pod on it, and when a node is delete, the pod is deleted too. it can be used in several usecases like for monitoring, kubeproxy, or networking where you need a particular service on each node in the cluster.

daemonset definition files are very similar to replicaset files, with slight differences
```
apiVersion: apps/v1
kind: DaemonSet
metadata:
  name: monitoring-daemon
spec:
  selector:
    matchLabels:
      app: monitoring-agent
  template:
    metadata:
      labels:
        app: monitoring-agent
    spec:
      containers:
      - name: monitoring-agent
        image: monitoring-agent
```

### static pods
static pods are pods created and managed by the kubelet daemon on a specific node, without the kube api monitoring them.
to create a static pod, write the pod definition file and place it in the directory `/etc/kubernetes/manifests`. it is automatically picked up by the kubelet and created. to confirm the pod file location, look in the kubelet configuration file for the staticPodPath. and to delete the pod, just delete the file.


### multiple schedulers
you can create and use your own scheduler asides the default scheduler. refer to [documentation](https://kubernetes.io/docs/tasks/extend-kubernetes/configure-multiple-schedulers/) to see how to do that.

