# Prescriptive Data DevOps Project



Summary
=================
Building highly available system, which servers traffic via load balancer, balancing traffic from multiple containers.
![k8s diagram](../pd-data/k8s/k8s-diagram.svg)


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
- [Technology Stack](#technology-stack)
- [Table Of Contents](#table-of-contents)
- [Prerequisite](#prerequisite)
- [Docker build](#docker-build)
- [Kubernetes](#kubernetes)
- [Deployments](#deployments)
- [Monitoring](#monitoring)
- [Project Resources](#project-resources)
- [Demos](#demos)

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
export AWS_ACCESS_KEY_ID=AKIAIOSFODNN7EXAMPLE
export AWS_SECRET_ACCESS_KEY=wJalrXUtnFEMI/K7MDENG/bPxRfiCYEXAMPLEKEY
export AWS_DEFAULT_REGION=us-east-1
export KOPS_STATE_STORE=s3://k8s-state-store
export NAME=k8s.rupgautam.me
```

`kops create cluster --zones us-east-1 --topology private --networking calico --master-size t3.medium --master-count 1 --node-size t3.medium ${NAME}`

> What's happening here?
* `kops` will create cluster in zone `us-east-1`
* Nodes/Pods/Master will be communicating via `private` topology
* Install Calico CNI plugin for networking 
* 1 master nodes of type t3.medium
* 2 worker nodes of type t3.medium

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


To check if our ingress controller has registered our traffic path 

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

Demos
=================
Demo can be access here. 
* [/all](https://a0d0dfc145f8a467db63b34d50c1126d-3514ae0d7f621945.elb.us-east-1.amazonaws.com/all)
* [/green](https://a0d0dfc145f8a467db63b34d50c1126d-3514ae0d7f621945.elb.us-east-1.amazonaws.com/green)
* [/blue](https://a0d0dfc145f8a467db63b34d50c1126d-3514ae0d7f621945.elb.us-east-1.amazonaws.com/blue)