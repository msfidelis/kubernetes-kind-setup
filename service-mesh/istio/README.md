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
helm  install istio-base -n istio-system charts/base
helm  install istio-discovery -n istio-system charts/istio-discovery/
helm  install istio-ingress -n istio-system charts/istio-ingress
helm  install istio-egress -n istio-system charts/istio-egress
helm  install istio-operator -n istio-system charts/istio-operator
```

# Install Addons via Helm

```sh 
helm  install kiali -n istio-system charts/istio-kiali
```

# Apply Nodeport service to expose kind ports 

```sh
kubectl apply -f service-mesh/istio/istio-nodeport-service.yml
```