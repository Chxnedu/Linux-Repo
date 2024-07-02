# minikube commands

* minikube start (to start the cluster)

* minikube status (check the status of running cluster)

# kubectl commands
- **`kubectl cluster-info`** (used to get info about a cluster)
  
- **`kubectl run --image=<image-name> <pod-name>`** (used to create a pod)
  
- **`kubectl get nodes/pods/services/deployments/configmaps`** (checking the status of those items)
-     "-o wide" flag to get more options
      "--namespace=dev" or "-n dev" flag to set the namespace
      "--all-namespaces" or "-A" flags to check in all the namespaces
      "--selector app=App1" flag to set the selector for filtering objects
      "-o yaml > file.yaml" flag to get the yaml file for an object which can be used to make updates

- **`kubectl create`** (same as apply)
-     "-f filename" to specify the file you want to create. can be a pod definition file or deployment file
      "deployment <deployment-name> --image=<image-name>" to create a deployment that will then create a pod
      "namespace my-namespace" to create your own namespace

 *if you want to automatically create a yaml file using k8s, there are a few commands you could try;*
- **`kubectl create deployment --image=nginx nginx --dry-run=client -o yaml > nginx-deployment.yaml`**
-     the --dry-run flag is used to tell k8s not to run the deployment
      you can also add the --replicas=2 flag

- **`kubectl apply -f filename.yaml`** (create a deployment from a config file)
-     --namespace=my-namespace (using this flag creates a resource in a namespace)
      you can also add "namespace: my-namespace" in the config file under metadata

- **`kubectl describe pod <pod-name>`** (to show whats happening inside the pod)

- **`kubectl edit`** (to edit an object)
-     deployment <deployment-name>
      KUBE_EDITOR="nano" kubectl edit (use this to change the editor to nano or anyone you want)

- **`kubectl logs <pod-name>`** (for checking the logs of a pod)
-     -c <container-name> (checking for container logs)

- **`kubectl exec -it <pod-name> --bin/bash or sh`** (opening a terminal inside a pod)

- **`kubectl delete deployment <deployment-name>`** (delete a deployment which in turn deletes the pods and replicas)

- **`kubectl delete -f filename.yaml`** (to delete a deployment/service using the config file)

- **`kubectl get configmap -n my-namespace`** (to get a configmap in a particular namespace. can also be used for other resources)

- **`kubectl rollout status deployment/<deployment-name>`** (to check the status of your rollouts)

- **`kubectl rollout history deployment/<deployment-name>`** (to see your rollout history)

- **`kubectl rollout undo deployment/<deployment-name>`** (to rollback an update)

- **`kubectl config set-context $(kubectl config current-context) --namespace=dev`** (this command is used to change the default namespace)

- **`kubectl taint nodes <node-name> key=value:taint-effect`** (this is used to apply a taint to a node to prevent pods from being placed on it)
-     there are 3 taint effects; NoSchedule, PreferNoSchedule, NoExecute
      eg; `kubectl taint nodes node01 app=blue:NoSchedule` (this will taint the node with the key-value pair "app=blue" and prevent any pod from being scheduled on it)
      tolerations for pods are added on the pod definition file (refer to documentation)

- **`kubectl label nodes <node-name> <key>=<value>`** (this is used to label a node to be used by a node selector)
  
- **`kubernetes logs -f <pod-name> <container-name>`** (used to view the application logs of a particular pod)
-     if there is only one container inside the pod, you don't need to specify the container name
      the "-f" flag is used to get the logs live-streamed to the output

- **`kubectl rollout status deployment/<deployment-name>`** (to see the status of your rollout)
- **`kubectl rollout history deployment/<deployment-name>`** (to see the rollout history of your deployment)
- **`kubectl rollout undo deployment/<deployment-name>`** (to return a deployment to the previous rollout revision)

- **`kubectl set image deployment/<deployment-name> <container>=<image>`** (to set a new image for a deployment)

- **`kubectl create configmap`** (used to create a configmap for a pod)
  ```
  kubectl create configmap \
      <config-name> --from-literal=<key>=<value> \
                    --from-literal=<key>=<value>
  ```

- **`kubectl create secret generic`** (used to create a secret)
  ```
  kubectl create secret generic \
     <secret-name> --from-literal=<key>=<value>
  ```

# notes
## pod definition file template
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
    env:
      - name: APP_COLOR
        value: pink
    envFrom:
      - configMapRef:
            name: app-config
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

## deployment file template
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

## service template
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

## tolerations
these are applied to pods and allow the scheduler to schedule pods with matching taints
```
tolerations:
- key: "key1"
  operator: "Equal"
  value: "value1"
  effect: "NoSchedule"
```
to remove a taint from a node, use the same command used to add it but add a "-" at the end

## node selectors and affinity
to make sure that a pod is only deployed on a particular node, you can use a node selector.
add the `nodeSelector` parameter to the spec section of the definition file followed by the key-value pair used to identify the node

**node affinity** is similar to selector, but with more functionality. look in the pod spec template to see how to use.
the `value` parameter can contain a list of values, and the `operator` parameter has specific operators you can use. refer to [documentation](https://kubernetes.io/docs/concepts/scheduling-eviction/assign-pod-node/#affinity-and-anti-affinity)

node affinity can be paired with taints & tolerations to ensure that pods are placed on nodes you want them to be placed on.


## resource requirements and limits
you can set the required resources a pod needs using the `resources` parameter under each container.
you can also set a limit so that they don't use up resources past that limit. refer to the pod spec template to see how to use.

a **LimitRange** object can be created to set the default and max resources a pod can use. refer to [documentation](https://kubernetes.io/docs/tasks/administer-cluster/manage-resources/memory-default-namespace/) to know how to use.

**Resource Quotas** can be used to set hard limits at the namespace level for resource requirements. refer to [documentation](https://kubernetes.io/docs/concepts/policy/resource-quotas/)


## daemonsets
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

## static pods
static pods are pods created and managed by the kubelet daemon on a specific node, without the kube api monitoring them.
to create a static pod, write the pod definition file and place it in the directory `/etc/kubernetes/manifests`. it is automatically picked up by the kubelet and created. to confirm the pod file location, look in the kubelet configuration file for the staticPodPath. and to delete the pod, just delete the file.


## multiple schedulers
you can create and use your own scheduler asides the default scheduler. refer to [documentation](https://kubernetes.io/docs/tasks/extend-kubernetes/configure-multiple-schedulers/) to see how to do that.


## monitoring and logging
you can monitor cluster components using the kubernetes metrics server. to enable it, clone the [github](https://github.com/kubernetes-sigs/metrics-server) repo and run `kubectl create -f .` from inside the cloned repo

give it a few minutes to collect the data it needs, then you can use the commands `kubectl top node` & `kubectl top pod` to check cpu and memory utilization of the pods and nodes.

to view application logs from a pod in kubernetes, use the `kubernetes logs` command


## rolling updates and rollbacks
there are 2 ways of carrying out updates in kubernetes; 
- recreate: all the instances of the application are taken down and the updated version is deployed
- rolling update: the instances are terminated one by one and replaced as they are terminated to avoid extended periods of downtime
in kubernetes, rolling updates is the default deployment strategy. to trigger the update, simply replace the docker image in the deployment file with the new one and do a `kubectl apply`


## commands and arguments
in a dockerfile, you can set the `ENTRYPOINT` and `CMD` commands to specify certain commands that should execute at runtime. with kubernetes, the equivalent for these commands are `command` and `args` under the container section of a definition file.

for example, a container using the ubuntu image will start and stop immediately. but if you specify that it should sleep for 10s, it will start, sleep for 10s and stop. to do that in docker, you include the commands in the docker file with `ENTRYPOINT ["sleep"]` and `CMD ["5"]`. this will ensure that when starting the container, you provide the length of sleep you want and it will be appended to the sleep command, if not, the CMD will take precedence.

in kubernetes, `command` serves the purpose of entrypoint and `args` serves the purpose of cmd. \
for more, check out the [documentation](https://kubernetes.io/docs/tasks/inject-data-application/define-command-argument-container/)


## env variables, configmaps, and secrets
the basic way to set an environment variable in k8s is to use the `env` property in the pod definition. there are other better ways to do it.

configmaps are used to pass configuration data in the form of key-value pairs in k8s. below is an example configmap definition file
```
apiVersion: v1
kind: ConfigMap
metadata:
  name: app-config
data:
    APP_COLOR: blue
    APP_ENV: dev
```
to inject the newly created configmap into a pod, add an `envFrom` property to the container \
if you want to only inject one key from the configmap, use the configuration below
```
env:
  - name: APP_COLOR
    valueFrom:
      configMapKeyRef:
        name: app-config
        key: APP_COLOR
```
for more info, check out the [documentation](https://kubernetes.io/docs/tasks/configure-pod-container/configure-pod-configmap/#configure-all-key-value-pairs-in-a-configmap-as-container-environment-variables)

secrets are similar to configmaps, but as the name implies they are used to store sensitive variables
```
apiVersion: v1
kind: Secret
metadata:
  name: app-secret
data:
  DB_Host: mysql
  DB_User: root
  DB_Password: passwd
```
the values should be encoded in base64. you can do that using `echo -n 'mysql' | base64` \
to inject the secret into the pod, use a `envFrom` property like in configmap, but with `secretRef` instead \
to inject only one key from the secret, use the config below
```
env:
  - name: DB_Password
    valueFrom:
      secretKeyRef:
        name: app-secret
        key: DB_Password
```
to encrypt secret data at rest, take a look at the [documentation](https://kubernetes.io/docs/tasks/administer-cluster/encrypt-data/)


## init containers
init containers are specialized containers that run before app containers in a Pod. Init containers can contain utilities or setup scripts not present in an app image.
to know more about them, check out the [documentation](https://kubernetes.io/docs/concepts/workloads/pods/init-containers/)


## probes - liveness, readiness and startup
liveness probes are used to know when to restart a container,  readiness probes are used to know when a container is ready to start accepting traffic, and startup probes are used to know when a container has started. \ 
to know how to implement them, check the [documentation](https://kubernetes.io/docs/tasks/configure-pod-container/configure-liveness-readiness-startup-probes/#define-startup-probes)


## 

