# Install CLI 

```sh
curl -L https://istio.io/downloadIstio | sh -
mv istio-1.9.5 ~/.istio
export PATH="$PATH:~/.istio/bin"
```

# Install Istio 

```sh 
istioctl install -y
```

# Install via Helm 

```sh 
kubectl create ns istio-system
helm install istio-base -n istio-system manifests/charts/base
helm install istio-discovery -n istio-system manifests/charts/istio-control/istio-discovery/
helm  install istio-ingress -n istio-system manifests/charts/gateways/istio-ingress
helm  install istio-egress -n istio-system manifests/charts/gateways/istio-egress
```

# Apply Nodeport service to expose kind ports 

```sh
kubectl apply -f service-mesh/istio/istio-nodeport-service.yml
```