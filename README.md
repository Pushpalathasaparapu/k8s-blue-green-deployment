# prescriptivedata.io

### Docker build

`docker build . -f "Dockerfile" -t mynginx:latest`

`docker build . -f "Dockerfile.green" -t mynginx:green`

`docker build . -f "Dockerfile.blue" -t mynginx:blue`

`docker tag docker-id docker-username/repo:tag`

`docker push docker-username/repo:tag`

### Kubernetes 

`kubectl apply -f deployment.yml`

`kubectl apply -f blue-deployment.yml`

`kubectl apply -f green-deployment.yml`

`kubectl apply -f service.yml`

`kubectl apply -f blue-service.yml`

`kubectl apply -f green-service.yml`

`kubectl apply -f ingress.yml`

To check if our deployment has be successful.

`kubectl get deployment,svc,pods`

`kubectl describe svc nginx`

`kubectl describe svc nginx-green-svc`

`kubectl describe svc nginx-blue-svc`


To check if our ingree controller has registered our traffic path 

`kubectl describe ingress nginx`

```
#out should look like
Name:             nginx
Namespace:        default
Address:          159.203.55.30
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