# minikube commands

* minikube start (to start the cluster)

* minikube status (check the status of running cluster)

# kubectl commands
- **`kubectl cluster-info`** (used to get info about a cluster)
  
- **`kubectl run --image=<image-name> <pod-name>`** (used to create a pod)
  
- **`kubectl get nodes/pods/services/deployments/configmaps/roles/rolebindings/persistentvolume/persistentvolumeclaim`** (checking the status of those items)
```
     "-o wide" flag to get more options
      "--namespace=dev" or "-n dev" flag to set the namespace
      "--all-namespaces" or "-A" flags to check in all the namespaces
      "--selector app=App1" flag to set the selector for filtering objects
      "-o yaml > file.yaml" flag to get the yaml file for an object which can be used to make updates
```

- **`kubectl create`** (same as apply)
```
     "-f filename" to specify the file you want to create. can be a pod definition file or deployment file
      "deployment <deployment-name> --image=<image-name>" to create a deployment that will then create a pod
      "namespace my-namespace" to create your own namespace
```

 *if you want to automatically create a yaml file using k8s, there are a few commands you could try;*
- **`kubectl create deployment --image=nginx nginx --dry-run=client -o yaml > nginx-deployment.yaml`**
```
     the --dry-run flag is used to tell k8s not to run the deployment
      you can also add the --replicas=2 flag
```

- **`kubectl apply -f filename.yaml`** (create a deployment from a config file)
```
     --namespace=my-namespace (using this flag creates a resource in a namespace)
      you can also add "namespace: my-namespace" in the config file under metadata
```

- **`kubectl describe pod <pod-name>`** (to show whats happening inside the pod)

- **`kubectl edit`** (to edit an object)
```
     deployment <deployment-name>
      KUBE_EDITOR="nano" kubectl edit (use this to change the editor to nano or anyone you want)
```

- **`kubectl logs <pod-name>`** (for checking the logs of a pod)
```
    -c <container-name> (checking for container logs)
```

- **`kubectl exec -it <pod-name> --bin/bash or sh`** (opening a terminal inside a pod)

- **`kubectl delete deployment <deployment-name>`** (delete a deployment which in turn deletes the pods and replicas)

- **`kubectl delete -f filename.yaml`** (to delete a deployment/service using the config file)

- **`kubectl get configmap -n my-namespace`** (to get a configmap in a particular namespace. can also be used for other resources)

- **`kubectl rollout status deployment/<deployment-name>`** (to check the status of your rollouts)

- **`kubectl rollout history deployment/<deployment-name>`** (to see your rollout history)

- **`kubectl rollout undo deployment/<deployment-name>`** (to rollback an update)

- **`kubectl config set-context $(kubectl config current-context) --namespace=dev`** (this command is used to change the default namespace)

- **`kubectl config view`** (used to view the current kubeconfig file)
```
you can pass a --kubeconfig=my-custom-config flag to specify the specific kubeconfig you want to use
```

- **`kubectl config use-context prod-user@production`** (use this command to change the current context)

- **`kubeconfig -h`** (to view other commands that can be used with this command)

- **`kubectl taint nodes <node-name> key=value:taint-effect`** (this is used to apply a taint to a node to prevent pods from being placed on it)
```
     there are 3 taint effects; NoSchedule, PreferNoSchedule, NoExecute
      eg; `kubectl taint nodes node01 app=blue:NoSchedule` (this will taint the node with the key-value pair "app=blue" and prevent any pod from being scheduled on it)
      tolerations for pods are added on the pod definition file (refer to documentation)
```

- **`kubectl label nodes <node-name> <key>=<value>`** (this is used to label a node to be used by a node selector)
  
- **`kubernetes logs -f <pod-name> <container-name>`** (used to view the application logs of a particular pod)
```
if there is only one container inside the pod, you don't need to specify the container name
      the "-f" flag is used to get the logs live-streamed to the output
```

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

- **`kubectl drain <node-name>`** (used to rid a node of the current workload running on it and move them over to another node)

- **`kubectl uncordon <node-name>`** (to mark a node as safe to place workloads on, after draining it)

- **`kubectl cordon <node-name>`** (to mark a node so that workloads cannot be placed on it)

- **`kubectl get all --all-namespaces -o yaml > all-deploy-services.yaml`** (to save the configuration of all objects to a yaml file)

- **`kubectl autoscale deployment <deployment-name> --cpu-percent=50 --min=1 --max=10`** (to implement horizontal pod autoscaling. [Docs](https://kubernetes.io/docs/tasks/run-application/horizontal-pod-autoscale/) )
  
- **`kubectl scale deployment/<deployment-name> --replicas=5`** (to scale a deployment and add replicas)

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
    volumeMounts:
    - mountPath: /opt
      name: data-volume
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
  serviceAccountName: my-prom-account
  volumes:
  - name: data-volume
    hostPath:
      path: /data
      type: Directory
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
a service is a method for exposing a network application running as one or more Pods in your cluster. services are cluster level objects, meaning they are not bound to a particular node.
ClusterIP is the default service type if you don't specify otherwise, and it creates a cluster level service which can only be accessed from the cluster alone. NodeIP on the ohter hand creates an IP that can also be accessed from external sources.


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

## annotations
annotations are key-value pairs used to attach arbitrary non-identifying metadata to objects like Pods, Services, Deployments, and more. think of annotations as sticky notes you attach to objects. they don’t change how things work, but they provide useful details for tools or people managing the cluster.

unlike labels, which are used for selection and grouping, annotations are mainly used to store descriptive or configuration information that Kubernetes components or external tools can read. you can find some well know annotations [Here](https://kubernetes.io/docs/reference/labels-annotations-taints/).


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
you can monitor cluster components using the kubernetes metrics server. to enable it, run 
```bash
kubectl apply -f https://github.com/kubernetes-sigs/metrics-server/releases/latest/download/components.yaml
```
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


## cluster upgrade process
when you want to upgrade a k8s cluster, there are a few points you have to take note of;
- k8s supports only 3 minor versions concurrently
- if the `kube-apiserver` is on version 1.10, the `control manager, kubectl, and kube-scheduler` can be lower by 1 minor version and cannot be higher than the apiserver
- the `kubelet` and `kubeproxy` can be lower by 2 minor versions, and also not higher than the apiserver version
- you can only upgrade one version at a time eg; from 1.10 to 1.11, not to 1.12

if you setup your cluster with the kubeadm tool, upgrading isn't too complicated; \
- upgrade the kubeadm tool using the commands;
```
sudo apt-mark unhold kubeadm && \
sudo apt-get update && sudo apt-get install -y kubeadm='1.29.0-1.1' && \
sudo apt-mark hold kubeadm
```
- run `kubeadm upgrade plan` to view the current version and available versions
- run `kubeadm upgrade apply v1.11.0` to upgrade the cluster components
- if you have kubelets running on the master node, upgrade it using `apt-get upgrade -y kubelet=1.12.00` then run `systemctl restart kubelet`

now it is time to upgrade the individual nodes. first you drain the node of any workloads \
then you update the package repo
then run the following commands on each node;
```
apt-get upgrade -y kubeadm=1.12.00
kubeadm upgrade node
apt-get upgrade -y kubelet=1.12.0
systemctl restart kubelet
```
after that you uncordon the node and do the same to the next node. \
follow the [documentation](https://kubernetes.io/docs/tasks/administer-cluster/kubeadm/kubeadm-upgrade/) closely for upgrading clusters \
recommend doing upgrades with a script


## backup and restore
you can back up a k8s cluster by backing up the object definition files, like by storing them on github. \
you can also back up the etcd server which stores info on all the objects in the cluster. First, export the etcd version using `export ETCDCTL_API=3`. 
```
etcdctl --endpoints=https://127.0.0.1:2379 \
  --cacert=<trusted-ca-file> --cert=<cert-file> --key=<key-file> \
  snapshot save <backup-file-location>
```
to get the needed files, describe the etcd pod which is found in the kube-system namespace. \
you can find the manifests for the controlplane objects in `/etc/kubernetes/manifests/` \
to restore a backup, `etcdctl snapshot restore --data-dir /var/lib/etcd-from-backup snapshot.db` \
after restoring the backup, change the volume host path at the end of the `/etc/kubernetes/manifests/etcd.yaml` file to the new data dir path. for more info check out the [Documentation](https://kubernetes.io/docs/tasks/administer-cluster/configure-upgrade-etcd/#restoring-an-etcd-cluster)


## authentication in kubernetes
in order to maintain security and access to our k8s clusters, we have to authenticate whoever has access to the kubeapi. there are different methods to authenticate users; password files, token files, certificates, 3rd party.
### password and token files
this is the easiest form of authentication and involves passing a csv file of users and passwords to the kubeapi. the file is a comma-separated 3-column list of password, username, and user id. the file is to be passed to the kubeapi as an option `--basic-auth-file=` \
to authenticate a user, use the command `curl -v -k https://master-node-ip:6443/api/v1/pods -u "user1:password123"`. the csv file can have an optional 4th column for groups. \
token files too are csv files containing columns; token, username, userid, group. to pass a token file use `--token-auth-file` and for the curl command use `--header "Authorization: Bearer token9u30430"` instead of `-u` \
note that this is not a recommended approach to authentication in k8s
### certificate authentication
authenticating with certificates is the right way to go in k8s. the certificates consist of the private and public(certificates). the public certificates end with a `.crt or .pem` extension while the private keys end with a `.key or -key.pem` extension. \
in a k8s cluster, the server certificates consist of `kubeapi, etcd and kubelet`, and the client certificates consists of `admins, kube-scheduler, kube-controller-manager, kube-proxy`, which all communicate with the kubeapi server and require their own sets of certs and keys. 

the kubeapi needs to communicate with the etcd and kubelet, and that can be done with the certificates already generated or you can generate new certificates for communication with the etcd and kubelet respectively. \
a Certificate Authority(CA) signs all the certificates. there are various CAs that can be used but I will stick with openssl. 

firstly, we get a certificate and key for the CA
```
openssl genrsa -out ca.key 2048 #generate private key

openssl req -new -key ca.key -subj "/CA=KUBERNETES-CA" -out ca.csr #send certificate signing request

openssl x509 -req -in ca.csr -signkey ca.key -out ca.cert #sign the certificate
```

then, to get certificate and key for the clients
```
openssl genrsa -out <client-name>.key 2048

openssl req -new -key <name>.key -subj "/CA=<client-name>" -out <name>.csr

openssl x509 -req -in <name>.csr -CA ca.cert -CAkey ca.key -out <name>.cert
```
when creating admin certificates, a parameter has to be added to the certificate signing request `/CA=kube-admin/O=system:masters` \
the kube-scheduler and kube-controller-manager are system components, so they require a prefix in their name when sending a CSR `/CA=system:<name>` 

to use an admin user, you can either send a curl request `curl https://kube-apiserver:6443/api/v1/pods --key admin.key --cert admin.crt --cacert ca.cert` or add those details to the kube-config file. \
the etcd server needs peer servers so you generate certificates for the etcd peers.

the kubeapi server requires you to add a config file when sending a CSR. You can check the [Documentation](https://kubernetes.io/docs/tasks/administer-cluster/certificates/#openssl) for more details 

the kubelet has its own certificates, but each kubectl node requires its own pair of certificates which should be generated and named after its respective node. since the nodes are system components like the kube-scheduler, add `system:node:<node-name>` when sending the CSR, and add them to the `system:node`  group like you did with the admin 

to specify the paths to these certificates we generated, add them to the manifest files of each service and to view the certificate path you can check the manifest files too at `/etc/kubernetes/manifests`

to view a certificate `openssl x509 -in /path/to/certificate.crt -text -noout` 

for more info you can check out the [Documentation](https://kubernetes.io/docs/setup/best-practices/certificates/)
when debugging issues related to certificates, remember to check the docker(crictl) logs for the containers and look into the files and paths well.

### certificates api
kubernetes has a certificates API for managing certificate signing requests. The API can be used to manage CSRs from users and sign certificates automatically. the workflow is that a new user generates a certificate using the `openssl` command, and generates a certificate signing request which they will send to the admin. 
the admin takes the CSR and generates a Certificate Signing Request Object that looks like this;
```
apiVersion: certificates.k8s.io/v1
kind: CertificateSigningRequest
metadata:
    name: chxnedu
spec: 
    expirationSeconds: 600
    usages: 
    - digital signature
    -  key encipherment
    - server auth
    request:
      jkljfkljfkljdkljdkgjdklgjklgjdgjsdkjdkgjkdjgsdkgkldkdjkjdkgj
``` 
note that the request field contains the CSR encoded in base64.
once the request has been created, it can be viewed with `kubectl get csr` and approved with `kubectl certificate approve chxnedu` \
after the certificate has been signed, you can view it with `kubectl get csr chxnedu -o yaml` and you will see the base64 encoded certificate content as part of the output. decode it and share it with the end user

### kubeconfig file
this is a file where you specify certificate paths, info about clusters, users and contexts between them so that you don't have to type it in with the kubectl command each time. An example config file is in the following format;
```
apiVersion: v1
kind: Config
current-context: my-kube-admin@my-kube-playground

clusters:
- name: my-kube-playground
  cluster:
    certificate-authority: /path/to/ca.crt
    server: https://my-kube-playground:6443


contexts:
- name: my-kube-admin@my-kube-playground
  context:
    cluster: my-kube-playground
    user: my-kube-admin
    namespace: default

users:
- name: my-kube-admin
  user: 
    client-certificate: /path/to/admin.crt
    client-key: /path/to/admin.key

```
after writing the file, you do not need to create any object for it, the kubectl will read the file as is and use it for operations. 
the `current-context` param is used to tell kubectl the default context to use.
the default kubeconfig file is located in `$HOME/.kube/config`

for more info, check out the [Documentation](https://kubernetes.io/docs/concepts/configuration/organize-cluster-access-kubeconfig/).


## authorization in kubernetes
after a user has been authenticated, he needs to have proper authorization to make API calls to the cluster. in k8s, there are multiple modes for authorization;
- ABAC (attribute-based access control)
- RBAC (role-based access control)
- Node
- WebHook
- AlwaysAllow
- AlwaysDeny
you can configure which authorization mode to apply using the configuration file argument `--authorization-mode=RBAC`

for more info on the authorization modes, check the [Documentation](https://kubernetes.io/docs/reference/access-authn-authz/authorization/)

### RBAC (role-based access control)
in this mode, a role is created with the appropriate permissions, and a user/s can be given that role and inherit the permissions of that role.

to create a role, you make a role object `developer-role.yaml` which has the following format
```
apiVersion: rbac.authorization.k8s.io/v1
kind: Role
metadata: 
  name: developer
  namespace: default
rules: 
- apiGroups: [""]
  resources: ["pods"]
  verbs: ["list", "get", "create", "update", "delete"]
  resourceNames: ["blue", "green"]
- apiGroups: 
  resources: ["configMap"]
  verbs: ["create"]
```
use `kubectl create -f developer-role.yaml` to create the object. \
to bind a user to a particular role, you have to create another binding object `devuser-developer-binding.yaml`
```
apiVersion: rbac.authorization.k8s.io/v1
kind: RoleBinding
metadata: 
  name: devuser-developer-binding
subjects: 
- kind: User
  name: dev-user
  apiGroup: rbac.authorization.k8s.io
roleRef: 
  kind: Role
  name: developer
  apiGroup: rbac.authorization.k8s.io
```
create the role binding using the kubectl create command. 

to check if you have a particular permission as a user, you can run the `kubectl auth can-i <action> <object>` command, eg `kubectl auth can-i create deployment`. you can also add the `--as dev-user` flag to check for other users.

to check the kubeapi server config, check the yaml file located at `/etc/kubernetes/manifests`

### cluster roles and role bindings
ClusterRole, by contrast, is a non-namespaced resource. The resources have different names (Role and ClusterRole) because a Kubernetes object always has to be either namespaced or not namespaced; it can't be both. If you want to define a role within a namespace, use a Role; if you want to define a role cluster-wide, use a ClusterRole.

the format for cluster roles and role bindings are very similar to regular roles and role bindings, you just have to change the kind to `ClusterRole` and `ClusterRoleBinding`, and know which resources are namespaces and which are not. \
if you create a cluster role for a user to access pods, the user will be able to access all pods in all namespaces in the cluster.


# service accounts in kubernetes
service accounts are created for bots to access our k8s clusters. to create a service account, run `kubectl create serviceaccount <account_name>` and to view the created service accounts, `kubectl get serviceaccount`. when a service account is created, a token is created to authenticate the cluster. the token is created as a secret, and to view it, describe the service account to see the name of the token object, then describe the secret.

when the 3rd party service that needs to access the cluster is within the cluster itself, you don't have to copy the token anymore, you will mount it as a volume inside the pod hosting the 3rd party application. to use a service account with a pod, you have to specify the name of that service account in the pod definition file. 

you can learn more about service accounts [here](https://kubernetes.io/docs/concepts/security/service-accounts/) and [here](https://kubernetes.io/docs/tasks/configure-pod-container/configure-service-account/).

## image security
to authenticate to a private server to pull an image, you have to create a secret for it. Read the [Documentation](https://kubernetes.io/docs/tasks/configure-pod-container/pull-image-private-registry/) for more info.

## security contexts
to know more about security contexts in k8s, read the [Documentation](https://kubernetes.io/docs/tasks/configure-pod-container/security-context/).

## network policies
a network policy controls ingress and egress traffic between pods in a cluster. an example network policy definition file below
```
apiVersion: networking.k8s.io/v1
kind: NetworkPolicy
metadata:
  name: test-network-policy
  namespace: default
spec:
  podSelector:
    matchLabels:
      role: db
  policyTypes:
  - Ingress
  - Egress
  ingress:
  - from:
    - ipBlock:
        cidr: 172.17.0.0/16
        except:
        - 172.17.1.0/24
    - namespaceSelector:
        matchLabels:
          project: myproject
      podSelector:
        matchLabels:
          role: frontend
    ports:
    - protocol: TCP
      port: 6379
  egress:
  - to:
    - ipBlock:
        cidr: 10.0.0.0/24
    ports:
    - protocol: TCP
      port: 5978

```
note that some network plugins like flannel do not support network policies.
when using network policies, for example, you want a database pod to only allow ingress traffic from an API pod. when that is specified, there is no need to specify an egress traffic section for the response, it is automatically allowed. \
under the from parameter, there are 2 sets of rules, not 3. the `ipBlock` is one rule, and the `nameSpaceSelector` & `podSelector` are a separate rule. this acts like an OR statement as it will allow from the ipblock or the namespace and podselector together.

## kubectx & kubens
kubectx is used to easily switch between contexts. Install it using 
```
sudo git clone https://github.com/ahmetb/kubectx /opt/kubectx
sudo ln -s /opt/kubectx/kubectx /usr/local/bin/kubectx
```
and use `kubectx` to list all contexts. to switch to a new context use `kubectx <context_name>` and to switch back use `kubectx -`. to see the current context use `kubectx -c`.

kubens on the other hand is used to easily switch between namespaces. install it using
```
sudo git clone https://github.com/ahmetb/kubectx /opt/kubectx
sudo ln -s /opt/kubectx/kubens /usr/local/bin/kubens
```
to switch to a new namespace use `kubens <new_namespace>` and to switch back use `kubens -`.


# storage in kubernetes
storage in k8s is handled using volumes. when a pod is created, a volume can be created and mounted to that pod so that the data is persisted. check the pod definition to see how to specify volumes, and check the [Documentation](https://kubernetes.io/docs/concepts/storage/volumes/) to see other options for volumes.

## persistent volumes and persistent volume claims
persistent volume (PV) in k8s is a piece of storage in the cluster that has been provisioned by an administrator or dynamically provisioned using Storage Classes. it is a resource in the cluster just like a node is a cluster resource.
persistent volume claim (PVC) is a request for storage by a user. It is similar to a pod. pods consume node resources and PVCs consume PV resources. pods can request specific levels of resources (CPU and Memory). claims can request specific size and access modes.

an example PV spec
```
apiVersion: v1
kind: PersistentVolume
metadata:
  name: pv-vol1
spec:
  accessModes:
    - ReadWriteOnce
  capacity: 
    storage: 1Gi
  hostPath:
    path: /tmp/data
```
you can replace the PV type with any supported option. Check out the [Documentation](https://kubernetes.io/docs/concepts/storage/persistent-volumes/#persistent-volumes) for more info. you can also set a reclaim policy to dictate what happens when the PVC is unbound from the pv. by default it is set to retain.

an example PVC spec
```
apiVersion: v1
kind: PersistentVolumeClaim
metadata:
  name: myclaim
spec:
  storageClassName: name #use this when using storage classes
  accessModes:
    - ReadWriteOnce
  resources:
    requests:
      storage: 500Mi
```

Once you create a PVC use it in a POD definition file by specifying the PVC Claim name under persistentVolumeClaim section in the volumes section like this:
```
apiVersion: v1
kind: Pod
metadata:
  name: mypod
spec:
  containers:
    - name: myfrontend
      image: nginx
      volumeMounts:
      - mountPath: "/var/www/html"
        name: mypd
  volumes:
    - name: mypd
      persistentVolumeClaim:
        claimName: myclaim
```

## storage class
with storage classes, you can automatically create a volume and attach it to a pod when a persistent volume claim is made. so you don't have to create a pv each time and create a pvc for it. you can read more about it in the [Documentation](https://kubernetes.io/docs/concepts/storage/storage-classes/).
a sample storage class definition
```
apiVersion: storage.k8s.io/v1
kind: StorageClass
metadata:
  name: google-storage
provisioner: kubernetes.io/gce-pd
```

## volume snapshots
Read [Documentation](https://kubernetes.io/docs/concepts/storage/volume-snapshots/) for more info.


# networking in kubernetes

when setting up a k8s cluster, you need to take note of all the ports that need to be open. Look at the [Documentation](https://kubernetes.io/docs/reference/networking/ports-and-protocols/) for more info.

## pod networking

k8s does not have a built in networking solution, it requires you to implement your own solution for networking. But k8s has its requirements for pod networking;

- every pod should have an IP address
- every pod should be able to communicate with every other pod in the same node
- every pod should be able to communicate with every other pod on other nodes without a NAT (with the same IP)

## calico cni

for my testing, i went with calico. Look into the documentation [Here](https://docs.tigera.io/calico/latest/getting-started/kubernetes/self-managed-onprem/onpremises).
`/opt/cni/bin` to see all the cni plugins installed
`/etc/cni/net.d` to see the current cni plugin being used

## ip address management

ipam is handled by the cni plugin. so look into how calico does it.

## services
a service is a method for exposing a network application running as one or more Pods in your cluster. services are cluster level objects, meaning they are not bound to a particular node. there are different types of services;
- **ClusterIP** is the default service type, and it exposes the service internally using a clusterIP or dns name. it's for services not meant to be accessed externally, like databases.
- **NodePort** exposes the service on a static port on each node in the cluster. the port is of the range 30000-32767. can be used for simple external access, but should'nt be used much in production coz of lack of load balancing and security concerns.
- **LoadBalancer** provides a LB to expose the service to external clients. it automatically integrates with cloud provider load balancing solutions. \
services are still used in k8s to manage access to pods. look into the role of services when using cni. look into the [Documentation](https://kubernetes.io/docs/concepts/services-networking/service/#type-nodeport) for more info.


## ingress
ingress is an API object that manages external access to the services in a cluster, typically HTTP. ingress may provide load balancing, SSL termination and name-based virtual hosting.
an ingress is divided into ingress controller and ingress resource. an ingress controller needs to be running for an ingress resource to work. 

### ingress controller
there are multiple ingress controllers that can be seen [here](https://kubernetes.io/docs/concepts/services-networking/ingress-controllers/). but we will go with nginx ingress controller.
to setup an nginx ingress controller, you need to create a couple of objects. first, a deployment;
```
apiVersion: apps/vl
kind: Deployment
metadata:
  name: nginx-ingress-controller
spec:
  replicas: 1
  selector:
    matchLabels:
      name: nginx-ingress
  template:
    metadata:
      labels:
        name: nginx-ingress
spec:
  containers:
    - name: nginx-ingress-controller
      image: quay.io/kubernetes-ingress-controller/nginx-ingress-controller:0.21.0
  args:
    - /nginx-ingress-controller
    - --configmap=$(POD_NAMESPACE)/nginx-configuration
  env:
    - name: POD_NAME 
      valueFrom:
        fieldRef:
          fieldPath: metadata.name
    - name: POD_NAMESPACE
      valueFrom:
        fieldRef:
          fieldPath: metadata.namespace
  ports:
    - name: http
      containerPort: 80
    - name: https
      containerPort: 443
```

then, a configmap to store the nginx configuration for decoupling
```
apiVersion: v1
kind: ConfigMap
metadata:
  name: nginx-configuration
```

and a service to expose the ingress controller to the external world.
``` 
apiVersion: v1
kind: Service
metadata:
  name: nginx-ingress
spec:
  type: NodePort
  ports:
  - port: 80
    targetPort: 80
    protocol: TCP
    name: http
  - port: 443
    targetPort: 443
    protocol: TCP
    name: https
  selector:
    name: nginx-ingress
```

lastly, the ingress controller requires a service account with the correct roles and rolebingings.
```
apiVersion: v1
kind: ServiceAccount
metadata:
  name: nginx-ingress-service-account
```

after all those have been created, time to create an ingress resource.

### ingress resource
an ingress resource is a set of rules and configurations applied to the ingress controller. look into the [Documentation](https://kubernetes.io/docs/concepts/services-networking/ingress/#default-ingress-class) on how to configure an ingress resource depending on your backend.
also look at annotations and rewrite target [Here](https://github.com/kubernetes/ingress-nginx/blob/main/docs/examples/rewrite/README.md).


# designing a k8s cluster

before you design a k8s cluster, you need to ask yourself a few questions;

- purpose
    - education
    - development and testing
    - hosting prod apps
- cloud or onprem
- workloads
    - how many?
    - what kind
        - web
        - big data/analytics
    - application resource requirements
        - cpu intensive
        - memory intensive
    - traffic
        - heavy traffic
        - burst traffic

A k8s cluster can be run on your laptop, onprem physical machines, or cloud infrastructure.

## k8s on your laptop or local machine

k8s cannot be setup on windows natively as there are no binaries. it can be run using virtualization software though. 

Minikube can be used to deploy a single node cluster easily. Kubeadm tool too can be used to provision a single node or multi node tool. Kubeadm requires the VMs to be ready, while minikube does not and will provision them itself.

## high availability in k8s
read up on high availability

## installing k8s the kubeadm way
the steps involved in setting up a cluster using the kubeadm tool include:
- provision vm's for nodes with one designated for master and the others worker nodes
- install a container runtime on the nodes, eg containerd
- install kubeadm on all nodes
- initialize the master server
- setup the pod network and the worker nodes can join the master node


# kubernetes dashboard

this is a web-based kubernetes UI interface. It can be deployed and accessed by following these steps;

1. deploy the dashboard
   ```bash
   # make sure helm is installed
   helm repo add kubernetes-dashboard https://kubernetes.github.io/dashboard/
   helm upgrade --install kubernetes-dashboard kubernetes-dashboard/kubernetes-dashboard --create-namespace --namespace kubernetes-dashboard
   
   ```
2. Create a user
   - create a sevice account;
     ```yaml
     apiVersion: v1
     kind: ServiceAccount
     metadata:
       name: admin-user
       namespace: kubernetes-dashboard
     ```
  - create a clusterrolebinding
    ```yaml
    apiVersion: rbac.authorization.k8s.io/v1
    kind: ClusterRoleBinding
    metadata:
      name: admin-user
    roleRef:
      apiGroup: rbac.authorization.k8s.io
      kind: ClusterRole
      name: cluster-admin
    subjects:
    - kind: ServiceAccount
      name: admin-user
      namespace: kubernetes-dashboard
    ```
  - get a bearer token for seviceaccount
    ```bash
    kubectl -n kubernetes-dashboard create token admin-user
    ```
3. Make the dashboard accessible
   ```bash
   kubectl -n kubernetes-dashboard port-forward --address 0.0.0.0 svc/kubernetes-dashboard-kong-proxy 8443:443
   ```




