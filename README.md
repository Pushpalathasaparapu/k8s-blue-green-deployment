# Prescriptive Data DevOps Project



Summary
=================
Building highly available system, which servers traffic via load balancer, balancing traffic from multiple containers.
![k8s diagram](https://github.com/rupgautam/prescriptivedata.io/blob/master/k8s-diagram.png?raw=true)

Demos
=================
Demo can be access here. 
* http://a3173397d93f34074a1332f104b58472-12a22ed26c201159.elb.us-east-1.amazonaws.com/all
* http://a3173397d93f34074a1332f104b58472-12a22ed26c201159.elb.us-east-1.amazonaws.com/blue
* http://a3173397d93f34074a1332f104b58472-12a22ed26c201159.elb.us-east-1.amazonaws.com/green

Technology Stack
=================
> List of technologies used in the project.
* Docker
* Terraform
* Kops
* Kubernetes
* Nginx Ingress controller


Table Of Contents
=================
- [Prescriptive Data DevOps Project](#prescriptive-data-devops-project)
- [Summary](#summary)
- [Demos](#demos)
- [Technology Stack](#technology-stack)
- [Table Of Contents](#table-of-contents)
- [Prerequisite](#prerequisite)
- [Docker build](#docker-build)
- [Kubernetes](#kubernetes)
- [Deployments](#deployments)
- [Scaling](#scaling)
- [Monitoring](#monitoring)
- [Project Resources](#project-resources)

Prerequisite
=================
> List of tools which need to be installed locally.
* [Docker](https://docs.docker.com/get-docker/)
* [kubectl](https://kubernetes.io/docs/tasks/tools/install-kubectl/)
* [kops](https://kubernetes.io/docs/setup/production-environment/tools/kops/)
* [helm](https://helm.sh/docs/intro/install/) 
 

Docker build
=================
Build docker images with three different flavors, Standard, Green, and Blue. We will be using all these three images to create blue-green deployment on k8s cluster. Docker images are build on top of `Alpine 3.10` 

`docker build . -f "Dockerfile" -t mynginx:latest`

`docker build . -f "Dockerfile.green" -t mynginx:green`

`docker build . -f "Dockerfile.blue" -t mynginx:blue`

`docker tag docker-id docker-username/repo:tag`

`docker push docker-username/repo:tag`

Kubernetes
=================
Installing k8s cluster using `kops` 

```
export AWS_ACCESS_KEY_ID=$(aws configure get aws_access_key_id)
export AWS_SECRET_ACCESS_KEY=$(aws configure get aws_secret_access_key)
export KOPS_STATE_STORE=s3://domain-example-state
export NAME=k8s.rupgautam.me
export NODE_SIZE=${NODE_SIZE:-m3.medium}
export MASTER_SIZE=${MASTER_SIZE:-m3.medium}
export ZONES=${ZONES:-"us-east-1a,us-east-1b,us-east-1c"}
```
```
kops create cluster ${NAME} \
  --zones $ZONES \
  --node-size $NODE_SIZE \
  --node-count 3 \
  --master-size ${MASTER_SIZE} \
  --master-count 3 \
  --master-zones ${ZONES} \
  --networking=calico \
  --topogoly=private
```

> What's happening here?
* `kops` will create cluster in zone `us-east-1` with 3 AZs 
* Install Calico CNI plugin for networking 
* 3 master nodes of type t3.medium
* 3 worker nodes of type t3.medium
* Uses `Calico` as Network plugin 
* Nodes/Pods/Master will be communicating via `private` topology

Since we are only using private IPs, out external access will be only via the AWS load balancer.
To do so, we will use nginx ingree controller.
Installing Nginx ingress controller for AWS.

`kubectl apply -f https://raw.githubusercontent.com/kubernetes/ingress-nginx/controller-v0.35.0/deploy/static/provider/aws/deploy.yaml`

To see if ingress pods are ready, Once ready we are done for setting up our cluster.

`kubectl get pods -n ingress-nginx --watch`


Deployments
=================
All of the below deployments will be done under `default` namespaces. 

Creates deployment for standard image.
`kubectl apply -f deployment.yml`

Creates deployment for blue image.

`kubectl apply -f blue-deployment.yml`

Creates deployment for green image.

`kubectl apply -f green-deployment.yml`

Creates service with spec `port` and `targetPort` `:80`. It will select all the deployment which has selector tag of `nginx`

`kubectl apply -f service.yml`

Creates service for blue deployment as above but this one will select the deployment with `version:blue` selector tag

`kubectl apply -f blue-service.yml`

Creates service for green deployment as above but this one will select the deployment with `version:green` selector tag

`kubectl apply -f green-service.yml`

Registers ingress path for `/all` `/blue` and `/green` 

`kubectl apply -f ingress.yml`

To check if our deployment has been successful.

`kubectl get deployment,svc,pods`

`kubectl describe svc nginx`

`kubectl describe svc nginx-green-svc`

`kubectl describe svc nginx-blue-svc`


To check if our ingress controller has registered our traffic path. AWS ELB takes 5-10min to properly propagate and register our internal IPs. 

`kubectl describe ingress nginx`

```
#out should look like
Name:             nginx
Namespace:        default
Address:          a0d0dfc145f8a467db63b34d50c1126d-3514ae0d7f621945.elb.us-east-1.amazonaws.com
Default backend:  default-http-backend:80 (<error: endpoints "default-http-backend" not found>)
Rules:
  Host        Path  Backends
  ----        ----  --------
  *           
              /all   nginx-svc:80 (10.244.0.154:80,10.244.0.155:80,10.244.0.16:80 + 12 more...)
  *           
              /blue   nginx-blue-svc:80 (10.244.0.154:80,10.244.0.167:80,10.244.0.64:80 + 2 more...)
  *           
              /green   nginx-green-svc:80 (10.244.0.173:80,10.244.0.188:80,10.244.0.70:80 + 2 more...)
```
Scaling 
=================
To scale our services, no manual work is needed. Kubernetes can scale up and down as per `daemonSet` and `replicasSet`.

`kubectl scale deployment nginx --replicas=5`

`kubectl scale deployment nginx-blue --replicas=5`

`kubectl scale deployment nginx-green --replicas=5`



Monitoring
=================

To install Prometheus

`kubectl apply --kustomize github.com/kubernetes/ingress-nginx/deploy/prometheus/`

To install Grafana

`kubectl apply --kustomize github.com/kubernetes/ingress-nginx/deploy/grafana/`


Project Resources
=================
> I have mostly used kubernetes.io documentation page for most of my work
* Kubernetes Docs
* Nginx Ingress Wiki
* Docker Docs
* 90% of Google search 

