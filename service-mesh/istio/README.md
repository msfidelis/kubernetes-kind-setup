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

# Apply Nodeport service to expose kind ports 

```sh
kubectl apply -f istio-nodeport-service.yml
```